<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>Smart Campus Service Platform</title>
  </head>
  <body>
    <div class="text-center" style="text-align: center;margin: 100px;">
      <span style="color: red;font-size: 48px;font-family: SimSun-ExtB">智慧校园服务平台</span>
    </div>
    <form name="Login" action="Login in.jsp" method="post" style="margin: 15px; text-align: center">
      用户名：<input type="text" name="username"/><br/>
      密&emsp;码：<input type="text" name="password"/><br/>
      <input type="button" value="登&ensp;录" style="margin-left: 180px;margin-top: 20px" onclick="Login.submit()"/>
    </form>
  </body>
</html>
