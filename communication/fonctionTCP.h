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

void printError(int err, char* msg, int sock);
int socketServeur(ushort nPort);
int socketClient(char* nomMachine, ushort nPort);
int connectionIA(int port);
int sendIA(int ent, int sockIA);
int recvIA(int sockIA);

#endif

