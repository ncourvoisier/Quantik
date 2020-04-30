package org.example;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertEquals;


import org.junit.Assert;
import org.junit.Before;
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
        assertEquals('C', g.intToPion(0));
        assertEquals('P', g.intToPion(1));
        assertEquals('S', g.intToPion(2));
        assertEquals('T', g.intToPion(3));
        assertEquals('Z', g.intToPion(4));
    }

    @Test
    public void testCaseIsFree() {
        assertTrue(g.caseIsFree(0,0));
        g.addPawnInGrille(0,0,1);
        assertFalse(g.caseIsFree(0,0));
    }

    @Test
    public void testReInitGrille() {
        assertEquals("[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]", g.toString());
        g.addPawnInGrille(0,0,1);
        g.addPawnInGrille(1,1,2);
        g.addPawnInGrille(2,3,3);
        assertEquals("[[1,0,0,0],[0,2,0,0],[0,0,0,3],[0,0,0,0]]", g.toString());
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
        g.addPawnInGrille(0,0,0);
        g.addPawnInGrille(0,1,1);
        g.addPawnInGrille(0,2,2);
        g.addPawnInGrille(0,3,3);
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalFalse() {
        g.addPawnInGrille(0,0,0);
        g.addPawnInGrille(0,1,1);
        g.addPawnInGrille(0,2,2);
        g.addPawnInGrille(0,3,2);
        assertFalse(g.isFinalMove());
    }

    @Test
    public void moveFinalColumn1() {
        g.addPawnInGrille(0,0,0);
        g.addPawnInGrille(1,0,1);
        g.addPawnInGrille(2,0,2);
        g.addPawnInGrille(3,0,3);
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalColumn2() {
        g.addPawnInGrille(0,0,0);
        g.addPawnInGrille(3,0,1);
        g.addPawnInGrille(2,0,2);
        g.addPawnInGrille(1,0,3);
        assertTrue(g.isFinalMove());
    }


    @Test
    public void moveFinalFalseColumn() {
        g.addPawnInGrille(0,0,0);
        g.addPawnInGrille(2,0,1);
        g.addPawnInGrille(2,0,2);
        g.addPawnInGrille(3,0,3);
        assertFalse(g.isFinalMove());
    }

    @Test
    public void moveFinalSquare1() {
        g.addPawnInGrille(0,0,0);
        g.addPawnInGrille(0,1,1);
        g.addPawnInGrille(1,0,2);
        g.addPawnInGrille(1,1,3);
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalSquare2() {
        g.addPawnInGrille(0,2,0);
        g.addPawnInGrille(0,3,1);
        g.addPawnInGrille(1,2,2);
        g.addPawnInGrille(1,3,3);
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalSquare3() {
        g.addPawnInGrille(2,0,0);
        g.addPawnInGrille(2,1,1);
        g.addPawnInGrille(3,0,2);
        g.addPawnInGrille(3,1,3);
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalSquare4() {
        g.addPawnInGrille(2,2,0);
        g.addPawnInGrille(2,3,1);
        g.addPawnInGrille(3,2,2);
        g.addPawnInGrille(3,3,3);
        assertTrue(g.isFinalMove());
    }



}
