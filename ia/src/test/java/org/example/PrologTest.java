package org.example;

import static org.junit.Assert.assertTrue;

import org.jpl7.Atom;
import org.jpl7.Query;
import org.jpl7.Term;
import org.jpl7.Variable;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

/**
 * Unit test for simple App.
 */
public class PrologTest
{
    /**
     * Rigorous Test :-)
     */
    @Test
    public void shouldAnswerWithTrue()
    {
        assertTrue( true );
    }
    String file = ClassLoader.getSystemResource("habite.pl").getPath();
    Query q1;

    @Before
    public void setup(){
        System.out.println(file.toString());
        q1 = new Query("consult", new Term[] {new Atom(file)});
    }

    @Test
    public void test1() {
        System.out.println("consult " + (q1.hasSolution() ? "succeeded" : "failed"));
        Assert.assertEquals(1,1);
        q1.close();
    }

    @Test
    public void test2(){
        q1 =
                new Query(
                        "habite",
                        new Term[] {new Atom("fabien"),new Atom("belfort")}
                );
        System.out.println(
                "habite(fabien,belfort) is " +
                        ( q1.hasSolution() ? "provable" : "not provable" )
        );
        q1.close();
    }

    @Test
    public void test3(){
        Variable X = new Variable("X");
        q1 =
                new Query(
                        "habite",
                        new Term[] {X,new Atom("vesoul")}
                );

        java.util.Map<String,Term> solution;
        solution = q1.oneSolution();
        System.out.println( "first solution of habite(X, vesoul)");
        System.out.println( "X = " + solution.get("X"));
        q1.close();
    }

    @Test
    public void test4(){
        Variable X = new Variable("X");
        q1 =
                new Query(
                        "habite",
                        new Term[] {X,new Atom("vesoul")}
                );
        java.util.Map<String,Term>[] solutions = q1.allSolutions();
        for ( int i=0 ; i < solutions.length ; i++ ) {
            System.out.println( "X = " + solutions[i].get("X"));
        }
        q1.close();
    }

    @Test
    public void test5() {
        java.util.Map <String,Term> solution;
        Variable Y = new Variable("ville");
        Variable X = new Variable("X");
        q1 =
                new Query(
                        "habite",
                        new Term[]{X, Y}
                );

        while (q1.hasMoreSolutions()) {
            solution = q1.nextSolution();
            System.out.println("X = " + solution.get("X") + ", Ville = " + solution.get("ville"));
        }
        q1.close();
    }
}
