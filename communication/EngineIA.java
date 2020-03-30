import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.EOFException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Scanner;

public class EngineIA {
	public static void main (String[] args) {

		int port = 0;
		String addr = "";
		
		if(args.length != 2) {
			System.out.println("Usage : adresse port");
		}
		addr = args[0];
		port = Integer.parseInt(args[1]);
		try{
			Socket sock = new Socket(addr,port);
			DataInputStream DIS = new DataInputStream(sock.getInputStream());
			DataOutputStream DOS = new DataOutputStream(sock.getOutputStream());
			
			int arret = 6;
			int result = 0;
				
				result = DIS.readInt();
				System.out.println("RECU " + result);
				DOS.writeInt(arret);
				
				//result = DIS.readInt();
				//System.out.println("RECU " + result);
				
				DIS.close();
				DOS.close();
				sock.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
