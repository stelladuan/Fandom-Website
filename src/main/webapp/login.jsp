<%--
  Created by IntelliJ IDEA.
  User: markgu
  Date: 6/8/21
  Time: 6:18 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>log in | fanworks.site</title>
</head>
<body>
<%
    // Redirect to dashboard if already logged in (prevent user from logging in again)
    if (session.getAttribute("username") != null && session.getAttribute("isModerator") != null) { %>
        <jsp:forward page="dashboard.jsp"/>
<%  }
%>

<%@include file="navigation.jsp"%>
<div class="text">
<h1>log in</h1>
    <br>
<form action="LoginServlet" method="post" >
    <table>
        <tr>
            <td>username </td>
            <td><input type="text" name="username" maxlength="20" required></td>
        </tr>
        <tr>
            <td>password </td>
            <td><input type="password" name="password" maxlength="20" required></td>
        </tr>
    </table>
    <br>
    <input type="submit" value="Log In">
</form>
<br><br>
don't have an account? sign up <a href="sign_up.jsp">here!</a>
</div>
</body>
</html>
