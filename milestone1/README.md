# uDESIGN

## Milestone 1

Deliverables:  
*  Initial Unum demo (as presented at DARPA TRADES).
*  A working implementation of a generalized Ubox method for Type 1 Unums for data on
N-dimensions subject to a constraint.

## Installation instructions

1. install julia.
  * instructions for download and files are available at: http://julialang.org/downloads/
  * requires julia 0.5 or higher
2. installation of unum package
  * run julia (usually `julia` at the command prompt.)
  * at the julia command prompt, run: `Pkg.clone("git://github.com/REX-computing/unumjl.git", "Unums")`

## Execution instructions

* ensure "milestone1.jl" is in a local directory.
* execute the command `julia milestone1.jl`

### Using the milestone program

The milestone program lets you input a function and comprehensively find
solutions within a certain boundary (ubox method, as described in John
Gustafson's *the end of error*), in a unum environment.  Specify your
environment (I suggest 3, 5 - which is 32 bits of fraction and 8 bits of
exponent) and input the function.  Polynomial and division functions are
supported for input parsing, though other are available.  Then input function
and bounds.  Some functions won't be able to be solved over the entire real
number line.

EG:
*  x^2 - 2 =>  '''
-1.4142135623842478 op → -1.4142135621514171 op
1.4142135621514171 op → 1.4142135623842478 op'''
*  x^5 - 4x^4 + 8x^2 + x - 2 (search over -100, 100) => Five sets of answers
that cluster near -1, -.675..., 0.46..., 2.0, 3.214...  Note that as a quintic,
this formula has no closed form algebraic solution.
*  1/(x^2 - 3x) + 5  (search over -100, 100) => Four sets of answers that
cluster around 0, 0.68... 2.93..., 3.0; 0 and 3.0 are output because the
asymptotic values cross over at these points.


## Other
Demonstration script shown at the kickoff meeting can be found at uDESIGN-demo.jl

uDESIGN is supported by
DARPA grant HR0011-17-9-0007 awarded to Etaphase, inc.

Principal contributors:

* Isaac Yonemoto
* Ruth Ann Mullen
* John Gustafson
