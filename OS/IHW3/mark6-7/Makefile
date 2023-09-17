all: TCPEchoClient TCPServer monitor
TCPEchoClient: TCPEchoClientLoop.c DieWithError.c
	gcc TCPEchoClientLoop.c DieWithError.c -o TCPClient
TCPServer: TCPEchoServer.h TCPEchoServer-Thread.c DieWithError.c
	gcc TCPEchoServer-Thread.c DieWithError.c \
	CreateTCPServerSocket.c AcceptTCPConnection.c \
	-o TCPServer -pthread -g
monitor: monitor.c DieWithError.c
	gcc monitor.c DieWithError.c -o monitor
