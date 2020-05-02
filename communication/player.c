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

 
/**
 * Fonction who print a help message to launch the program
 * @param char* name the name of the program
 */
void printHelp(char* name) {
    printf("usage : %s IPserver port name color(W/B) portIA\n", name);
}

/**
 * Fonction who make a score of the two player for the current player
 * @param int end a code to determinate the winner
 */
void scorePlayer(int end) {
	switch(end) {
		case 1 :
		 	wonMatchOpponent++;
			lostMatch++;
			break;
		case 2 :
			drawMatchOpponent++;
			drawMatch++;
			break;
		case 3 :
			lostMatchOpponent++;
			wonMatch++;
			break;
		default :
			printf("default score");
	}
}

/**
 * Fonction who make a score of the two player for the opponent player
 * @param int end a code to determinate the winner
 */
void scoreOpponent(int end) {
	switch(end) {
		case 1 :
		 	wonMatch++;
			lostMatchOpponent++;
			break;
		case 2 :
			drawMatch++;
			drawMatchOpponent++;
			break;
		case 3 :
			lostMatch++;
			wonMatchOpponent++;
			break;
		default :
			printf("default score");
	}
}

/**
 * Function that plays the player if he plays first
 * @param int sock the socket to connect with the game server
 * @param int i the number of move
 * @param int err a code of error
 * @param TPartieReq gameRequest the request of the game
 * @param TPartieRep gameResponse the response of the game request
 */
int playFirst(int sock, int sockIA, int i, int err, TPartieReq gameRequest, TPartieRep gameResponse) {
	
	int end = 0; 												// If the game is ended
  int x; 															// Coordinate in line choose
  int y; 															// Coordinate in column choose
  int p; 															// Pawn choose 
  int c; 															// If the move is winner, looser...
	TCoupReq coupRepAdversaire;					// Opponent request
	TCoupReq coupReq;										// Us request
	TCoupRep coupResponse;							// Us response
	TCoupRep coupResponseAdversaire;		// Opponent response
		
	printf("-----------------------------------------------------------------------------\n");
	printf ("\n\nplayFirst Iteration %d\n", i);
	
	x = recvIA(sockIA);
  if (x == -1) {
  	return -1;
  }
	y = recvIA(sockIA);
  if (y == -1) {
  	return -1;
  }
  p = recvIA(sockIA);
  if (p == -1) {
  	return -1;
  }
  c = recvIA(sockIA);
  if (c == -1) {
  	return -1;
  }
  
	printf("IA Result : [%d,%d,%d,%d]\n", x, y, p, c);
	
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
		scoreOpponent(end);
		err = sendIA(end, sockIA);
		if (err == -1) {
			return -1;
		}
		return end;
	}
	end = responseValidCoup(coupResponse.validCoup, gameRequest.nomJoueur);
	if (end != 0) {
		scoreOpponent(end);
		err = sendIA(end, sockIA);
		if (err == -1) {
			return -1;
		}
		return end;
	}
	end = responseContinuerAJouer(coupResponse.propCoup, gameRequest.nomJoueur);
	if (end != 0) {
		scoreOpponent(end);
		err = sendIA(end, sockIA);
		if (err == -1) {
			return -1;
		}
		return end;
	}
	
	err = 0;
	printf("Waiting the player to play...\n");
	err = recv(sock, &coupResponseAdversaire, sizeof(TCoupRep),0);
	printError(err, "(player) recv error with the opponent move response\n", sock);
	
	end = responseAdversaireError(coupResponseAdversaire.err);
	if (end != 0) {
		scorePlayer(end);
		err = sendIA(end, sockIA);
		if (err == -1) {
			return -1;
		}
		return end;
	}
	end = responseAdversaireValidCoup(coupResponseAdversaire.validCoup, gameResponse.nomAdvers);
	if (end != 0) {
		scorePlayer(end);
		err = sendIA(end, sockIA);
		if (err == -1) {
			return -1;
		}
		return end;
	}
	end = responseAdversairePropCoup(coupResponseAdversaire.propCoup, gameResponse.nomAdvers);
	if (end != 0) {
		scorePlayer(end);
		err = sendIA(end, sockIA);
		if (err == -1) {
			return -1;
		}
		return end;
	}
	err = sendIA(end, sockIA);
	if (err == -1) {
		return -1;
	}
	
	err = recv(sock, &coupRepAdversaire, sizeof(TCoupReq),0);
	printError(err, "(player) recv error with the opponent move\n", sock);

	int xa = ligneToInt(coupRepAdversaire.posPion.l);
	int ya = colonneToInt(coupRepAdversaire.posPion.c);
	int pa = pionToInt(coupRepAdversaire.pion.typePion);
	int ca = coupRepAdversaire.propCoup;
	
	printf("[%d,%d,%d,%d]\n", xa, ya, pa, ca);
	err = sendIA(xa, sockIA);
  if (err == -1) {
  	return -1;
  }
  err = sendIA(ya, sockIA);
  if (err == -1) {
  	return -1;
  }
  err = sendIA(pa, sockIA);
  if (err == -1) {
  	return -1;
  }
  err = sendIA(ca, sockIA);
  if (err == -1) {
  	return -1;
  }
  
	return end;
}

/**
 * Function that plays the player if he plays second
 * @param int sock the socket to connect with the game server
 * @param int i the number of move
 * @param int err a code of error
 * @param TPartieReq gameRequest the request of the game
 * @param TPartieRep gameResponse the response of the game request
 */
int playSecond(int sock, int sockIA, int i,  int err, TPartieReq gameRequest, TPartieRep gameResponse) {
	
	int end = 0; 												// If the game is ended
  int x; 															// Coordinate in line choose
  int y; 															// Coordinate in column choose
  int p; 															// Pawn choose 
  int c; 															// If the move is winner, looser...
	TCoupReq coupRepAdversaire;					// Opponent request
	TCoupReq coupReq;										// Us request
	TCoupRep coupResponse;							// Us response
	TCoupRep coupResponseAdversaire;		// Opponent response
	
	printf("-----------------------------------------------------------------------------\n");
	printf("\n\nplaySecond Iteration %d\n", i);
	
	err = 0;
	err = recv(sock, &coupResponseAdversaire, sizeof(TCoupRep),0);
	printError(err, "(player) recv error with the opponent move response\n", sock);
	
	end = responseAdversaireError(coupResponseAdversaire.err);
	if (end != 0) {
		err = sendIA(end, sockIA);
		if (err == -1) {
			return -1;
		}
		err = 0;
		scorePlayer(end);
		return end;
	}
	end = responseAdversaireValidCoup(coupResponseAdversaire.validCoup, gameResponse.nomAdvers);
	if (end != 0) {
		err = sendIA(end, sockIA);
		if (err == -1) {
			return -1;
		}
		err = 0;
		scorePlayer(end);
		return end;
	}
	end = responseAdversairePropCoup(coupResponseAdversaire.propCoup, gameResponse.nomAdvers);
	if (end != 0) {
		err = sendIA(end, sockIA);
		if (err == -1) {
			return -1;
		}
		err = 0;
		scorePlayer(end);
		return end;
	}
	
	err = sendIA(end, sockIA);
	if (err == -1) {
		return -1;
	}
	err = 0;
	
	err = 0;
	err = recv(sock, &coupRepAdversaire, sizeof(TCoupReq),0);
	printError(err, "(player) recv error with the opponent move\n", sock);
	
	int xa = ligneToInt(coupRepAdversaire.posPion.l);
	int ya = colonneToInt(coupRepAdversaire.posPion.c);
	int pa = pionToInt(coupRepAdversaire.pion.typePion);
	int ca = coupRepAdversaire.propCoup;
	
	printf("[%d,%d,%d,%d]\n", xa, ya, pa, ca);
	
	err = sendIA(xa, sockIA);
  if (err == -1) {
  	return -1;
  }
  err = sendIA(ya, sockIA);
  if (err == -1) {
  	return -1;
  }
  err = sendIA(pa, sockIA);
  if (err == -1) {
  	return -1;
  }
  err = sendIA(ca, sockIA);
  if (err == -1) {
  	return -1;
  }
  
  x = recvIA(sockIA);
  if (x == -1) {
  	return -1;
  }
	y = recvIA(sockIA);
  if (y == -1) {
  	return -1;
  }
  p = recvIA(sockIA);
  if (p == -1) {
  	return -1;
  }
  c = recvIA(sockIA);
  if (c == -1) {
  	return -1;
  }
  
	printf("IA Result : [%d,%d,%d,%d]\n", x, y, p, c);
	
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
		scoreOpponent(end);
		err = sendIA(end, sockIA);
		if (err == -1) {
			return -1;
		}
		err = 0;
		return end;
	}
	end = responseValidCoup(coupResponse.validCoup, gameRequest.nomJoueur);
	if (end != 0) {
		scoreOpponent(end);
		err = sendIA(end, sockIA);
		if (err == -1) {
			return -1;
		}
		err = 0;
		return end;
	}
	end = responseContinuerAJouer(coupResponse.propCoup, gameRequest.nomJoueur);
	if (end != 0) {
		scoreOpponent(end);
		err = sendIA(end, sockIA);
		if (err == -1) {
			return -1;
		}
		err = 0;
		return end;
	}
	return end;
}

/**
 * Main fonction
 */
int main (int argc, char** argv) {

    if (argc != 6) {
        printHelp(argv[0]);
        return -1;
    }

    char* ipServeur = argv[1];			// The ip of the distant server
    char* playerName = argv[3];			// The name of the player
    char* color = argv[4];					// The color choose by the player
    int port = atoi(argv[2]);				// The port of the distant server
    int sock;												// The socket to connect the distant server
    int err;												// The error code for future fonction
    int portIA = atoi(argv[5]);			// The port of the IA
    int i = 0;											// The number of loop
		int end = 0;										// If the game is ended
    TPartieReq gameRequest;					// Request to create a game
    TPartieRep gameResponse;				// Response of the request 'create a game'

		int sockIA  = connectionIA(portIA); // Connexion a l'IA

    if(!strcmp(color,"W")) {
        gameRequest.coulPion = BLANC;
    } else if(!strcmp(color,"B")) {
        gameRequest.coulPion = NOIR;
    } else {
        printHelp(argv[0]);
        return -2;
    }
    
    
    sock = socketClient(ipServeur, port);
    printError(sock, "(player) error during the creation of the socketClient\n", sock);
    
    gameRequest.idReq = PARTIE;
    strcpy(gameRequest.nomJoueur, playerName);

		printf("-----------------------------------------------------------------------------\n");
		printf("Welcome to Quantik !\n");


    err = send(sock, &gameRequest, sizeof(TPartieReq),0);
    printError(err, "(player) send error with the initialize game request\n", sock);

    printf("Waiting for player...\n");
    err = recv(sock, &gameResponse, sizeof(TPartieRep),0);
    printError(err, "(player) recv error with the initialize game response\n", sock);

		initializeGameResponse(gameResponse.err, gameResponse.nomAdvers);
		gameRequest.coulPion = initializeColor(gameResponse.validCoulPion, gameRequest.coulPion);
		
    printf("The first game is starded :\n");
    int startIA = -1;
    if (gameRequest.coulPion == NOIR) {
    	startIA = 1;
    } else {
    	startIA = 0;
    }
    
    // Send into java who's start
    err = sendIA(startIA, sockIA);
    if (err == -1) {
    	return -1;
    }
		
		do {
			i++;
			if (gameRequest.coulPion == BLANC) {
				end = playFirst(sock, sockIA, i, err, gameRequest, gameResponse);
				if (end != 0) {
					break;
				}
			}
			if (gameRequest.coulPion == NOIR) {
				end = playSecond(sock, sockIA, i, err, gameRequest, gameResponse);
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
		
		end = 0;	//Initialize again to zero to the second game
		i = 0;		//Initialize again the number of iteration to the second game

		do {
			i++;
			if (gameRequest.coulPion == BLANC) {
				end = playSecond(sock, sockIA, i, err, gameRequest, gameResponse);
				if (end != 0) {
					break;
				}
			}
			if (gameRequest.coulPion == NOIR) {
				end = playFirst(sock, sockIA, i, err, gameRequest, gameResponse);
				if (end != 0) {
					break;
				}
			}
		} while (end != 1);

		printf("\n-----------------------------------------------------------------------------\n");
		printf("The second game is ended\n");
		printf("-Player %s : won match : %d / drew match : %d / lost match : %d\n",
			 gameRequest.nomJoueur, wonMatch, drawMatch, lostMatch);
		printf("-Player %s : won match : %d / drew match : %d / lost match : %d\n",
			 gameResponse.nomAdvers, wonMatchOpponent, drawMatchOpponent, lostMatchOpponent);
		printf("See you !\n");		

    shutdown(sock, SHUT_RDWR); close(sock);
    shutdown(sockIA, SHUT_RDWR); close(sockIA);
    return 0;
}



