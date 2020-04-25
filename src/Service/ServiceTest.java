package Service;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

public class ServiceTest {
    private ServerSocket server;
    public static void main(String[] args) {
        ServiceTest server=new ServiceTest();
        server.start();
    }
    //启动方法
    public void start() {

        try {
            server = new ServerSocket(8880);
            this.receive();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

    }

    /*
     * 接收客户端
     */
    private void receive() {
        try {
            while (true)
            {
                Socket client=server.accept();
                Socket socket = new Socket("localhost", 8800);
                //获取输入流,并且指定统一的编码格式
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(client.getInputStream(), "UTF-8"));
                //读取一行数据
                String str;
                //通过while循环不断读取信息，
                while (true) {
                    //输出打印
                    if((str = bufferedReader.readLine()) != null)
                    {
                        System.out.println(str);
                        BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
                        bufferedWriter.write("登录成功\n");
                        bufferedWriter.flush();
                    }
                }
            }
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
    /*
     * 停止服务器
     */
    public void stop() {

    }
}
