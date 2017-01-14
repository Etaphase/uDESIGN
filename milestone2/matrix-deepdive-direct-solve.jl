M = [-832  -244
     -1019 -247]

v1 = [-228.0000001192093,  -5.0000001192092896]
v2 = [-227.99999994039536, -5.000000059604645]
v3 = [-228.0000001192093,  -5.000000059604645]
v4 = [-227.99999994039536, -5.0000000000000000]
v5 = [-228.0000001192093,  -5.0000000000000000]
v6 = [-227.99999994039536, -4.999999761581421]
v7 = [-228.0000001192093,  -4.999999761581421]
v8 = [-227.99999994039536, -4.999999523162842]

r1 = (M * v1 - [190916.0, 233567.0])
r2 = (M * v2 - [190916.0, 233567.0])

x1 = max(abs.(r1[1]), abs.(r2[1]))
x2 = max(abs.(r1[2]), abs.(r2[2]))
println(x1,"\n",x2)
println(x1   +  x2)
println(x1^2 +  x2^2)

println("-----")

r3 = (M * v3 - [190916.0, 233567.0])
r4 = (M * v4 - [190916.0, 233567.0])

x1 = max(abs.(r3[1]), abs.(r4[1]))
x2 = max(abs.(r3[2]), abs.(r4[2]))
println(x1,"\n",x2)
println(x1   +  x2)
println(x1^2 +  x2^2)

println("-----")

r5 = (M * v5 - [190916.0, 233567.0])
r6 = (M * v6 - [190916.0, 233567.0])

x1 = max(abs.(r5[1]), abs.(r6[1]))
x2 = max(abs.(r5[2]), abs.(r6[2]))
println(x1,"\n",x2)
println(x1   +  x2)
println(x1^2 +  x2^2)

println("-----")

r7 = (M * v7 - [190916.0, 233567.0])
r8 = (M * v8 - [190916.0, 233567.0])

x1 = max(abs.(r7[1]), abs.(r8[1]))
x2 = max(abs.(r7[2]), abs.(r8[2]))
println(x1,"\n",x2)
println(x1   +  x2)
println(x1^2 +  x2^2)

println("==== double check 3, bignum")

#double check part 3, except in bignum.
MB = map(big, M)
v5b = map(big, v5)
v6b = map(big, v6)

r5b = (MB * v5b - [190916.0, 233567.0])
r6b = (MB * v6b - [190916.0, 233567.0])

x1b = max(abs.(r5b[1]), abs.(r6b[1]))
x2b = max(abs.(r5b[2]), abs.(r6b[2]))

println(x1b)
println(x2b)

println("===== checking individual multiplications")

a1 = v5b[1] * MB[1,1]
a2 = v6b[1] * MB[1,1]
a3 = v5b[2] * MB[1,2]
a4 = v6b[2] * MB[1,2]

println(a1)
println(a2)
println(a3)
println(a4)

println("===== checking sums")

slow = a4 + a2
shi = a3 + a1

println(slow)
println(shi)
