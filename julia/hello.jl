#
# Print out the process' MPI rank
#

using MPI
MPI.Init()

rank = MPI.Comm_rank(MPI.COMM_WORLD)
nproc = MPI.Comm_size(MPI.COMM_WORLD)
println("hello world, rank $rank of $nproc")

MPI.Finalize()

