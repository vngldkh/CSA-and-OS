all: Programmer Server Monitor
Programmer: Programmer.c DieWithError.c
	gcc Programmer.c DieWithError.c -o Programmer
Server: EchoServer.h EchoServer-Thread.c DieWithError.c
	gcc EchoServer-Thread.c DieWithError.c \
	-o Server -pthread -g
Monitor: Monitor.c DieWithError.c
	gcc Monitor.c DieWithError.c -o Monitor
