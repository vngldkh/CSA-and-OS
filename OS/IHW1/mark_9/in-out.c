#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#define BUF_SIZE 10

size_t read_num(int fd) {
    size_t x = 0;
    char symbol;
    read(fd, &symbol, 1);
    while (symbol != ' ' && symbol != '\n') {
        x = x * 10 + (symbol - '0');
        read(fd, &symbol, 1);
    }
    return x;
}

int main (int argc, char **argv) {
    if (argc != 3) {
        printf("Wrong number of arguments!\n");
        exit(-1);
    }

    int fd;
    char buf[BUF_SIZE];

    mkfifo("first_to_second.fifo", S_IFIFO | 0666);

    printf("Waiting for another process...\n"); 

    if ((fd = open("first_to_second.fifo", O_WRONLY)) < 0) {
        printf("Can\'t open FIFO for writing\n");
        exit(-1);
    }

    int file;
    if ((file = open(argv[1], O_RDONLY, 0666)) < 0) {
        printf("File doesn't exist or you don't have access to it\n");
        exit(-1);
    }

    size_t size, n1, n2;
    size = read_num(file);
    n1 = read_num(file);
    n2 = read_num(file);
    write(fd, &size, sizeof(size_t));
    write(fd, &n1, sizeof(size_t));
    write(fd, &n2, sizeof(size_t));
    size_t total_written = 0;
    while (total_written < size) {
        read(file, buf, BUF_SIZE);
        total_written += write(fd, buf, BUF_SIZE);
    }

    if (close(fd) < 0) {
        printf("Can\'t close FIFO\n");
        exit(-1);
    }
    if (close(file) < 0) {
        printf("Can\'t close input file\n");
        exit(-1);
    }

    if ((fd = open("second_to_first.fifo", O_RDONLY)) < 0) {
        printf("Can\'t open FIFO for reading\n");
        exit(-1);
    }
    if ((file = open(argv[2], O_WRONLY | O_CREAT, 0666)) < 0) {
        printf("File doesn't exist or you don't have access to it\n");
        exit(-1);
    }
    size_t read_size, read_total = 0;
    while (read_total < size) {
        read_size = read(fd, buf, BUF_SIZE);
        write(file, buf, BUF_SIZE);
        read_total += read_size;
    }
    if (close(fd) < 0) {
        printf("Can\'t close FIFO\n");
        exit(-1);
    }
    if (close(file) < 0) {
        printf("Can\'t close output file\n");
        exit(-1);
    }
}