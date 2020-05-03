<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>Smart Campus Service Platform</title>
  </head>
  <body>
    <div class="text-center" style="text-align: center;margin: 100px;">
      <span style="color: red;font-size: 48px;font-family: SimSun-ExtB">智慧校园服务平台</span>
    </div>
    <form name="Login" action="LoginState.jsp" method="Post" style="margin: 15px; text-align: center">
      用户名：<input type="text" name="username"/><br/>
      密&emsp;码：<input type="text" name="password"/><br/>
      <input type="button" value="登&ensp;录" style="margin-left: 180px;margin-top: 20px" onclick="Login.submit()"/>
    </form>
  <!--script>
    var websocket = null;
    // alert(username)
    //判断当前浏览器是否支持WebSocket
    if ('WebSocket' in window) {
      alert("浏览器支持Websocket")
      websocket = new WebSocket('ws://localhost/webSocket/');
    } else {
      alert('当前浏览器 Not support websocket')
    }

    //连接发生错误的回调方法
    websocket.onerror = function() {
      alert("WebSocket连接发生错误")
      setMessageInnerHTML("WebSocket连接发生错误");
    };

    //连接成功建立的回调方法
    websocket.onopen = function() {
      alert("WebSocket连接成功")
      setMessageInnerHTML("WebSocket连接成功");
    }

    //接收到消息的回调方法
    websocket.onmessage = function(event) {
      alert("接收到消息的回调方法")
      alert("这是后台推送的消息："+event.data);
      websocket.close();
      alert("webSocket已关闭！")
    }

    //连接关闭的回调方法
    websocket.onclose = function() {
      setMessageInnerHTML("WebSocket连接关闭");
    }

    //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
    window.onbeforeunload = function() {
      closeWebSocket();
    }

    //关闭WebSocket连接
    function closeWebSocket() {
      websocket.close();
    }

    //将消息显示在网页上
    function setMessageInnerHTML(innerHTML) {
      document.getElementById('message').innerHTML += innerHTML + '<br/>';
    }

    //发送消息
    function send() {
      var message = document.getElementById('username').value;
      websocket.send(message);
    }
  </script-->
  </body>
</html>