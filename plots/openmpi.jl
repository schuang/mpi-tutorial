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

latency_ompi_ucx = """
1                       1.93
2                       1.93
4                       1.93
8                       1.93
16                      1.94
32                      1.96
64                      2.07
128                     2.82
256                     2.96
512                     3.07
1024                    3.29
2048                    3.77
4096                    4.26
8192                    5.31
16384                   7.07
32768                   9.84
65536                  15.62
131072                 25.97
262144                 47.80
524288                 88.90
1048576               171.11
2097152               335.06
4194304               664.93"""


bw_ompi_ucx = """
1                       3.30
2                       7.06
4                      14.60
8                      29.16
16                     58.38
32                    115.82
64                    212.69
128                   366.53
256                   662.03
512                  1248.94
1024                 2022.70
2048                 4023.61
4096                 4970.19
8192                 5578.00
16384                5726.58
32768                5835.57
65536                5895.50
131072               5933.27
262144               6370.04
524288               6384.61
1048576              6392.38
2097152              6405.55
4194304              6405.41"""


x1, y1 = parse_data(latency_ompi_ucx)
x2, y2 = parse_data(bw_ompi_ucx)

p = plot(x2,y2, xaxis=:log, legend=:topleft, labels ="",
    color=:black,
    xlabel="data size (bytes)", ylabel="bandwidth (MB/s)",
    title = "OpenMPI 4.1.2 + ucx")
scatter!(x2, y2, color=:red, labels="")
savefig(p, "ompi_bw_ucx.svg")



p = plot(x1,y1, xaxis=:log, legend=:topleft, labels ="",
    color=:black,
    xlabel="data size (bytes)", ylabel="latency (μs)",
    title = "OpenMPI 4.1.2 + ucx")
scatter!(x1[2:end], y1[2:end], color=:red, labels="")
savefig(p, "ompi_latency_ucx.svg")


# TCP data

bw_tcp = """
2                       0.57
4                       1.08
8                       2.15
16                      3.86
32                      7.42
64                     13.21
128                    22.64
256                    41.38
512                    62.72
1024                   90.03
2048                  100.75
4096                  106.47
8192                  110.89
16384                 114.27
32768                 116.27
65536                 116.21
131072                116.85
262144                117.28
524288                117.51
1048576               117.60
2097152               117.64
4194304               117.66"""


latency_tcp = """
1                      24.62
2                      24.49
4                      24.50
8                      24.50
16                     24.59
32                     24.51
64                     24.57
128                    25.00
256                    48.98
512                    51.99
1024                   74.88
2048                  118.95
4096                  154.72
8192                  202.36
16384                 252.88
32768                 432.08
65536                 973.53
131072               1543.98
262144               2650.59
524288               4801.94"""


# latency plot

x2, y2 = parse_data(latency_ompi_ucx)
x1, y1 = parse_data(latency_tcp)

p = plot(x1, y1, xaxis = :log, yaxis=:log, 
        title="OpenMPI latency: Infiniband vs TCP",
        labels="TCP", color=:blue, legend=:topleft,
        xlabel="data size (bytes)", ylabel="latency (μs)")
scatter!(p, x1, y1, color=:blue, labels="")

plot!(p, x2,y2, labels="Infiniband", color=:red)
scatter!(p, x2, y2, color=:red, labels="")
ylims!(p, (1, 1e4))
savefig(p, "ompi_latency_tcp_vs_ib.svg")


# bandwidth plot

x1, y1 = parse_data(bw_tcp)
x2, y2 = parse_data(bw_ompi_ucx)
p = plot(x1, y1, xaxis = :log, yaxis = :log,
        title="OpenMPI bandwidth: Infiniband vs TCP",
        labels="TCP", color=:blue, legend=:topleft,
        xlabel="data size (bytes)", ylabel="bandwidth (MB/s)")
plot!(p, x2,y2, labels="Infiniband", color=:red)
scatter!(p, x1, y1, color=:blue, labels="")
scatter!(p, x2, y2, color=:red, labels="")
ylims!(p, (0.1, 1e4))

savefig(p, "ompi_bw_tcp_vs_ib.svg")
