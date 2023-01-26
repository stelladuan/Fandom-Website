<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet"%>
<%@ page import="java.sql.*" %>
<%@ page import="project.CPSC304_Project.DataHandler" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String dtype = request.getParameter("d");
%>

<html>
<head>
    <title>works liked by all moderators statistics | fanworks.site</title>
</head>

<body>
<%@include file="navigation.jsp"%>
<div class="text">
<h1> <%="works liked by all moderators"%></h1>

<table border="1">
    <tr>
        <td><%=dtype%></td>

    </tr>
        <%
    try {
        Connection connection = DataHandler.getConnection();
        Statement st = connection.createStatement();
        String query = "SELECT w." +  dtype+" FROM Work w WHERE NOT EXISTS ((SELECT u.Username from SiteUser u where u.IsModerator=1) MINUS (select l.Username from Likes l where l.WorkID=w.WorkID))";
        ResultSet rset= st.executeQuery(query);

        while (rset.next()) {
%>
    <tr>
        <td><%=rset.getString(1)%></td>

    </tr>
        <%
        }
    }
    catch (Exception e) {
        e.printStackTrace();
    }

%>

</div>
</body>
</html>

