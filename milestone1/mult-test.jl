using Unums

lhs = Unum{3,5}(0x0000000000000001, 0x5555555500000000, 0x0001, 0x0002, 0x001F)
rhs = Unum{3,5}(0x000000000000000C, 0x3800000000000000, 0x0000, 0x0003, 0x001F)

res = lhs * rhs

println("result:")
println(res)
describe(res)
