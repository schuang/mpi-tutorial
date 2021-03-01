using MPI

MPI.Init()
comm = MPI.COMM_WORLD
pid = MPI.Comm_rank(comm)
nproc = MPI.Comm_size(comm)
N = 4
root = 0

A = Float64[ 100*(pid+1) + i for i in 1:N ]
println("[1] rank=$pid A=$A")

B = Array{Float64}(undef, nproc*N)
recvbuf = MPI.UBuffer(B, N, nproc, MPI.DOUBLE)

MPI.Allgather!(A, recvbuf, comm)

println("[2] rank=$pid B=$B")

MPI.Finalize()
