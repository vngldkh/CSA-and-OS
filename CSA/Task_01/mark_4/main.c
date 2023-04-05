#include <stdio.h>

int main() 
{
    int size = 0;

input:
    printf("length? ");
    scanf("%d", &size);
    if (size <= 0) {
        goto input;
    }

    double A[size];
    double B[size];

    for (int i = 0; i < size; ++i) {
        printf("A[%d]? ", i);
        scanf("%lf", &A[i]);
        B[i] = 9.8 * A[i] * A[i] / 2;
    }

    for (int i =0; i < size; ++i) {
        printf("A[%d] = %lfs; B[%d] = %lfm\n", i, A[i], i, B[i]);
    }

    return 0;
}