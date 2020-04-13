<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

</body>
</html>

<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    out.println(username);
    out.println(password);
%>