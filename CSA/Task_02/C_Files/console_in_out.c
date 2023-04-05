#include <stdio.h>

int console_input(char str[]) {
	printf("Write your string (it must not be longer than 1000 symbols).\nTo stop writing press CTRL+D twice!\n");
	int i = 0;
	char new_symbol;
	do {
		new_symbol = getchar();
		if (new_symbol > 127) {
			return 1;
		}
		str[i++] = new_symbol;
	} while (new_symbol != EOF && i < 1000);
	if (i == 1000) {
		str[i] = '\0';
	}
	return 0;
}

void console_output(int vowels, int consonants) {
	printf("\nCount of vowels - %d\n", vowels);
	printf("Count of consonants - %d\n", consonants);
}