#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>

extern double func(double x, int* iterations);
extern int consoleInput(double* x);
extern void consoleOutput(double x, int count);
extern int fileInput(double* x, char **argv);
extern int fileOutput(double x, int count, char **argv);
extern double random_arg();
extern int noteRandomInput(double x, char **argv);

int main(int argc, char **argv) {
	srand(time(NULL));
	clock_t start_read, end_read, start_calc, end_calc, start_write, end_write;

	// Проверяем на кол-во аргументов
	if (argc == 2 || argc > 4) {
		printf("Wrong number of arguments!\n");
		return 1;
	}

	start_read = clock();
	int res;
	double x;
	if (argc == 1) {
		res = consoleInput(&x);
	} else if (argc == 3) {
		res = fileInput(&x, argv);
	} else {
		x = random_arg();
		res = noteRandomInput(x, argv);
	}
	if (res == 1) {
		printf("Wrong input!\n");
		return 1;
	} else if (res == 2) {
		printf("The file doesn't exist or couldn't be read!\n");
		return 2;
	}
	end_read = clock() - start_read;

	start_calc = clock();
	int iterations = 0;
	double f = func(x, &iterations);
	end_calc = clock() - start_calc;

	start_write = clock();
	if (argc == 1) {
		consoleOutput(f, iterations);
	} else {
		if (fileOutput(f, iterations, argv) != 0) {
			printf("The file couldn't be changed!\n");
		}
	}
	end_write = clock() - start_write;

	double time_read = ((double)end_read)/CLOCKS_PER_SEC;
	double time_calc = ((double)end_calc)/CLOCKS_PER_SEC;
	double time_write = ((double)end_write)/CLOCKS_PER_SEC;
	double total = time_read + time_calc + time_write;
	printf("\nRead:\t\t%f\n", time_read);
	printf("Calc:\t\t%f\n", time_calc);
	printf("Write:\t\t%f\n", time_write);
	printf("Total:\t\t%f\n", total);
}

