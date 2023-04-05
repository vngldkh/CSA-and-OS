#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    int down, up;

    printf("Waiting for general process...\n");

    if ((down = open("first_to_second.fifo", O_RDONLY)) < 0) {
        printf("Can\'t open FIFO for writing\n");
        exit(-1);
    }
    if ((up = open("second_to_first.fifo", O_WRONLY)) < 0) {
        printf("Can\'t open FIFO for writing\n");
        exit(-1);
    }

    size_t size, n1, n2;
    read(down, &size, sizeof(size_t));
    read(down, &n1, sizeof(size_t));
    read(down, &n2, sizeof(size_t));

    char str[size];
    if (read(down, str, size) != size) {
        printf("Can't read all string\n");
        exit(-1);
    }

    if (close(down) < 0) {
        printf("Can\'t close FIFO\n");
        exit(-1);
    }

    char new_str[size];
    size_t i = 0;
    for (; i < n1; ++i) {
        new_str[i] = str[i];
    }
    for (; i <= n2; ++i) {
        new_str[i] = str[n2 - (i - n1)];
    }
    for (; i < size; ++i) {
        new_str[i] = str[i];
    }
    
    if (write(up, new_str, size) != size) {
        printf("Can't write all string\n");
        exit(-1);
    }

    return 0;
}
