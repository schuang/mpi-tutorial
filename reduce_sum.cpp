/*

   MPI_Reduce (sum) example : parallel sum of 1 to N

*/
#include <cstdio>
#include <mpi.h>
#include <vector>
int main(int argc, char *argv[])
{
    const int         N = 10;
    int               rank, nproc;
    std::vector<int>  data;
    int               sum_loc;
    int               sum;

    MPI_Init(&argc,&argv);
    MPI_Comm_size(MPI_COMM_WORLD, &nproc);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    
    if (N%nproc !=0) {
	MPI_Abort(MPI_COMM_WORLD,1);
    }

    /* each process initialize its own data */

    data.resize(N/nproc);
    for (unsigned int i=0; i<data.size(); i++) {
	int offset = rank*(N/nproc);
	data[i] = offset + i + 1 ;
    }

    /* compute local sum on each process */

    sum_loc = 0;
    for (int i=0; i<N/nproc; i++) {
	sum_loc += data[i];
    }

    /* accumulate global sum (across processes) */

    MPI_Reduce(&sum_loc,      /* send buffer */
	       &sum,          /* receive buffer (result on rank=0, see below) */
	       1,             /* send count */
	       MPI_INT,       /* data type */
	       MPI_SUM,       /* reduce operation type */
	       0,             /* result on rank=0 process */
	       MPI_COMM_WORLD /* communicator */
	       );

    /* note that only rank=0 has the final (correct) result */

    if (rank == 0) {
       printf("rank=%d  result=%d\n",rank,sum);
    }

    MPI_Finalize();
}

/* Sample output

$ mpicxx reduce_sum.cpp 

$ mpirun -n 2 ./a.out
rank=0  result=55

$ mpirun -n 5 ./a.out
rank=0  result=55

*********************************************************************/



