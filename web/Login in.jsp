<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Service.DESUtil" %>
<%@ page import="java.net.Socket" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.ServerSocket" %>
<%@ page import="java.util.Base64" %>
<!--%@ page import="webServiceTest" %-->
<html>
<head>
    <title>登录状态</title>
</head>
<body>

</body>
</html>

<%
    DESUtil desUtil = new DESUtil();
    final Base64.Decoder decoder = Base64.getDecoder();
    String username = request.getParameter("username");
    String key = request.getParameter("password");
    while (key.length()%8!=0)
    {
        key+='u';
    }
    Socket socket = new Socket("localhost",8880);
    ServerSocket server = new ServerSocket(8800);
    Socket client=server.accept();
    //通过socket获取字符流
    BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
    bufferedWriter.write(username + "\n");
    bufferedWriter.flush();
    //通过标准输入流获取字符流
    BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(client.getInputStream(), "UTF-8"));
    String permit = bufferedReader.readLine();
    byte[] message = desUtil.decrypt(decoder.decode(permit),key.getBytes("ISO-8859-1"));
    String str = new String(message,"UTF-8");
    String checkcode = str.substring(str.length()-7);
    //out.println(checkcode);
    if(checkcode.equals("Success"))
    {
        out.println("登录成功");
    }
%>