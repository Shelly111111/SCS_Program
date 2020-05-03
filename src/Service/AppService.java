package Service;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Base64;

public class AppService {
    private ServerSocket server;
    public static void main(String[] args) {
        AppService server = new AppService();
        server.start();
    }

    public void start() {
        try {
            server = new ServerSocket(8860);//本应用服务接口
            this.receive();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    //TODO,@刘亦菲，根据请求启动相应的程序
    private boolean RunApproval(char Approval)
    {
        switch (Approval){
            case 'a':
                //Run .....
                return true;
            default:
                break;

        }
        return false;
    }

    private void receive() {
        try {
            DESUtil des = new DESUtil();
            final Base64.Encoder encoder = Base64.getEncoder();
            final Base64.Decoder decoder = Base64.getDecoder();
            final String Kserv = "Heloword";//审批服务器密钥Kserv
            while (true) {
                Socket client=server.accept();
                Socket socket = new Socket("localhost", 8600);//前端消息接收接口
                //获取输入流,并且指定统一的编码格式
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(client.getInputStream(),
                        "UTF-8"));
                String Message;
                while (true) {
                    if ((Message = bufferedReader.readLine()) != null) {
                        byte[] Qserv = decoder.decode(Message.substring(0,12));
                        byte[] Tserv = decoder.decode(Message.substring(12));
                        Tserv = des.decrypt(Tserv,Kserv.getBytes("ISO-8859-1"));
                        String Ksess2 = new String(Tserv,"ISO-8859-1");
                        if (Ksess2.substring(Ksess2.length()-2).equals("OK")) {
                            Ksess2 = Ksess2.substring(0,Ksess2.length()-2);
                            Qserv = des.decrypt(Qserv,Ksess2.getBytes("ISO-8859-1"));
                            String Request = new String(Qserv,"ISO-8859-1");
                            char Approval = Request.trim().charAt(Request.trim().length()-1);
                            if(RunApproval(Approval)) {
                                BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
                                bufferedWriter.write("Success:成功运行" + "\n");
                                bufferedWriter.flush();
                            }
                            else {
                                BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
                                bufferedWriter.write("Error:运行失败" + "\n");
                                bufferedWriter.flush();
                            }
                        }
                        else {
                            BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
                            bufferedWriter.write("Error:请求出错，请重新发送请求" + "\n");
                            bufferedWriter.flush();
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
