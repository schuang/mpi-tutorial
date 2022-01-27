program hello

use mpi

integer rank, size, ierror

call MPI_INIT(ierror)
call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierror)
call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierror)
print*, 'Hello from process', rank, 'of', size
call MPI_FINALIZE(ierror)
end
