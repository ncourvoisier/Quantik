package org.example;

import org.jpl7.Query;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.net.Socket;

public class Engine {

    public static void main (String[] args) {

        int port = 2567;
        String addr = "127.0.0.1";

        App a = new App();

        //if(args.length != 2) {
        //    System.out.println("Usage : adresse port");
        //}
        //addr = args[0];
        //port = Integer.parseInt(args[1]);

        Query consult = App.consult();
        int res = a.random();
        System.out.println("Le resultat duprolog : " + res);

        /*try{
            Socket sock = new Socket(addr,port);
            DataInputStream DIS = new DataInputStream(sock.getInputStream());
            DataOutputStream DOS = new DataOutputStream(sock.getOutputStream());

            int arret = 6;
            int result = 0;

            result = DIS.readInt();
            System.out.println("RECU " + result);
            DOS.writeInt(arret);


            DIS.close();
            DOS.close();
            sock.close();
        } catch (Exception e) {
            e.printStackTrace();
        }*/






    }
}