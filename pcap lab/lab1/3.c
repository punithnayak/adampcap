#include<stdio.h>
#include<mpi.h>
int main(int argc, char **argv){
	int a=10;
	int b=5;
	int rank,size;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	if(rank ==0)
		printf("sum=%d\n",a+b );
	else if (rank==1)
		printf("differece=%d\n",a-b);
	else if (rank==2)
		printf("product=%d\n",a*b);
	else if (rank==3)
		printf("a/b=%d\n",a/b );
	MPI_Finalize();

	return 0;
}
