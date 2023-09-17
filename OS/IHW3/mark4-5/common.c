#include "common.h"

void init() {
	srand(time(NULL));
	for (int i = 0; i < PROGRAMMERS; ++i) {
		pthread_mutex_init(&mutex[i], NULL);
		done[i] = 0;
		for (int j = 0; j < PROGRAMMERS * MSG_SIZE; ++j) {
            queues[i][j] = -1;
        }
	}
	pthread_mutex_init(&status_mutex, NULL);
}

bool check() {
	bool flag = true;

	pthread_mutex_lock(&status_mutex);

	for (int i = 0; i < PROGRAMMERS; ++i) {
		flag &= done[i];
	}

	pthread_mutex_unlock(&status_mutex);

	return flag;
}

void toggle(int id) {
	pthread_mutex_lock(&status_mutex);

	done[id] = true;

	pthread_mutex_unlock(&status_mutex);
}