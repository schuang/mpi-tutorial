/*

   MPI vector-vector inner product example

/*

#include <stdio.h>
#include <mpi.h>
int main(int argc, char *argv[])
{
    int nproc, rank;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &nproc);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    /* We assume N is a multiple of nproc here for simplicity. In a
       real code, you should take care the cases when (N % nproc) is
       not zero. */

    const int N = 100;
    double x[N/nproc];   /* each process only hold part of the vector */
    double y[N/nproc];

    /* initialization */

    for (int i=0; i<N/nproc; i++) {
	int offset = rank*(N/nproc);
	x[i] = (double) i + offset;
	y[i] = (double) i + offset;
    }

    /* compute inner product */

    double sum = 0.0;
    for (int i=0; i<N/nproc; i++) {
	sum += x[i]*y[i];
    }

    /* At this point, sum is the partial sum on each process; the
       value is different on each process. */

    double sum_total;
    MPI_Reduce(&sum, &sum_total, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
    if (rank == 0) {
	printf("MPI inner product x.y = %f\n", sum_total);
    }
    MPI_Finalize();
}

/* Sample output

$ mpicxx vecvec_mpi.cpp 

$ mpirun -n 2 ./a.out
MPI inner product x.y = 328350.000000

$ mpirun -n 4 ./a.out
MPI inner product x.y = 328350.000000

*********************************************************************/



