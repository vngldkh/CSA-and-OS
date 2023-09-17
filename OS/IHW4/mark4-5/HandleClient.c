#include <stdio.h>      /* for printf() and fprintf() */
#include <sys/socket.h> /* for recv() and send() */
#include "common.h"

void DieWithError(char *errorMessage);  /* Error handling function */

// Получаем программу от клиента - программиста
void ReceiveProgram() {

    socklen_t cliAddrLen = sizeof(clntAddr[0]);
    /* Block until receive message from a client */
    if ((recvfrom(sock, buffer, MSG_SIZE * sizeof(int), 0,
                                (struct sockaddr *) NULL, NULL)) < 0)
        DieWithError("recvfrom() failed");
    printf("Get [%d, %d, %d] from programmer #%d\n", buffer[0], buffer[1], buffer[2], buffer[1]);
}

void SendProgram(int receiver) {
    printf("Send [%d, %d, %d] to programmer #%d\n", buffer[0], buffer[1], buffer[2], receiver);
    if (sendto(sock, buffer, MSG_SIZE * sizeof(int), 0,
               (struct sockaddr *) &clntAddr[receiver], sizeof(clntAddr[receiver])) != MSG_SIZE * sizeof(int))
        DieWithError("sendto() sent a different number of bytes than expected");
}

void Finish() {
    printf("Finish");
    buffer[0] = buffer[1] = buffer[2] = -1;
    for (int i = 0; i < PROGRAMMERS; ++i) {
        SendProgram(i);
    }
}

int ChooseInspector(int threadId) {
    return (threadId + rand() % (PROGRAMMERS - 1) + 1) % PROGRAMMERS;
}

void HandleClient() {
    for (int i = 0; i < PROGRAMMERS; ++i) {
        if (sendto(sock, &i, sizeof(int), 0,
                   (struct sockaddr *) &clntAddr[i], sizeof(clntAddr[i])) != sizeof(int))
            DieWithError("sendto() sent a different number of bytes than expected");
    }

    int threadId;

    while (programs < PROGS * PROGRAMMERS) {
        ReceiveProgram();
        threadId = buffer[1];

        if (buffer[2] > 0) {
            ++programs;
        }

        if (buffer[2] == 0) {
            SendProgram(ChooseInspector(buffer[1]));
        } else {
            SendProgram(buffer[1]);
        }
    }

    Finish();
}

