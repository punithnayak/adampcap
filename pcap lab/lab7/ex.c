#include"cuda_runtime.h"
#include"device_launch_parameters.h"
#include<stdio.h>
#include<stdlib.h>


__gobal__ boid transpose(int *a,int *b){
	int n=threadIdx.x,m=blockIdx.x,size=blockDim.x,size1=gridDim.x;
	b[n*size1+m]=a[m*size+n];
}
int main()
{
	int *a,*b,m,n;
	int *d_a,*d_b;
	printf("enter the value of m and n\n");
	scanf("%d",&m);
	scanf("%d",&n);
	int size=sizeof(int)*m*n;
	a=(int*)malloc(size);
	b=(int*)malloc(size);
    printf("enter matrix:");
    for (int i = 0; i < m*n; ++i)
    {
    	scanf("%d",&a[i]);
    }
	cudaMalloc((void**)&d_a,size);
	cudaMalloc((void**)&d_b,size);
	cudaMemcpy(d_a,a,size,cudaMemcpyHostToDevice);
	transpose<<<m,n>>>(d_a,d_b);
	cudaMemcpy(b,d_b,size,cudaMemcpyDeviceToHost);
	printf("result vector\n");
	for (int i = 0; i < n; i++)
	{
		for (int j = 0; j < m; j++)
		{
			printf("%d\n",b[i*m+j] );
		}
	}
	cudaFree(d_a);
	cudaFree(d_b);
	return 0;

}