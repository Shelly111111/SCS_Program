<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.Socket" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.ServerSocket" %>
<!--%@ page import="webServiceTest" %-->
<html>
<head>
    <title>登录状态</title>
</head>
<body>

</body>
</html>

<%
    String username = request.getParameter("username");
    Socket socket = new Socket("localhost",8880);
    ServerSocket server = new ServerSocket(8800);
    Socket client=server.accept();
    //通过socket获取字符流
    BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
    bufferedWriter.write(username + "\n");
    bufferedWriter.flush();
    //通过标准输入流获取字符流
    BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(client.getInputStream(), "UTF-8"));
    String str = bufferedReader.readLine();
    out.println(str);
%>