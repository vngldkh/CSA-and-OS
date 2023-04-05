#include <stdio.h>

int getLength() {
    int size = 0;
input:
    printf("length? ");
    scanf("%d", &size);
    if (size <= 0) {
        goto input;
    }
    return size;
}

void inputA(double A[], int size) {
    for (int i = 0; i < size; ++i) {
        printf("A[%d]? ", i);
        scanf("%lf", &A[i]);
    }
}

void makeB(double A[], double B[], int size) {
    for (int i = 0; i < size; ++i) {
        B[i] = 9.8 * A[i] * A[i] / 2;
    }
} 

int main() 
{
    int size = getLength();

    double A[size];
    double B[size];

    inputA(A, size);
    makeB(A, B, size);

    for (int i =0; i < size; ++i) {
        printf("A[%d] = %lfs; B[%d] = %lfm\n", i, A[i], i, B[i]);
    }

    return 0;
}