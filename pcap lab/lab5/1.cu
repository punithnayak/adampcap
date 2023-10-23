#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>

__global__ void vecAdd(int *a,int *b,int *c,int n){
	int idx=blockDim.x*blockIdx.x+threadIdx.x;
	if(idx<n){
	c[idx]=a[idx]+b[idx];
	}
}
int main(){
	int ha[8]={1,1,1,1,1,1,1,1};
	int hb[8]={1,1,1,1,1,1,1,1};
	int hc[8];
	int *da,*db,*dc;
	int size=sizeof(int);
	cudaMalloc(&da,size*8);
	cudaMalloc(&db,size*8);
	cudaMalloc(&dc,size*8);
	cudaMemcpy(da,ha,size*8,cudaMemcpyHostToDevice);
	cudaMemcpy(db,hb,size*8,cudaMemcpyHostToDevice);
	vecAdd<<<1,32>>>(da,db,dc,8);
	cudaMemcpy(hc,dc,size*8,cudaMemcpyDeviceToHost);
	for(int i=0;i<8;i++)
		printf("%d ",hc[i]);
	cudaFree(da);
	cudaFree(db);
	cudaFree(dc);
	return 0;

}