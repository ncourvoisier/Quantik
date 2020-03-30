#include "validation.h"
#include "fonctionTCP.h"
#include "protocolQuantik.h"

void printHelp(char* name) {
    printf("usage : %s IPserver port name color(W/B)\n", name);
}

int connectionIA(int port) {
  printf("CONNECTION IA");
  struct sockaddr_in addClient;
  int sockTrans;
  int	sizeAddr;
	int	err;

  int sockServ = socketServeur(port);
  if (sockServ < 0){
		printf("(connectionIA) Error on socket server portIA\n");
		return -2;
	}

  sizeAddr = sizeof(struct sockaddr_in);
	sockTrans = accept(sockServ, (struct sockaddr *)&addClient, (socklen_t *)&sizeAddr);
	if (sockTrans < 0) {
		perror("(connectionIA) Error on accept");
		return -3;
	}

  return sockTrans;
}

int sendIA(int ent, int sockIA) {
	int err = 0;
	ent = htonl(ent);
	err = send(sockIA, &ent, sizeof(int),0);
	if (err <= 0) {
		perror("(player) send error with the IA request\n");
		shutdown(sockIA, SHUT_RDWR); close(sockIA);
		return -1;
	}
  ent = ntohl(ent);
  return 0;
}

int recvIA(int sockIA) {
	 	int entres;
    int err = 0;
    while (err < 4) {
        err = recv(sockIA, &entres, sizeof(int),MSG_PEEK);
    }
    err = recv(sockIA, &entres, sizeof(int),0);
    if (err <= 0) {
        perror("(player) recv error with the IA response\n");
        shutdown(sockIA, SHUT_RDWR); close(sockIA);
        return -1;
    }
    int res = ntohl(entres);
    return res;
}


int main (int argc, char** argv) {

    if (argc != 6) {
        printHelp(argv[0]);
        return -1;
    }

    printf("Av co ia\n");
    char* ipServeur = argv[1];
    char* playerName = argv[3];
    char* color = argv[4];
    int port = atoi(argv[2]);
    int sock = socketClient(ipServeur, port);
    //msg erreur TO DO
    int err;
    int portIA = atoi(argv[5]);
    TPartieReq gameRequest;
    TPartieRep gameResponse;

    if(strcmp(color,"W")) {
        gameRequest.coulPion = BLANC;
    } else if(strcmp(color,"B")) {
        gameRequest.coulPion = NOIR;
    } else {
        printHelp(argv[0]);
        return -2;
    }
    
    strcpy(gameRequest.nomJoueur, playerName);
/*
    err = send(sock, &gameRequest, sizeof(TPartieReq),0);
    if (err <= 0) {
        perror("(player) send error with the game request\n");
        shutdown(sock, SHUT_RDWR); close(sock);
        return -3;
    }

    printf("Waiting for player...\n");

    err = recv(sock, &gameResponse, sizeof(TPartieRep),0);
    if (err <= 0) {
        perror("(player) recv error with the game response\n");
        shutdown(sock, SHUT_RDWR); close(sock);
        return -4;
    }

    switch(gameResponse.err) {
        case ERR_OK : 
            printf("You play against : %s", gameResponse.nomAdvers);
            break;
        case ERR_PARTIE :
            printf("Couldn't log into the game, invalid game request\n");
            break;
        case ERR_TYP :
            printf("Couldn't log into the game, invalid type request\n");
            break;
        default :
            printf("default\n");
    } 

    if (gameResponse.validCoulPion) {
        if (gameRequest.coulPion == BLANC) {
            printf("Color not available, you will with black.\n");
            gameRequest.coulPion = NOIR;
        } else {
            printf("Color not available, you will with white.\n");
            gameRequest.coulPion = BLANC;
        }
    } else {
       if (gameRequest.coulPion == BLANC) {
            printf("You will with white.\n");
        } else {
            printf("You will with black.\n");
        }
    }*/


    printf("The game is starded :\n");
    int sockIA  = connectionIA(portIA); // Connexion a l'IA
      
    // Envoie au java
    int ent = 12;
    err = sendIA(ent, sockIA);
    if (err == -1) {
    	return -1;
    }
    
    // Reception du java
    int recu = recvIA(sockIA);
    if (recu == -1) {
    	return -1;
    }
    
   
    printf("\nRECU DU JAVA : %d\n", recu);

    shutdown(sock, SHUT_RDWR); close(sock);
    return 0;
}

