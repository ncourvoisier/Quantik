#include "printMessageEnum.h"



int responseError(TCodeRep err) {
	switch(err) {
		case ERR_OK :
	      break;
	  case ERR_PARTIE :
	      printf("Couldn't log into the game, invalid move\n");
	      return 1;
	      break;
	  case ERR_TYP :
	      printf("Couldn't log into the game, move\n");
	      return 1;
	      break;
	  default :
	      printf("default\n");
	}
	return 0;
}

int responseValidCoup(TValCoup validCoup, char* name) {
	switch(validCoup) {
		case VALID : 
	      printf("%s, your move is valid\n", name);
	      break;
	  case TIMEOUT :
	      printf("%s, your move isn't valid, you are over time to play.\n", name);
	      return 1;
	      break;
	  case TRICHE :
	      printf("%s, your move isn't valid, CHEATER\n", name);
	      return 1;
	      break;
	  default :
	      printf("default\n");
	}
	return 0;
}

int responseContinuerAJouer(TPropCoup coup, char* name) {
	switch(coup) {
		case CONT :
			printf("We continue the game\n");
			break;
		case GAGNE :
			printf("%s, you won !\n", name);
			return 1;
			break;
		case NUL :
			printf("%s, you drew\n", name);
			return 2;
			break;
		case PERDU :
			printf("%s, you lost !\n", name);
			return 3;
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
		    return 1;
		    break;
		case ERR_TYP :
		    printf("Couldn't log into the game, move\n");
		    return 1;
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
		    printf("%s took too long to play\n", name);
		    return 1;
		    break;
		case TRICHE :
		    printf("%s cheated\n", name);
		    return 1;
		    break;
		default :
		    printf("default\n");
	}
	return 0;
}

int responseAdversairePropCoup(TPropCoup coup, char* name) {
	switch(coup) {
		case CONT :
			printf("We continue the game\n");
			break;
		case GAGNE :
			printf("The opposing player, %s, won\n", name);
			return 1;
			break;
		case NUL :
			printf("You drew against %s\n", name);
			return 2;
			break;
		case PERDU :
			printf("The opposing player, %s, lost\n", name);
			return 3;
			break;
		default :
		 printf("default\n");
	}
	return 0;
}

