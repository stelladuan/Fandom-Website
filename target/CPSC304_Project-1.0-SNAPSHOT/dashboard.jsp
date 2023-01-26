<%--
  Created by IntelliJ IDEA.
  User: markgu
  Date: 6/10/21
  Time: 6:13 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page errorPage="error.jsp"%>
<html>
<head>
    <title>dashboard | fanworks.site</title>
</head>
<body>
<%
    // Redirect to login page if not logged in
    if (session.getAttribute("username") == null || session.getAttribute("isModerator") == null) { %>
        <jsp:forward page="login.jsp"/>
<%  }
    String username = session.getAttribute("username").toString();
    boolean isModerator = Boolean.parseBoolean(session.getAttribute("isModerator").toString());
%>

<%@include file="navigation.jsp"%>

<div class="text">
<h1>dashboard</h1>
<div>
    <form action="create_work.jsp">
        <input type="submit" value="create a new work">
    </form>
    <form action="displayworks" method="get">
        <input type="submit" value="my works">
        <input type="hidden" name="filter_type" value="author">
        <input type="hidden" name="work_filter" value="<%=username%>">
    </form>
    <br>
    <% if (isModerator) { %>
    <h2>moderator tools</h2>
    <form action="view_reports.jsp">
        <input type="submit" value="view reports">
    </form>
    <form action="admin.jsp">
        <input type="submit" value="view site users">
    </form>
    <% } %>
</div></div>

</body>
</html>
