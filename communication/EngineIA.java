import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.EOFException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Scanner;

public class EngineIA {
  
    
  
  
    public static void main (String [] args) {
        if(args.length != 2) {
			System.out.println("Usage : adresse port");
        }
        int port = Integer.parseInt(args[1]);
        String addr = args[0];
        try{

            Socket sock = new Socket(addr,port);
            System.out.println("SOCKET : " + sock);
            
            DataInputStream DIS = new DataInputStream(sock.getInputStream());
			DataOutputStream DOS = new DataOutputStream(sock.getOutputStream());
            
                System.out.println(sock.isClosed());
                int result = 0;
                while(DIS.available() > 0) {
                    result = DIS.readInt();
                }
                
                
                System.out.print(" RESULTE"+result);

                DOS.write(result);
                
                System.out.print(" RESULTE"+result);
               
            sock.close();

        } catch (Exception e) {
			e.printStackTrace();
		}

    }
}