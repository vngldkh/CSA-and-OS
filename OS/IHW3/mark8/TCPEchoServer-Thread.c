#include "TCPEchoServer.h"  /* TCP echo server includes */
#include <pthread.h>        /* for POSIX threads */
#include "HandleTCPClient.c"

void *ThreadMain(void *arg);            /* Main program of a thread */

/* Structure of arguments to pass to client thread */
struct ThreadArgs
{
    int id;
    int clntSock;                      /* Socket descriptor for client */
};

int main(int argc, char *argv[])
{
    int servSock;                    /* Socket descriptor for server */
    unsigned short echoServPort;     /* Server port */
    struct ThreadArgs *threadArgs;   /* Pointer to argument structure for thread */
    init();

    if (argc != 3)     /* Test for correct number of arguments */
    {
        fprintf(stderr,"Usage:  %s <SERVER PORT> <MONITOR COUNT>\n", argv[0]);
        exit(1);
    }

    echoServPort = atoi(argv[1]);  /* First arg:  local port */
    monitor_count = atoi(argv[2]);

    if (monitor_count > MAX_MONITORS) {
        fprintf(stderr,"Too big number of monitors. Max = %d.\n", MAX_MONITORS);
        exit(1);
    }

    servSock = CreateTCPServerSocket(echoServPort);

    pthread_t tid[PROGRAMMERS];

    for (int i = 0; i < PROGRAMMERS; ++i) 
    {
        clntSocket[i] = AcceptTCPConnection(servSock);
    }

    for (int i = 0; i < monitor_count; ++i) {
        monitorSocket[i] = AcceptTCPConnection(servSock);
    }

    for (int i = 0; i < PROGRAMMERS; ++i) /* run forever */
    {
        /* Create separate memory for client argument */
        if ((threadArgs = (struct ThreadArgs *) malloc(sizeof(struct ThreadArgs)))
            == NULL)
            DieWithError("malloc() failed");
        threadArgs -> id = i;
        threadArgs -> clntSock = clntSocket[i];

        /* Create client thread */
        if (pthread_create(&tid[i], NULL, ThreadMain, (void *) threadArgs) != 0)
            DieWithError("pthread_create() failed");
        printf("with thread %ld\n", (long int) tid[i]);
    }

    for (int i = 0; i < PROGRAMMERS; ++i) {
        pthread_join(tid[i], NULL);
    }

    char finish[BUF_SIZE] = "\0";
    print(finish);
    sleep(1000000);
    pthread_mutex_destroy(&status_mutex);
    for (int i = 0; i < PROGRAMMERS; ++i) {
        close(clntSocket[i]);    /* Close client socket */
    }
    for (int i = 0; i < monitor_count; ++i) {
        close(monitorSocket[i]);
    }
}

void *ThreadMain(void *threadArgs)
{
    int clntSock, id;                   /* Socket descriptor for client connection */

    /* Guarantees that thread resources are deallocated upon return */
    pthread_detach(pthread_self());

    /* Extract socket file descriptor from argument */
    id = ((struct ThreadArgs *) threadArgs) -> id;
    clntSock = ((struct ThreadArgs *) threadArgs) -> clntSock;
    free(threadArgs);              /* Deallocate memory for argument */

    HandleTCPClient(id, clntSock);

    return (NULL);
}
