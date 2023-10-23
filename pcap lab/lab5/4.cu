#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>

__global__ void csin(float *a,float *b,int n){
	int idx=blockIdx.x;
	if(idx<n){
	b[idx]=sinf(a[idx]);
	}
}
int main(){
	float a[6]={0,0.3,0.45,.6,.9,1};
	float b[6];
	int size=sizeof(float);
	float *da,*db;
	cudaMalloc((void**)&da,size*6);
	cudaMalloc((void**)&db,size*6);
	
	cudaMemcpy(da,a,size*6,cudaMemcpyHostToDevice);

	csin<<<6,1>>>(da,db,6);
	cudaMemcpy(b,db,size*6,cudaMemcpyDeviceToHost);
	for(int i=0;i<6;i++)
		printf("%f ",b[i]);
	cudaFree(da);
	cudaFree(db);
	return 0;

}