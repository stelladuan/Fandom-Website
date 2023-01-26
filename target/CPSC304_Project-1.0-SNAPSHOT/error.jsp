<%@ page import="java.io.PrintWriter" %><%--
  Created by IntelliJ IDEA.
  User: markgu
  Date: 6/9/21
  Time: 12:44 PM
  To change this template use File | Settings | File Templates.
--%>
<%-- This page can be redirected to by other pages in case an exception occurred.
     It's probably less informative than just letting the browser display the error,
        but I guess it's an option for error handling.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<html>
<head>
    <title>Error</title>
</head>
<body>

<%
    PrintWriter writer = response.getWriter();

    writer.println("<h1>An error has occurred.</h1>");

    exception.printStackTrace(writer);

%>
</body>
</html>
