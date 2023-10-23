#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>

__global__ void multiply_elementwise(int *a, int *b, int *c, int wa, int wb) {
    int rida = threadIdx.y;
    int cidb = threadIdx.x;
    int sum = 0;
    for (int k = 0; k < wa; k++)
        sum += a[rida * wa + k] * b[k * wb + cidb];
    c[rida * wb + cidb] = sum;
}

int main() {
    int *a, *b, *c, wa, ha, wb, hb;
    int *d_a, *d_b, *d_c;
    
    printf("Enter value of wa, ha:\n");
    scanf("%d %d", &wa, &ha);
    
    printf("Enter value of wb, hb:\n");
    scanf("%d %d", &wb, &hb);

    if (wa != hb) {
        printf("Matrix dimensions are not compatible for multiplication.\n");
        return 1;
    }

    int size1 = sizeof(int) * wa * ha;
    int size2 = sizeof(int) * wb * hb;

    a = (int*)malloc(size1);
    b = (int*)malloc(size2);
    c = (int*)malloc(sizeof(int) * wa * wb);

    cudaMalloc((void**)&d_a, size1);
    cudaMalloc((void**)&d_b, size2);
    cudaMalloc((void**)&d_c, sizeof(int) * wa * wb);

    printf("Enter matrix1:\n");
    for (int i = 0; i < wa * ha; i++)
        scanf("%d", &a[i]);

    printf("Enter matrix2:\n");
    for (int i = 0; i < wb * hb; i++)
        scanf("%d", &b[i]);

    cudaMemcpy(d_a, a, size1, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size2, cudaMemcpyHostToDevice);

    dim3 blockDims(wb, ha);
    multiply_elementwise<<<1, blockDims>>>(d_a, d_b, d_c, wa, wb);

    cudaMemcpy(c, d_c, sizeof(int) * wa * wb, cudaMemcpyDeviceToHost);

    printf("Resultant matrix:\n");
    for (int i = 0; i < ha; i++) {
        for (int j = 0; j < wb; j++)
            printf("%d ", c[i * wb + j]);
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
