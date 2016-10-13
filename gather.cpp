/**

  MPI_Gather use example

*/
#include <cstdio>
#include <mpi.h>
int main(int argc, char *argv[])
{
    const int N = 20;
    double    *data_coll = NULL;
    double    *data = NULL;
    char      fn[128];
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
	data[i] = (double)rank;
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
        sprintf(fn,"data.gather");
	FILE *fp = fopen(fn,"w");
	for (int i=0; i<N; i++) {
	    fprintf(fp,"data_coll[%d] = %f\n",i,data_coll[i]);
	}
	fclose(fp);
    }
    if (data) delete [] data;
    if (data_coll) delete [] data_coll;
    MPI_Finalize();
}
