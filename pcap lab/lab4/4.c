#include<stdio.h>
#include "mpi.h"
int main(int argc,char* argv[]){
	int rank,size,matrix[4][4],temp[4],result[4],ans;
	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Barrier(MPI_COMM_WORLD);
	if (rank==0){
		printf("enter a 4*4 matrix\n");
		for (int i = 0; i < 4; i++)
		{
			for (int j= 0; j < 4; j++)
			{
				scanf("%d",&matrix[i][j]);
			}
		}
	}
	MPI_Scatter(matrix,4,MPI_INT,temp,4,MPI_INT,0,MPI_COMM_WORLD);
	MPI_Scan(temp,result,4,MPI_INT,MPI_SUM,MPI_COMM_WORLD);
	MPI_Barrier(MPI_COMM_WORLD);
	printf("row %d :",rank);
	for (int i = 0; i < 4; i++)
		{
				printf(" %d ",result[i]);
			
		}
		printf("\n");
	MPI_Finalize();
}