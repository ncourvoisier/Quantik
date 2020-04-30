package org.example;

/**
 * The class grille is a class to define a grid for the Quantik game
 * This class add pawn on the grid and save the position of all of
 * pawn during all the game to determinate the next move by the IA
 */
public class Grille {

    /**
     * The grid of the Quantik game
     */
    private int grille[][];

    /**
     * The aviable pawn of the Quantik game
     */
    private String pionRestant[];

    /**
     * The constructor of the class
     */
    Grille () {
        this.grille = new int[4][4];
        intitalizeGrille(this.grille);
        this.pionRestant = new String[8];
        initializePionRestant(this.pionRestant);
    }

    /**
     * This function initialize the aviable pawn for the Quantik game
     *
     * @param p the array to initialize
     */
    private void initializePionRestant(String[] p) {
        p[0] = "c";
        p[1] = "c";
        p[2] = "p";
        p[3] = "p";
        p[4] = "s";
        p[5] = "s";
        p[6] = "t";
        p[7] = "t";
    }

    /**
     * Function who initialize a Quantik grid with a default value
     *
     * @param grille the grid to initialize
     */
    private void intitalizeGrille(int[][] grille) {
        int nbColonne = grille.length;
        int nbLigne = grille[0].length;
        for (int i = 0; i < nbLigne; i++) {
            for (int j = 0; j < nbColonne; j++) {
                grille[i][j] = -1;
            }
        }
    }

    /**
     * Function who transform an int to a pawn value
     *
     * @param p the int to convert
     * @return the pawn converted
     */
    public char intToPion(int p) {
        switch (p) {
            case 0:
                return 'C';
            case 1:
                return 'P';
            case 2:
                return 'S';
            case 3:
                return 'T';
            default:
                return 'Z';
        }
    }

    /**
     * Function who print all the grid and the pawn position
     */
    public void printGrille() {
        int nbColonne = grille.length;
        int nbLigne = grille[0].length;
        for (int i = 0; i < nbLigne; i++) {
            for (int j = 0; j < nbColonne; j++) {
                System.out.print("" + intToPion(grille[i][j]));
                if (j != 3) {
                    System.out.print("|");
                }
            }
            if (i != 3) {
                System.out.println("\n--------------");
            }
        }
        System.out.println("\n");
    }

    /**
     * Function who determinate if one case is free in the grid
     *
     * @param x coordinate x in the grid
     * @param y coordinate y in the grid
     * @return the boolean response
     */
    public boolean caseIsFree(int x, int y) {
        if (grille[x][y] != -1) {
            return false;
        }
        return true;
    }

    /**
     * Function who add a pawn into the grid with coordinate position
     *
     * @param x coordinate x in the grid
     * @param y coordiante y in the grid
     * @param p the pawn played
     */
    public void addPawnInGrille(int x, int y, int p) {
        grille[x][y] = p;
    }

    /**
     * This function transform the grid in list of list String for the prolog file
     *
     * @return the String of list of list of the Quantik grid
     */
    public String toString() {
        int nbColonne = grille.length;
        int nbLigne = grille[0].length;
        String str = "[";
        for (int i = 0; i < nbLigne; i++) {
            str += "[";
            for (int j = 0; j < nbColonne; j++) {
                str += grille[i][j];
                if  (j != 3) {
                    str += ",";
                }
            }
            str += "]";
            if (i != 3) {
                str += ",";
            }
        }
        str += "]";
        return str;
    }

    /**
     * Function who check if one square of the grid is ended (all pawn in the square)
     *
     * @param xs the coordinate to start the check
     * @param ys the coordinate to start the check
     * @param xa the coordinate to finish the check
     * @param ya the coordinate to finish the check
     * @return the boolean response
     */
    public boolean isFinalMoveSquare(int xs, int ys, int xa, int ya) {
        int gagne = 0;
        boolean C = false;
        boolean P = false;
        boolean S = false;
        boolean T = false;
        for (int i = xs; i < xa; i++) {
            for (int j = ys; j < ya; j++) {
                if(grille[i][j] != -1) {
                    gagne++;
                }
                if(grille[i][j] == 0) {
                    C = true;
                }
                if(grille[i][j] == 1) {
                    P = true;
                }
                if(grille[i][j] == 2) {
                    S = true;
                }
                if(grille[i][j] == 3) {
                    T = true;
                }
            }
        }
        if (gagne == 4 && C && P && S && T ) {
            return true;
        }
        return false;
    }

    /**
     * Function who check if one line, one column or one square is ended
     *
     * @return the boolean response
     */
    public boolean isFinalMove() {
        int nbColonne = grille.length;
        int nbLigne = grille[0].length;
        int gagne = 0;
        boolean C = false;
        boolean P = false;
        boolean S = false;
        boolean T = false;

        // Check if one column is final
        for (int i = 0; i < nbLigne; i++) {
            for (int j = 0; j < nbColonne; j++) {
                if(grille[i][j] != -1) {
                    gagne++;
                }
                if(grille[i][j] == 0) {
                    C = true;
                }
                if(grille[i][j] == 1) {
                    P = true;
                }
                if(grille[i][j] == 2) {
                    S = true;
                }
                if(grille[i][j] == 3) {
                    T = true;
                }
            }
            if (gagne == 4 && C && P && S && T ) {
                return true;
            }
            C = false;
            P = false;
            S = false;
            T = false;
        }

        gagne = 0;
        // Check if one line is final
        for (int i = 0; i < nbLigne; i++) {
            for (int j = 0; j < nbColonne; j++) {
                if(grille[j][i] != -1) {
                    gagne++;
                }
                if(grille[j][i] == 0) {
                    C = true;
                }
                if(grille[j][i] == 1) {
                    P = true;
                }
                if(grille[j][i] == 2) {
                    S = true;
                }
                if(grille[j][i] == 3) {
                    T = true;
                }
            }
            if (gagne == 4 && C && P && S && T ) {
                return true;
            }
            C = false;
            P = false;
            S = false;
            T = false;
        }

        if (isFinalMoveSquare(0,0,2,2)) {
            return true;
        }
        if (isFinalMoveSquare(2,2,4,4)) {
            return true;
        }
        if (isFinalMoveSquare(0,2,2,4)) {
            return true;
        }
        if (isFinalMoveSquare(2,0,4,2)) {
            return true;
        }
        return false;
    }

}
