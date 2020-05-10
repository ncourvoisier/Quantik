package org.example;

import org.jpl7.Query;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.net.Socket;


/**
 * The class EngineIA make a connection with the player (file player.c)
 * This class receive and send the move realize by the player
 */
public class EngineIA {

    /**
     * Return the opponent color
     *
     * @param couleur color of current player
     * @return the opponent color
     */
    public static int opponentCouleur(int couleur) {
        if (couleur == 1) {
            return 0;
        }
        if (couleur == 0) {
            return 1;
        }
        return -1;
    }

    /**
     * Transform an int in pawn
     *
     * @param p : the pawn to transform
     * @param couleur : if the player is black or white
     * @return the spawn returned
     */
    public static String intToStringPawn(int p, int couleur) {
        if (couleur == 1) { // noir
            switch(p) {
                case 0 : return "cn";
                case 1 : return "pn";
                case 2 : return "sn";
                case 3 : return "tn";
                default: return "";
            }
        } else { // blanc
            switch(p) {
                case 0 : return "cb";
                case 1 : return "pb";
                case 2 : return "sb";
                case 3 : return "tb";
                default: return "";
            }
        }
    }

    public static int stringToIntPawn(String p) {
        switch(p) {
            case "c" : return 0;
            case "p" : return 1;
            case "s" : return 2;
            case "t" : return 3;
            default: return -1;
        }
    }

    /**
     * This function realize a communication with player when he plays in second
     *
     * @param g the Quantik grid
     * @param i the number iteration
     * @param DIS the DataInputStream to receive move of the opponent player
     * @param DOS the DataOutputStream to send move of the opponent player
     * @return an error message if he are an error or 0 if all is normal
     * @throws Exception the exception to catch error with recv and send function
     */
    public static int playSecond(Grille g, int i, DataInputStream DIS, DataOutputStream DOS, int couleur) throws Exception {
        int xSend;
        int ySend;
        int pSend;
        int cSend;
        int xRecv;
        int yRecv;
        int pRecv;
        int cRecv;
        int continuerPartie = 0;
        int colorOpponent = opponentCouleur(couleur);

        System.out.println("-------------------------------------------------------------");
        System.out.println("\n\nPlaySecond Iteration " + i);

        g.printGrille();

        continuerPartie = DIS.readInt();
        if (continuerPartie != 0) {
            return -1;
        }

        xRecv = DIS.readInt();
        yRecv = DIS.readInt();
        pRecv = DIS.readInt();
        cRecv = DIS.readInt();
        if (cRecv != 0) {
            return -1;
        }

        g.addPawnInGrille(xRecv, yRecv, intToStringPawn(pRecv, colorOpponent));

        System.out.println("The opponent played :");
        g.printGrille();

        xSend = 0;
        ySend = 0;
        pSend = 0;
        cSend = 0;

        Prolog p = new Prolog();
        try {
            int[] r = p.jouerCoupHeuristique(g);
            System.out.println(r[0]);
            System.out.println(r[1]);
            System.out.println(r[2]);
            xSend = r[0];
            ySend = r[1];
            pSend = r[2];
            g.addPawnInGrille(xSend, ySend, intToStringPawn(pSend, couleur));
            if (g.isFinalMove()) {
                cSend = 1;
            }
        } catch (NullPointerException e) {
            cSend = 2;
        }

        DOS.writeInt(xSend); //Envoie de xSend
        DOS.writeInt(ySend); //Envoie de ySend
        DOS.writeInt(pSend); //Envoie de pSend
        DOS.writeInt(cSend); //Envoie de cSend

        System.out.println("The grid after your move :");
        g.printGrille();

        return 0;
    }

    /**
     * This function realize a communication with player when he plays in second
     *
     * @param g the Quantik grid
     * @param i the number iteration
     * @param DIS the DataInputStream to receive move of the opponent player
     * @param DOS the DataOutputStream to send move of the opponent player
     * @return an error message if he are an error or 0 if all is normal
     * @throws Exception the exception to catch error with recv and send function
     */
    public static int playFirst(Grille g, int i, DataInputStream DIS, DataOutputStream DOS, int couleur) throws Exception {
        int xSend;
        int ySend;
        int pSend;
        int cSend;
        int xRecv;
        int yRecv;
        int pRecv;
        int cRecv;
        int continuerPartie = 0;
        int colorOpponent = opponentCouleur(couleur);

        System.out.println("-------------------------------------------------------------");
        System.out.println("\n\nPlayFirst Iteration " + i);

        g.printGrille();

        xSend = 0;
        ySend = 0;
        pSend = 0;
        cSend = 0;

        Prolog p = new Prolog();
        try {
            int[] r = p.jouerCoupHeuristique(g);
            System.out.println(r[0]);
            System.out.println(r[1]);
            System.out.println(r[2]);
            xSend = r[0];
            ySend = r[1];
            pSend = r[2];
            g.addPawnInGrille(xSend, ySend, intToStringPawn(pSend, couleur));
            if (g.isFinalMove()) {
                cSend = 1;
            }
        } catch (NullPointerException e) {
            cSend = 2;
        }

        System.out.println("COUP " + cSend);

        DOS.writeInt(xSend); //Envoie de xSend
        DOS.writeInt(ySend); //Envoie de y
        DOS.writeInt(pSend); //Envoie de p
        DOS.writeInt(cSend); //Envoie de c

        System.out.println("The grid after your move :");
        g.printGrille();

        continuerPartie = DIS.readInt();
        if (continuerPartie != 0) {
            return -1;
        }

        xRecv = DIS.readInt();
        yRecv = DIS.readInt();
        pRecv = DIS.readInt();
        cRecv = DIS.readInt();
        if (cRecv != 0) {
            return -1;
        }

        g.addPawnInGrille(xRecv, yRecv, intToStringPawn(pRecv, colorOpponent));

        System.out.println("The opponent played :");
        g.printGrille();
        return 0;
    }

    /**
     * Main function to communicate with the player and the prolog file
     * @param args the arguments array
     */
    public static void main (String[] args) {

        if (args.length != 2) {
            System.out.println("Usage : java -jar ia.jar addr port");
        }

        int port = Integer.parseInt(args[1]);
        String addr = args[0];

        Socket sock = null;

        try{
            sock = new Socket(addr,port);
            DataInputStream DIS = new DataInputStream(sock.getInputStream());
            DataOutputStream DOS = new DataOutputStream(sock.getOutputStream());

            int playFirst = DIS.readInt();
            Grille g = new Grille(playFirst);
            g.printGrille();

            int end = 0;
            int i = 0;

            do {
                i++;
                if (playFirst == 0) {
                    end = playFirst(g, i , DIS, DOS, playFirst);
                    if (end != 0) {
                        break;
                    }
                }
                if (playFirst != 0) {
                    end = playSecond(g, i, DIS, DOS, playFirst);
                    if (end != 0) {
                        break;
                    }
                }
            } while (end != 1) ;

            System.out.println("FIN DE LA PREMIERE PARTIE\nDebut de la revanche :\n");
            end = 0;
            i = 0;
            g.reInitGrille();

            do {
                i++;
                if (playFirst == 0) {
                    end = playSecond(g, i, DIS, DOS, playFirst);
                    if (end != 0) {
                        break;
                    }
                }
                if (playFirst != 0) {
                    end = playFirst(g, i , DIS, DOS, playFirst);
                    if (end != 0) {
                        break;
                    }
                }
            } while (end != 1);

            DIS.close();
            DOS.close();
            sock.close();
        } catch (Exception e) {
            e.printStackTrace();
        }finally{
            try {
                if (sock != null) {
                    sock.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
