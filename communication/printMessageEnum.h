#ifndef _PRINTLIB_H
#define _PRINTLIB_H

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "protocolQuantik.h"


int responseError(TCodeRep err);
int responseValidCoup(TValCoup validCoup, char* name);
int responseContinuerAJouer(TPropCoup coup, char* name);
int responseAdversaireError(TCodeRep err);
int responseAdversaireValidCoup(TValCoup validCoup, char* name);
int responseAdversairePropCoup(TPropCoup coup, char* name);

#endif
