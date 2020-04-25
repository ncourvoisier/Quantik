package org.example;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertFalse;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

/**
 * Unit test for grille class
 */
public class GrilleTest {

    Grille g = new Grille();

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
