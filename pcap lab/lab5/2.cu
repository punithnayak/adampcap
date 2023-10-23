#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>

__global__ void vecAdd(int *a, int *b, int *c, int n) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < n) {
        c[idx] = a[idx] + b[idx];
    }
}
int main() {
    int N = 1024;
    int ha[N], hb[N], hc[N];  /
    int *da, *db, *dc;  
    int size = N * sizeof(int);
    for (int i = 0; i < N; i++) {
        ha[i] = 1;
        hb[i] = 1;
    }
    cudaMalloc((void**)&da, size);
    cudaMalloc((void**)&db, size);
    cudaMalloc((void**)&dc, size);

    cudaMemcpy(da, ha, size, cudaMemcpyHostToDevice);
    cudaMemcpy(db, hb, size, cudaMemcpyHostToDevice);

    int threadsPerBlock = 256;
    int blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;
    vecAdd<<<blocksPerGrid, threadsPerBlock>>>(da, db, dc, N);
    cudaMemcpy(hc, dc, size, cudaMemcpyDeviceToHost);
    for (int i = 0; i < N; i++) {
        printf("%d ", hc[i]);
    }
    cudaFree(da);
    cudaFree(db);
    cudaFree(dc);
    return 0;
}
