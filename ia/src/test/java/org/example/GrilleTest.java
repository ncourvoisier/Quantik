package org.example;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertEquals;


import org.junit.Test;

/**
 * Unit test for grille class
 */
public class GrilleTest {

    Grille g = new Grille(0);

    @Test
    public void testInitStart() {
        assertEquals("[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]", g.toString());
        assertEquals("[cb,cb,pb,pb,sb,sb,tb,tb]", g.getPionRestantToString());
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
        String[] pr = {"cb","cb","pb","pb","sb","sb","tb","tb"};
        String[] res = g.getPionRestant();
        for (int i = 0; i < 7; i++) {
            assertEquals(pr[i], res[i]);
        }
    }

    @Test
    public void testRemovePionJouer1() {
        assertEquals("[cb,cb,pb,pb,sb,sb,tb,tb]",g.getPionRestantToString());
        assertEquals(8,g.getPionRestant().length);
        g.removePionJouer("cb");
        assertEquals("[cb,pb,pb,sb,sb,tb,tb]",g.getPionRestantToString());
        assertEquals(7,g.getPionRestant().length);
        g.removePionJouer("cb");
        assertEquals("[pb,pb,sb,sb,tb,tb]",g.getPionRestantToString());
        assertEquals(6,g.getPionRestant().length);

        g.removePionJouer("pb");
        assertEquals("[pb,sb,sb,tb,tb]",g.getPionRestantToString());
        assertEquals(5,g.getPionRestant().length);
        g.removePionJouer("pb");
        assertEquals("[sb,sb,tb,tb]",g.getPionRestantToString());
        assertEquals(4,g.getPionRestant().length);

        g.removePionJouer("sb");
        assertEquals("[sb,tb,tb]",g.getPionRestantToString());
        assertEquals(3,g.getPionRestant().length);
        g.removePionJouer("sb");
        assertEquals("[tb,tb]",g.getPionRestantToString());
        assertEquals(2,g.getPionRestant().length);

        g.removePionJouer("tb");
        assertEquals("[tb]",g.getPionRestantToString());
        assertEquals(1,g.getPionRestant().length);
        g.removePionJouer("tb");
        assertEquals("[]",g.getPionRestantToString());
        assertEquals(1,g.getPionRestant().length);
    }

    @Test
    public void testRemovePionJouer2() {
        assertEquals("[cb,cb,pb,pb,sb,sb,tb,tb]", g.getPionRestantToString());
        assertEquals(8, g.getPionRestant().length);
        g.removePionJouer("cb");
        assertEquals("[cb,pb,pb,sb,sb,tb,tb]", g.getPionRestantToString());
        assertEquals(7, g.getPionRestant().length);
        g.removePionJouer("cb");
        assertEquals("[pb,pb,sb,sb,tb,tb]", g.getPionRestantToString());
        assertEquals(6, g.getPionRestant().length);

        g.removePionJouer("cb");
        assertEquals("[pb,pb,sb,sb,tb,tb]", g.getPionRestantToString());
        assertEquals(6, g.getPionRestant().length);

    }


    @Test
    public void moveFinalLine1() {
        g.addPawnInGrille(0,0,"cn");
        g.addPawnInGrille(0,1,"pn");
        g.addPawnInGrille(0,2,"sb");
        g.addPawnInGrille(0,3,"tb");
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalFalse() {
        g.addPawnInGrille(0,0,"cn");
        g.addPawnInGrille(0,1,"pb");
        g.addPawnInGrille(0,2,"sn");
        g.addPawnInGrille(0,3,"sb");
        assertFalse(g.isFinalMove());
    }

    @Test
    public void moveFinalColumn1() {
        g.addPawnInGrille(0,0,"cn");
        g.addPawnInGrille(1,0,"pn");
        g.addPawnInGrille(2,0,"sb");
        g.addPawnInGrille(3,0,"tb");
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalColumn2() {
        g.addPawnInGrille(0,0,"cb");
        g.addPawnInGrille(3,0,"pn");
        g.addPawnInGrille(2,0,"sn");
        g.addPawnInGrille(1,0,"tb");
        assertTrue(g.isFinalMove());
    }


    @Test
    public void moveFinalFalseColumn() {
        g.addPawnInGrille(0,0,"cn");
        g.addPawnInGrille(2,0,"pn");
        g.addPawnInGrille(2,0,"sn");
        g.addPawnInGrille(3,0,"tn");
        assertFalse(g.isFinalMove());
    }

    @Test
    public void moveFinalSquare1() {
        g.addPawnInGrille(0,0,"cn");
        g.addPawnInGrille(0,1,"pn");
        g.addPawnInGrille(1,0,"sb");
        g.addPawnInGrille(1,1,"tb");
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalSquare2() {
        g.addPawnInGrille(0,2,"cb");
        g.addPawnInGrille(0,3,"pb");
        g.addPawnInGrille(1,2,"sn");
        g.addPawnInGrille(1,3,"tn");
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalSquare3() {
        g.addPawnInGrille(2,0,"cb");
        g.addPawnInGrille(2,1,"pb");
        g.addPawnInGrille(3,0,"sn");
        g.addPawnInGrille(3,1,"tb");
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalSquare4() {
        g.addPawnInGrille(2,2,"cb");
        g.addPawnInGrille(2,3,"pn");
        g.addPawnInGrille(3,2,"sb");
        g.addPawnInGrille(3,3,"tn");
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalSquare5() {
        g.addPawnInGrille(3,0,"cn");
        g.addPawnInGrille(3,1,"pb");
        g.addPawnInGrille(3,2,"sb");
        g.addPawnInGrille(3,3,"tn");
        assertTrue(g.isFinalMove());

        g.reInitGrille();
        g.addPawnInGrille(3,0,"sn");
        g.addPawnInGrille(3,1,"tb");
        g.addPawnInGrille(3,2,"pn");
        g.addPawnInGrille(3,3,"cn");
        assertTrue(g.isFinalMove());
    }

    @Test
    public void moveFinalSquare6() {
        g.addPawnInGrille(0,0,"cn");
        g.addPawnInGrille(1,1,"pn");
        g.addPawnInGrille(1,3,"sb");
        g.addPawnInGrille(3,0,"pb");
        g.addPawnInGrille(3,2,"sn");
        g.addPawnInGrille(3,3,"cb");
        g.addPawnInGrille(3,1,"tn");
        assertTrue(g.isFinalMove());
    }

}
