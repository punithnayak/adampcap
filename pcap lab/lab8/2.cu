#include <stdio.h>
#include <cuda_runtime.h>

__global__ void modifyMatrix(int *matrix, int rows, int cols) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int j = blockIdx.y * blockDim.y + threadIdx.y;

    if (i < rows) {
        if (j < cols) {
            matrix[i * cols + j] = pow(matrix[i * cols + j] , (i + 1));
        }
    }
}

int main() {
    int M, N;

    printf("Enter the number of rows (M) and columns (N) of the matrix: ");
    scanf("%d %d", &M, &N);

    int *matrix;
    int size = M * N * sizeof(int);

    matrix = (int*)malloc(size);

    int *d_matrix;
    cudaMalloc((void**)&d_matrix, size);

    printf("Enter matrix elements (%dx%d):\n", M, N);
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
            scanf("%d", &matrix[i * N + j]);
        }
    }

    cudaMemcpy(d_matrix, matrix, size, cudaMemcpyHostToDevice);

    dim3 blockDim(16, 16);
    dim3 gridDim((N + blockDim.x - 1) / blockDim.x, (M + blockDim.y - 1) / blockDim.y);

    modifyMatrix<<<gridDim, blockDim>>>(d_matrix, M, N);

    cudaMemcpy(matrix, d_matrix, size, cudaMemcpyDeviceToHost);

    printf("Modified Matrix:\n");
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
            printf("%d ", matrix[i * N + j]);
        }
        printf("\n");
    }

    free(matrix);
    cudaFree(d_matrix);

    return 0;
}
