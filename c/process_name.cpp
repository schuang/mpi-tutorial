/*

   Print processor (or host) name

*/
#include <mpi.h>
#include <cstdio>
int main(int argc, char *argv[])
{
    char name[MPI_MAX_PROCESSOR_NAME];
    int len,rank;
    MPI_Init(&argc,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Get_processor_name(name,&len);
    printf("rank = %d processor name = %s\n",rank,name);
    MPI_Finalize();
} 

/* Sample output

$ mpicxx process_name.cpp 

$ mpirun -n 2 ./a.out 
rank = 1 processor name = mg
rank = 0 processor name = mg

*********************************************************************/



