#include "mpi.h"
#include <stdio.h>

void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

int main(int argc, char *argv[]) {
    int rank, numProcesses;
    int data[] = {5, 2, 9, 1, 5, 6, 2, 8};

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &numProcesses);

    int localSize = sizeof(data) / sizeof(int) / numProcesses;
    int localData[localSize];

    // Scatter data to all processes
    MPI_Scatter(data, localSize, MPI_INT, localData, localSize, MPI_INT, 0, MPI_COMM_WORLD);

    // Sort local data using parallel odd-even transposition sort
    for (int phase = 0; phase < numProcesses; phase++) {
        int partner;
        if (phase % 2 == 0) {
            // Even phase
            partner = (rank % 2 == 0) ? rank + 1 : rank - 1;
        } else {
            // Odd phase
            partner = (rank % 2 == 0) ? rank - 1 : rank + 1;
        }

        if (partner >= 0 && partner < numProcesses) {
            // Exchange data with the partner process
            MPI_Sendrecv(localData, localSize, MPI_INT, partner, 0, localData, localSize, MPI_INT, partner, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            // Sort the local data after each exchange
            if (rank < partner) {
                for (int i = 0; i < localSize; i++) {
                    if (localData[i] > localData[i + localSize]) {
                        swap(&localData[i], &localData[i + localSize]);
                    }
                }
            } else {
                for (int i = 0; i < localSize; i++) {
                    if (localData[i] < localData[i + localSize]) {
                        swap(&localData[i], &localData[i + localSize]);
                    }
                }
            }
        }
    }

    // Gather the sorted local data back to rank 0
    MPI_Gather(localData, localSize, MPI_INT, data, localSize, MPI_INT, 0, MPI_COMM_WORLD);

    // Print the sorted data on rank 0
    if (rank == 0) {
        printf("Sorted data: ");
        for (int i = 0; i < sizeof(data) / sizeof(int); i++) {
            printf("%d ", data[i]);
        }
        printf("\n");
    }

    MPI_Finalize();
    return 0;
}
