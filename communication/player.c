#include "validation.h"
#include "fonctionTCP.h"
#include "protocolQuantik.h"
#include "conversion.h"
#include "printMessageEnum.h"


int wonMatch = 0;										// The number of match won for the player 
int drawMatch = 0;									// The number of match drew for the player
int lostMatch = 0;									// The number of match lost for the player
int wonMatchOpponent = 0;						// The number of match won for the opponent player
int drawMatchOpponent = 0;					// The number of match drew for the opponent player
int lostMatchOpponent = 0; 					// The number of match lost for the opponent player
    

void printHelp(char* name) {
    printf("usage : %s IPserver port name color(W/B) portIA\n", name);
}

int playFirst(int sock, int end, int err, int i, int x, int y, int p, int c, TCoupReq coupRepAdversaire, TCoupReq coupReq, TCoupRep coupResponse, TCoupRep coupResponseAdversaire, TPartieReq gameRequest, TPartieRep gameResponse) {
	printf("-----------------------------------------------------------------------------\n");
	printf ("\n\nplayFirst Iteration %d\n", i);
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
	
	err = 0;
	err = send(sock, &coupReq, sizeof(TCoupReq),0);
	printError(err, "(player) send error with the game request of one move\n", sock);
	
 	err = 0;
	err = recv(sock, &coupResponse, sizeof(TCoupRep),0);
	printError(err, "(player) recv error with the game response of one move\n", sock);
	
	end = responseError(coupResponse.err);
	if (end != 0) {
		lostMatch++;
		wonMatchOpponent++;
		return end;
	}
	end = responseValidCoup(coupResponse.validCoup, gameRequest.nomJoueur);
	if (end != 0) {
		lostMatch++;
		wonMatchOpponent++;
		return end;
	}
	end = responseContinuerAJouer(coupResponse.propCoup, gameRequest.nomJoueur);
	if (end == 1) {
		wonMatch++;
		lostMatchOpponent++;
		return end;
	}
	if (end == 2) {
		drawMatch++;
		drawMatchOpponent++;
		return end;
	}
	if (end == 3) {
		lostMatch++;
		wonMatchOpponent++;
		return end;
	}
	
	err = 0;
	printf("Waiting the player to play...\n");
	err = recv(sock, &coupResponseAdversaire, sizeof(TCoupRep),0);
	printError(err, "(player) recv error with the opponent move response\n", sock);
	
	end = responseAdversaireError(coupResponseAdversaire.err);
	if (end != 0) {
		lostMatchOpponent++;
		wonMatch++;
		return end;
	}
	end = responseAdversaireValidCoup(coupResponseAdversaire.validCoup, gameResponse.nomAdvers);
	if (end != 0) {
		lostMatchOpponent++;
		wonMatch++;
		return end;
	}
	end = responseAdversairePropCoup(coupResponseAdversaire.propCoup, gameResponse.nomAdvers);
	if (end == 1) {
		wonMatchOpponent++;
		lostMatch++;
		return end;
	}
	if (end == 2) {
		drawMatchOpponent++;
		drawMatch++;
		return end;
	}
	if (end == 3) {
		lostMatchOpponent++;
		wonMatch++;
		return end;
	}
	
	err = recv(sock, &coupRepAdversaire, sizeof(TCoupReq),0);
	printError(err, "(player) recv error with the opponent move\n", sock);

	int xa = ligneToInt(coupRepAdversaire.posPion.l);
	int ya = colonneToInt(coupRepAdversaire.posPion.c);
	int pa = pionToInt(coupRepAdversaire.pion.typePion);
	int ca = coupRepAdversaire.propCoup;
	
	printf("[%d,%d,%d,%d]\n", xa, ya, pa, ca);
	return end;
}

int playSecond(int sock, int end, int err, int i, int x, int y, int p, int c, TCoupReq coupRepAdversaire, TCoupReq coupReq, TCoupRep coupResponse, TCoupRep coupResponseAdversaire, TPartieReq gameRequest, TPartieRep gameResponse) {
	printf("-----------------------------------------------------------------------------\n");
	printf("\n\nplaySecond Iteration %d\n", i);
	
	err = 0;
	err = recv(sock, &coupResponseAdversaire, sizeof(TCoupRep),0);
	printError(err, "(player) recv error with the opponent move response\n", sock);
	
	end = responseAdversaireError(coupResponseAdversaire.err);
	if (end != 0) {
		lostMatchOpponent++;
		wonMatch++;
		return end;
	}
	end = responseAdversaireValidCoup(coupResponseAdversaire.validCoup, gameResponse.nomAdvers);
	if (end != 0) {
		lostMatchOpponent++;
		wonMatch++;
		return end;
	}
	end = responseAdversairePropCoup(coupResponseAdversaire.propCoup, gameResponse.nomAdvers);
	if (end == 1) {
		wonMatchOpponent++;
		lostMatch++;
		return end;
	}
	if (end == 2) {
		drawMatchOpponent++;
		drawMatch++;
		return end;
	}
	if (end == 3) {
		lostMatchOpponent++;
		wonMatch++;
		return end;
	}
	
	err = 0;
	err = recv(sock, &coupRepAdversaire, sizeof(TCoupReq),0);
	printError(err, "(player) recv error with the opponent move\n", sock);
	
	int xa = ligneToInt(coupRepAdversaire.posPion.l);
	int ya = colonneToInt(coupRepAdversaire.posPion.c);
	int pa = pionToInt(coupRepAdversaire.pion.typePion);
	int ca = coupRepAdversaire.propCoup;
	
	printf("[%d,%d,%d,%d]\n", xa, ya, pa, ca);
	
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
	
	err = 0;
	err = send(sock, &coupReq, sizeof(TCoupReq),0);
	printError(err, "(player) send error with the game request of one move\n", sock);
	
 	printf("Waiting the player to play...\n");
	err = 0;
	err = recv(sock, &coupResponse, sizeof(TCoupRep),0);
	printError(err, "(player) recv error with the game response of one move\n", sock);
	
	end = responseError(coupResponse.err);
	if (end != 0) {
		lostMatch++;
		wonMatchOpponent++;
		return end;
	}
	end = responseValidCoup(coupResponse.validCoup, gameRequest.nomJoueur);
	if (end != 0) {
		lostMatch++;
		wonMatchOpponent++;
		return end;
	}
	end = responseContinuerAJouer(coupResponse.propCoup, gameRequest.nomJoueur);
	if (end == 1) {
		wonMatch++;
		lostMatchOpponent++;
		return end;
	}
	if (end == 2) {
		drawMatch++;
		drawMatchOpponent++;
		return end;
	}
	if (end == 3) {
		lostMatch++;
		wonMatchOpponent++;
		return end;
	}
	return end;
}


int main (int argc, char** argv) {

    if (argc != 6) {
        printHelp(argv[0]);
        return -1;
    }

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

		printf("-----------------------------------------------------------------------------\n");
		printf("Welcome to Quantik !\n");


    err = send(sock, &gameRequest, sizeof(TPartieReq),0);
    printError(err, "(player) send error with the initialize game request\n", sock);

    printf("Waiting for player...\n");
    err = recv(sock, &gameResponse, sizeof(TPartieRep),0);
    printError(err, "(player) recv error with the initialize game response\n", sock);


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
    
    int end = 0; 												//if the game is ended
    int i = 0; 													//iteration of the loop
    int x; 															//coordinate in line choose
    int y; 															//coordinate in column choose
    int p; 															//pawn choose 
    int c; 															//if the move is winner, looser...
		TCoupReq coupRepAdversaire;					//opponent request
		TCoupReq coupReq;										//us request
		TCoupRep coupResponse;							//us response
		TCoupRep coupResponseAdversaire;		//opponent response
		
		do {
			i++;
			if (gameRequest.coulPion == BLANC) {
				end = playFirst(sock, end, err, i, x, y, p, c, coupRepAdversaire, coupReq, coupResponse, coupResponseAdversaire, gameRequest, gameResponse);
				if (end != 0) {
					break;
				}
			}
			if (gameRequest.coulPion == NOIR) {
				end = playSecond(sock, end, err, i, x, y, p, c, coupRepAdversaire, coupReq, coupResponse, coupResponseAdversaire, gameRequest, gameResponse);
				if (end != 0) {
					break;
				}
			}
		} while (end != 1);
		
		printf("\n-----------------------------------------------------------------------------\n");
		printf("The first game is ended\n");
		printf("-Player %s : won match : %d / drew match : %d / lost match : %d\n",
			 gameRequest.nomJoueur, wonMatch, drawMatch, lostMatch);
		printf("-Player %s : won match : %d / drew match : %d / lost match : %d\n",
			 gameResponse.nomAdvers, wonMatchOpponent, drawMatchOpponent, lostMatchOpponent);
			 
		printf("Now we start revenge, good luck !\n\n");
		
		end = 0; //Initialize again to zero to the second game

		do {
			i++;
			if (gameRequest.coulPion == BLANC) {
				end = playSecond(sock, end, err, i, x, y, p, c, coupRepAdversaire, coupReq, coupResponse, coupResponseAdversaire, gameRequest, gameResponse);
				if (end != 0) {
					break;
				}
			}
			if (gameRequest.coulPion == NOIR) {
				end = playFirst(sock, end, err, i, x, y, p, c, coupRepAdversaire, coupReq, coupResponse, coupResponseAdversaire, gameRequest, gameResponse);
				if (end != 0) {
					break;
				}
			}
		} while (end != 1);

		printf("\n-----------------------------------------------------------------------------\n");
		printf("The first game is ended\n");
		printf("-Player %s : won match : %d / drew match : %d / lost match : %d\n",
			 gameRequest.nomJoueur, wonMatch, drawMatch, lostMatch);
		printf("-Player %s : won match : %d / drew match : %d / lost match : %d\n",
			 gameResponse.nomAdvers, wonMatchOpponent, drawMatchOpponent, lostMatchOpponent);
		printf("See you !\n");		

    shutdown(sock, SHUT_RDWR); close(sock);
    return 0;
}







































