#include <mpi.h>
#include <stdio.h>

int main(int argc, char* argv[])
{
  int rank, np, i;
  int x[3];

  MPI_Init(&argc, &argv);
 
  if (rank==0) {
    x[0] = 1;
    x[1] = 2;
    x[2] = 3;
  }

  if (rank==1) {
    printf("Before bcast\n");
    for(i=0; i<3; i++) {
       printf("rank=%d x[%d]=%d\n",rank,i,x[i]);
    }
  }

  /* broadcat from process #0 to all other processes */
  MPI_Bcast(x,3,MPI_INT,0,MPI_COMM_WORLD);

  if (rank==1) {
    printf("After bcast\n");
    for(i=0; i<3; i++) {
       printf("rank=%d x[%d]=%d\n",rank,i,x[i]);
    }
  }

  MPI_Finalize();
  return 0;
}
