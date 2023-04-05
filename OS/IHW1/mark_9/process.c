#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUF_SIZE 10

int main() {
    int fd;
    char buf[BUF_SIZE];

    mkfifo("second_to_first.fifo", S_IFIFO | 0666);

    printf("Waiting for general process...\n");
    
    if ((fd = open("first_to_second.fifo", O_RDONLY)) < 0) {
        printf("Can\'t open FIFO for writing\n");
        exit(-1);
    }

    size_t size, n1, n2;
    read(fd, &size, sizeof(size_t));
    read(fd, &n1, sizeof(size_t));
    read(fd, &n2, sizeof(size_t));

    char str[size];
    size_t total_read = 0;
    size_t read_size;
    while (total_read < size) {
        read_size = read(fd, buf, BUF_SIZE);
        strcpy(str + total_read, buf);
        total_read += read_size;
    }

    if (close(fd) < 0) {
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

    if ((fd = open("second_to_first.fifo", O_WRONLY)) < 0) {
        printf("Can\'t open FIFO for writing\n");
        exit(-1);
    }
    size_t total_written = 0;
    while (total_written < size) {
        size_t i = 0;
        while (i < BUF_SIZE && i + total_written < size) {
            buf[i] = new_str[total_written + i];
            ++i;
        }
        total_written += write(fd, buf, BUF_SIZE);
    }

    return 0;
}
