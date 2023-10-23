#include"mpi.h"
#include<stdio.h>
int factorial(int n){
	if(n==0) return 1;
	return n*factorial(n-1);
}
int main(int argc,char* argv[]){
	int rank,size,fact,result;
	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	fact=factorial(rank);
	MPI_Reduce(&fact,&result,1,MPI_INT,MPI_SUM,0,MPI_COMM_WORLD);
	if (rank==0)
	{
		printf("%d\n",result );
	}
	MPI_Finalize();
}