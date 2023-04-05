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

int fileGetSize(char **path) {
    FILE *fin;
    fin = fopen(path[1], "r");
    int size = 0;
    fscanf(fin, "%d", &size);
    fclose(fin);
    return size;
}

void fileInputA(char **path, double A[], int size) {
    FILE *fin;
    fin = fopen(path[1], "r");
    int temp;
    fscanf(fin, "%d", &temp);
    for (int i = 0; i < size; ++i) {
        fscanf(fin, "%lf", &A[i]);
    }
    fclose(fin);
}

void makeB(double A[], double B[], int size) {
    for (int i = 0; i < size; ++i) {
        B[i] = 9.8 * A[i] * A[i] / 2;
    }
} 

void fileOutput(char **path, double A[], double B[], int size) {
    FILE *fin;
    fin = fopen(path[2], "w");
    for (int i = 0; i < size; ++i) {
        fprintf(fin, "A[%d] = %lfs; B[%d] = %lfm\n", i, A[i], i, B[i]);
    }
    fclose(fin);
}

void print(double A[], double B[], int size) {
    for (int i = 0; i < size; ++i) {
        printf("A[%d] = %lfs; B[%d] = %lfm\n", i, A[i], i, B[i]);
    }
}