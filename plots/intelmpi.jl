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



# two processes on m3, m4
bw_intel_2on2_ib = """
1                       1.31
2                       2.98
4                       6.03
8                      12.13
16                     24.56
32                     48.93
64                     93.05
128                   182.24
256                   362.87
512                   701.04
1024                 1353.15
2048                 2401.94
4096                 3962.92
8192                 5315.25
16384                5601.18
32768                5796.25
65536                5983.74
131072               6118.60
262144               6144.27
524288               6115.43
1048576              6208.90
2097152              6265.87
4194304              6295.43"""


x2, y2 = parse_data(bw_intel_2on2_ib)

p = plot(x2,y2, xaxis=:log, legend=:topleft, labels ="",
    color=:black,
    xlabel="data size (bytes)", ylabel="bandwidth (MB/s)",
    title = "intel 18.04/MPI + IB")
scatter!(x2, y2, color=:red, labels="")

savefig(p, "intelmpi_bw_ib.svg")



latency_intel_2on2_ib = """
1                       2.15
2                       2.11
4                       2.11
8                       2.11
16                      2.11
32                      2.18
64                      2.76
128                     2.74
256                     2.80
512                     2.91
1024                    3.17
2048                    3.72
4096                    4.19
8192                    5.25
16384                   6.72
32768                   9.91
65536                  15.65
131072                 26.73
262144                 49.02
524288                266.18
1048576               385.16
2097152               644.03
4194304              1134.77"""

x1, y1 = parse_data(latency_intel_2on2_ib)

p = plot(x1,y1, xaxis=:log, legend=:topleft, labels ="",
    color=:black, title="Intel 18.04/MPI + IB", 
    xlabel="data size (bytes)", ylabel="latency (μs)")
scatter!(p, x1[2:end], y1[2:end], labels="", color=:red)

savefig(p, "intelmpi_latency_ib.svg")



latency_tcp = """
2                      47.82
4                      34.49
8                      24.81
16                     39.40
32                     48.98
64                     48.93
128                    47.81
256                    48.99
512                    54.00
1024                   95.99
2048                  112.33
4096                  237.45
8192                  209.78
16384                 294.54
32768                 425.59
65536                 822.58
131072               1293.26
262144               2646.31
524288               4807.61
1048576              9309.21"""

bw_tcp = """
1                       0.25
2                       0.49
4                       1.01
8                       1.94
16                      4.04
32                      6.76
64                     13.42
128                    23.07
256                    41.79
512                    65.82
1024                   90.86
2048                  100.68
4096                  106.34
8192                  110.36
16384                 114.17
32768                 116.25
65536                 116.84
131072                117.20
262144                117.31
524288                117.52
1048576               117.60
2097152               117.64
4194304               117.63"""

x1, y1 = parse_data(latency_tcp)
x2, y2 = parse_data(latency_intel_2on2_ib)

p = plot(x1, y1, xaxis = :log, yaxis=:log, 
        title="Intel MPI latency: Infiniband vs TCP",
        labels="TCP", color=:blue, legend=:topleft,
        xlabel="data size (bytes)", ylabel="latency (μs)")
plot!(p, x2,y2, labels="Infiniband", color=:red)
scatter!(p, x1, y1, color=:blue, labels="")
scatter!(p, x2, y2, color=:red, labels="")
ylims!(p, (1, 1e4))
savefig(p, "intel_latency_tcp_vs_ib.svg")


x1, y1 = parse_data(bw_tcp)
x2, y2 = parse_data(bw_intel_2on2_ib)
p = plot(x1, y1, xaxis = :log, yaxis = :log,
        title="Intel MPI bandwidth: Infiniband vs TCP",
        labels="TCP", color=:blue, legend=:topleft,
        xlabel="data size (bytes)", ylabel="bandwidth (MB/s)")
plot!(p, x2,y2, labels="Infiniband", color=:red)
scatter!(p, x1, y1, color=:blue, labels="")
scatter!(p, x2, y2, color=:red, labels="")
ylims!(p, (0.1, 1e4))

savefig(p, "intel_bw_tcp_vs_ib.svg")
