#
# MPI Send/Recv example
#
# mpirun -n 2 julia send.jl
#

using MPI
MPI.Init()

pid = MPI.Comm_rank(MPI.COMM_WORLD)
nproc = MPI.Comm_size(MPI.COMM_WORLD)

# this program runs only when nproc==2
if nproc != 2
    if pid==0 
        println("This program works only when nproc==2")
    end
    MPI.Abort(MPI.COMM_WORLD, 1)
    MPI.Finalize()
end

src = 0
dst = 1
N = 5

if pid == src
    data_src = Float64[ x for x in 1:N ]
else
    data_src = nothing
end

if pid == dst
    data_dst = Array{Float64}(undef, N)
else
    data_dst = nothing
end

println("[1] rank=$pid data_src=$data_src")
println("[1] rank=$pid data_dst=$data_dst")

if pid == src
    MPI.Send(data_src, dst, src, MPI.COMM_WORLD)
end
if pid == dst
    stat = MPI.Recv!(data_dst, src, src, MPI.COMM_WORLD)
end

println("[2] rank=$pid data_dst=$data_dst")
MPI.Finalize()
