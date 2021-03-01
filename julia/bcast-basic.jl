using MPI

MPI.Init()
root = 0
N = 3
pid = MPI.Comm_rank(MPI.COMM_WORLD)

if pid == root
    A = [ 10.0*i for i in 1:N ]
else
    A = Array{Float64}(undef, N)
end
println("[1] rank = $(pid) A=$A")

MPI.Bcast!(A, root, MPI.COMM_WORLD)

println("[2] rank = $(pid) A=$A")
MPI.Finalize()

