#demonstration suite

0.1 + 0.2 == 0.3

using Unums

U = Unum{3,5}
U(0.1) + U(0.2) == U(0.3)
describe(U(0.1) + U(0.2))
describe(U(0.3))
U(0.1) + U(0.2) ≹ U(0.3)

describe(U(33) * U(10))
describe(U(1500) + U(2144))
describe(U(33) / U(10))

U2 = Unum{4,7}
bits(U2(1) / U2(3), " ")

U = Utype{3,5}
issqrt2(x) = x * x ≹ U(2)
res = ufilter(issqrt2, Ubound(U(-Inf), U(Inf)), Val{true})
describe.(res);

M = [5 7
     4 3]
v = [9,2]
r = M * v
M \ r

MU = U.(M);
vu = U.(v);
ru = MU * vu;

describe.(MU \ ru)

function solvelinear(M, r)
  startsoln = M \ r
  filtered = ufilter((v) -> M * v .≹ r, startsoln)
  for idx = 1:size(filtered, 2)
    if *(is_exact.(filtered[:,idx])...)
      return filtered[:,idx]
    end
  end
  return filtered
end

describe.(solvelinear(MU, ru));
