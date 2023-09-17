#include <stdio.h>      /* for printf() and fprintf() */
#include <sys/socket.h> /* for socket(), connect(), send(), and recv() */
#include <arpa/inet.h>  /* for sockaddr_in and inet_addr() */
#include <stdlib.h>     /* for atoi() and exit() */
#include <string.h>     /* for memset() */
#include <unistd.h>     /* for close() */
#include "common.h"

void DieWithError(char *errorMessage);  /* Error handling function */

int main(int argc, char *argv[])
{
    srand(time(NULL));
    int sock;                        /* Socket descriptor */
    struct sockaddr_in echoServAddr; /* Echo server address */
    struct sockaddr_in fromAddr;     /* Source address of echo */
    unsigned short echoServPort;     /* Echo server port */
    unsigned int fromSize;           /* In-out of address size for recvfrom() */
    char *servIP;                    /* IP address of server */
    char buffer[MAX_MSG];                                   /* Buffer for echo string */
    int bytesRcvd, totalBytesRcvd;                          /* Bytes read in single recv() and total bytes read */

    if ((argc != 3))    /* Test for correct number of arguments */
    {
        fprintf(stderr, "Usage: %s <Server IP> <Echo Port>\n",
                argv[0]);
        exit(1);
    }

    servIP = argv[1];
    echoServPort = atoi(argv[2]); /* Use given port, if any */

    /* Create a datagram/UDP socket */
    if ((sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
        DieWithError("socket() failed");

    /* Construct the server address structure */
    memset(&echoServAddr, 0, sizeof(echoServAddr));    /* Zero out structure */
    echoServAddr.sin_family = AF_INET;                 /* Internet addr family */
    echoServAddr.sin_addr.s_addr = inet_addr(servIP);  /* Server IP address */
    echoServAddr.sin_port   = htons(echoServPort);     /* Server port */

    /* Establish the connection to the echo server */
    if (connect(sock, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr)) < 0)
        DieWithError("connect() failed");

    /* Send the string to the server */
    if (sendto(sock, "0", 1, 0, (struct sockaddr *)
            &echoServAddr, sizeof(echoServAddr)) != 1)
        DieWithError("sendto() sent a different number of bytes than expected");

    // Получаем первое сообщение
    if ((recvfrom(sock, buffer, MAX_MSG, 0,
                                  (struct sockaddr *) NULL, NULL)) <= 0)
            DieWithError("recvfrom() failed");
    // Пустая строка - сообщение об окончании работы
    while (strlen(buffer)) {
        // Выводим полученное сообщение
        printf("%s", buffer);
        // Читаем новое
        if ((recvfrom(sock, buffer, MAX_MSG, 0,
                                      (struct sockaddr *) NULL, NULL)) <= 0)
                DieWithError("recvfrom() failed");
    }

    printf("Finished\n");
    exit(0);
}
