#posit_linpack.jl - run linpack using posits
#  usage:  julia posit_linpack.jl <N> <iters> <ES>
#  where the linpack linear solver will solve an NxN matrix. using Posit{32,ES}
#  linpack will also perform the same solution against IEEE 32-bit fp.

using SigmoidNumbers

if length(ARGS) != 2
    throw(ArgumentError("incorrect argument count for this program."))
else
    const T = parse("Posit{32, $(ARGS[2])}") |> eval
end

const N = parse(ARGS[1])
#const iters = parse(ARGS[3])

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
soln_vec_quire = SigmoidNumbers.solve_quire(rand_mtx_posit, res_vec_posit)
soln_vec_refin = SigmoidNumbers.solve_quire_refine(rand_mtx_posit, res_vec_posit)

deviation_FP32 = sum(abs.(Float64.(soln_vec_FP32) - 1.0)) / N
deviation_posit = sum(abs.(Float64.(soln_vec_posit) - 1.0)) / N
deviation_quire = sum(abs.(Float64.(soln_vec_quire) - 1.0)) / N
deviation_refin = sum(abs.(Float64.(soln_vec_refin) - 1.0)) / N

println("FP32 deviation: $deviation_FP32")
println("$T deviation: $deviation_posit")
println("$T (quire) deviation: $deviation_quire")
println("$T (quire + refin) deviation: $deviation_refin")
