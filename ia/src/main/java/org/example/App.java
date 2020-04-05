package org.example;

import org.jpl7.Atom;
import org.jpl7.Query;
import org.jpl7.Term;
import org.jpl7.Variable;

/**
 * Hello world!
 *
 */
public class App 
{
    public static void main( String[] args ) {


        //String file = ClassLoader.getSystemResource("ia.pl").getPath();
        String file = ClassLoader.getSystemResource("ia.pl").getPath();
        Query q1 = new Query("consult", new Term[] {new Atom(file)});

        System.out.println("Consult prolog file : " + (q1.hasSolution() ? "succeeded" : "failed")); //Si le fichier a pu etre lu

        String strq = "random(0,4,S)"; //REQUETE vers le fichier ia: ici un int random entre 0 et 4

        q1 = new Query(strq);

        java.util.Map<String,Term> solution;
        solution = q1.oneSolution();
        System.out.println("random is " + ( q1.hasSolution() ? "provable" : "not provable")); //Si la solution est possible
        System.out.println( "S = " + solution.get("S")); //Le resultat

    }
}
