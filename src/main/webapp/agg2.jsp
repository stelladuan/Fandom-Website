<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet"%>
<%@ page import="java.sql.*" %>
<%@ page import="project.CPSC304_Project.DataHandler" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<%
    String btype = request.getParameter("b");
%>

<html>
<head>
    <title>fandom likes statistics | fanworks.site</title>
</head>
<body>
<%@include file="navigation.jsp"%>
<div class="text">
<h1> <%="fandom likes"%></h1>

<table border="1">
    <tr>
        <td>FandomName</td>
        <td><%=btype+ " number of likes"%></td>
    </tr>
        <%
    try {
        Connection connection = DataHandler.getConnection();
        Statement st = connection.createStatement();
        String query = "SELECT B.Fandomname, "+ btype +"(temp.c) FROM BelongsTo B, (SELECT W.WorkID, COUNT(Username) AS c FROM  Work W LEFT OUTER JOIN Likes L ON L.WorkID=W.WorkID GROUP BY W.WorkID) temp WHERE B.WorkID=temp.WorkID GROUP BY Fandomname";
        ResultSet rset= st.executeQuery(query);
           while (rset.next()) {
%>
    <tr>
        <td><%=rset.getString(1)%></td>
        <td><%=rset.getString(2)%></td>

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
