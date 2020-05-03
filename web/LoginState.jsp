<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Service.DESUtil" %>
<%@ page import="java.net.Socket" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.ServerSocket" %>
<%@ page import="java.util.Base64" %>

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
    final Base64.Encoder encoder = Base64.getEncoder();
    String username = request.getParameter("username");
    if (username == null || "".equals(username.trim())) {
        out.print("<script>alert('用户名不能为空,请重新输入')</script>");
        response.sendRedirect(request.getContextPath() + "login.jsp");
        return;
    }
    String password = request.getParameter("password");
    while (password.length()%8!=0) {
        password+='u';
    }
    Socket Loginsocket = new Socket("localhost",8880);//登录验证发送接口
    Socket Approvalsocket = new Socket("localhost",8870);//服务审批发送接口
    Socket AppService = new Socket("localhost",8860);//应用服务发送接口
    ServerSocket server = new ServerSocket(8800);//接收登录消息接口
    ServerSocket server2 = new ServerSocket(8700);//接收审批消息接口
    ServerSocket server3 = new ServerSocket(8600);//接收应用消息接口
    Socket client=server.accept();
    Socket client2=server2.accept();
    Socket client3 = server3.accept();
    //通过socket获取字符流
    BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(Loginsocket.getOutputStream()));
    bufferedWriter.write(username + "\n");
    bufferedWriter.flush();
    //通过标准输入流获取字符流
    BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(client.getInputStream(), "UTF-8"));
    BufferedReader bufferedReader2 = new BufferedReader(new InputStreamReader(client2.getInputStream(), "UTF-8"));
    BufferedReader bufferedReader3 = new BufferedReader(new InputStreamReader(client3.getInputStream(), "UTF-8"));
    String Message = null;
    String Message2 = null;
    String Message3 = null;
    String Ksess = null;
    try {
        while ((Message = bufferedReader.readLine())!=null) {
            byte[] permit = desUtil.decrypt(decoder.decode(Message),password.getBytes("ISO-8859-1"));//使用密码机密通行证
            String str = new String(permit,"UTF-8");
            String checkcode = str.substring(str.length()-7);//取出验证码并查看是否正确
            if (checkcode.equals("Success")) {//如果为Success即证明用户密码输入正确
                response.setCharacterEncoding("utf-8");
                out.print("<script>alert('登录成功')</script>");
                //out.println("登录成功");
                /*
                 * TODO，根据用户的操作申请服务，@程思雯
                 */
                Ksess = str.substring(0,8);//前8位为会话密钥
                byte[] Qgrant = "Request -a".getBytes("ISO-8859-1");//生成所请求的服务，可使用Request -加abcd即对应的服务
                Qgrant = desUtil.encrypt(Qgrant,Ksess.getBytes("ISO-8859-1"));
                byte[] Tgrant = decoder.decode(str.substring(8,str.length()-7));//通行证即除去会话密钥与Success验证码的部分
                //合并通行证和请求为向服务审批发送的审批消息
                byte[] Sgrant = new byte[Qgrant.length + Tgrant.length];
                System.arraycopy(Qgrant, 0, Sgrant, 0, Qgrant.length);
                System.arraycopy(Tgrant, 0, Sgrant, Qgrant.length, Tgrant.length);
                BufferedWriter bWriter = new BufferedWriter(new OutputStreamWriter(Approvalsocket.getOutputStream()));
                bWriter.write(encoder.encodeToString(Sgrant) + "\n");
                bWriter.flush();
                break;
            } else {
                out.print("<script>alert('用户名密码错误，请重新输入'); window.location='index.jsp'</script>");
                /*
                 * TODO，跳转至登录界面,重新登录
                 */
                break;
            }
        }
        while ((Message2 = bufferedReader2.readLine())!=null) {
            if(Message2.substring(0, 6).equals("Error:")) {
                out.print("<script>alert('" + Message2.substring(6) + "')</script>");
                break;
            } else {
                byte[] rspMessage = desUtil.decrypt(decoder.decode(Message2),Ksess.getBytes("ISO-8859-1"));
                Message2 = new String(rspMessage,"ISO-8859-1");
                String Ksess2 = Message2.substring(0,8);
                byte[] Qserv = "Run -a".getBytes("ISO-8859-1");
                Qserv = desUtil.encrypt(Qserv,Ksess2.getBytes("ISO-8859-1"));
                //out.println(encoder.encodeToString(Qserv).length());
                BufferedWriter bWriter = new BufferedWriter(new OutputStreamWriter(AppService.getOutputStream()));
                bWriter.write(encoder.encodeToString(Qserv) + Message2.substring(8) + "\n");
                bWriter.flush();
                break;
            }
        }
        while ((Message3 = bufferedReader3.readLine())!=null) {
            if(Message3.substring(0, 6).equals("Error:")) {
                out.print("<script>alert('" + Message3.substring(6) + "')</script>");
                break;
            } else {
                out.print("<script>alert('" + Message3 + "')</script>");
                break;
            }
        }
    } catch (Exception e) {
        Loginsocket.close();
        Approvalsocket.close();
        AppService.close();
        server.close();
        server2.close();
        server3.close();
        //out.print("<script>alert('用户名密码错误，请重新输入'); window.location='index.jsp'</script>");
    }
%>