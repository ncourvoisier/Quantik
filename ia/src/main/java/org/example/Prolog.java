package org.example;

import org.jpl7.Atom;
import org.jpl7.Query;
import org.jpl7.Term;
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
        String file = ClassLoader.getSystemResource("ia.pl").getPath();
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
    public int[] jouerCoupRandom(Grille g) {

        int[] coup = {2,0,3};
        String cpStr = "[2,0,3]";

        Query q1 = consult();
        String strq = "jouerCoupRandomSurCaseVide(["+cpStr+"],L,C,P).";
        q1 = new Query(strq);

        java.util.Map<String,Term> solution;
        solution = q1.oneSolution();
        System.out.println( "L = " + solution.get("L"));
        System.out.println( "C = " + solution.get("C"));
        System.out.println( "P = " + solution.get("P"));


        int[] res = new int[3];
        res[0] = solution.get("L").intValue();
        res[1] = solution.get("C").intValue();
        res[2] = solution.get("P").intValue();

        return res;
    }




    public static void main( String[] args ) {

        Prolog p = new Prolog();

        Grille g = new Grille();
        g.addPawnInGrille(2,0,3);

        p.jouerCoupRandom(g);

        System.out.println("S : " + p.random());
    }
}
