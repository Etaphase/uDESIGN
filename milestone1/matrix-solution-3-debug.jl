srand(10)

M = rand(0:1023, 5, 5)
v = rand(0:1023, 5)
r = M * v

vsolv = M \ r

using Unums

import Base: +, -, *, /

U = Utype{3,6}

#inject reporting into the operator definitions.  Maybe we can find which operation
#is causing problems.

function +(lhs::U, rhs::U)
  println("====================")
  println("operation +")
  print("lhs:"); describe(lhs)
  print("rhs:"); describe(rhs)
  println("lhs:", lhs)
  println("rhs:", rhs)
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
  println("lhs:", lhs)
  println("rhs:", rhs)
  res::U = U(lhs.val * rhs.val)
  print("res:"); describe(res)
  res
end
function /(lhs::U, rhs::U)
  println("====================")
  println("operation /")
  print("lhs:"); describe(lhs)
  print("rhs:"); describe(rhs)
  println("lhs:", lhs)
  println("rhs:", rhs)
  res::U = U(lhs.val / rhs.val)
  print("res:"); describe(res)
  res
end

#don't know why this is necessary, but julia's type system freaks out when the
#above functions are injected.  Identified the culprit operation:

Base.one(::Type{Any}) = one(U)

MU = map(U, M)
ru = map(U, r)

usolv = MU \ ru
