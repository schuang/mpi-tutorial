using MPI
MPI.Init()
comm = MPI.COMM_WORLD
pid = MPI.Comm_rank(comm)
nproc = MPI.Comm_size(comm)
N = 16
root = 0

A = Float64[ 100 * pid + i for i in 1:N ]

if pid == root
    println("[1] rank=$pid A=$A")
end

B = Array{Float64}(undef, N ÷ nproc)
MPI.Scatter!( MPI.UBuffer(A, N÷nproc, nproc, MPI.DOUBLE),
              B, root, comm)

println("[2] rank=$pid B=$B")

MPI.Finalize()



