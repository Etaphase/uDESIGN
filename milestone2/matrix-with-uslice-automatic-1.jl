
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

function isterminal{U <: Utype}(ulist::Matrix{U}, dimension)
  #go ahead and just check the first item in the ulist.
  Unums.isterminal(ulist[dimension, 1])
end

function union{U <: Utype}(ulist::Matrix{U})
  uresult = Array{U}(size(ulist, 1))
  for idx = 1:size(ulist, 1)
    lowest =  Unums.resolve_lower(ulist[idx, 1].val)
    highest = Unums.resolve_upper(ulist[idx, 1].val)
    for jdx = 2:size(ulist,2)
      test_lower = Unums.resolve_lower(ulist[idx, jdx].val)
      test_upper = Unums.resolve_upper(ulist[idx, jdx].val)

      #this is a strange way to do this, but it's necessary due to ulp issues.
      !(test_lower > lowest)  && (lowest  = test_lower)
      !(test_upper < highest) && (highest = test_upper)
    end
    uresult[idx] = U(Unums.resolve_as_utype!(copy(lowest), copy(highest)))
  end
  uresult
end


#examine ulist is a function which takes a ulist and returns a range of indices
#to keep.
examine_ulist = (ulist) -> begin
  #first, generate the cumulative distance record.
  distance_record = Unums.glb.(cumdist2(M * ulist, r))
  low_range = 1
  high_range = length(distance_record)
  #start from the front end of the list.
  for idx = 1:(length(distance_record) - 2)
    if distance_record[idx] >= distance_record[idx + 1]
      low_range = idx + 1
    else
      break
    end
  end

  for idx = length(distance_record): -1 : 3
    if distance_record[idx] >= distance_record[idx - 1]
      high_range = idx - 1
    else
      break
    end
  end
  #return the keeplist
  if low_range > high_range
    return high_range : low_range
  elseif low_range == high_range
    return low_range - 1:high_range + 1
  else
    return (low_range:high_range)
  end
end

function uslice_optimize(f::Function, ulist, dimension)
  #first, divide into fours.
  ulist = uslice(ulist, dimension)
  ulist = uslice(ulist, dimension)

  while !isterminal(ulist, dimension)
    keepers = f(ulist)
    ulist = slicedim(ulist, 2, keepers)
    ulist = uslice(ulist, dimension)
  end

  #be careful with the last one.
  ulist
end

println("================")
println("value zero")
describe.(u0);

uΩ1 = uslice_optimize(examine_ulist, u0, 1)
println("================")
println("value omega-one")
uΩ1 = union(uΩ1)
describe.(uΩ1);

uΩ2 = uslice_optimize(examine_ulist, uΩ1, 2)
println("================")
println("value omega-two")
uΩ2 = union(uΩ2)
describe.(uΩ2);



#=
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
=#
