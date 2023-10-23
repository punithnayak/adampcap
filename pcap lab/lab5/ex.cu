#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<stdio.h>
__global__ void add(int *a,int *b,int *c){
	*c=*a+*b;
}
int main(void){
	int a,b,c;\
	int *da,*db,*dc;
	int size=sizeof(int);
	cudaMalloc((void**)&da,size);
	cudaMalloc((void**)&db,size);
	cudaMalloc((void**)&dc,size);
	a=5;
	b=6;
	cudaMemcpy(da,&a,size,cudaMemcpyHostToDevice);
	cudaMemcpy(db,&b,size,cudaMemcpyHostToDevice);
	add<<<1,1>>>(da,db,dc);
	cudaMemcpy(&c,dc,size,cudaMemcpyDeviceToHost);
	printf("%d",c);
	cudaFree(da);
	cudaFree(db);
	cudaFree(dc);
	return 0;
}