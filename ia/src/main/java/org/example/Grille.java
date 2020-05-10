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
    private String[][] grille;

    /**
     * The aviable pawn of the Quantik game
     */
    private String[] pionRestant;

    /**
     * The color during the game
     */
    private int color;

    /**
     * The constructor of the class
     */
    Grille (int color) {
        this.color = color;
        this.grille = new String[4][4];
        intitalizeGrille(this.grille);
        this.pionRestant = new String[8];
        initializePionRestant(this.pionRestant, this.color);
    }

    /**
     * This function initialize the aviable pawn for the Quantik game
     *
     * @param p the array to initialize
     */
    private void initializePionRestant(String[] p, int couleur) {
        if (couleur == 1) { // noir
            p[0] = "cn";
            p[1] = "cn";
            p[2] = "pn";
            p[3] = "pn";
            p[4] = "sn";
            p[5] = "sn";
            p[6] = "tn";
            p[7] = "tn";
        } else { // blanc
            p[0] = "cb";
            p[1] = "cb";
            p[2] = "pb";
            p[3] = "pb";
            p[4] = "sb";
            p[5] = "sb";
            p[6] = "tb";
            p[7] = "tb";
        }
    }

    /**
     * This function initialize again the grid after the first game
     */
    public void reInitGrille(){
        intitalizeGrille(this.grille);
        this.pionRestant = new String[8];
        initializePionRestant(this.pionRestant, this.color);
    }

    /**
     * This function return the available pawn
     *
     * @return the list of available pawn
     */
    public String[] getPionRestant() {
        return pionRestant;
    }

    /**
     * This function return the available pawn in String format
     *
     * @return the list of available pawn in String format
     */
    public String getPionRestantToString() {
        StringBuilder str = new StringBuilder("[");
        int nbPion = pionRestant.length;
        for (int i = 0; i < nbPion; i++) {
            str.append(pionRestant[i]);
            if (i != nbPion -1) {
                str.append(",");
            }
        }
        str.append("]");
        return str.toString();
    }

    /**
     * This function remove a pawn in the available list pawn
     *
     * @param pawn the pawn removed
     */
    public void removePionJouer(String pawn) {
        if (pionRestant.length == 1) {
            pionRestant[0] = "";
            return;
        }
        int nbPion = pionRestant.length;
        boolean trouve = false;
        for (int i = 0; i < nbPion; i++) {
            if (pionRestant[i].equals(pawn)) {
                pionRestant[i] = "";
                nbPion--;
                trouve = true;
                break;
            }
        }
        if(!trouve) {
            return;
        }
        String[] tmp = new String[nbPion];
        for (int i = 0,j = 0; i < nbPion+1; i++,j++) {
            if (pionRestant[i].equals("")) {
                pionRestant[i] = "";
                i++;
            }
            if (i > nbPion) {
                break;
            }
            tmp[j] = pionRestant[i];
        }
        pionRestant = tmp;
    }

    /**
     * Function who initialize a Quantik grid with a default value
     *
     * @param grille the grid to initialize
     */
    private void intitalizeGrille(String[][] grille) {
        int nbColonne = grille.length;
        int nbLigne = grille[0].length;
        for (int i = 0; i < nbLigne; i++) {
            for (int j = 0; j < nbColonne; j++) {
                grille[i][j] = "0";
            }
        }
    }

    /**
     * Function who transform a string to a pawn value
     *
     * @param p the int to convert
     * @return the pawn converted
     */
    public char StringToPion(String p) {
        switch (p) {
            case "c":
                return 'C';
            case "p":
                return 'P';
            case "s":
                return 'S';
            case "t":
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
                System.out.print("" + StringToPion(grille[i][j]));
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
        if (grille[x][y] != "0") {
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
    public void addPawnInGrille(int x, int y, String p) {
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
        StringBuilder str = new StringBuilder("[");
        for (int i = 0; i < nbLigne; i++) {
            str.append("[");
            for (int j = 0; j < nbColonne; j++) {
                str.append(grille[i][j]);
                if  (j != 3) {
                    str.append(",");
                }
            }
            str.append("]");
            if (i != 3) {
                str.append(",");
            }
        }
        str.append("]");
        return str.toString();
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
                if(grille[i][j] != "0") {
                    gagne++;
                }
                if(grille[i][j] == "c") {
                    C = true;
                }
                if(grille[i][j] == "p") {
                    P = true;
                }
                if(grille[i][j] == "s") {
                    S = true;
                }
                if(grille[i][j] == "t") {
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
                //System.out.println(grille[i][j] +"  ");
                if(!grille[i][j].equals("0")) {
                    gagne++;
                }
                if(grille[i][j].equals("c")) {
                    C = true;
                }
                if(grille[i][j].equals("p")) {
                    P = true;
                }
                if(grille[i][j].equals("s")) {
                    S = true;
                }
                if(grille[i][j].equals("t")) {
                    T = true;
                }
            }

            if (gagne == 4 && C && P && S && T ) {
                return true;
            }
            gagne = 0;
            C = false;
            P = false;
            S = false;
            T = false;
        }

        gagne = 0;
        // Check if one line is final
        for (int i = 0; i < nbLigne; i++) {
            for (int j = 0; j < nbColonne; j++) {
                if(grille[j][i] != "0") {
                    gagne++;
                }
                if(grille[j][i] == "c") {
                    C = true;
                }
                if(grille[j][i] == "p") {
                    P = true;
                }
                if(grille[j][i] == "s") {
                    S = true;
                }
                if(grille[j][i] == "t") {
                    T = true;
                }
            }
            if (gagne == 4 && C && P && S && T ) {
                return true;
            }
            gagne = 0;
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