#ifndef FUNCS_H
#define FUNCS_H

int getLength();
int fileGetSize(char **path);
void inputA(double A[], int size);
void fileInputA(char **path, double A[], int size);
void makeB(double A[], double B[], int size);
void fileOutput(char **path, double A[], double B[], int size);
void print(double A[], double B[], int size);

#endif /*FUNCS_H*/