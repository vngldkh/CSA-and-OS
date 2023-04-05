#include <stdio.h>
#include <stdbool.h>

bool is_vowel(char letter) {
	char vowels[] = "EYUIOAeyuioa";
	for (int i = 0; i < 12; ++i) {
		if (letter == vowels[i]) {
			return true;
		}
	}
	return false;
}

int count_vowels(char str[]) {
	int count = 0;
	int i = 0;
	while (str[i] != EOF) {
		if (is_vowel(str[i])) {
			++count;
		}
		++i;
	}
	return count;
}