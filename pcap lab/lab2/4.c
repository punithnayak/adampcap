#include "mpi.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	int rank, size,num;

	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Status status;
	if (rank==0)
	{
		printf("enter  elements\n" );
		scanf("%d",&num);
		MPI_Send(&num,1,MPI_INT,1,0,MPI_COMM_WORLD);
		MPI_Recv(&num,1,MPI_INT,size-1,0,MPI_COMM_WORLD,&status);
		printf("process %d:%d\n",rank,num );
	}
	else{
		MPI_Recv(&num,1,MPI_INT,rank-1,0,MPI_COMM_WORLD,&status);
		printf("process %d:%d\n",rank,num );
		num++;
		if (rank==size-1)
		MPI_Send(&num,1,MPI_INT,0,0,MPI_COMM_WORLD);
		else
		MPI_Send(&num,1,MPI_INT,rank+1,0,MPI_COMM_WORLD);	

	}
	
	
	MPI_Finalize();
}