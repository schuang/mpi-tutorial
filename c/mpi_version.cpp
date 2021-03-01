/*

   Show MPI API version

   (This is not the same as the version of the MPI "library" (aka
   the "implementaton" you are using.)

*/
#include <mpi.h>
#include <cstdio>
int main(int argc, char *argv[])
{
    int rank,ver,subver;
    MPI_Init(&argc,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Get_version(&ver,&subver);
    printf("MPI version = %d subversion = %d\n",ver,subver);
    MPI_Finalize();
} 

/* Sample output

$ mpicxx mpi_version.cpp 

$ mpirun -n 1 ./a.out 
MPI version = 3 subversion = 1

********************************************************************/



