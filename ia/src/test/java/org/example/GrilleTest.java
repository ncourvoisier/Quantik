package org.example;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertEquals;


import org.junit.Test;

/**
 * Unit test for grille class
 */
public class GrilleTest {

    Grille g = new Grille();

    @Test
    public void testInitStart() {
        assertEquals("[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]", g.toString());
        assertEquals("[c,c,p,p,s,s,t,t]", g.getPionRestantToString());
        g.printGrille();
    }

    @Test
    public void testIntToPion() {
        assertEquals('C', g.StringToPion("c"));
        assertEquals('P', g.StringToPion("p"));
        assertEquals('S', g.StringToPion("s"));
        assertEquals('T', g.StringToPion("t"));
        assertEquals('Z', g.StringToPion("0"));
    }

    @Test
    public void testCaseIsFree() {
        assertTrue(g.caseIsFree(0,0));
        g.addPawnInGrille(0,0,"c");
        assertFalse(g.caseIsFree(0,0));
    }

    @Test
    public void testReInitGrille() {
        assertEquals("[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]", g.toString());
        g.addPawnInGrille(0,0,"c");
        g.addPawnInGrille(1,1,"p");
        g.addPawnInGrille(2,3,"s");
        assertEquals("[[c,0,0,0],[0,p,0,0],[0,0,0,s],[0,0,0,0]]", g.toString());
        g.reInitGrille();
        assertEquals("[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]", g.toString());
    }

    @Test
    public void testGetPionRestant() {
        String[] pr = {"c","c","p","p","s","s","t","t"};
        String[] res = g.getPionRestant();
        for (int i = 0; i < 7; i++) {
            assertEquals(pr[i], res[i]);
        }
    }

    @Test
    public void testRemovePionJouer1() {
        assertEquals("[c,c,p,p,s,s,t,t]",g.getPionRestantToString());
        assertEquals(8,g.getPionRestant().length);
        g.removePionJouer("c");
        assertEquals("[c,p,p,s,s,t,t]",g.getPionRestantToString());
        assertEquals(7,g.getPionRestant().length);
        g.removePionJouer("c");
        assertEquals("[p,p,s,s,t,t]",g.getPionRestantToString());
        assertEquals(6,g.getPionRestant().length);

        g.removePionJouer("p");
        assertEquals("[p,s,s,t,t]",g.getPionRestantToString());
        assertEquals(5,g.getPionRestant().length);
        g.removePionJouer("p");
        assertEquals("[s,s,t,t]",g.getPionRestantToString());
        assertEquals(4,g.getPionRestant().length);

        g.removePionJouer("s");
        assertEquals("[s,t,t]",g.getPionRestantToString());
        assertEquals(3,g.getPionRestant().length);
        g.removePionJouer("s");
        assertEquals("[t,t]",g.getPionRestantToString());
        assertEquals(2,g.getPionRestant().length);

        g.removePionJouer("t");
        assertEquals("[t]",g.getPionRestantToString());
        assertEquals(1,g.getPionRestant().length);
        g.removePionJouer("t");
        assertEquals("[]",g.getPionRestantToString());
        assertEquals(1,g.getPionRestant().length);
    }

    @Test
    public void testRemovePionJouer2() {
        assertEquals("[c,c,p,p,s,s,t,t]", g.getPionRestantToString());
        assertEquals(8, g.getPionRestant().length);
        g.removePionJouer("c");
        assertEquals("[c,p,p,s,s,t,t]", g.getPionRestantToString());
        assertEquals(7, g.getPionRestant().length);
        g.removePionJouer("c");
        assertEquals("[p,p,s,s,t,t]", g.getPionRestantToString());
        assertEquals(6, g.getPionRestant().length);

        g.removePionJouer("c");
        assertEquals("[p,p,s,s,t,t]", g.getPionRestantToString());
        assertEquals(6, g.getPionRestant().length);

    }


    @Test
    public void moveFinalLine1() {
        g.addPawnInGrille(0,0,"c");
        g.addPawnInGrille(0,1,"p");
        g.addPawnInGrille(0,2,"s");
        g.addPawnInGrille(0,3,"t");
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalFalse() {
        g.addPawnInGrille(0,0,"c");
        g.addPawnInGrille(0,1,"p");
        g.addPawnInGrille(0,2,"s");
        g.addPawnInGrille(0,3,"s");
        assertFalse(g.isFinalMove());
    }

    @Test
    public void moveFinalColumn1() {
        g.addPawnInGrille(0,0,"c");
        g.addPawnInGrille(1,0,"p");
        g.addPawnInGrille(2,0,"s");
        g.addPawnInGrille(3,0,"t");
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalColumn2() {
        g.addPawnInGrille(0,0,"c");
        g.addPawnInGrille(3,0,"p");
        g.addPawnInGrille(2,0,"s");
        g.addPawnInGrille(1,0,"t");
        assertTrue(g.isFinalMove());
    }


    @Test
    public void moveFinalFalseColumn() {
        g.addPawnInGrille(0,0,"c");
        g.addPawnInGrille(2,0,"p");
        g.addPawnInGrille(2,0,"s");
        g.addPawnInGrille(3,0,"t");
        assertFalse(g.isFinalMove());
    }

    @Test
    public void moveFinalSquare1() {
        g.addPawnInGrille(0,0,"c");
        g.addPawnInGrille(0,1,"p");
        g.addPawnInGrille(1,0,"s");
        g.addPawnInGrille(1,1,"t");
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalSquare2() {
        g.addPawnInGrille(0,2,"c");
        g.addPawnInGrille(0,3,"p");
        g.addPawnInGrille(1,2,"s");
        g.addPawnInGrille(1,3,"t");
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalSquare3() {
        g.addPawnInGrille(2,0,"c");
        g.addPawnInGrille(2,1,"p");
        g.addPawnInGrille(3,0,"s");
        g.addPawnInGrille(3,1,"t");
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalSquare4() {
        g.addPawnInGrille(2,2,"c");
        g.addPawnInGrille(2,3,"p");
        g.addPawnInGrille(3,2,"s");
        g.addPawnInGrille(3,3,"t");
        assertTrue(g.isFinalMove());
    }



}
