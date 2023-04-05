#include <stdio.h>
#include "funcs.h"

int main(int argc, char **argv) 
{
    if (argc != 1 && argc != 3) {
        printf("Wrong number of arguments!");
        return 1;
    }

    if (argc == 1) {
        int size = getLength();
        double A[size];
        double B[size];
        inputA(A, size);
        makeB(A, B, size);
        print(A, B, size);
    }

    if (argc == 3) {
        int size = fileGetSize(argv);
        if (size <= 0) {
            printf("Wrong size!");
            return 1;
        }
        double A[size];
        double B[size];
        fileInputA(argv, A, size);
        makeB(A, B, size);
        fileOutput(argv, A, B, size);
    }
    
    return 0;
}