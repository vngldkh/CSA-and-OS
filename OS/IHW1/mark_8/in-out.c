#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

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

    mkfifo("first_to_second.fifo", S_IFIFO | 0666);
    mkfifo("second_to_first.fifo", S_IFIFO | 0666);

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
    
    char str[size];
    read(file, str, size);

    if (write(fd, str, size) != size) {
        printf("Can't write all string\n");
        exit(-1);
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
    if (read(fd, str, size) != size) {
        printf("Can't reading all string\n");
        exit(-1);
    }
    if ((file = open(argv[2], O_WRONLY | O_CREAT, 0666)) < 0) {
        printf("File doesn't exist or you don't have access to it\n");
        exit(-1);
    }
    write(file, str, size);
    if (close(file) < 0) {
        printf("Can\'t close output file!\n");
        exit(-1);
    }

    if (close(fd) < 0) {
        printf("Can\'t close FIFO\n");
        exit(-1);
    }
}