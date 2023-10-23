#include"cuda_runtime.h"
#include"device_launch_parameters.h"
#include<stdio.h>
#include<stdlib.h>


__global__ void addmatrix(int *a,int *b,int *c){
	int n=threadIdx.x,m=blockIdx.x,size=blockDim.x;
	c[m*size+n]=a[m*size+n]+b[m*size+n];

	}

int main()
{
	int *a,*b,*c,m,n;
	int *d_a,*d_b,*d_c;
	printf("enter the value of m and n\n");
	scanf("%d",&m);
	scanf("%d",&n);
	int size=sizeof(int)*m*n;
	a=(int*)malloc(size);
	b=(int*)malloc(size);
	c=(int*)malloc(size);
    printf("enter matrix1:");
    for (int i = 0; i < m*n; ++i)
    {
    	scanf("%d",&a[i]);
    }
    printf("enter matrix2:");
    for (int i = 0; i < m*n; ++i)
    {
    	scanf("%d",&b[i]);
    }
	cudaMalloc((void**)&d_a,size);
	cudaMalloc((void**)&d_b,size);
	cudaMalloc((void**)&d_c,size);
	cudaMemcpy(d_a,a,size,cudaMemcpyHostToDevice);
	cudaMemcpy(d_b,b,size,cudaMemcpyHostToDevice);
	addmatrix<<<m,n>>>(d_a,d_b,d_c);
	cudaMemcpy(c,d_c,size,cudaMemcpyDeviceToHost);
	printf("result vector\n");
	for (int i = 0; i < m; i++)
	{
		for (int j = 0; j < n; j++)
		{
			printf("%d ",c[i*n+j] );
		}printf("\n");
	}
	cudaFree(d_a);
	cudaFree(d_b);
	return 0;

}