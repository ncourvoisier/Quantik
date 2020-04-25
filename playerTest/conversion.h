#ifndef _CONVERTLIB_H
#define _CONVERTLIB_H

#include "protocolQuantik.h"

/**
 * Transform type TLg (ligne) to int
 * @param TLg l ligne to transform
 * @return int the number of the line (0, 1, 2, 3)
 */
int ligneToInt(TLg l);

/**
 * Transform type TCol (column) to int
 * @param TCol c column to transform
 * @return int the number of the column (0, 1, 2, 3)
 */
int colonneToInt(TCol c);

/**
 * Transform type TTypePion (pion) to int
 * @param TTypePion p pion to transform
 * @return int the number of the pion (0, 1, 2, 3)
 */
int pionToInt(TTypePion p);

/**
 * Transform int to type TLg (ligne)
 * @param int x int to transform
 * @return TLg the line (1, 2, 3, 4)
 */
TLg intToLigne(int x);

/**
 * Transform int to type TCol (column)
 * @param int y int to transform
 * @return TCol the column (A, B, C, D)
 */
TCol intToColonne(int y);

/**
 * Transform type int to type TTypePion
 * @param int p pion to transform
 * @return TTypePion the pion (CYLINDRE, PAVE, SPHERE, TETRAEDRE)
 */
TTypePion intToPion(int p);

/**
 * Transform type int to type TPropCoup
 * @param int c 
 * @return TPropCoup (CONT, GAGNE, NUL, PERDU)
 */
TPropCoup intToProprieteCoup(int c);

/**
 * Transform two coordonate to type TCase
 * @param int x line coordonate
 * @param int y column coordonate
 * @return TCase the case of coordonate x and y
 */
TCase positionToTCase(int x, int y);

/**
 * Tranform pion and color to type TPion
 * @param int p the pion
 * @param TCoul couleurPion color of pion
 * @return TPion
 */
TPion pionToTPion(int p, TCoul couleurPion);

/**
 * transform a few variable to TCoupReq
 * @param TIdReq idRequest id game
 * @param int numPartie the identifiant of the game
 * @param bool estBloque if the player can play
 * @param TPion pion pawn played
 * @param TCase positionPion the position of the pawn played
 * @param TPropCoup
 * @return the structure TCoupReq
 */
TCoupReq requeteCoup(TIdReq idRequest, int numPartie, bool estBloque, TPion pion, TCase positionPion, TPropCoup propCoup);

#endif



