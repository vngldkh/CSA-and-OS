#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <stdbool.h>

#define PROGRAMMERS 3
#define PROGS 10
#define MSG_SIZE 3

int queues[PROGRAMMERS][MSG_SIZE * PROGRAMMERS];
pthread_mutex_t mutex[PROGRAMMERS];

bool done[PROGRAMMERS];
pthread_mutex_t status_mutex;

int buffer[PROGRAMMERS][MSG_SIZE];
int clntSocket[PROGRAMMERS];

void init();
bool check();
void toggle(int id);

