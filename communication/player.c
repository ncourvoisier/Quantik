#include "validation.h"
#include "fonctionTCP.h"
#include "protocolQuantik.h"

void printHelp(char* name) {
    printf("usage : %s IPserver port name color(W/B) portIA\n", name);
}


int ligneToInt(TLg l) {
	switch(l) {
		case UN :
			return 0;
		case DEUX :
			return 1;
		case TROIS :
			return 2;
		default :
			return 3;
	}
}

int colonneToInt(TCol c) {
	switch(c) {
		case A :
			return 0;
		case B :
			return 1;
		case C :
			return 2;
		default :
			return 3;
	}
}

int pionToInt(TTypePion p) {
	switch(p) {
		case CYLINDRE :
			return 0;
		case PAVE :
			return 1;
		case SPHERE :
			return 2;
		default :
			return 3;
	}
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

TPropCoup intToProprieteCoup(int c) {
	switch(c) {
        case 0 : 
            return CONT;
        case 1 :
            return GAGNE;
        case 2 :
            return NUL;
        default :
            return PERDU;
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

    if(!strcmp(color,"W")) {
        gameRequest.coulPion = BLANC;
    } else if(!strcmp(color,"B")) {
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
            printf("You will play with white and you start(%d).\n",gameRequest.coulPion);
        } else {
            printf("You will play with black and white start(%d).\n",gameRequest.coulPion);
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
    
    
    int end = 0;
    int i = 0;
    int x;
    int y;
    int p;
    int c;
		TCoupReq coupRepAdversaire;
		TCoupReq coupReq;
		TCoupRep coupResponse;
		TCoupRep coupResponseAdversaire;
		
		do {
		
			i++;
			
			if (gameRequest.coulPion == BLANC) {
				
				printf ("\n\nIteration %d\n", i);
				printf("\nChoisir x (0,1,2,3) :\n");
				scanf("%d", &x);
				printf("Choisir y (0,1,2,3) :\n");
				scanf("%d", &y);
				printf("Choisir p (0,1,2,3) :\n");
				scanf("%d", &p);
				printf("Propirete coup (0,1,2,3) : \n");
				scanf("%d", &c);
				printf("\n\n");
				
				TPion tpion = pionToTPion(p, gameRequest.coulPion);
				TCase tcase = positionToTCase(x, y);
				TPropCoup propCoup = intToProprieteCoup(c);
				bool estBloque = false;
				
				coupReq = requeteCoup(COUP, 1, estBloque, tpion, tcase, propCoup);
				
				printf("SEND BLANC\n");
				err = 0;
				err = send(sock, &coupReq, sizeof(TCoupReq),0);
				if (err <= 0) {
				    perror("(player) send error during the last try\n");
				    shutdown(sock, SHUT_RDWR); close(sock);
				    return -4;
				}
			 
			 	printf("RECV REPONSE VALIDE BLANC\n");
				err = 0;
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
				      //end = 1;
				      break;
				  case TRICHE :
				      printf("Your move isn't valid, CHEATER\n");
				      //end = 1;
				      break;
				  default :
				      printf("default\n");
				}
			
				err = 0;
				printf("Waiting the player to play...\n");
				
				err = 0;
				printf("RECV COUV VALIDE ADVERSAIRE BLANC\n");
				err = recv(sock, &coupResponseAdversaire, sizeof(TCoupRep),0);
				if (err <= 0) {
				    perror("(player) recv error with the adversaire response\n");
				    shutdown(sock, SHUT_RDWR); close(sock);
				    return -5;
				}
				printf("valid adv[%d,%d]",coupResponseAdversaire.err, coupResponseAdversaire.validCoup);
				switch(coupResponseAdversaire.err) {
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
				
				switch(coupResponseAdversaire.validCoup) {
					case VALID : 
				      printf("The move of %s is valid\n", gameResponse.nomAdvers);
				      break;
				  case TIMEOUT :
				      printf("L'adversaire a mis trop de temps a jouer.\n");
				      //end = 1;
				      break;
				  case TRICHE :
				      printf("L'adversaire a triché\n");
				      //end = 1;
				      break;
				  default :
				      printf("default\n");
				}
				
				switch(coupResponseAdversaire.propCoup) {
					case CONT :
						printf("Nous continuons\n");
						break;
					case GAGNE :
						printf("Le joueur adverse a gagné\n");
						break;
					case NUL :
						printf("Vous avez fait match nul\n");
						break;
					case PERDU :
						printf("Le joueur adverse a perdu\n");
						break;
					default :
					 printf("default\n");
				}
				switch(coupResponse.propCoup) {
					case CONT :
						printf("Nous continuons\n");
						break;
					case GAGNE :
						printf("Vous avez gagné\n");
						break;
					case NUL :
						printf("Nous avons fait match nul\n");
						break;
					case PERDU :
						printf("Vous avez perdu\n");
						break;
					default :
					 printf("default\n");
				}
				
				printf("RECV COUP ADV BLANC\n");
				err = recv(sock, &coupRepAdversaire, sizeof(TCoupReq),0);
				if (err <= 0) {
				    perror("(player) recv error with the adversaire response\n");
				    shutdown(sock, SHUT_RDWR); close(sock);
				    return -5;
				}
				int xa = ligneToInt(coupRepAdversaire.posPion.l);
				int ya = colonneToInt(coupRepAdversaire.posPion.c);
				int pa = pionToInt(coupRepAdversaire.pion.typePion);
				int ca = coupRepAdversaire.propCoup;
				
				printf("\n[x,y,p,c]\n[%d,%d,%d,%d]\n", xa, ya, pa, ca);
				printf("\n[%d,%d,%d,%d]\n", coupRepAdversaire.posPion.l, coupRepAdversaire.posPion.c, coupRepAdversaire.pion.typePion, ca);
			
			}
			
			if (gameRequest.coulPion == NOIR) {
				
				printf("\n\nIteration %d\n", i);
				err = 0;
				printf("RECV COUV VALIDE ADVERSAIRE NOIR\n");
				err = recv(sock, &coupResponseAdversaire, sizeof(TCoupRep),0);
				if (err <= 0) {
				    perror("(player) recv error with the adversaire response\n");
				    shutdown(sock, SHUT_RDWR); close(sock);
				    return -5;
				}
				printf("valid adv[%d,%d]",coupResponseAdversaire.err, coupResponseAdversaire.validCoup);
				switch(coupResponseAdversaire.err) {
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
				
				switch(coupResponseAdversaire.validCoup) {
					case VALID : 
				      printf("The move of %s is valid\n", gameResponse.nomAdvers);
				      break;
				  case TIMEOUT :
				      printf("L'adversaire a mis trop de temps a jouer.\n");
				      //end = 1;
				      break;
				  case TRICHE :
				      printf("L'adversaire a triché\n");
				      //end = 1;
				      break;
				  default :
				      printf("default\n");
				}
				
				switch(coupResponseAdversaire.propCoup) {
					case CONT :
						printf("Nous continuons\n");
						break;
					case GAGNE :
						printf("Le joueur adverse a gagné\n");
						break;
					case NUL :
						printf("Vous avez fait match nul\n");
						break;
					case PERDU :
						printf("Le joueur adverse a perdu\n");
						break;
					default :
					 printf("default\n");
				}
				
				
				printf("RECV COUP ADV NOIR \n");
				err = 0;
				err = recv(sock, &coupRepAdversaire, sizeof(TCoupReq),0);
				if (err <= 0) {
				    perror("(player) recv error with the adversaire response\n");
				    shutdown(sock, SHUT_RDWR); close(sock);
				    return -5;
				}
				int xa = ligneToInt(coupRepAdversaire.posPion.l);
				int ya = colonneToInt(coupRepAdversaire.posPion.c);
				int pa = pionToInt(coupRepAdversaire.pion.typePion);
				int ca = coupRepAdversaire.propCoup;
				
				printf("\n[x,y,p,c]\n[%d,%d,%d,%d]\n", xa, ya, pa, ca);
				printf("\n[%d,%d,%d,%d]\n", coupRepAdversaire.posPion.l, coupRepAdversaire.posPion.c, coupRepAdversaire.pion.typePion, ca);
				
				printf("Choisir x (0,1,2,3) :\n");
				scanf("%d", &x);
				printf("Choisir y (0,1,2,3) :\n");
				scanf("%d", &y);
				printf("Choisir p (0,1,2,3) :\n");
				scanf("%d", &p);
				printf("Propirete coup (0,1,2,3) : \n");
				scanf("%d", &c);
				
				
				TPion tpion = pionToTPion(p, gameRequest.coulPion);
				TCase tcase = positionToTCase(x, y);
				TPropCoup propCoup = intToProprieteCoup(c);
				bool estBloque = false;
				coupReq = requeteCoup(COUP, 1, estBloque, tpion, tcase, propCoup);
				
				printf("SEND NOIR\n");
				err = 0;
				err = send(sock, &coupReq, sizeof(TCoupReq),0);
				if (err <= 0) {
				    perror("(player) send error during the last try\n");
				    shutdown(sock, SHUT_RDWR); close(sock);
				    return -4;
				}
			 
			 	printf("Waiting the player to play...\n");
				printf("RECV REPONSE COUP NOIR\n");
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
				      //end = 1;
				      break;
				  case TRICHE :
				      printf("Your move isn't valid, CHEATER\n");
				      //end = 1;
				      break;
				  default :
				      printf("default\n");
				}
				switch(coupResponse.propCoup) {
					case CONT :
						printf("Nous continuons\n");
						break;
					case GAGNE :
						printf("Vous avez gagné\n");
						break;
					case NUL :
						printf("Nous avons fait match nul\n");
						break;
					case PERDU :
						printf("Vous avez perdu\n");
						break;
					default :
					 printf("default\n");
				}
				
			}
		
		
		
		} while (end != 1);

    shutdown(sock, SHUT_RDWR); close(sock);
    return 0;
}







































