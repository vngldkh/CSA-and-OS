#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <stdbool.h>

#define PROGRAMMERS 3
#define PROGS 10
#define MSG_SIZE 3
#define MAX_MSG 64
#define MAX_MONITORS 100

int sock;                        /* Socket */
int programs = 0;
int monitors_count;

int buffer[MSG_SIZE];
struct sockaddr_in clntAddr[PROGRAMMERS];
struct sockaddr_in monitorAddr[MAX_MONITORS];

