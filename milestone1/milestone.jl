using Unums

print("input ESS: ")
ESS = chomp(readline())

print("input FSS: ")
FSS = chomp(readline())

U = Utype{parse(ESS), parse(FSS)}

print("input function to solve: f(x) = ")
fstring = readline()

pfstring = parse(fstring)

unum_sub(e::Symbol) = e
unum_sub(e::Union{Integer, Float64, Float32}) = :(U($e))
function unum_sub(e::Expr)
  if e.head == :call
    if e.args[1] in [:+, :-, :*, :/]
      e.args[2] = unum_sub(e.args[2])
      e.args[3] = unum_sub(e.args[3])
    end
  end
  e
end


print("lower bound (enter for all real #s): ")
lboundstring = readline()
if chomp(lboundstring) == ""
  lbound = U(-Inf)
  ubound = U(Inf)
else
  lbound = U(eval(parse(chomp(lboundstring))))
  print("upper bound: ")
  uboundstring = readline()
  ubound = U(eval(parse(chomp(uboundstring))))
end


unum_sub(pfstring)

pfdef = parse("h(x) = ($pfstring) ≹ zero(U)")
eval(pfdef)

res = ufilter(h, Ubound(lbound, ubound), Val{true})

println("results:")
describe.(res)
