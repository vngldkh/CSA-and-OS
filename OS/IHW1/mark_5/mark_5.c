#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <fcntl.h>

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

    int result;

    mkfifo("first_to_second.fifo", S_IFIFO | 0666);
    mkfifo("second_to_third.fifo", S_IFIFO | 0666);

    result = fork();
    if (result < 0) {
        printf("Can\'t fork child\n");
        exit(-1);
    } else if (result > 0) { /* Parent process */
        int fd;
        if((fd = open("first_to_second.fifo", O_WRONLY)) < 0){
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
        char str[size];
        write(fd, &size, sizeof(size_t));
        write(fd, &n1, sizeof(size_t));
        write(fd, &n2, sizeof(size_t));

        read(file, str, size);
        if (close(file) < 0) {
            printf("Can\'t close input file!\n");
            exit(-1);
        }

        if (write(fd, str, size) != size) {
            printf("Can\'t write all string to pipe\n");
            exit(-1);
        }
        if (close(fd) < 0) {
            printf("parent: Can\'t close writing side of pipe\n");
            exit(-1);
        }
    } else { /* Child process */
        result = fork();

        if (result < 0) {
            printf("Can\'t fork child\n");
            exit(-1);
        } else if (result > 0) {
            int fd;
            if((fd = open("first_to_second.fifo", O_RDONLY)) < 0){
                printf("Can\'t open FIFO for reading\n");
                exit(-1);
            }

            size_t size, n1, n2;
            read(fd, &size, sizeof(size_t));
            read(fd, &n1, sizeof(size_t));
            read(fd, &n2, sizeof(size_t));
            char str[size];

            if (read(fd, str, size) != size) {
                printf("Can\'t read string from pipe\n");
                exit(-1);
            }
            
            if (close(fd) < 0) {
                printf("child: Can\'t close reading side of pipe\n");
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

            if((fd = open("second_to_third.fifo", O_WRONLY)) < 0){
                printf("Can\'t open FIFO for writing\n");
                exit(-1);
            }
            write(fd, &size, sizeof(size_t));
            if (write(fd, new_str, size) != size) {
                printf("Can\'t write all string to pipe\n");
                exit(-1);
            }
            if (close(fd) < 0) {
                printf("child: Can\'t close writing side of pipe\n");
                exit(-1);
            }
        } else { /* Child process */
            int fd;
            if((fd = open("second_to_third.fifo", O_RDONLY)) < 0){
                printf("Can\'t open FIFO for reading\n");
                exit(-1);
            }

            size_t size;
            read(fd, &size, sizeof(size_t));
            char str[size];
            if (read(fd, str, size) != size) {
                printf("Can\'t read all string from pipe\n");
                exit(-1);
            }
            if (close(fd) < 0) {
                printf("child: Can\'t close reading side of pipe\n");
                exit(-1);
            }

            int file;
            if ((file = open(argv[2], O_WRONLY | O_CREAT, 0666)) < 0) {
                printf("File doesn't exist or you don't have access to it\n");
                exit(-1);
            }
            write(file, str, size);
            if (close(file) < 0) {
                printf("Can\'t close output file!\n");
                exit(-1);
            }
        }
    }

    return 0;
}