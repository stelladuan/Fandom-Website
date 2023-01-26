<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet"%>
<%@ page import="java.sql.*" %>
<%@ page import="project.CPSC304_Project.DataHandler" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String atype = request.getParameter("a");
%>

<html>
<head>
    <title>word count statistics | fanworks.site</title>
</head>
<body>
<%@include file="navigation.jsp"%>
<div class="text">
<h1> <%="word count"%></h1>

<%
    try {
        Connection connection = DataHandler.getConnection();
        Statement st = connection.createStatement();
        String query = "SELECT "+ atype + "(WordCount) FROM WrittenWork";
        ResultSet rset= st.executeQuery(query);
        while (rset.next()) {
        %>
         <tr><%=atype%></tr>
         <tr><%=rset.getString(1)%></tr>

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
