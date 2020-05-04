package org.example;

import org.jpl7.Atom;
import org.jpl7.Query;
import org.jpl7.Term;
import org.jpl7.Util;
import org.jpl7.Variable;

/**
 * This class is the class who interact with artificial intelligence.
 * The class using prolog file in directory resources.
 */
public class Prolog {

    /**
     * The constructor of the class
     */
    Prolog() {

    }

    /**
     * This function realize the connection with the prolog file
     *
     * @return the query to make request to the prolog file
     */
    public Query consult() {
        String file = System.getProperty("user.dir") + "/ia.pl";
        System.out.println(file);
        Query q1 = new Query("consult", new Term[] {new Atom(file)});
        System.out.println("Consult prolog file : " + (q1.hasSolution() ? "succeeded" : "failed")); //Si le fichier a pu etre lu
        return q1;
    }

    /**
     * This function return a random integer in the interval 0 and 4
     *
     * @return the random integer
     */
    public int random() {
        Query q1 = consult();
        String strq = "random(0,4,S)";
        q1 = new Query(strq);

        java.util.Map<String,Term> solution;
        solution = q1.oneSolution();

        return solution.get("S").intValue();
    }

    /**
     * This function find the next move. She places a pawn in a random case in the grid and check if the case free
     *
     * @param g the Quantik grid with the move of the two players
     * @return the next move chose by the IA
     */
    public int[] jouerCoupRandomSurCaseVide(Grille g) {
        String cpStr =  g.toString();

        Query q1 = consult();
        String strq = "jouerCoupRandomSurCaseVide("+cpStr+",L,C,P).";
        q1 = new Query(strq);

        java.util.Map<String,Term> solution;
        solution = q1.oneSolution();

        int[] res = new int[3];
        res[0] = solution.get("L").intValue();
        res[1] = solution.get("C").intValue();
        res[2] = solution.get("P").intValue();

        return res;
    }

    /**
     * This function transform a pawn in an integer value
     *
     * @param pion the pawn to transform
     * @return the integer value
     */
    public int pionToInt(String pion) {
        switch (pion) {
            case "c" :
                return 0;
            case "p" :
                return 1;
            case "s" :
                return 2;
            case "t" :
                return 3;
            default :
                return -1;
        }
    }

    /**
     * This function make a request at the prolog file and return the next move
     *
     * @param g the Quantik grid
     * @return the next move
     */
    public int[] jouerCoup(Grille g) {
        Query q1 = consult();
        String strq = "jouerCoup("+ g.toString() +", L, C, P, "+ g.getPionRestantToString() +",NvPion).";
        q1 = new Query(strq);

        java.util.Map<String,Term> solution;
        solution = q1.oneSolution();
        g.removePionJouer(solution.get("P").toString());

        int[] res = new int[3];
        res[0] = solution.get("L").intValue();
        res[1] = solution.get("C").intValue();
        res[2] = pionToInt(solution.get("P").toString());
        return res;
    }

    /**
     * This function make a request at the prolog file and return the next move with the heuristique
     *
     * @param g the Quantik grid
     * @return the next move
     */
    public int[] jouerCoupHeuristique(Grille g) {
        Query q1 = consult();
        String str = "jouerCoupHeuristique(" + g.toString() + "," + g.getPionRestantToString() + ",L,C,P).";
        q1 = new Query(str);

        java.util.Map<String,Term> solution;
        solution = q1.oneSolution();

        System.out.println(str);

        int[] res = new int[3];
        try {
            res[0] = solution.get("L").intValue();
            res[1] = solution.get("C").intValue();
            res[2] = pionToInt(solution.get("P").toString());
            g.removePionJouer(solution.get("P").toString());
        } catch (Exception p) {
            res[0] = 0;
            res[1] = 0;
            res[2] = 0;
        }
        return res;
    }
}