/*

  MPI_Scatter use example

  Note: for simplicity, we assume the global data size (N) is a multiple
        of number of processors (nproc).

 */
#include <mpi.h>
#include <cstdio>

int main(int argc, char *argv[])
{
    const int N=20;
    int       rank,nproc;
    int       *data_src=NULL;
    int       *data=NULL;
    char      fn[128];

    MPI_Init(&argc,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&nproc);

    if (N%nproc != 0) {
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    /* prepare data on rank=0 process */

    if (rank == 0) {
	data_src = new int[N];
	for (int i=0; i<N; i++) {
	    data_src[i] = i;
	}
    } 

    /* every process will receive a "N/nproc" data piece */

    data = new int [N/nproc];

    /* scatter data from rank=0 to all other processes */
    MPI_Scatter(data_src,          /* send buffer (data source) */
		N/nproc,           /* send count */
		MPI_INT,           /* send type */
		data,              /* receive buffer */
                N/nproc,           /* receive count */
		MPI_INT,           /* receive type */
		0,                 /* data source is rank=0 process */
		MPI_COMM_WORLD     /* communicator */
		);

    /* Each process writes results to a different file */

    sprintf(fn,"data.%d",rank);
    printf("process %d writting results to %s\n",rank,fn);
    FILE *fp = fopen(fn,"w");
    fprintf(fp,"# rank %d\n",rank);
    for (int i=0; i<N/nproc; i++) {
	fprintf(fp,"data[%d] = %d\n",i,data[i]);
    }
    fclose(fp);

    if (data) delete [] data;
    if (data_src) delete [] data_src;

    MPI_Finalize();
}

/* Sample output

$ mpicxx scatter.cpp 

$ mpirun -n 2 ./a.out 
process 0 writting results to data.0
process 1 writting results to data.1

$ cat data.0
# rank 0
data[0] = 0
data[1] = 1
data[2] = 2
data[3] = 3
data[4] = 4
data[5] = 5
data[6] = 6
data[7] = 7
data[8] = 8
data[9] = 9

$ cat data.1
# rank 1
data[0] = 10
data[1] = 11
data[2] = 12
data[3] = 13
data[4] = 14
data[5] = 15
data[6] = 16
data[7] = 17
data[8] = 18
data[9] = 19

*/
