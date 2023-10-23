#include "mpi.h"
#include <stdio.h>
#include <stdlib.h>
int factorial(int n) {
    if (n <= 1) {
        return 1; // Base case: factorial of 0 and 1 is 1
    } else {
        return n * factorial(n - 1); // Recursive case
    }
}

int main(int argc, char *argv[]) {
    int rank, size, A[100], B[100], c, n;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if (rank == 0) {
        n = size;
        printf("Enter %d elements:\n", n);
        for (int i = 0; i < n; ++i) {
            scanf("%d", &A[i]);
        }
    }

    MPI_Scatter(A, 1, MPI_INT, &c, 1, MPI_INT, 0, MPI_COMM_WORLD);
    printf("Process %d received %d\n", rank, c);
    c = factorial(c);

    MPI_Gather(&c, 1, MPI_INT, B, 1, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("Squared values in rank 0:\n");
        for (int i = 0; i < n; ++i) {
            printf("%d ", B[i]);
        }
        printf("\n");
    }

    MPI_Finalize();
    return 0;
}