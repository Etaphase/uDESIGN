#posit_linpack.jl - run linpack using posits
#  usage:  julia posit_linpack.jl <N> <iters> <ES>
#  where the linpack linear solver will solve an NxN matrix. using Posit{32,ES}
#  linpack will also perform the same solution against IEEE 32-bit fp.

using SigmoidNumbers

if length(ARGS) != 3
    throw(ArgumentError("incorrect argument count for this program."))
else
    const T = parse("Posit{32, $(ARGS[2])}") |> eval
end

const N = parse(ARGS[1])
const iters = parse(ARGS[3])

function single_iter()
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

  deviation_FP32 = sum(abs.(Float64.(soln_vec_FP32) - 1.0)) / N
  deviation_posit = sum(abs.(Float64.(soln_vec_posit) - 1.0)) / N
  deviation_refin = sum(abs.(Float64.(soln_vec_refin) - 1.0)) / N

  (deviation_FP32, deviation_posit, deviation_refin)
end

FP32_dev_array = zeros(Float64, iters)
posit_dev_array = zeros(Float64, iters)
quire_dev_array = zeros(Float64, iters)

print("completing: ")
for idx = 1:iters
    print(" $idx / $iters ")
    (FP32_dev_array[idx], posit_dev_array[idx], quire_dev_array[idx]) = log.(single_iter())
end
println()

sort!(FP32_dev_array)
sort!(posit_dev_array)
sort!(quire_dev_array)

#report statistics.
println("worst case for FP32: $(exp(last(FP32_dev_array)))")
println("worst case for posit: $(exp(last(posit_dev_array)))")
println("worst case for quire: $(exp(last(quire_dev_array)))")

println("median case for FP32: $(exp(median(FP32_dev_array)))")
println("median case for posit: $(exp(median(posit_dev_array)))")
println("median case for quire: $(exp(median(quire_dev_array)))")

println("mean case for FP32: $(exp(mean(FP32_dev_array)))")
println("mean case for posit: $(exp(mean(posit_dev_array)))")
println("mean case for quire: $(exp(mean(quire_dev_array)))")
