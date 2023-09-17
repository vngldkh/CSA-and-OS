#include <stdio.h>      /* for printf() and fprintf() */
#include <sys/socket.h> /* for recv() and send() */
#include "common.c"

void DieWithError(char *errorMessage);  /* Error handling function */

// Получаем программу от клиента - программиста
void ReceiveProgram(int threadId) {
    if ((recv(clntSocket[threadId], &buffer[threadId], MSG_SIZE * sizeof(int), 0)) < 0)
        DieWithError("recv() failed");
    char str[BUF_SIZE];
    printf("Thread #%d >> Get %d, %d, %d\n", threadId, buffer[threadId][0], buffer[threadId][1], buffer[threadId][2]);
    sprintf (str, "Thread #%d >> Get %d, %d, %d\n", threadId, buffer[threadId][0], buffer[threadId][1], buffer[threadId][2]);
    print(str);
}

void SendProgram(int receiver, int threadId) {
    if (send(clntSocket[receiver], &buffer[threadId], MSG_SIZE * sizeof(int), 0) != MSG_SIZE * sizeof(int))
        DieWithError("send() sent a different number of bytes than expected");
    char str[BUF_SIZE];
    if (buffer[threadId][0] != -1) {
        printf("Thread #%d >> Send %d, %d, %d to %d\n", threadId, buffer[threadId][0], buffer[threadId][1], buffer[threadId][2], receiver);
        sprintf (str, "Thread #%d >> Send %d, %d, %d to %d\n", threadId, buffer[threadId][0], buffer[threadId][1], buffer[threadId][2], receiver);
        print(str);
    }
}

void Finish(int threadId) {
    printf("Thread #%d >> Finished.\n", threadId);
    buffer[threadId][0] = buffer[threadId][1] = buffer[threadId][2] = -1;
    for (int i = 0; i < PROGRAMMERS; ++i) {
        SendProgram(i, threadId);
    }
}

int ChooseInspector(int threadId) {
    return (threadId + rand() % (PROGRAMMERS - 1) + 1) % PROGRAMMERS;
}

void HandleTCPClient(int threadId, int socket) {
    char str[BUF_SIZE];
    clntSocket[threadId] = socket;
    int inspectorId = -1;

    while (!check()) {
        // Программист написал (или дописал программу).
        ReceiveProgram(threadId);

        if (buffer[threadId][0] == -1) {
            toggle(threadId);
            sprintf(str, "Thread #%d >> Finished writing.\n", threadId);
            print(str);
            continue;
        }

        if (buffer[threadId][2] == 0) {
            if (buffer[threadId][1] == PROGRAMMERS) {
                buffer[threadId][1] = threadId;
                inspectorId = ChooseInspector(threadId);
            }
            sprintf(str, "Thread #%d >> Send program #%d to %d for checking.\n", threadId, buffer[threadId][0] + 1, inspectorId);
            print(str);
            SendProgram(inspectorId, threadId);
        } else {
            sprintf(str, "Thread #%d >> Send program #%d to %d with result %d.\n", threadId, buffer[threadId][0] + 1, buffer[threadId][1], buffer[threadId][2]);
            print(str);
            SendProgram(buffer[threadId][1], threadId);
        }
    }

    Finish(threadId);
}

