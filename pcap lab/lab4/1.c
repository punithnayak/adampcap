#include"mpi.h"
#include<stdio.h>
#define buff 1000
int factorial(int n){
	if(n==0) return 1;
	return n*factorial(n-1);
}
void ErrorHandler(int error_code){
	if(error_code!=MPI_SUCCESS){
	char error_string[buff];
	int length_of_error_string,error_class;
	MPI_Error_class(error_code,&error_class);
	MPI_Error_string(error_code,error_string,&length_of_error_string);
	printf("%d,%s\n",error_class,error_string);
}}
int main(int argc,char* argv[]){
	int rank,size,fact,result,error_code;
	MPI_Init(&argc,&argv);
	error_code=MPI_Comm_size(MPI_COMM_WORLD,&size);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	ErrorHandler(error_code);
	fact=factorial(rank);
	error_code=MPI_Scan(&fact,&result,1,MPI_INT,MPI_SUM,MPI_COMM_WORLD);
	ErrorHandler(error_code);
	printf("in process %d:%d\n",rank,result );
	MPI_Finalize();
}