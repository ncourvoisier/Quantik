package org.example;

import org.jpl7.Query;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.net.Socket;
import java.util.Scanner;

public class EngineIA {


    public static int playSecond(Grille g, int i, DataInputStream DIS, DataOutputStream DOS) throws Exception {
        Scanner sc = new Scanner(System.in);
        int xSend;
        int ySend;
        int pSend;
        int cSend;
        int xRecv;
        int yRecv;
        int pRecv;
        int cRecv;
        int continuerPartie = 0;

        System.out.println("-------------------------------------------------------------");
        System.out.println("\n\nPlaySecond Iteration " + i);

        g.printGrille();

        System.out.println("CONTINUER OU PAS ?");
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

        g.addPawnInGrille(xRecv, yRecv, pRecv);

        System.out.println("Choisir x : (0,1,2,3)");
        xSend = Integer.parseInt(sc.next());
        System.out.println("Choisir y : (0,1,2,3)");
        ySend = Integer.parseInt(sc.next());
        System.out.println("Choisir p : (0,1,2,3)");
        pSend = Integer.parseInt(sc.next());
        System.out.println("Choisir c : (0,1,2,3)");
        cSend = Integer.parseInt(sc.next());

        DOS.writeInt(xSend); //Envoie de xSend
        DOS.writeInt(ySend); //Envoie de ySend
        DOS.writeInt(pSend); //Envoie de pSend
        DOS.writeInt(cSend); //Envoie de cSend

        g.addPawnInGrille(xSend, ySend, pSend);

        return 0;
    }

    public static int playFirst(Grille g, int i, DataInputStream DIS, DataOutputStream DOS) throws Exception {

        Scanner sc = new Scanner(System.in);
        int xSend;
        int ySend;
        int pSend;
        int cSend;
        int xRecv;
        int yRecv;
        int pRecv;
        int cRecv;
        int continuerPartie = 0;

        System.out.println("-------------------------------------------------------------");
        System.out.println("\n\nPlayFirst Iteration " + i);

        g.printGrille();

        System.out.println("Choisir xSend : (0,1,2,3)");
        xSend = Integer.parseInt(sc.next());
        System.out.println("Choisir y : (0,1,2,3)");
        ySend = Integer.parseInt(sc.next());
        System.out.println("Choisir p : (0,1,2,3)");
        pSend = Integer.parseInt(sc.next());
        System.out.println("Choisir c : (0,1,2,3)");
        cSend = Integer.parseInt(sc.next());

        DOS.writeInt(xSend); //Envoie de xSend
        DOS.writeInt(ySend); //Envoie de y
        DOS.writeInt(pSend); //Envoie de p
        DOS.writeInt(cSend); //Envoie de c

        g.addPawnInGrille(xSend, ySend, pSend);

        System.out.println("CONTINUER OU PAS ?");
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

        g.addPawnInGrille(xRecv, yRecv, pRecv);
        return 0;
    }


    public static void main (String[] args) {

        int port = 2567;
        String addr = "127.0.0.1";
        Scanner sc = new Scanner(System.in);

        Grille g = new Grille();

        //Prolog p = new Prolog();
        //Query consult = Prolog.consult();
        //int res = p.random();
        //System.out.println("Le resultat duprolog : " + res);


        g.printGrille();

        int xSend;
        int ySend;
        int pSend;
        int cSend;

        int xRecv;
        int yRecv;
        int pRecv;
        int cRecv;

        try{
            Socket sock = new Socket(addr,port);
            DataInputStream DIS = new DataInputStream(sock.getInputStream());
            DataOutputStream DOS = new DataOutputStream(sock.getOutputStream());

            int playFirst = DIS.readInt();

            int end = 0;
            int i = 0;
            int continuerPartie = 0;

            do {
                i++;
                if (playFirst == 0) {
                    end = playFirst(g, i , DIS, DOS);
                    if (end != 0) {
                        break;
                    }
                }
                if (playFirst != 0) {
                    end = playSecond(g, i, DIS, DOS);
                    if (end != 0) {
                        break;
                    }
                }
            } while (end != 1) ;

            System.out.println("FIN DE LA PREMIERE PARTIE\nDebut de la revange :\n");
            end = 0;
            i = 0;

            do {
                i++;
                if (playFirst == 0) {
                    end = playSecond(g, i, DIS, DOS);
                    if (end != 0) {
                        break;
                    }
                }
                if (playFirst != 0) {
                    end = playFirst(g, i , DIS, DOS);
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
        }





    }
}
