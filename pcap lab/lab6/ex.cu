#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define N 1024

__global__ void count(char* A,int *d_count){
	int i=threadIdx.x;
	if(A[i]=='a')
	atomicAdd(d_count,1);
}
int main(){
	char A[N];
	char *d_A;
	int count = 0, *d_count, result;
	printf("enter a string");
	fgets(A,N,stdin);
	cudaEvent_t start,stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start,0);
	cudaMalloc((void**)&d_A,strlen(A)*sizeof(char));
	cudaMalloc((void**)&d_count,sizeof(int));
	cudaMemcpy(d_A,A,strlen(A)*sizeof(char),cudaMemcpyHostToDevice);
	cudaMemcpy(d_count, &count, sizeof(int), cudaMemcpyHostToDevice);
	 count<<<1, strlen(A)>>>(d_A, d_count);
	cudaEventRecord(stop,0);
	cudaEventSynchronize(stop);
	float time;
	cudaEventElapsedTime(&time,start,stop);
	cudaMemcpy(&result,d_count,sizeof(int),cudaMemcpyDeviceToHost);
	printf("count=%d\n",result);
	printf("time=%f\n",time);
	cudaFree(d_A);
	cudaFree(d_count);
}


