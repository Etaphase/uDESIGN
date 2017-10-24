# uDESIGN

## Milestone 3

Deliverables:  
*  Time Complexity Analysis of solutions of linear equations.

## Installation instructions

1. install julia.
  * instructions for download and files are available at: http://julialang.org/downloads/
  * requires julia 0.5
2. installation of unum package
  * run julia (usually `julia` at the command prompt.)
  * at the julia command prompt, run: `Pkg.clone("git://github.com/interplanetary-robot/SigmoidNumbers.git", "SigmoidNumbers")`

## Execution instructions

* ensure "milestone3.jl" is in a local directory.
* execute the command `julia milestone2.jl BITSIZE MATRIXWIDTH`

### Using the milestone program

The milestone program will randomly generate an n x n matrix, solve it, then apply
the ubox method.  Performance metrics are reported.

## Results

Raw results are reported in msres-w-n-i text files, where w is the bit width,
n is the width of the matrix, and i is the file#.  These programs were run
in parallel on a 32-core 3.7 GHz haswell processor, with fewer processors than
cores.  The following runtimes are reported:

|{16,2}:  | 2x2          | 3x3          | 4x4         |
|---------|--------------|--------------|-------------|
|AVG      | 0.012285847  | 0.918572427  | 164.9628396 |
|MED      | 0.002394     | 0.2367075    | 28.49811    |
|MAX      | 0.336559     | 23.208866    | 5172.51267  |

|{20,2}:  | 2x2          | 3x3          | 4x4         |
|---------|--------------|--------------|-------------|
|AVG      | 0.010361213  | 0.931323613  | 147.6124616 |
|MED      | 0.00256      | 0.244189     | 27.86586    |
|MAX      | 0.238893     | 16.673372    | 2469.026126 |

|{24,2}:  | 2x2          | 3x3          | 4x4         |
|---------|--------------|--------------|-------------|
|AVG      | 0.0048848    | 1.37826312   | 469.9271525 |
|MED      | 0.001986     | 0.1766215    | 32.546246   |
|MAX      | 0.095775     | 44.896629    | 33491.4996  |

|{28,2}:  | 2x2          | 3x3          | 4x4         |
|---------|--------------|--------------|-------------|
|AVG      | 0.008152507  | 0.769795393  | 198.4638911 |
|MED      | 0.0034785    | 0.297836     | 22.3079905  |
|MAX      | 0.067623     | 11.868287    | 9947.680456 |

|{32,2}:  | 2x2          | 3x3          | 4x4         |
|---------|--------------|--------------|-------------|
|AVG      | 0.007034413	 | 3.747612067  | 344.1819766 | 	   	 	 	 	 	 	 	   	   
|MED 	    | 0.0023385    | 0.146224     | 22.903803 	|  	     	  	 	     		 	  
|MAX 	    | 0.373717     | 392.323464   | 18897.246 	|  	   		  	 	   		   	  

The results suggest exponential growth in time based on N, on the order of 100x
per N.  The results also appear to be insensitive to the precision of the posit
number system.

## Other
Technology demonstration video is available at: https://asciinema.org/a/125169?speed=4
Example run of this program is available at:

uDESIGN is supported by
DARPA grant HR0011-17-9-0007 awarded to Etaphase, inc.

Principal contributors:

* Isaac Yonemoto
* Ruth Ann Mullen
* John Gustafson
