#include <stdio.h>
#include <stdbool.h>

bool is_consonant(char letter) {
	char consonants[] = "QWRTPSDFGHJKLZXCVBNMqwrtpsdfghjklzxcvbnm";
	for (int i = 0; i < 40; ++i) {
		if (letter == consonants[i]) {
			return true;
		}
	}
	return false;
}

int count_consonants(char str[]) {
	int count = 0;
	int i = 0;
	while (str[i] != EOF) {
		if (is_consonant(str[i])) {
			++count;
		}
		++i;
	}
	return count;
}