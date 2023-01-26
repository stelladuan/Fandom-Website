<%--
  Created by IntelliJ IDEA.
  User: duanx
  Date: 6/10/2021
  Time: 2:05 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet"%>
<%@ page import="java.sql.*" %>
<%@ page import="project.CPSC304_Project.DataHandler" %>
<%
    String ptype = request.getParameter("c");
%>



<!DOCTYPE html>
<html>
<head>
    <title>user information | fanworks.site</title>
</head>

<body>
<%@include file="navigation.jsp"%>
<div class="text">
<h1> <%="Users' information"%></h1>

<table border="1">
    <tr>
        <td><%=ptype%></td>

    </tr>
    <%
    try {
    Connection connection = DataHandler.getConnection();
    Statement st = connection.createStatement();
    String query;
    ResultSet rset;

    query = "SELECT " + ptype +" FROM SiteUser";
    rset = st.executeQuery(query);
    while (rset.next()) {
    %>
    <tr><td><%=rset.getString(1)%></td></tr>
    <%
    }
    } catch (Exception e) {
            e.printStackTrace();
    }
%>


</table>
</div>
</body>
</html>


