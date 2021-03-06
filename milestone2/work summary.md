Milestone 2
===========

work summary:

* build a crude version of the "uslice" method that whittles down the solution space.

Initial, experimental versions:

matrix-with-uslice-manual.jl - "manually" picks the correct slices for a supplied
linear algebra problem.  Allows proof of principle.

matrix-with-uslice-automatic-1.jl - first pass at an "automatic" slice selector.
Helps decide what methods need to be committed upstream.

demonstrates the following result:

  ================
  value zero
  Ubound{3,5}(4.999999988824129 op → 5.000000008381903 op)
  Ubound{3,5}(5.9999999944120646 op → 6.000000007450581 op)
  ================
  value omega-one
  Ubound{3,5}(4.99999999627471 op → 5.000000001862645 op)
  Ubound{3,5}(5.9999999944120646 op → 6.000000007450581 op)
  ================
  value omega-two
  Ubound{3,5}(4.99999999627471 op → 5.000000001862645 op)
  Ubound{3,5}(5.999999998137355 op → 6.00000000372529 op)

which is an improvement over the original result.  The next task is to complete
the result by expanding process into the *NEXT FSS* and give results of a higher
precision than available in the "current" FSS, then backtracking and outputting
the result.  Furthermore, currently the uslice method expands into a far too
pessimistic solution space which should be restricted further.

Also should consider implementation of a check that stops the search pattern
when the deltas themselves are also at the size of a terminal ulp.

* expand into the next FSS.

created a promoteFSS that takes a utype and expands its FSS by one.

created a parallel function to isterminal() which measures if the resolution
of the solution is terminal to the previous FSS.

* further debugging of the matrix operations.

julia matrix-with-uslice-automatic-random.jl 3

sometimes throws an error

julia matrix-with-uslice-automatic-random.jl 4

almost always throws an error.  Went ahead and added debug checks.
uncovered parity errors in multilpication and division bound solving.

* debugging for higher order matrices.

problems uncovered in executing matrices size > 25.  Some random matrices of small
size < 3 or so will 'miss' the target area.  Need to investigate why.

executing matrices size > 25 has been resolved.

* discovered potential addition error.

addition of ubounds can sometimes have a single bit difference (see test case
labeled 11 September 2015).  Leaving on the "to examine" list given that the
uslice is having some problems converging on the exact answer.

* extremely long execute times for some larger matrices.

srand(10) -> results in a very long execution time for dimension 3 in a 25
dimensional matrix.  Need to examine why.

"matrix-with-uslice-automatic-random-debug-expansion.jl"

rapid expansion of execution values occurs between rounds 20->30.

* evaluation of matrix values misses for small values.

"matrix-with-uslice-automatic-random-debug-misses.jl"

srand(10) -> results in missing the target on round 22 of optimization.

presumed the lub() method fails due to some sort of symmetry breaking.  Switching
to lub(B) - glb(B) to get the full 'width' of the uncertainty does a much better
job.  However, at finer resolutions, there still is some problem with calculation,
which will probably need an "increase in fsize resolution" to adequately address.

* promoting to a next FSS

definitely is a correct strategy as it increases the resolution on the process,
however, is not necessarily correct in that it doesn't seem to address a bigger
problem of error distances converging onto the intersect point.  It's possible
that there is some sort of multiplication or division error going on here that
needs to be repaired.
