package org.example;

import org.jpl7.Query;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.net.Socket;
import java.util.Scanner;

public class EngineIA {

    public static void intitalizeGrille(int grille [][]) {
        int nbColonne = grille.length;
        int nbLigne = grille[0].length;
        for (int i = 0; i < nbLigne; i++) {
            for (int j = 0; j < nbColonne; j++) {
                grille[i][j] = -1;
            }
        }
    }

    public static char intToPion(int p) {
        switch (p) {
            case 0:
                return 'C';
            case 1:
                return 'P';
            case 2:
                return 'S';
            case 3:
                return 'T';
            default:
                return 'Z';
        }
    }

    public static void printGrille(int grille[][]) {
        int nbColonne = grille.length;
        int nbLigne = grille[0].length;
        for (int i = 0; i < nbLigne; i++) {
            for (int j = 0; j < nbColonne; j++) {
                System.out.print("" + intToPion(grille[i][j]));
                if (j != 3) {
                    System.out.print("|");
                }
            }
            if (i != 3) {
                System.out.println("\n--------------");
            }
        }
    }


    public static void main (String[] args) {

        int port = 2567;
        String addr = "127.0.0.1";
        Scanner sc = new Scanner(System.in);

        //Prolog p = new Prolog();
        //Query consult = Prolog.consult();
        //int res = p.random();
        //System.out.println("Le resultat duprolog : " + res);

        int grille[][] = new int[4][4];
        intitalizeGrille(grille);

        printGrille(grille);

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

            int playFirst = 0;

            playFirst = DIS.readInt();

            int end = 0;
            int i = 0;

            do {

                i++;

                if (playFirst == 0) {
                    System.out.println("-------------------------------------------------------------");
                    System.out.println("\n\nPlayFirst Iteration " + i);

                    printGrille(grille);

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

                    grille[xSend][ySend] = pSend;

                    xRecv = DIS.readInt();
                    yRecv = DIS.readInt();
                    pRecv = DIS.readInt();
                    cRecv = DIS.readInt();

                    if (cRecv != 0) {
                        end = 0;
                        break;
                    }

                }

                if (playFirst != 0) {

                    System.out.println("-------------------------------------------------------------");
                    System.out.println("\n\nPlaySecond Iteration " + i);

                    printGrille(grille);

                    xRecv = DIS.readInt();
                    yRecv = DIS.readInt();
                    pRecv = DIS.readInt();
                    cRecv = DIS.readInt();

                    if (cRecv != 0) {
                        end = 0;
                        break;
                    }
                    grille[xRecv][yRecv] = pRecv;

                    System.out.println("Choisir x : (0,1,2,3)");
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


                }

            } while (end != 1) ;




            System.out.println("FIN DE LA PARTIE\n");




            DIS.close();
            DOS.close();
            sock.close();
        } catch (Exception e) {
            e.printStackTrace();
        }





    }
}
