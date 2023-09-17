all: TCPEchoClient TCPServer
TCPEchoClient: TCPEchoClientLoop.c DieWithError.c
	gcc TCPEchoClientLoop.c DieWithError.c -o TCPClient
TCPServer: TCPEchoServer.h TCPEchoServer-Thread.c DieWithError.c
	gcc TCPEchoServer-Thread.c DieWithError.c \
	CreateTCPServerSocket.c AcceptTCPConnection.c \
	-o TCPServer -pthread -g
