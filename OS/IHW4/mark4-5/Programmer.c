#include <stdio.h>      /* for printf() and fprintf() */
#include <sys/socket.h> /* for socket(), connect(), send(), and recv() */
#include <arpa/inet.h>  /* for sockaddr_in and inet_addr() */
#include <stdlib.h>     /* for atoi() and exit() */
#include <string.h>     /* for memset() */
#include <unistd.h>     /* for close() */
#include "common.h"

void DieWithError(char *errorMessage);  /* Error handling function */

void print(int buf[3]) {
    printf("%d, %d, %d\n", buf[0], buf[1], buf[2]);
}

int main(int argc, char *argv[])
{
    srand(time(NULL));
    int sock;                        /* Socket descriptor */
    struct sockaddr_in echoServAddr; /* Echo server address */
    struct sockaddr_in fromAddr;     /* Source address of echo */
    unsigned short echoServPort;     /* Echo server port */
    unsigned int fromSize;           /* In-out of address size for recvfrom() */
    char *servIP;                    /* IP address of server */
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

    int id;
    recvfrom(sock, &id, size, 0,
             (struct sockaddr *) NULL, NULL);
    printf("Programmer #%d\n", id);

    int count = 0;
    bool new = true;

    while (count < PROGS) {
        // Отправляем программу.
        buffer[0] = count;
        buffer[1] = id;
        buffer[2] = 0;
        /* Send the string to the server */
        if (sendto(sock, buffer, size, 0, (struct sockaddr *)
                &echoServAddr, sizeof(echoServAddr)) != size)
            DieWithError("sendto() sent a different number of bytes than expected");
        printf("Program #%d sent.\n", count + 1);
        bool is_checking;
        do {
            if ((bytesRcvd = recvfrom(sock, buffer, size, 0,
                                          (struct sockaddr *) NULL, NULL)) != size)
                DieWithError("recvfrom() failed");
            print(buffer);
            is_checking = buffer[2] == 0;
            if (is_checking) {
                buffer[2] = rand() % 100 > 20 ? 1 : -1;
                if (sendto(sock, buffer, size, 0, (struct sockaddr *)
                        &echoServAddr, sizeof(echoServAddr)) != size)
                    DieWithError("sendto() sent a different number of bytes than expected");
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

    while (true) {
        if ((recvfrom(sock, buffer, size, 0,
                                  (struct sockaddr *) NULL, NULL)) <= 0)
            DieWithError("recvfrom() failed");

        if (buffer[0] == -1) {
            break;
        }

        buffer[2] = rand() % 100 > 20 ? 1 : -1;
        if (sendto(sock, buffer, size, 0, (struct sockaddr *)
                &echoServAddr, sizeof(echoServAddr)) != size)
            DieWithError("sendto() sent a different number of bytes than expected");
    }

    buffer[0] = buffer[1] = buffer[2] = -1;
    if (sendto(sock, buffer, size, 0, (struct sockaddr *)
            &echoServAddr, sizeof(echoServAddr)) != size)
        DieWithError("sendto() sent a different number of bytes than expected");

    exit(0);
}
