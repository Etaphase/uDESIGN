M = Float32[1 2
            3 4]
v = Float32[5; 6]
r = M * v
M \ r

using Unums
U = Utype{3,5};
M = U[1 2
      3 4];
v = U[5; 6];
r = M * v;
res = M \ r;
describe.(res);

check = (v) -> prod(map(≹, M * v, r));
res2 = ufilter(check, res);
describe.(res2);
