#include "mpi.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    int rank, size,n1,n2,r1,r2;
    char str1[100],str2[100],ch1[100],ch2[100],result[100];
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if (rank==0)
    {
        printf("enter a string(divisible by no. of process)\n");
        scanf("%s",str1);
        printf("enter a string(divisible by no. of process)\n");
        scanf("%s",str2);
        n1=strlen(str1);
        n2=strlen(str2);
    }
    r1=n1/size;
    r2=n2/size;
    MPI_Bcast(&r1,1,MPI_INT,0,MPI_COMM_WORLD);
    MPI_Bcast(&r2,1,MPI_INT,0,MPI_COMM_WORLD);
    MPI_Scatter(str1,r1,MPI_CHAR,ch1,r1,MPI_CHAR,0,MPI_COMM_WORLD);
    MPI_Scatter(str2,r2,MPI_CHAR,ch2,r2,MPI_CHAR,0,MPI_COMM_WORLD);
    strcat(ch1,ch2);
    MPI_Gather(ch1,r1+r2,MPI_CHAR,result,r1+r2,MPI_CHAR,0,MPI_COMM_WORLD);
    if (rank==0)
    printf("%s\n",result );    
    MPI_Finalize();
    return 0;
}
