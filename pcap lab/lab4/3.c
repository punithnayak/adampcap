#include<stdio.h>
#include<stdlib.h>
#include "mpi.h"
int main(int argc,char* argv[]){
	int rank,size,matrix[3][3],temp[3],ele,count=0,ans;
	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	if (rank==0){
		printf("enter a 3*3 matrix\n");
		for (int i = 0; i < 3; i++)
		{
			for (int j= 0; j < 3; j++)
			{
				scanf("%d",&matrix[i][j]);
			}
		}
		printf("enter element to search");
		scanf("%d",&ele);
	}
	MPI_Bcast(&ele,1,MPI_INT,0,MPI_COMM_WORLD);
	MPI_Scatter(matrix,3,MPI_INT,temp,3,MPI_INT,0,MPI_COMM_WORLD);
	for (int i = 0; i < 3; ++i)
	{
		if (temp[i]==ele)
		{
			count++;
		}
	}
	MPI_Reduce(&count,&ans,1,MPI_INT,MPI_SUM,0,MPI_COMM_WORLD);
	if (rank==0)
	{
		printf("%d\n",ans );
	}

	MPI_Finalize();
}