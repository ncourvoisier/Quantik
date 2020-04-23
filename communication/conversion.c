#include "conversion.h"

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
