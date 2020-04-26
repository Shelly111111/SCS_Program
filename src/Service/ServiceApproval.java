package Service;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Base64;

import static java.util.Arrays.copyOf;


public class ServiceApproval {
    private ServerSocket server;
    public static void main(String[] args) {
        ServiceApproval server = new ServiceApproval();
        server.start();
    }

    public void start() {
        try {
            server = new ServerSocket(8870);//本服务审批接口
            this.receive();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    private void receive() {
        try {
            DESUtil des = new DESUtil();
            final Base64.Encoder encoder = Base64.getEncoder();
            final Base64.Decoder decoder = Base64.getDecoder();
            final String Kgrant = "Hellowrd";//服务器密钥Kgrant
            while (true) {
                Socket client=server.accept();
                Socket socket = new Socket("localhost", 8700);//前端消息接收接口
                //获取输入流,并且指定统一的编码格式
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(client.getInputStream(),
                        "UTF-8"));
                String Message;
                while (true) {
                    if ((Message = bufferedReader.readLine()) != null) {
                        byte[] Sgrant = decoder.decode(Message);
                        byte[] Tgrant = new byte[16];//通行证
                        byte[] Qgrant =  copyOf(Sgrant,Sgrant.length-16);//请求
                        System.arraycopy(Sgrant,Sgrant.length-16,Tgrant,0,16);
                        Tgrant = des.decrypt(Tgrant,Kgrant.getBytes("ISO-8859-1"));
                        String Ksess = new String(Tgrant,"ISO-8859-1");
                        if(Ksess.substring(8).equals("Request")) {//验证一下
                            Ksess = Ksess.substring(0,8);
                            Qgrant = des.decrypt(Qgrant,Ksess.getBytes("ISO-8859-1"));
                            String Request = new String(Qgrant,"ISO-8859-1");
                            //TODO,这里解析请求
                            switch (Request.trim().charAt(Request.length()-1)){
                                case 'a':
                                    BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
                                    bufferedWriter.write("Respone:你申请的服务是服务'a'" + "\n");
                                    bufferedWriter.flush();
                                    //System.out.println("Respone:你申请的服务是服务'a'");
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
