# uDESIGN

## Milestone 2

Deliverables:  
*  A program that solves for exact solutions of systems of linear equations.

## Installation instructions

1. install julia.
  * instructions for download and files are available at: http://julialang.org/downloads/
  * requires julia 0.5
2. installation of unum package
  * run julia (usually `julia` at the command prompt.)
  * at the julia command prompt, run: `Pkg.clone("git://github.com/interplanetary-robot/SigmoidNumbers.git", "SigmoidNumbers")`

## Execution instructions

* ensure "milestone2.jl" is in a local directory.
* execute the command `julia milestone2.jl FILENAME`, where FILENAME is the name of the linear equation file.

### Using the milestone program

The milestone program lets you input a matrix and will iteratively solve the
matrix using LU decomposition until the closest possible representable solution
is found, using 32 bit posits and the fused dot product operator.  The output
will be reported and compared to the performance of IEEE 32-bit floating points.

## Other
Technology demonstration video is available at: https://asciinema.org/a/125169?speed=4
Example run of this program is available at:

uDESIGN is supported by
DARPA grant HR0011-17-9-0007 awarded to Etaphase, inc.

Principal contributors:

* Isaac Yonemoto
* Ruth Ann Mullen
* John Gustafson
