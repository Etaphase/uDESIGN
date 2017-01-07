M = Float32[1 2
            3 4]
v = Float32[5; 6]
r = M * v
M \ r

using Unums
U = Utype{3,5}
M = U[1 2
      3 4]
v = U[5; 6]
r = M * v
u0 = M \ r

function cumdist2(table, v)
  res = Vector{Utype}(size(table,2))
  for jdx = 1:size(table,2)
   sumdist = Utype(zero(Unum{3,5}))
   for idx = 1:size(table,1)
     sumdist += Unums.lub(Unums.abs(table[idx,jdx] - v[idx]))
   end
   res[jdx] = sumdist
  end
  res
end

#first, divide into fours.
ulist = uslice(u0,1)
ulist = uslice(ulist, 1)
for idx = 1:20
  println("----")
  describe.(cumdist2(M * ulist, r))
  ulist = uslice(ulist[:,2:3], 1)
end

function merge{ESS,FSS}(a::Array{Utype{ESS,FSS}})
  #for now.
  Utype(Ubound(a[1].val, a[2].val))
end

println("====")
describe.(ulist);
#experimentally, take the middle uslice and turn it into a ubound.
ulist = Utype{3,5}[merge(ulist[1,2:3]),ulist[2,1]]
describe.(ulist);
println("====")

ulist = uslice(ulist,2)
ulist = uslice(ulist,2)
for idx = 1:20
  println("----")
  describe.(cumdist2(M * ulist, r))
  ulist = uslice(ulist[:,2:3], 2)
end
