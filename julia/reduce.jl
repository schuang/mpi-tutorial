#
# MPI Reduce
#

using MPI
MPI.Init()

pid = MPI.Comm_rank(MPI.COMM_WORLD)
N = 5
root = 0

A = pid*N .+ Float64[ x for x in 1:N ]
println("[BEFORE] rank=$pid A= $A")

Ar = MPI.Reduce(A, MPI.SUM, root, MPI.COMM_WORLD)

println("[AFTER]  rank=$pid Ar=$Ar")

MPI.Finalize()
