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



p = plot(x1,y1, xaxis=:log, legend=:topleft, labels ="",
    color=:black,
    xlabel="data size (bytes)", ylabel="latency (μs)",
    title = "MPICH 3.4.3 + ucx")
scatter!(x1, y1, color=:red, labels="")
savefig(p, "mpich_latency_ucx.svg")


# IB rate 100 data

ib100_bw = """
1                       6.04
2                      12.16
4                      24.57
8                      49.70
16                     96.99
32                    195.49
64                    362.26
128                   716.18
256                  1119.77
512                  2095.57
1024                 3605.24
2048                 5677.92
4096                 8615.30
8192                10370.51
16384               10958.18
32768               11367.36
65536               11798.74
131072              11943.84
262144              12011.13
524288              12041.85
1048576             12055.46
2097152             12052.02
4194304             12037.77"""

ib100_latency = """
1                       0.95
2                       0.95
4                       0.95
8                       0.95
16                      0.95
32                      1.00
64                      1.13
128                     1.16
256                     1.65
512                     1.74
1024                    1.94
2048                    2.32
4096                    2.91
8192                    3.55
16384                   5.35
32768                   7.32
65536                  10.11
131072                 15.89
262144                 26.74
524288                 48.67
1048576                93.57
2097152               180.16
4194304               354.69"""


# IB rate 56 vs 100: latency

x1, y1 = parse_data(latency_mpich_ucx)
a1, b1 = parse_data(ib100_latency)


p = plot(x1,y1, xaxis=:log, yaxis=:log, legend=:topleft, labels ="FDR (IB rate = 56)",
    color=:blue,
    xlabel="data size (bytes)", ylabel="Latency (μs)",
    title = "MPICH 3.4.3/UCX")
scatter!(x1, y1, color=:blue, labels="")

plot!(a1,b1, labels ="EDR (IB rate = 100)", color=:red)
scatter!(a1, b1, color=:red, labels="")
ylims!(p, (1e-1, 1e3))
savefig(p, "mpich_ibrate_latency.svg")


# IB rate 56 vs 100: bandwidth

x2, y2 = parse_data(bw_mpich_ucx)
a2, b2 = parse_data(ib100_bw)

p = plot(x2,y2, xaxis=:log, yaxis=:log, 
    legend=:topleft, labels ="FDR (IB rate = 56)",
    color=:blue,
    xlabel="data size (bytes)", ylabel="bandwidth (MB/s)",
    title = "MPICH 3.4.3/UCX")
scatter!(x2, y2, color=:blue, labels="")

plot!(a2,b2, labels ="EDR (IB rate = 100)", color=:red)
scatter!(a2, b2, color=:red, labels="")
ylims!(p, (1, 1e5))

savefig(p, "mpich_ibrate_bandwidth.svg")



# Running across IB switches

# same leaf switch: n7640 to n7641
# across leaf switch: n7640 to 6674

same_switch_ib100_bw = """
1                       6.01
2                      12.12
4                      24.74
8                      48.18
16                     97.54
32                    195.78
64                    371.50
128                   720.41
256                  1113.19
512                  2072.38
1024                 3574.04
2048                 5679.88
4096                 8616.80
8192                10334.32
16384               10927.52
32768               11308.11
65536               11772.47
131072              11943.93
262144              12009.42
524288              12040.36
1048576             12055.60
2097152             12052.53
4194304             12062.58"""

across_switch_ib100_bw = """
1                       5.48
2                      11.29                                                                                                  4                      22.65
8                      45.54                                                                                                  16                     91.54
32                    180.29
64                    347.92
128                   661.14
256                  1033.63
512                  1946.11
1024                 3375.49
2048                 4957.71
4096                 5633.42
8192                 6047.30
16384                6214.54
32768                6323.27
65536                6396.02
131072               6456.37
262144               6473.75
524288               6483.74
1048576              6489.82
2097152              6489.25
4194304              6492.92"""

x1,y1 = parse_data(same_switch_ib100_bw)
x2,y2 = parse_data(across_switch_ib100_bw)

p = plot(x1,y1, xaxis=:log, yaxis=:log, 
    legend=:topleft, labels ="same leaf switch (EDR)",
    color=:blue,
    xlabel="data size (bytes)", ylabel="bandwidth (MB/s)",
    title = "MPICH 3.4.3/UCX")
scatter!(x1, y1, color=:blue, labels="")

plot!(x2,y2, labels ="across leaf switch (EDR)", color=:red)
scatter!(x2,y2, color=:red, labels="")
ylims!(p, (1, 1e5))

savefig(p, "mpich_bandwidth_cross_edr_switch.svg")


across_switch_ib100_latency = """
1                       1.40
2                       1.39
4                       1.40
8                       1.39                                                                                                  16                      1.40
32                      1.45
64                      1.57
128                     1.62
256                     2.11
512                     2.22
1024                    2.46
2048                    2.91
4096                    3.62
8192                    4.48
16384                   6.40
32768                   9.44
65536                  16.03
131072                 26.11
262144                 46.34
524288                 87.59
1048576               169.50
2097152               332.86
4194304               659.30"""

same_switch_ib100_latency = """
1                       0.96
2                       0.96
4                       0.96
8                       0.96
16                      0.97
32                      1.01
64                      1.12
128                     1.15
256                     1.65
512                     1.73
1024                    1.94
2048                    2.31
4096                    2.90
8192                    3.50
16384                   5.39
32768                   7.23
65536                  10.12
131072                 15.93
262144                 26.68
524288                 48.64
1048576                93.05
2097152               180.42
4194304               354.85"""


x1,y1 = parse_data(same_switch_ib100_latency)
x2,y2 = parse_data(across_switch_ib100_latency)

p = plot(x1,y1, xaxis=:log, yaxis=:log, 
    legend=:topleft, labels ="same leaf switch (EDR)",
    color=:blue,
    xlabel="data size (bytes)", ylabel="latency (μs)",
    title = "MPICH 3.4.3/UCX")
scatter!(x1, y1, color=:blue, labels="")

plot!(x2,y2, labels ="across leaf switch (EDR)", color=:red)
scatter!(x2,y2, color=:red, labels="")
ylims!(p, (0.1, 1e3))

savefig(p, "mpich_latency_cross_edr_switch.svg")