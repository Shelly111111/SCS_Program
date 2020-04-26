package Service;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Base64;
import java.util.Random;

/*
 * 创建服务器，并启动
 * 请求并响应
 */
public class ServiceTest {
    private ServerSocket server;
    public static final String CRLF="\r\n";
    public static final String BLANK=" ";
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

    public static String getRandomString(int length){
        String str="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        Random random=new Random();
        StringBuffer sb=new StringBuffer();
        for(int i=0;i<length;i++){
            int number=random.nextInt(62);
            sb.append(str.charAt(number));
        }
        return sb.toString();
    }

    /*
     * 接收客户端
     */
    private void receive() {
        try {
            DESUtil des = new DESUtil();
            final Base64.Encoder encoder = Base64.getEncoder();
            while (true)
            {
                Socket client=server.accept();
                Socket socket = new Socket("localhost", 8800);
                //获取输入流,并且指定统一的编码格式
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(client.getInputStream(), "UTF-8"));
                //读取一行数据
                String username;
                //通过while循环不断读取信息，
                while (true) {
                    //输出打印
                    if((username = bufferedReader.readLine()) != null) {
                        /*
                         *TODO
                         * username，即从客户端传过来的用户名
                         * 通过数据库查询对应的密钥
                         */
                        System.out.println(username);
                        String key = "b";//这里应该是从数据库中取出的密码，并使用DES解密
                        while (key.length()%8!=0) {
                            key+='u';
                        }
                        String password = getRandomString(8);
                        password += "Success";
                        /*
                         * TODO
                         *
                         *
                         */
                        System.out.println(password);
                        byte[] text = des.encrypt(password.getBytes("ISO-8859-1"),key.getBytes("ISO-8859-1"));
                        final String permit = encoder.encodeToString(text);
                        BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
                        bufferedWriter.write(permit + "\n");
                        bufferedWriter.flush();
                        System.out.println(new String(des.decrypt(text,key.getBytes("ISO-8859-1")),"UTF-8"));
                    }
                }
            }
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /*
     * 停止服务器
     */
    public void stop() {

    }
}