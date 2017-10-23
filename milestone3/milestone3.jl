#extract parameters

length(ARGS) < 2 && exit

VN = parse(ARGS[1])
DIM = parse(ARGS[2])

using SigmoidNumbers

function trim{N,ES}(v::Valid{N,ES})
    SigmoidNumbers.tile(reinterpret(Vnum{N,ES}, reinterpret(Int64, v.lower) & (reinterpret(Int64, 0x8000_0000_0000_0000) >> (N - 2))))
end

box_volume(v::Vector{Valid{N,ES}}) where {N, ES} = [Float64(x.upper) - Float64(x.lower) for x in v] |> prod
box_count(v::Vector{Valid{N,ES}}) where {N, ES} = [(reinterpret(UInt64, x.upper) >> (64 - N)) - (reinterpret(UInt64, x.lower) >> (64 - N)) + 1 for x in v] |> prod


function run_experiment(n, T)
    m = rand(n,n) .|> T .|> trim
    v = rand(n) .|> T .|> trim
    res = m \ v

    start_box_volume = box_volume(res)
    start_box_count = box_count(res)

    println("------------------------------")
    println("starting box volume: $start_box_volume")
    println("starting box count: $start_box_count")
    println(res)

    mapreduce(SigmoidNumbers.roundsinf, |, false, res) && (println("this value rounds infinity"); next)

    function testlinear(x)
        reduce(&, true, (m * x) .≹ v)
    end

    res2 = ufilter_dfs(testlinear, res)

    println(res2)
    final_box_volume = box_volume(res2)
    final_box_count = box_count(res2)
    println("final box volume: $final_box_volume")
    println("final box count: $final_box_count")
    println(100.0 - 100.0 * final_box_volume / start_box_volume, " % improvement in bounding box.")
end

run_experiment(DIM, Valid{VN, 2})
#println("precompiled.")

for idx = 1:30
  @time res = run_experiment(DIM, Valid{VN, 2})
end
