#include "printMessageEnum.h"





int responseError(TCodeRep err) {
	switch(err) {
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
	return 0;
}

int responseValidCoup(TValCoup validCoup, char* name) {
	switch(validCoup) {
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
	return 0;
}

int responseContinuerAJouer(TPropCoup coup, char* name) {
	switch(coup) {
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
	return 0;
}


int responseAdversaireError(TCodeRep err) {
	switch(err) {
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
	return 0;
}

int responseAdversaireValidCoup(TValCoup validCoup, char* name) {
	switch(validCoup) {
		case VALID : 
		    printf("The move of %s is valid\n", name);
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
	return 0;
}

int responseAdversairePropCoup(TPropCoup coup, char* name) {
	switch(coup) {
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
	return 0;
}

