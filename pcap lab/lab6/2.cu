#include <stdio.h>
#include <string.h>
#include <cuda_runtime.h>

__global__ void copyString(char* S, char* RS, int length) {
    int threadId = blockIdx.x * blockDim.x + threadIdx.x;

    if (threadId < length * 4) {
        RS[threadId] = S[threadId % 4]; // Copy characters from S to RS
    }
}

int main() {
    const char* inputString = "PCAP"; // Input string
    int inputLength = strlen(inputString);

    // Allocate memory for S and RS on the host
    char* h_S = (char*)malloc(inputLength * sizeof(char));
    char* h_RS = (char*)malloc(inputLength * 4 * sizeof(char));

    // Copy input string from host to device
    char* d_S;
    char* d_RS;
    cudaMalloc((void**)&d_S, inputLength * sizeof(char));
    cudaMalloc((void**)&d_RS, inputLength * 4 * sizeof(char));
    cudaMemcpy(d_S, inputString, inputLength * sizeof(char), cudaMemcpyHostToDevice);

    // Launch the CUDA kernel
    int threadsPerBlock = 256;
    int blocksPerGrid = (inputLength * 4 + threadsPerBlock - 1) / threadsPerBlock;
    copyString<<<blocksPerGrid, threadsPerBlock>>>(d_S, d_RS, inputLength);

    // Copy the result from device to host
    cudaMemcpy(h_RS, d_RS, inputLength * 4 * sizeof(char), cudaMemcpyDeviceToHost);

    // Print the result
    printf("Input string S: %s\n", inputString);
    printf("Output string RS: %s\n", h_RS);

    // Cleanup
    free(h_S);
    free(h_RS);
    cudaFree(d_S);
    cudaFree(d_RS);

    return 0;
}
