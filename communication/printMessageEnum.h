#ifndef _PRINTLIB_H
#define _PRINTLIB_H

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "protocolQuantik.h"


/**
 * Print a message according to the error code in parameter
 * @param TCodeRep err the code error to print
 * @return a return code
 */
int responseError(TCodeRep err);

/**
 * Print a message according to the validity of the move in parameter
 * @param TValCoup validCoup is the move of the player is valid
 * @param char* name the name of the player
 * @return a return code
 */
int responseValidCoup(TValCoup validCoup, char* name);

/**
 * Print a message according to the propriety of move in parameter
 * @param TPropCoup coup the propriety of the move
 * @param char* name the name of the player
 * @return a return code
 */
int responseContinuerAJouer(TPropCoup coup, char* name);

/**
 * Print a message according to the error code in parameter of the opponent player
 * @param TCodeRep err the code error to print
 * @return a return code
 */
int responseAdversaireError(TCodeRep err);

/**
 * Print a message according to the validity of the move in parameter of the oppponent player
 * @param TValCoup validCoup is the move of the player is valid
 * @param char* name the name of the opponent player
 * @return a return code
 */
int responseAdversaireValidCoup(TValCoup validCoup, char* name);

/**
 * Print a message according to the propriety of move in parameter of the opponent player
 * @param TPropCoup coup the propriety of the move
 * @param char* name the name of the opponent player
 * @return a return code
 */
int responseAdversairePropCoup(TPropCoup coup, char* name);

#endif
