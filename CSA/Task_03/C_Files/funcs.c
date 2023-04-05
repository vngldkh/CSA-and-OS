#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>

double func(double x, int* iterations) {
	double new = 1 + x;
	double prev = 1;
	double summand = x;
	*iterations = 0;
	do {
		summand *= x;
		prev = new;
		new += summand;
		++(*iterations);
	} while (fabs(new - prev) > 0.0000001);
	return new;
}

int consoleInput(double* x) {
	printf("x? ");
	scanf("%lf", x);
	if (*x <= -1 || *x >= 1) {
		return 1;
	}
	return 0;
}

void consoleOutput(double x, int count) {
	printf("1/(1-x) = %lf\n", x);
	printf("iterations: %d", count);
}

int fileInput(double* x, char **argv) {
	FILE *fin = fopen(argv[1], "r");
	if (fin == NULL) {
		return 2;
	}
	fscanf(fin, "%lf", x);
	if (*x <= -1 || *x >= 1) {
		return 1;
	}
	fclose(fin);
	return 0;
}

int fileOutput(double x, int count, char **argv) {
	FILE *fout;
    fout = fopen(argv[2], "w");
    if (fout == NULL) {
		return 1;
	}	
	fprintf(fout, "1/(1-x) = %lf\n", x);
	fprintf(fout, "iterations: %d", count);
	return 0;
}

double random_arg() {
	double min = -1;
	double max = 1;
	double x = min + (max - min) / RAND_MAX * rand();
	printf("%lf", x);
	return x;
}

int noteRandomInput(double x, char **argv) {
	FILE *fin = fopen(argv[1], "w");
	if (fin == NULL) {
		return 2;
	}
	fprintf(fin, "%lf", x);
	fclose(fin);
	return 0;
}