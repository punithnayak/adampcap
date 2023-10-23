#include <stdio.h>

// Define the filter size and constant memory size
#define FILTER_SIZE 3
#define DATA_SIZE 10

// Define the filter in constant memory
__constant__ int filter[FILTER_SIZE];

__global__ void convolution(int* input, int* output) {
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    int halfFilterSize = FILTER_SIZE / 2;
    int result = 0;

    for (int i = 0; i < FILTER_SIZE; i++) {
        int inputIndex = tid - halfFilterSize + i;
        if (inputIndex >= 0 && inputIndex < DATA_SIZE) {
            result += input[inputIndex] * filter[i];
        }
    }

    output[tid] = result;
}

int main() {
    int data[DATA_SIZE];
    int result[DATA_SIZE];
    int hostFilter[FILTER_SIZE] = {1, 2, 1};  // Define the filter on the host

    // Initialize data and filter
    for (int i = 0; i < DATA_SIZE; i++) {
        data[i] = i;
    }

    // Copy the filter from the host to constant memory
    cudaMemcpyToSymbol(filter, hostFilter, FILTER_SIZE * sizeof(int));

    int* d_data;
    int* d_result;
    cudaMalloc((void**)&d_data, DATA_SIZE * sizeof(int));
    cudaMalloc((void**)&d_result, DATA_SIZE * sizeof(int));

    // Copy data to the device
    cudaMemcpy(d_data, data, DATA_SIZE * sizeof(int), cudaMemcpyHostToDevice);

    // Configure kernel launch
    int block_size = 256;
    int grid_size = (DATA_SIZE + block_size - 1) / block_size;

    convolution<<<grid_size, block_size>>>(d_data, d_result);

    // Copy the result back to the host
    cudaMemcpy(result, d_result, DATA_SIZE * sizeof(int), cudaMemcpyDeviceToHost);

    // Print the result
    for (int i = 0; i < DATA_SIZE; i++) {
        printf("%d\n", result[i]);
    }

    cudaFree(d_data);
    cudaFree(d_result);

    return 0;
}
