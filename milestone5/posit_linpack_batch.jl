#posit_linpack.jl - run linpack using posits
#  usage:  julia posit_linpack.jl <N> <ES> <dir>
#  where the linpack linear solver will solve an NxN matrix. using Posit{32,ES}
#  linpack will also perform the same solution against IEEE 32-bit fp.
#  results will placed in a csv file <uuid>.dat inside directory <dir>

#need to divide by two because we don't care about hyperthreading.
const corestouse = clamp(div(Sys.CPU_CORES, 2),1,10)

info("number of procs detected: $corestouse")

addprocs(corestouse,exeflags=["-Cx86-64","--precompiled=no","--compilecache=no"])

info("number of procs added: $(nprocs())")

@everywhere using SigmoidNumbers

if length(ARGS) != 3
    throw(ArgumentError("incorrect argument count for this program."))
else
    PType = parse("Posit{32, $(ARGS[2])}") |> eval
    const T = PType
end

const N = parse(ARGS[1])
const iters = length(procs())
const directory = ARGS[3]

@everywhere function single_iter(resultfile, N, T)
  #first make a random matrix using the floating point as a ground truth.
  #by passing through both Float32 and T, we guarantee that it's correctly
  #representable as both.  We'll use IEEE 64-bit FP as "ground truth".
  rand_mtx_FP32 =  Float32.(T.(2 * rand(Float64, N, N) - 1))
  rand_mtx_posit = T.(rand_mtx_FP32)
  rand_mtx_truth = Float64.(rand_mtx_FP32)

  #sum the ground truth rows to obtain the solution vector.  This means that the
  #correct solution should be 1, and deviation from the correct solution should be
  #readily observable.
  res_vec_truth = reshape(sum(rand_mtx_truth, 2), N)
  res_vec_FP32  = Float32.(res_vec_truth)
  res_vec_posit = T.(res_vec_truth)

  #solve the matrix:
  soln_vec_FP32 = rand_mtx_FP32 \ res_vec_FP32
  soln_vec_posit = rand_mtx_posit \ res_vec_posit
  soln_vec_refin = SigmoidNumbers.solve_quire_refine(rand_mtx_posit, res_vec_posit)

  maxdev_FP32 = maximum(abs.(Float64.(soln_vec_FP32) - 1.0))
  maxdev_posit = maximum(abs.(Float64.(soln_vec_posit) - 1.0))
  maxdev_refin = maximum(abs.(Float64.(soln_vec_refin) - 1.0))

  deviation_FP32 = sum(abs.(Float64.(soln_vec_FP32) - 1.0)) / N
  deviation_posit = sum(abs.(Float64.(soln_vec_posit) - 1.0)) / N
  deviation_refin = sum(abs.(Float64.(soln_vec_refin) - 1.0)) / N

  println(resultfile, "$deviation_FP32, $deviation_posit, $deviation_refin, $maxdev_FP32, $maxdev_posit, $maxdev_refin")
  :ok
end

FP32_dev_array = zeros(Float64, iters)
posit_dev_array = zeros(Float64, iters)
quire_dev_array = zeros(Float64, iters)

#create a futures array
futures = Future[]

uuid = Base.Random.uuid4()
info(STDERR, "beginning run $uuid")
open(joinpath(directory , string(uuid) * ".dat"), "w") do resultfile
    println(resultfile, "type: T")
    println(resultfile, "mtx: $(N)x$N")
    println(resultfile, "dev_fp32,  dev_posit,  dev_refin, max_fp32, max_posit, max_refin")
    for idx = 1:iters
        info(STDERR, "spawning $idx / $iters ")
        push!(futures, remotecall(single_iter, 1, resultfile, N, T))
    end
    #go ahead and clear all the futures
    for idx in 1:length(futures)
        fetch(futures[idx]) == :ok ? info(STDERR, "computation $idx OK.") : error(STDERR, "computation $idx FAILED.")
    end
end

