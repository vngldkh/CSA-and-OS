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
    int sock;                                               /* Socket descriptor */
    struct sockaddr_in echoServAddr;                        /* Echo server address */
    unsigned short echoServPort;                            /* Echo server port */
    char *servIP;                                           /* Server IP address (dotted quad) */
    int buffer[MSG_SIZE];                                   /* Buffer for echo string */
    unsigned int size = MSG_SIZE * sizeof(int);    /* Length of string to echo */
    int bytesRcvd, totalBytesRcvd;                          /* Bytes read in single recv() and total bytes read */

    if ((argc != 3))    /* Test for correct number of arguments */
    {
        fprintf(stderr, "Usage: %s <Server IP> <Echo Port>\n",
                argv[0]);
        exit(1);
    }

    servIP = argv[1];
    echoServPort = atoi(argv[2]); /* Use given port, if any */

    /* Create a reliable, stream socket using TCP */
    if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
        DieWithError("socket() failed");

    /* Construct the server address structure */
    memset(&echoServAddr, 0, sizeof(echoServAddr));     /* Zero out structure */
    echoServAddr.sin_family      = AF_INET;             /* Internet address family */
    echoServAddr.sin_addr.s_addr = inet_addr(servIP);   /* Server IP address */
    echoServAddr.sin_port        = htons(echoServPort); /* Server port */

    /* Establish the connection to the echo server */
    if (connect(sock, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr)) < 0)
        DieWithError("connect() failed");

    int count = 0;
    bool new = true;

    while (count < PROGS) {
        // Отправляем программу.
        buffer[0] = count;
        if (new) {
            buffer[1] = PROGRAMMERS;
        }
        buffer[2] = 0;
        if (send(sock, &buffer, size, 0) != size)
            DieWithError("send() sent a different number of bytes than expected");
        printf("Program #%d sent.\n", count + 1);
        bool is_checking;
        do {
            if ((bytesRcvd = recv(sock, &buffer, size, 0)) <= 0)
                DieWithError("recv() failed or connection closed prematurely");
            is_checking = buffer[2] == 0;
            if (is_checking) {
                buffer[2] = rand() % 100 > 20 ? 1 : -1;
                if (send(sock, &buffer, size, 0) != size)
                    DieWithError("send() sent a different number of bytes than expected");
            }
        } while(is_checking);

        printf("Program #%d received.\n", count + 1);

        new = buffer[2] > 0;
        if (new) {
            printf("Program #%d done.\n", ++count);
        } else {
            printf("Continue writing program #%d.\n", count);
        }
    }

    buffer[0] = buffer[1] = buffer[2] = -1;
    if (send(sock, &buffer, size, 0) != size)
        DieWithError("send() sent a different number of bytes than expected");

    while (true) {
        if ((recv(sock, &buffer, size, 0)) <= 0)
            DieWithError("recv() failed or connection closed prematurely");

        if (buffer[0] == -1) {
            break;
        }

        buffer[2] = rand() % 100 > 20 ? 1 : -1;
        if (send(sock, &buffer, size, 0) != size)
            DieWithError("send() sent a different number of bytes than expected");
    }

    buffer[0] = buffer[1] = buffer[2] = -1;
    if (send(sock, &buffer, size, 0) != size)
        DieWithError("send() sent a different number of bytes than expected");


    close(sock);
    exit(0);
}
