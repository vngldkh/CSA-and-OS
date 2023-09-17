#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <stdbool.h>

#define PROGRAMMERS 3
#define PROGS 10
#define MSG_SIZE 3

int sock;                        /* Socket */
int programs = 0;

int buffer[MSG_SIZE];
struct sockaddr_in clntAddr[PROGRAMMERS];

