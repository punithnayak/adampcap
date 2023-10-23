import<stdio.h>
import<stdlib.h>
import<cuda_runtime.h>
import<device_launch_parameters.h>
__global__ void csrMatrixMul(int *result,int *rowptr,int *colindices,int* values,int* vector,int n){
	int tid=blockIdx.x*blockDim.x+threadIdx.x;
	if(tid<n){
	int dotproduct=0;
	int start=rowptr[tid];
	int end=rowptr[tid+1];
	for(int i=start;i<end;i++){
	int col=colindices[i];
	dotproduct+=values[i]*vector[col];
	}result[tid]=dotproduct;
	}
}
int main(){
	int rowptr[3]={0,2,5};
	int colindices[6]={0,2,0,1,2,1};
	int values[5]={1,2,3,4,5};
	int vector[3]={1,2,3};
	int result[3][3]={0};
	int *d_rowptr,*d_colindices,*d_values,*d_vector,*d_result;
	cudaMalloc((**void)&d_rowptr,sizeof(int)*3);
	cudaMalloc((**void)&d_colindices,sizeof(int)*6);
	cudaMalloc((**void)&d_values,sizeof(int)*5);
	cudaMalloc((**void)&d_vector,sizeof(int)*3);
	cudaMalloc((**void)&d_result,sizeof(int)*3*3);
	cudaMemcpy(d_rowptr,rowptr,sizeof(int)*3,cudaMemcpyHostToDevice);
	cudaMemcpy(d_colincdices,colindices,sizeof(int)*6,cudaMemcpyHostToDevice);
	cudaMemcpy(d_vector,vector,sizeof(int)*3,cudaMemcpyHostToDevice);
	csrMatrixMul<<<1,3>>>(d_result,d_rowptr,d_colindices,d_vector,n);
	cudaMemcpy(result,d_result,sizeof(int),cudaMemcpyHostToDevice);
	for(int i=0;i<3;i++){
	for(int j=0;j<3;j++)
	printf("%d ",&result[i][j]);
	}printf("\n");
	cudaFree(d_rowptr);
	cudaFree(d_colindices);
	cudaFree(d_values);
	cudaFree(d_result);
	cudaFree(d_vector);

}

