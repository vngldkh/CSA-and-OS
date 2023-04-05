#include <stdio.h>
#include <stdlib.h>

int note_random_input(char str[], char **argv) {
	FILE *fin = fopen(argv[1], "w");
	if (fin == NULL) {
		return 2;
	}
	int i = 0;
	while (str[i] != EOF) {
		fprintf(fin, "%c", str[i++]);
	}
	fclose(fin);
	return 0;
}

int random_input(char str[], char **argv) {
	if (*argv[3] != '0' && *argv[3] != '1') {
		return 1;
	}
	int size = rand() % 1001;
	str[size] = EOF;
	if (*argv[3] == '0') {
		for (int i = 0; i < size; ++i) {
			char x = 'A' + rand() % 26;
			str[i] = x;
		}
	} else {
		for (int i = 0; i < size; ++i) {
			str[i] = '0' + rand() % 127;
		}
	}
	return note_random_input(str, argv);
}

int file_input(char str[], char **argv) {
	FILE *fin = fopen(argv[1], "r");
	if (fin == NULL) {
		return 2;
	}
	int i = 0;
	char new_symbol;
	do {
		new_symbol = fgetc(fin);
		if (new_symbol > 127) {
			fclose(fin);
			return 1;
		}
		str[i++] = new_symbol;
	} while (new_symbol != EOF && i < 1000);
	if (i == 1000) {
		str[i] = EOF;
	}
	fclose(fin);
	return 0;
}

int file_output(int vowels, int consonants, char **argv) {
	FILE *fin;
    fin = fopen(argv[2], "w");
    if (fin == NULL) {
		return 1;
	}	
	fprintf(fin, "Count of vowels - %d\n", vowels);
	fprintf(fin, "Count of consonants - %d\n", consonants);
	return 0;
}