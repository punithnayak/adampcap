#include "mpi.h"
#include <stdio.h>
#include <stdlib.h>


int main(int argc, char *argv[]) {
    int rank, size, A[100], B[100], m;
    float avg=0,sum;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if (rank == 0) {
        printf("enter value of m\n");
        scanf("%d",&m);
        printf("Enter %d elements:\n", m*size);
        for (int i = 0; i < m*size; ++i) {
            scanf("%d", &A[i]);
        }
    }
    MPI_Bcast(&m,1,MPI_INT,0,MPI_COMM_WORLD);
    MPI_Scatter(A, m, MPI_INT, B, m, MPI_INT, 0, MPI_COMM_WORLD);
    for (int i = 0; i < m; i++)
    {
    	avg+=B[i];
    }
    avg/=m;
    printf("avg in Process %d :%f ", rank, avg);
    MPI_Reduce(&avg,&sum,1,MPI_FLOAT,MPI_SUM,0,MPI_COMM_WORLD);

    if (rank == 0) {
        printf("SUM OF AVG:%f\n",sum);
          }

    MPI_Finalize();
    return 0;
}
