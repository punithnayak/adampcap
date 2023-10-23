#include "mpi.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	int rank, size, arr[100],error_code;

	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	if (rank==0)
	{
		printf("enter %d elements\n",size-1 );
		for (int i = 0; i < size-1; i++)
		scanf("%d",&arr[i]);
	    int bsize=MPI_BSEND_OVERHEAD + sizeof(arr);
	    int* buf=(int*)malloc(bsize);
	    MPI_Buffer_attach(buf,bsize);
	    for (int i = 0; i < size-1; i++)
	    {
	    	MPI_Bsend(&arr[i],1,MPI_INT,i+1,0,MPI_COMM_WORLD);
	    }

	    MPI_Buffer_detach(&buf,&bsize);
	}
	else{
		int num;
		MPI_Recv(&num,1,MPI_INT,0,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
		if (rank%2==0)
		{
			printf("%d:%d\n",rank,num*num );
		}
		else
			printf("%d:%d\n",rank,num*num*num );
	}
	MPI_Finalize();
}