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
