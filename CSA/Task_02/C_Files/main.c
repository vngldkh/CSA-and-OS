#include <stdio.h>
#include <time.h>

extern int count_vowels(char str[]);
extern int count_consonants(char str[]);
extern int console_input(char str[]);
extern void console_output(int vowels, int consonants);
extern int file_input(char str[], char **argv);
extern int file_output(int vowels, int consonants, char **argv);
extern int random_input(char str[], char **argv);

int main(int argc, char **argv) {
	char str[1001];
	clock_t start_read, end_read, start_calc, end_calc, start_write, end_write;

	// Проверяем на кол-во аргументов
	if (argc == 2 || argc > 4) {
		printf("Wrong number of arguments!\n");
		return 1;
	}

	// Вводим строку
	start_read = clock();
	int res;
	if (argc == 1) {
		res = console_input(str);
	} else if (argc == 3) {
		res = file_input(str, argv);
	} else {
		res = random_input(str, argv);
	}
	if (res == 1) {
		printf("Wrong input!\n");
		return 1;
	} else if (res == 2) {
		printf("The file doesn't exist or couldn't be read!\n");
		return 2;
	}
	end_read = clock() - start_read;
	
	// Считаем кол-во гласных и согласных
	start_calc = clock();
	int vowels = count_vowels(str);
	int consonants = count_consonants(str);
	end_calc = clock() - start_calc;

	// Выводим результат
	start_write = clock();
	if (argc == 1) {
		console_output(vowels, consonants);
	} else {
		if (file_output(vowels, consonants, argv) != 0) {
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