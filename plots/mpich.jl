using Plots

function parse_data(data)
    x = []
    y = []
    for d in split(data, "\n")
        a, b = split(d)
        a = parse(Int, a)
        b = parse(Float64, b)
        push!(x, a)
        push!(y, b)
    end
    return x, y
end

latency_mpich_ucx = """
0                       2.07
1                       2.00
2                       2.00
4                       2.00
8                       2.00
16                      1.96
32                      1.97
64                      2.06
128                     2.74
256                     2.83
512                     2.99
1024                    3.30
2048                    3.81
4096                    4.31
8192                    5.35
16384                   6.66
32768                   9.57
65536                  15.03
131072                 26.43
262144                 48.18
524288                 89.09
1048576               171.33
2097152               336.11
4194304               667.19"""


bw_mpich_ucx = """
1                       3.15
2                       6.50
4                      13.51
8                      27.05
16                     55.02
32                    108.71
64                    201.35
128                   358.63
256                   650.60
512                  1184.41
1024                 2108.70
2048                 3958.20
4096                 4976.05
8192                 5553.37
16384                5737.18
32768                5834.39
65536                5898.57
131072               5945.91
262144               6367.82
524288               6362.43
1048576              6361.75
2097152              6377.16
4194304              6356.95"""



x1, y1 = parse_data(latency_mpich_ucx)
x2, y2 = parse_data(bw_mpich_ucx)

p = plot(x2,y2, xaxis=:log, legend=:topleft, labels ="",
    color=:black,
    xlabel="data size (bytes)", ylabel="bandwidth (MB/s)",
    title = "MPICH 3.4.3 + ucx")
scatter!(x2, y2, color=:red, labels="")
savefig(p, "mpich_bw_ucx.svg")



p = plot(x1[2:end],y1[2:end], xaxis=:log, legend=:topleft, labels ="",
    color=:black,
    xlabel="data size (bytes)", ylabel="latency (μs)",
    title = "MPICH 3.4.3 + ucx")
scatter!(x1[2:end], y1[2:end], color=:red, labels="")
savefig(p, "mpich_latency_ucx.svg")