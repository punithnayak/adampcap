#include "mpi.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
    int rank, size,n;
    char str[10], word[10];

    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Status status;

    if (rank == 0)
    {
        printf("Enter a word (up to 99 characters):\n");
        scanf("%s", str);
        n=strlen(str);
        MPI_Ssend(&n, 1, MPI_INT, 1, 1, MPI_COMM_WORLD);
        MPI_Ssend(str, n, MPI_CHAR, 1, 0, MPI_COMM_WORLD);
        MPI_Recv(str, n, MPI_CHAR, 1, 0, MPI_COMM_WORLD, &status);
        printf("%s\n", str);
    }
    else
    {
    	MPI_Recv(&n, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);

        MPI_Recv(&word, n, MPI_CHAR, 0, 0, MPI_COMM_WORLD, &status);
        for (int i = 0; i < n; ++i)
        {
            if (word[i]>='a'&&word[i]<='z')
            {
            	word[i]-=32;
            }
            else if(word[i]>='A'&&word[i]<='Z')
            	word[i]+=32;
        }
        MPI_Ssend(word, n, MPI_CHAR, 0, 0, MPI_COMM_WORLD);
    }

    MPI_Finalize();
    return 0;
}
