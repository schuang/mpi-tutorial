/**

  MPI_Gather example

*/
#include <cstdio>
#include <mpi.h>
int main(int argc, char *argv[])
{
    const int N = 20;
    double    *data_coll = NULL;
    double    *data = NULL;
    int       nproc, rank;
    MPI_Init(&argc,&argv);
    MPI_Comm_size(MPI_COMM_WORLD, &nproc);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    /* each process has space for data */

    data = new double [N/nproc];

    /* rank=0 process prepares to receive collected data */

    if (rank==0) {
	data_coll = new double [N];
    }

    /* initial data on each process */
    for (int i=0; i<N/nproc; i++) {
	data[i] = (double)rank*100 + i;
    }

    /* gather data from all processes onto rank=0 process */

    MPI_Gather(data,          /* send buffer (data source) */
	       N/nproc,       /* send count */
	       MPI_DOUBLE,    /* send type */
	       data_coll,     /* receive buffer (on rank=0, see below) */
	       N/nproc,       /* receive count */
	       MPI_DOUBLE,    /* receive type */
	       0,             /* receive on rank=0 */
	       MPI_COMM_WORLD /* communicator */
	       );

    /* rank=0 process writes results to disk */

    if (rank == 0) {
	for (int i=0; i<N; i++) {
	    printf("data_coll[%d] = %f\n",i,data_coll[i]);
	}
    }
    if (data) delete [] data;
    if (data_coll) delete [] data_coll;
    MPI_Finalize();
}

/* Sample output

$ mpicxx gather.cpp 

$ mpirun -n 4 ./a.out
data_coll[0] = 0.000000
data_coll[1] = 1.000000
data_coll[2] = 2.000000
data_coll[3] = 3.000000
data_coll[4] = 4.000000
data_coll[5] = 100.000000
data_coll[6] = 101.000000
data_coll[7] = 102.000000
data_coll[8] = 103.000000
data_coll[9] = 104.000000
data_coll[10] = 200.000000
data_coll[11] = 201.000000
data_coll[12] = 202.000000
data_coll[13] = 203.000000
data_coll[14] = 204.000000
data_coll[15] = 300.000000
data_coll[16] = 301.000000
data_coll[17] = 302.000000
data_coll[18] = 303.000000
data_coll[19] = 304.000000

**********************************************************************/


