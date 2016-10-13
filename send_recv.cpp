/*
   Process #0 send an integer 99 to process #1 
*/

#include <mpi.h>
#include <stdio.h>
int main(int argc, char** argv)
{
  int rank,np;
  int x;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &np);

  /* assume at least 2 processes in this run */
  if (np < 2) {
    MPI_Abort(MPI_COMM_WORLD, 1);
  }

  if (rank == 0) {
    x = -99;
    MPI_Send(&x, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
  } else if (rank == 1) {
    printf("rank=%d: before receiving x = %d\n",rank,x);
    MPI_Recv(&x, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    printf("rank=%d: after receiving x = %d\n",rank,x);
  }
  MPI_Finalize();
  return 0;
}

