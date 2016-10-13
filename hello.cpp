/*

   MPI "hello world" program

*/ 
#include <mpi.h>
#include <cstdio>
int main(int argc, char *argv[])
{
    int rank, nproc;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &nproc);
    printf("hello world from MPI process %d of %d\n",rank,nproc);
    MPI_Finalize(); 
}

/* Sample output

$ mpicxx hello.cpp 

$ mpirun -n 4 ./a.out
hello world from MPI process 2 of 4
hello world from MPI process 1 of 4
hello world from MPI process 0 of 4
hello world from MPI process 3 of 4

**********************************************************************/


