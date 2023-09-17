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
    printf("Get [%d, %d, %d] from programmer #%d\n", buffer[0], buffer[1], buffer[2], buffer[1] + 1);
}

void SendProgram(int receiver) {
    printf("Send [%d, %d, %d] to programmer #%d\n", buffer[0], buffer[1], buffer[2], receiver + 1);
    if (sendto(sock, buffer, MSG_SIZE * sizeof(int), 0,
               (struct sockaddr *) &clntAddr[receiver], sizeof(clntAddr[receiver])) != MSG_SIZE * sizeof(int))
        DieWithError("sendto() sent a different number of bytes than expected");
}

void SendToMonitors(char message[MAX_MSG]) {
    for (int i = 0; i < monitors_count; ++i) {
        sendto(sock, message, MAX_MSG, 0,
                   (struct sockaddr *) &monitorAddr[i], sizeof(monitorAddr[i]));
    }
}

void Finish() {
    printf("Finish\n");
    buffer[0] = buffer[1] = buffer[2] = -1;
    for (int i = 0; i < PROGRAMMERS; ++i) {
        SendProgram(i);
    }
    SendToMonitors("\0");
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

    int inspectorId;

    char msg[MAX_MSG];
    while (programs < PROGS * PROGRAMMERS) {
        ReceiveProgram();

        if (buffer[2] == 0) {
            inspectorId = ChooseInspector(buffer[1]);
            sprintf(msg, "Programmer #%d sent program #%d to check to programmer #%d\n", buffer[1] + 1, buffer[0] + 1, inspectorId + 1);
            SendToMonitors(msg);
            SendProgram(inspectorId);
        } else {
            sprintf(msg, "Programmer #%d's program #%d returned with result #%d\n", buffer[1] + 1, buffer[0] + 1, buffer[2]);
            SendToMonitors(msg);
            SendProgram(buffer[1]);
            if (buffer[2] > 0) {
                ++programs;
                sprintf(msg, "Programmer #%d finished program #%d\n", buffer[1] + 1, buffer[0] + 1);
                SendToMonitors(msg);
            }
        }
    }

    Finish();
}

