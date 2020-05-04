#ifndef _SOCKLIB_H
#define _SOCKLIB_H

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <netdb.h>

/**
 * print an error message and exit the program when receiving and sending an error in fonctions recv and send
 * @param int err determines if there is an error
 * @param char* msg the message to print
 * @param int sock the socket to close, if there is a problem
 * @param int sockIA the IA socket to close, if there is a problem
 */
void printError(int err, char* msg, int sock, int sockIA);

/**
 * Create a socket server with a port
 * @param ushort nPort the number of port to create a server access
 * @return int the number of the server socket
 */
int socketServeur(ushort nPort);

/**
 * Create a socket client with an IP and a port
 * @param char* nomMachine the ip of the distant server
 * @param ushort nPort the port of the distant server
 * @return int the number of the client socket
 */
int socketClient(char* nomMachine, ushort nPort);

/**
 * Initialise the connection with IA in Java
 * @param int port the port choose to connect with IA
 * @return int the number of the IA socket
 */
int connectionIA(int port);

/**
 * Send int to the IA
 * Send int with the language C to the language Java 
 * @param int ent the number to send
 * @param int sockIA the socket of the IA
 * @return int a code of error or not
 */
int sendIA(int ent, int sockIA);

/**
 * Recv int to the IA
 * Recv int with the language C to the language Java 
 * @param int sockIA the socket of the IA
 * @return int the number received
 */
int recvIA(int sockIA);

#endif

