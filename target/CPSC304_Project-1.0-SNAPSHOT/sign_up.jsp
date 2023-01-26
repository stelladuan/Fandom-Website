<%--
  Created by IntelliJ IDEA.
  User: markgu
  Date: 6/10/21
  Time: 5:52 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>sign up | fanworks.site</title>
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
<h1>create a new user account</h1>
    <br>
<form method="post" action="SignUpServlet">
    <table>
        <tr>
            <td>username </td>
            <td><input type="text" name="username" maxlength="20" required></td>
        </tr>
        <tr>
            <td>password </td>
            <td><input type="password" name="password" maxlength="20" required></td>
        </tr>
        <tr>
            <td>email address </td>
            <td><input type="email" name="email" maxlength="256" required></td>
        </tr>
    </table>
    <br><br>
    <input type="submit" value="Create account">
</form>
</div>
</body>
</html>
