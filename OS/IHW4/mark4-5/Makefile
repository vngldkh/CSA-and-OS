all: Programmer Server
Programmer: Programmer.c DieWithError.c
	gcc Programmer.c DieWithError.c -o Programmer
Server: EchoServer.h EchoServer-Thread.c DieWithError.c
	gcc EchoServer-Thread.c DieWithError.c \
	-o Server -pthread -g
