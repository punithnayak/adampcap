#include "mpi.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    int rank, size,n,r,v=0,c,count[100],total=0;
    char str[100],ch[100];
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if (rank==0)
    {
        printf("enter a string(divisible by no. of process)\n");
        scanf("%s",str);
        n=strlen(str);

    }
    r=n/size;
    MPI_Bcast(&r,1,MPI_INT,0,MPI_COMM_WORLD);
    MPI_Scatter(str,r,MPI_CHAR,ch,r,MPI_CHAR,0,MPI_COMM_WORLD);
    for (int i = 0; i < r; ++i)
    {
        if (ch[i]=='a'||ch[i]=='e'||ch[i]=='i'||ch[i]=='o'||ch[i]=='u'||ch[i]=='A'||ch[i]=='E'||ch[i]=='I'||ch[i]=='O'||ch[i]=='U')
        {
            v++;
        }
    }
    c=r-v;
    MPI_Gather(&c,1,MPI_INT,count,1,MPI_INT,0,MPI_COMM_WORLD);
    if (rank==0)
    {
        for (int i = 0; i < size; ++i)
        {
            printf("no. of non vowels in %d:%d\n",i,count[i] );
            total+=count[i];
        }
        printf("total count:%d\n",total );
    }

    MPI_Finalize();
    return 0;
}
