#include <stdio.h>
#include <cuda_runtime.h>

#define MASK_SIZE 3 


__global__ void convolution2D(int *input, int *output, int *mask, int width, int height) {
    int tx=threadIdx.x;
    int ty=threadIdx.y;
    int col=blockDim.x*blockIdx.x+tx;
    int row=blockDim.y*blockIdx.y+ty;
    int halfmask=MASK_SIZE/2;
    int sum=0;
    for(int i=-halfmask;i<=halfmask;i++){
    for(int j=-halfmask;j<=halfmask;j++){
    int inputX=col+i;
    int inputY=row+j;
    if(inputX>=0&&inputX<width&&inputY>=0&&inputY<height)
    sum+=input[inputX*width+inputY]*mask[(i+halfmask)*MASK_SIZE+(j+halfmask)];
    }
    }
    output[row*width+col]=sum;
}

int main() {
    int width = 4; 
    int height = 4;
    
    int input[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}; 
    int mask[] = {1, 2, 1, 0, 0, 0, -1, -2, -1}; 
    int output[width * height]; 

    int *d_input, *d_output, *d_mask;
    
    cudaMalloc((void**)&d_input, sizeof(int) * width * height);
    cudaMalloc((void**)&d_output, sizeof(int) * width * height);
    cudaMalloc((void**)&d_mask, sizeof(int) * MASK_SIZE * MASK_SIZE);

  
    cudaMemcpy(d_input, input, sizeof(int) * width * height, cudaMemcpyHostToDevice);
    cudaMemcpy(d_mask, mask, sizeof(int) * MASK_SIZE * MASK_SIZE, cudaMemcpyHostToDevice);

    dim3 gridSize(width, height);
    dim3 blockSize(MASK_SIZE, MASK_SIZE);

    convolution2D<<<gridSize, blockSize>>>(d_input, d_output, d_mask, width, height);

    cudaMemcpy(output, d_output, sizeof(int) * width * height, cudaMemcpyDeviceToHost);

    cudaFree(d_input);
    cudaFree(d_output);
    cudaFree(d_mask);

   
    printf("Input Image:\n");
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            printf("%d ", input[i * width + j]);
        }
        printf("\n");
    }

    printf("\nConvolution Mask:\n");
    for (int i = 0; i < MASK_SIZE; i++) {
        for (int j = 0; j < MASK_SIZE; j++) {
            printf("%d ", mask[i * MASK_SIZE + j]);
        }
        printf("\n");
    }

    printf("\nOutput Image (after 2D convolution):\n");
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            printf("%d ", output[i * width + j]);
        }
        printf("\n");
    }

    return 0;
}
