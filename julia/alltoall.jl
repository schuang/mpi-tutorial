#
# MPI Alltoall
#
# mpirun -n 3 julia alltoall.jl

using MPI
MPI.Init()

pid    = MPI.Comm_rank(MPI.COMM_WORLD)
nproc  = MPI.Comm_size(MPI.COMM_WORLD)
N      = 6

X = [ 100*(pid+1) + x for x in 1:N ]
Y = [ 0 for x in 1:N ]

xbuf = MPI.UBuffer(X, N ÷ nproc, nproc, MPI.DOUBLE)
ybuf = MPI.UBuffer(Y, N ÷ nproc, nproc, MPI.DOUBLE)

println("(BEFORE) rank=$pid X=$X")

MPI.Alltoall!(xbuf, ybuf, MPI.COMM_WORLD)

println("(AFTER) rank=$pid Y=$Y")

MPI.Finalize()
