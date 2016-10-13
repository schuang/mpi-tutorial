/*

  MPI matrix-vector product A*x = y

  A is a M-by-N matrix. x is a N-vector. y is a M-vector.

  For simplicity, we assume both M and N are multiples of number of
  MPI processes (i.e. M%nproc == N%nproc == 0). In a real code, you
  need to take care of the cases when M%nproc or N%nproc is not zero.

*/

#include <mpi.h>
#include <cstdio>
#include <cstdlib>

struct parVec {
    int       N;            /* global vector length */
    int       n;            /* local vector length */
    int       *offset;      /* starting index */
    double    *data;        /* vector content */
};

struct parMat {
    int       M;            /* global height */
    int       N;            /* global width */
    int       n;            /* local width */
    int       *col_offset;  /* column offset */
    int       *row_offset;  /* row offset */
    double    *data;        /* local matrix content */
};

/* row-major order: (i,j) and (i,j+1) are adjancent in memory */
static inline int idx(const int i, const int j, const int N)
{
    return (j + N*i);
}

void allocMat(const int M, const int N, parMat& A, MPI_Comm comm)
{
    int nproc;
    MPI_Comm_size(comm,&nproc);
    A.M = M;
    A.N = N;
    A.n = N/nproc;
    A.data = new double [(A.M)*(A.n)];
    A.col_offset = new int [nproc];
    A.row_offset = new int [nproc];
    for (int i=0; i<nproc; i++) {
	A.col_offset[i] = i*(N/nproc);
	A.row_offset[i] = i*(M/nproc);
    }
}

void allocVec(const int N, parVec& X, MPI_Comm comm)
{
    int nproc;
    MPI_Comm_size(comm,&nproc);
    X.N = N;
    X.n = N/nproc;
    X.data = new double [N];
    X.offset = new int [nproc];
    for (int i=0; i<nproc; i++) {
	X.offset[i] = i*(N/nproc);
    }
}

void setupMat(parMat& A)
{
    int n = A.n;
    int M = A.M;
    int *offset = A.col_offset;
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    for (int i=0; i<M; i++) {
	for (int j=0; j<n; j++) {
	    A.data[ idx(i,j,n) ] = (double) i + (j + offset[rank]);
	}
    }    
}

void setupVec(parVec& v)
{
    int n = v.n;
    for (int i=0; i<n; i++) {
	v.data[i] = 1.0;
    }
}

void viewMat(const parMat A)
{
    int rank, nproc;
    char filename[256];
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &nproc);
    if (rank==0) {
	printf("writing matrix A into matview.* files\n");
    }
    sprintf(filename,"matview.%d",rank);
    FILE *fp = fopen(filename, "w");
    fprintf(fp,"# rank = %d\n",rank);
    fprintf(fp, "M %d N %d n %d \n",A.M,A.N,A.n);
    for (int i=0; i<nproc; i++) {
	fprintf(fp,"offset[%d] = %d\n",i,A.col_offset[i]);
    }
    for (int i=0; i<A.M; i++) {
	for (int j=0; j<A.n; j++) {
	    fprintf(fp,"A(%d,%d) = %f\n",i+1,1+j+A.col_offset[rank],A.data[ idx(i,j,A.n) ]);
	}
    }
    fclose(fp);
}

void viewVec(const parVec x)
{
    int rank, nproc;
    char filename[256];
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &nproc);
    sprintf(filename,"vecview.%d",rank);
    FILE *fp = fopen(filename, "w");
    fprintf(fp,"# rank = %d\n",rank);
    fprintf(fp, "N %d n %d \n",x.N,x.n);
    fprintf(fp,"offset ");
    for (int i=0; i<nproc; i++) {
	fprintf(fp,"offset[%d] = %d ",i, x.offset[i]);
    }
    for (int i=0; i<x.n; i++) {
	fprintf(fp,"x[%d] = %f\n",i+x.offset[rank], x.data[i]);
    }
    fclose(fp);
}

void parVecMatMult(const parMat A, const parVec x, parVec& y)
{
    int nproc,rank;
    int M = A.M;
    int n = A.n;
    int *row_offset = A.row_offset;
    double sum = 0.0, sum_total = 0.0;
    MPI_Comm_size(MPI_COMM_WORLD, &nproc);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    for (int p=0; p<nproc; p++) {
	for (int i=0; i<M/nproc; i++) {
	    sum = 0.0;
	    for (int j=0; j<n; j++) {
		sum += A.data[ idx(i+row_offset[p],j,n) ]*x.data[j];
	    }
	    MPI_Reduce(&sum,&sum_total,1,MPI_DOUBLE,MPI_SUM,p,MPI_COMM_WORLD);
	    if (rank==p) {
		y.data[i] = sum_total;
	    }
	}
    }
}

int main(int argc, char *argv[])
{
    MPI_Init(&argc, &argv);
    int M=20, N=20;
    parMat A;
    parVec x,y;
    allocMat(M,N,A,MPI_COMM_WORLD);
    allocVec(N,x,MPI_COMM_WORLD);
    allocVec(M,y,MPI_COMM_WORLD);
    setupMat(A);
    setupVec(x);
    viewMat(A);
    parVecMatMult(A,x,y);
    viewVec(y);
    MPI_Finalize();
    return 0;
}

/********************************************************************/



