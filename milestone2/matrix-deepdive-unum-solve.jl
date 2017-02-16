using Unums
U = Utype{3,6}
M = U[-832  -244
      -1019 -247];
r = U[190916.0, 233567.0];
dim1 = Ubound(Unum{3,6}(0x000000000000000E, 0xC800000300000000, 0x0003, 0x0003, 0x001F), Unum{3,6}(0x000000000000000E, 0xC7FFFFFE00000000, 0x0003, 0x0003, 0x001F))

makevector(x) = U[dim1, x]

v1 = makevector(Unum{3,6}(0x0000000000000003, 0x4000004000000000, 0x0003, 0x0001, 0x0019))
v2 = makevector(Unum{3,6}(0x0000000000000003, 0x4000000000000000, 0x0003, 0x0001, 0x0019))
v3 = makevector(Unum{3,6}(0x0000000000000003, 0x3FFFFFC000000000, 0x0003, 0x0001, 0x0019))
v4 = makevector(Unum{3,6}(0x0000000000000003, 0x3FFFFF8000000000, 0x0003, 0x0001, 0x0019))

println("----")
describe.(M * v1 - r)
println("----")
describe.(M * v2 - r)
println("----")
describe.(M * v3 - r)
println("----")
describe.(M * v4 - r)

println("====")

################################################################################
# we know that #3 and #4 are providing odd answers.  Let's check #3 by manually
# doing the matrix multiplication in the first coordinate (the one that's wonky)

#first multiplication:
checkval1 = U(-832) * U(dim1)
describe(checkval1)

#second multiplication:
checkval2 = U(-244) * U(Unum{3,6}(0x0000000000000003, 0x3FFFFFC000000000, 0x0003, 0x0001, 0x0019))
describe(checkval2)

println("====")

println(checkval1)
println(checkval2)
#sum.
sumval = checkval1 + checkval2

describe(sumval)
println("===== checking incorrect multiplication")
describe(v3[2])
describe(v3[2] * U(-244))
