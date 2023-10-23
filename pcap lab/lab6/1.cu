#include<stdio.h>
#include"cuda_runtime.h"
#include<string.h>
#include"device_launch_parameters.h"
#include<stdlib.h>


__global__ void cudacount(char *sentence,char *word,int *result,int sentencelenght,int wordlength){
    int idx=threadIdx.x;
    int flag=1;
    if(idx+wordlength<sentencelenght){
        for(int i=0;i<wordlength;i++){
            if(sentence[idx+i]!=word[i]){
                flag=0;
            }
        }if(flag)
        atomicAdd(result,1);
    }
}
int main(){
    char a[100]="hello helloooo,hello hellooooo,heooo";
    char b[6]="hello";
    int result=0;
    char *d_a,*d_b;
    int *d_c;
    int wordlen=strlen(a);
    cudaMalloc((void**)&d_a,sizeof(char)*wordlen);
    cudaMalloc((void**)&d_b,sizeof(char)*6);
    cudaMalloc((void**)&d_c,sizeof(int));
    cudaMemcpy(d_a,a,sizeof(char)*wordlen,cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,b,sizeof(char)*6,cudaMemcpyHostToDevice);
    cudaMemcpy(d_c,&result,sizeof(int),cudaMemcpyHostToDevice);
    cudacount<<<1,wordlen>>>(d_a,d_b,d_c,wordlen,6);
    cudaMemcpy(&result,d_c,sizeof(int),cudaMemcpyDeviceToHost);
    printf("%d",result);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
}