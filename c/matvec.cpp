/*
 
  Sequential matrix-vector product

*/
#include <cstdio>
#include <cstdlib>

struct seqVec {
    int      N;       /* vector length */
    double   *data;   /* vector content */
};


struct seqMat {
    int       M;       /* height */
    int       N;       /* width */
    double    *data;   /* matrix content */
};


/* row-major order: (i,j) and (i,j+1) are adjancent in memory */
static inline int idx(const int i, const int j, const int N)
{
    return (j + N*i);
}

void allocMat(const int M, const int N, seqMat& A)
{
    A.M = M;
    A.N = N;
    A.data = new double [M*N];
}

void allocVec(const int N, seqVec& X)
{
    X.N = N;
    X.data = new double [N];
}

void destroyVec(seqVec& X)
{
    delete [] X.data;
}

void destroyMat(seqMat& A)
{
    delete [] A.data;
}

void setupMat(seqMat& A)
{
    int M = A.M;
    int N = A.N;
    for (int i=0; i<M; i++) {
	for (int j=0; j<N; j++) {
	    A.data[ idx(i,j,N) ] = (double) i + j;
	}
    }
}

void setupVec(seqVec& v)
{
    int n = v.N;
    for (int i=0; i<n; i++) {
	v.data[i] = 1.0;
    }
}

void seqMatVecMult(const seqMat A, const seqVec x, seqVec& y)
{
    double sum;
    int M = A.M;
    int N = A.N;
    for (int i=0; i<M; i++) {
	sum = 0.0;
	for (int j=0; j<N; j++) {
	    sum += A.data[ idx(i,j,N) ] * x.data[j];
	}
	y.data[i] = sum;
    }
}

void viewVec(const seqVec y, const char filename[])
{
    FILE *fp=fopen(filename,"w");
    fprintf(fp,"# vector\n");
    for (int i=0; i<y.N; i++) {
	fprintf(fp,"%d %f\n",i,y.data[i]);
    }
    fclose(fp);
}

void viewMat(const seqMat A, const char filename[])
{
    FILE *fp=fopen(filename,"w");
    fprintf(fp,"# matrix\n");
    for (int j=0; j<A.N; j++) {
	for (int i=0; i<A.M; i++) {
	    fprintf(fp,"A(%d,%d) = %f\n",i+1,j+1,A.data[ idx(i,j,A.N) ]);
	}
    }
    fclose(fp);
}

int main(int argc, char *argv[])
{
    seqMat A;
    seqVec x,y;

    int M=20, N=20;

    allocMat(M,N,A);
    allocVec(M,x);
    allocVec(M,y);

    setupMat(A);
    setupVec(x);

    seqMatVecMult(A,x,y);

    viewMat(A, "seqmat.dat");
    viewVec(y, "seqv.dat");

    destroyVec(x);
    destroyVec(y);
    destroyMat(A);

    return 0;
}

/*******************************************************************/



