#include "validation.h"
#include "fonctionTCP.h"
#include "protocolQuantik.h"

void printHelp(char* name) {
    printf("usage : %s IPserver port name color(W/B) portIA\n", name);
}


TLg intToLigne(int x) {
	switch(x) {
        case 0 : 
            return UN;
        case 1 :
            return DEUX;
        case 2 :
            return TROIS;
        default :
            return QUATRE;
    } 
}

TCol intToColonne(int y){
	switch(y) {
        case 0 : 
            return A;
        case 1 :
            return B;
        case 2 :
            return C;
        default :
            return D;
    } 
}

TTypePion intToPion(int p) {
	switch(p) {
        case 0 : 
            return CYLINDRE;
        case 1 :
            return PAVE;
        case 2 :
            return SPHERE;
        default :
            return TETRAEDRE;
    } 
}

TCase positionToTCase(int x, int y) {
	TLg ligne = intToLigne(x);
	TCol colonne = intToColonne(y);
	
	TCase tcase;
	
	tcase.l = ligne;
	tcase.c = colonne;
	
	return tcase;
}

TPion pionToTPion(int p, TCoul couleurPion) {
	TTypePion tp = intToPion(p);
	
	TPion tpion;
	
	tpion.coulPion = couleurPion;
	tpion.typePion = tp;
	
	return tpion;
}

TCoupReq requeteCoup(TIdReq idRequest, int numPartie, bool estBloque, TPion pion, TCase positionPion, TPropCoup propCoup) {
	TCoupReq cr;
	cr.idRequest = idRequest;
	cr.numPartie = numPartie;
	cr.estBloque = estBloque;
	cr.pion = pion;
	cr.posPion = positionPion;
	cr.propCoup = propCoup;
	return cr;
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
    
    gameRequest.idReq = PARTIE;
    
    strcpy(gameRequest.nomJoueur, playerName);

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
            printf("You play against : %s\n", gameResponse.nomAdvers);
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
            gameRequest.coulPion = NOIR;
            printf("Color not available, you will play with black (%d).\n",gameRequest.coulPion);
        } else {
            gameRequest.coulPion = BLANC;
        		printf("Color not available, you will play with white (%d).\n",gameRequest.coulPion);
        }
    } else {
       if (gameRequest.coulPion == BLANC) {
            printf("You will play with white (%d).\n",gameRequest.coulPion);
        } else {
            printf("You will play with black (%d).\n",gameRequest.coulPion);
        }
    }


   /* printf("The game is starded :\n");
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
    }  */
    
    int x = 1;
    int y = 2;
    int p = 1;
    
    TPion tpion = pionToTPion(p, gameRequest.coulPion);
    TCase tcase = positionToTCase(x, y);
		TPropCoup propCoup;
		bool estBloque = false;
    
    printf("[Ligne %d colonne %d Pion %d Couleur %d]\n",tcase.l, tcase.c, tpion.typePion, tpion.coulPion);
    TCoupReq coupReq = requeteCoup(COUP, 1, estBloque, tpion, tcase, propCoup);
    TCoupRep coupResponse;
   	
   	err = send(sock, &coupReq, sizeof(TCoupReq),0);
    if (err <= 0) {
        perror("(player) send error during the last try\n");
        shutdown(sock, SHUT_RDWR); close(sock);
        return -4;
    }
   
   	printf("Waiting the player to play...\n");

    err = recv(sock, &coupResponse, sizeof(TCoupRep),0);
    if (err <= 0) {
        perror("(player) recv error with the game response\n");
        shutdown(sock, SHUT_RDWR); close(sock);
        return -5;
    }
    
    switch(coupResponse.err) {
    	case ERR_OK :
          break;
      case ERR_PARTIE :
          printf("Couldn't log into the game, invalid move\n");
          break;
      case ERR_TYP :
          printf("Couldn't log into the game, move\n");
          break;
      default :
          printf("default\n");
    }
    
    switch(coupResponse.validCoup) {
    	case VALID : 
          printf("Your move is valid\n");
          break;
      case TIMEOUT :
          printf("Your move isn't valid, you are over time to play.\n");
          break;
      case TRICHE :
          printf("Your move isn't valid, CHEATER\n");
          break;
      default :
          printf("default\n");
    }
    

    shutdown(sock, SHUT_RDWR); close(sock);
    return 0;
}

