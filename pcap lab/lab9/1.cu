#include<stdio.h>
#include"cuda_runtime.h"
#include"device_launch_parameters.h"
__global__ void matrixMul(int *a,int *b,int *c,int m1,int n1,int n2){
	int col=threadIdx.x+blockIdx.x*blockDim.x;
	int row=threadIdx.y+blockIdx.y*blockDim.y;
	if(row<m1 && col<n2){
	int sum=0;
	for (int k = 0; k < n1; k++) {
            sum += a[row * n1 + k] * b[k * n2 + col];
    }
        c[row * n2 + col] = sum;
	}

}
int main() {
    int *a, *b, *c;
    int *d_a, *d_b, *d_c;
    int m1, n1;
    int m2, n2;
    
    printf("Enter the value of m1 and n1\n");
    scanf("%d %d", &m1, &n1);
    
    printf("Enter the value of m2 and n2\n");
    scanf("%d %d", &m2, &n2);
    
    a = (int*)malloc(sizeof(int) * m1 * n1);
    b = (int*)malloc(sizeof(int) * m2 * n2);
    c = (int*)malloc(sizeof(int) * m1 * n2);
    
    cudaMalloc((void**)&d_a, sizeof(int) * m1 * n1);
    cudaMalloc((void**)&d_b, sizeof(int) * m2 * n2);
    cudaMalloc((void**)&d_c, sizeof(int) * m1 * n2);
    
    printf("Enter matrix 1\n");
    for (int i = 0; i < m1 * n1; i++) {
        scanf("%d", &a[i]);
    }
    
    printf("Enter matrix 2\n");
    for (int i = 0; i < m2 * n2; i++) {
        scanf("%d", &b[i]);
    }
    
    cudaMemcpy(d_a, a, sizeof(int) * m1 * n1, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, sizeof(int) * m2 * n2, cudaMemcpyHostToDevice);
    
    dim3 dimGrid((n2 + 4) / 4, (m1 + 4) / 4);
    dim3 blockGrid(2, 2);
    matrixMul<<<dimGrid, blockGrid>>>(d_a, d_b, d_c, m1, n1, n2);
    
    cudaMemcpy(c, d_c, sizeof(int) * m1 * n2, cudaMemcpyDeviceToHost);
    
    printf("Resultant matrix\n");
    for (int i = 0; i < m1; i++) {
        for (int j = 0; j < n2; j++) {
            printf("%d ", c[i * n2 + j]);
        }
        printf("\n");
    }
    
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    free(a);
    free(b);
    free(c);

    return 0;
}
