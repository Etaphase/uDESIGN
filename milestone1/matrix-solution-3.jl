dim = parse(Int64, ARGS[1]);

M = rand(0:1023, dim, dim);
v = rand(0:1023, dim);
r = M * v;

vsolv = M \ r;

using Unums

U = Utype{3,5};

MU = map(U, M);
ru = map(U, r);

usolv = MU \ ru;

check = (v) -> prod(map(≹, MU * v, ru));
@time res2 = ufilter(check, usolv)
#describe.(res2);
