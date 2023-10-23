#include "mpi.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	int rank, size, num;

	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	if (rank==0)
	{

	    for (int i = 0; i < size-1; i++)
	    {
	    	MPI_Send(&i,1,MPI_INT,i+1,0,MPI_COMM_WORLD);
	    }

	}
	else{

		MPI_Recv(&num,1,MPI_INT,0,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);

		printf("%d:%d\n",rank,num );
	}
	MPI_Finalize();
}