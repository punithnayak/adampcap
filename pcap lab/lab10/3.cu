#include<cuda_runtime.h>
#include<device_launch_parameters.h>
#include<stdio.h>
#include<stdlib.h>
__global__ void odd(int *a){
	int idx=threadIdx.x;
	int n=blockDim.x;
	if((idx%2)!=0&& (idx+1)<n){
	if(a[idx]>a[idx+1]){
	int temp=a[idx];
	a[idx]=a[idx+1];
	a[idx+1]=temp;
	}
	}
}
__global__ void even(int *a){
	int idx=threadIdx.x;
	int n=blockDim.x;
	if((idx%2)==0&& (idx+1)<n){
	if(a[idx]>a[idx+1]){
	int temp=a[idx];
	a[idx]=a[idx+1];
	a[idx+1]=temp;
	}
	}
}


int main(){
	int *a;
	int *d_a;
	int n;
	printf("enter the size of the array");
	scanf("%d",&n);
	a=(int*)malloc(sizeof(int)*n);
	printf("enter the array");
	for(int i=0;i<n;i++)
	scanf("%d",&a[i]);
	cudaMalloc((void**)&d_a,sizeof(int)*n);
	cudaMemcpy(d_a,a,sizeof(int)*n,cudaMemcpyHostToDevice);
	for(int i=0;i<n/2;i++){
	odd<<<1,n>>>(d_a);
	even<<<1,n>>>(d_a);
	}
	cudaMemcpy(a,d_a,sizeof(int)*n,cudaMemcpyDeviceToHost);
	for(int i=0;i<n;i++)
	printf("%d ",a[i]);
	cudaFree(d_a);


}
