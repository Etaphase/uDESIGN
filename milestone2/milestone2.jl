#check to make sure we're using julia version 0.5.x
((VERSION.major == 0) && (VERSION.minor == 5)) || (error("must use julia version 0.5.0"))

#check to make sure we've passed a file.
length(ARGS) < 1 && (error("needs a file to open"); exit())

filename = ARGS[1]

#load up the sigmoidnumbers library and set P32 to be the {32,2} posit environment
using SigmoidNumbers
P32 = Posit{32,2}

#actual matrix value is going to be here.  We'll store it as Float64.
actualmatrix = Matrix{Float64}()
actualvector = Vector{Float64}()

open(filename, "r") do f
  row = 0
  matrixrow = Vector{Float64}()
  vectorval = 0

  global actualmatrix
  global actualvector

  for line in readlines(f)
    #first trim off anything after any pound signs
    content = split(line, "#")[1] |> strip

    #ignore otherwise blank lines.
    if content == ""
      continue
    end

    #check to make sure that the content looks correct (as in, has a divider).
    if !ismatch(r".*\|.*", content)
      error("line doesn't have proper format:  $line")
      exit()
    end

    #next split the content along the line
    (matrixline, vectorline) = split(content, "|")

    #split the matrix lines
    try
      matrixrow = Float64.(parse.(split(matrixline)))
      vectorval = Float64(parse(vectorline))
    catch e
      error("line is not parseable: $line")
      exit()
    end

    row += 1
    #check to see if we haven't already synthesized the matrix.
    if (row == 1)
      l = length(matrixrow)
      actualmatrix = zeros(Float64, l, l)
      actualvector = zeros(Float64, l)
    end

    #fill values in
    actualmatrix[row, :] = matrixrow[:]
    actualvector[row] = vectorval
  end
end

#next renormalize actualvector and actualmatrix so that it can be expressible as Posit-32.
actualvector = Float64.(P32.(actualvector))
actualmatrix = Float64.(P32.(actualmatrix))

#next, solve the matrix in big floating point
actualsoln = actualmatrix \ actualvector

#calculatle what t he solution should be in 32-bit IEEE
actual_f32soln = Float32.(actualsoln)

#then solve it in 32-bit floating point.
f32soln = Float32.(actualmatrix) \ Float32.(actualvector)

#then convert the actual solution to Posit{32,2}
actual_positsoln = P32.(Float64.(actualsoln))

#then do a iterative solution using exact dot product
positsoln = solve(P32.(actualmatrix), P32.(actualvector))
old_residualsum = sum(abs, SigmoidNumbers.find_residuals(P32.(actualmatrix), positsoln, P32.(actualvector)))
while (true)
  positsoln = refine(positsoln, P32.(actualmatrix), P32.(actualvector))
  new_residualsum = sum(abs, SigmoidNumbers.find_residuals(P32.(actualmatrix), positsoln, P32.(actualvector)))
  (new_residualsum >= old_residualsum) && break
  old_residualsum = new_residualsum
end

#a simple formatting tool
function fformat(x)
  sx = string(Float64(x))
  pad = 24 - length(sx)
  string(" " ^ pad, sx)
end

function fformat2(x::Posit)
  sx = "0x" * hex(reinterpret(UInt64, x) >> 32, 8)
  pad = 24 - length(sx)
  string(" " ^ pad, sx)
end

labels = ["Float64  solution vector    :",
          "closest 32-bit IEEE vector  :",
          "solved  32-bit IEEE vector  :",
          "closest {32,2} posit vector :",
          "solved  {32,2} posit vector :"]

for (label, list) in zip(labels, (actualsoln, actual_f32soln, f32soln, actual_positsoln, positsoln))
  println(label, join(map(fformat, list), "|"))
end

IEEEdeviation  = sum(abs, Float64.(f32soln - Float32.(actualsoln)))
println("deviation of IEEE32 solution: $(IEEEdeviation)")
positresiduals = sum(abs, Float64.(positsoln - P32.(actualsoln)))
println("deviation of posit-solution : $(Float64(positresiduals))")

IEEEresiduals  = sum(abs, actualvector - actualmatrix * Float64.(f32soln))
println("residuals of IEEE32 solution: $(IEEEresiduals)")
positresiduals = sum(abs, SigmoidNumbers.find_residuals(P32.(actualmatrix), positsoln, P32.(actualvector)))
println("residuals of posit-solution : $(Float64(positresiduals))")
