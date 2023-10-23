#include"cuda_runtime.h"
#include"device_launch_parameters.h"
#include<stdio.h>
#include<stdlib.h>

__global__ void multiply_rowwise(int *a,int *b,int *c,int wa,int wb){
	int rida=threadIdx.x;
	int sum;
	for(int cidb=0;cidb<wb;cidb++){
	sum=0;
	for(int k=0;k<wa;k++)
	sum+=a[rida*wa+k]*b[k*wb+cidb];
	c[rida*wb+cidb]=sum;
	}
}
int main(){
	int *a,*b,*c,wa,ha,wb,hb;
	int *d_a,*d_b,*d_c;
	printf("enter valude of wa,ha\n");
	scanf("%d",&wa);
	scanf("%d",&ha);
	printf("enter valude of wb,hb\n");
	scanf("%d",&wb);
	scanf("%d",&hb);
	int size1=sizeof(int)*wa*ha,size2=sizeof(int)*wb*hb;
	a=(int*)malloc(size1);
	b=(int*)malloc(size2);
	c=(int*)malloc(sizeof(int)*wa*hb);
	cudaMalloc((void**)&d_a,size1);
	cudaMalloc((void**)&d_b,size2);
	cudaMalloc((void**)&d_c,sizeof(int)*wa*hb);
	printf("enter matrix1\n");
	for(int i=0;i<wa*ha;i++)
	scanf("%d",&a[i]);
	printf("enter matrix2\n");
	for(int i=0;i<wb*hb;i++)
	scanf("%d",&b[i]);
	cudaMemcpy(d_a,a,size1,cudaMemcpyHostToDevice);
	cudaMemcpy(d_b,b,size2,cudaMemcpyHostToDevice);
    multiply_rowwise<<<1,ha>>>(d_a,d_b,d_c,wa,wb);
    cudaMemcpy(c,d_c,sizeof(int)*wa*hb,cudaMemcpyDeviceToHost);
    printf("resultant matrix\n");
    for(int i=0;i<wa;i++){
    for(int j=0;j<hb;j++)
    printf("%d ",c[i*hb+j]);
    printf("\n");
    }
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);


}
