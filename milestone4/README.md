# uDESIGN

## Milestone 4

Deliverables:
*  Linpack 100 & 1000 performance analysis

## Installation instructions

1. install julia.
  * instructions for download and files are available at: http://julialang.org/downloads/
  * requires julia 0.6.0
2. installation of unum package
  * run julia (usually `julia` at the command prompt.)
  * at the julia command prompt, run: `Pkg.clone("git://github.com/interplanetary-robot/SigmoidNumbers.git", "SigmoidNumbers")`

## posit_linpack.jl

This is a quick command-line demonstration of the posit_linpack function.

### Execution

run `julia posit_linpack.jl 100 2` for linpack 100 performance measurement using Posit{32,2}.

run `julia posit_linpack.jl 1000 2` for linpack 1000 performance measurement using Posit{32,2}.

### Output

the program will output the numerical accuracy of a 100x100 matrix solution.

## posit\_linpack\_stat.jl

Runs posit_linpack equivalent, over multiple iterations and reports statistics
on deviations from ground truth.

### Execution

run `julia posit_linpack_stat.jl 100 2 1000` for linpack 100 performance measurement using Posit{32,2}, 1000 iterations

run `julia posit_linpack_stat.jl 1000 2 1000` for linpack 1000 performance measurement using Posit{32,2}, 1000 iterations

### Example results:

Linpack 100, Posit{32,2}, 1000 iterations
```
  worst case for FP32: 0.0027954190969467175
  worst case for posit: 0.00010961107909679417
  worst case for quire: 5.122087895870208e-6
  median case for FP32: 5.28692443179437e-6
  median case for posit: 5.325673134485374e-7
  median case for quire: 1.9278296309798645e-8
  mean case for FP32: 6.705199868354203e-6
  mean case for posit: 6.729170415778234e-7
  mean case for quire: 2.4604283056469153e-8
```
