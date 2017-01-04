M = Float32[1 2
            3 4]
v = Float32[5; 6]
r = M * v
M \ r

using Unums

import Base: +, -, *, /

U = Utype{3,5}

#inject reporting into the operator definitions.  Maybe we can find which operation
#is causing problems.

function +(lhs::U, rhs::U)
  println("====================")
  println("operation +")
  print("lhs:"); describe(lhs)
  print("rhs:"); describe(rhs)
  res = U(lhs.val + rhs.val)
  print("res:"); describe(res)
  res
end
function -(lhs::U, rhs::U)
  println("====================")
  println("operation -")
  print("lhs:"); describe(lhs)
  print("rhs:"); describe(rhs)
  println("lhs:", lhs)
  println("rhs:", rhs)
  res = U(lhs.val - rhs.val)
  print("res:"); describe(res)
  res
end
function *(lhs::U, rhs::U)
  println("====================")
  println("operation *")
  print("lhs:"); describe(lhs)
  print("rhs:"); describe(rhs)
  res::U = U(lhs.val * rhs.val)
  print("res:"); describe(res)
  res
end
function /(lhs::U, rhs::U)
  println("====================")
  println("operation /")
  print("lhs:"); describe(lhs)
  print("rhs:"); describe(rhs)
  res::U = U(lhs.val / rhs.val)
  print("res:"); describe(res)
  res
end

#don't know why this is necessary, but julia's type system freaks out when the
#above functions are injected.  Identified the culprit operation:

#
# operation *
# lhs:Unum{3,5}(0.3333333333139308 op → 0.33333333337213844 op)
# rhs:Unum{3,5}(39.0 ex)
# res:Unum{3,5}(12.999999998137355 op → 13.0 op)
#

#discovered a second culprit operation:
#
# operation -
# lhs:Unum{3,5}(17.0 ex)
# rhs:Ubound{3,5}(12.999999998137355 op → 13.000000001862645 op)
# res:Ubound{3,5}(2.9999999997671694 op → 4.000000001862645 op)
#

Base.one(::Type{Any}) = one(U)

M = U[1 2
      3 4]
v = U[5; 6]
r = M * v
res = M \ r
