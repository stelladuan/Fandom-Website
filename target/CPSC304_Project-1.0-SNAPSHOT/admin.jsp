<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet"%>
<%@ page import="java.sql.*" %>
<%@ page import="project.CPSC304_Project.DataHandler" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>view site users | fanworks.site</title>
</head>

<body>
<%
    // Redirect to dashboard if not logged in as a moderator
    if (session.getAttribute("username") == null || session.getAttribute("isModerator") == null || !session.getAttribute("isModerator").equals(true)) { %>
<jsp:forward page="dashboard.jsp"/>
<%  }
%>
<%@include file="navigation.jsp"%>
<div class="text">
<h1>view site users</h1>


<table border="1">
    <tr>
        <td>Username</td>
        <td>Password</td>
        <td>EmailAddress</td>
        <td>IsModerator</td>
    </tr>
<%
try {
        Connection connection = DataHandler.getConnection();
        Statement st = connection.createStatement();
        String query = "SELECT * FROM SiteUser";
        ResultSet rset = st.executeQuery(query);

        while (rset.next()) {
%>
<tr>
    <td><%=rset.getString(1)%></td>
    <td><%=rset.getString(2)%></td>
    <td><%=rset.getString(3)%></td>
    <td><%=rset.getString(4)%></td>
</tr>
<%
        }
} catch (Exception e) {
    e.printStackTrace();
}
%>
</table>


<form action="projection1.jsp" method="post">
    Projection <select name = "c">
    <option>Username</option>
    <option>Password</option>
    <option>EmailAddress</option>
    <option>IsModerator</option>
</select>
    <input type="submit" value="submit">
</form>


</div>
</body>
</html>
