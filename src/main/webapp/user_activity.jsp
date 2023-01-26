<%@ page import="project.CPSC304_Project.model.NoteInfo" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: markgu
  Date: 6/10/21
  Time: 10:37 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="dataHandler" class="project.CPSC304_Project.DataHandler"/>
<html>
<head>
    <title>search for user activity | fanworks.site</title>
</head>
<body>
<%@include file="navigation.jsp"%>
<div class="text">
<h1>search for user interactions</h1>
<form action="UserActivityServlet" method="get">
    <label for="search_username">search by username </label>
    <input type="text" id="search_username" name="search_username" required> <br>
<%
    if (session.getAttribute("username") != null) { %>
    <br>
    <label>view my interactions
        <input type="checkbox" onclick="document.getElementById('search_username').value = '<%=session.getAttribute("username")%>';">
    </label>
    <br>
<%  }
%>
    <br>
    search for activity <br>
        <input type="radio" id="likes" name="activity_type" value="Likes" required>
        <label for="likes">likes</label> <br>

        <input type="radio" id="notes" name="activity_type" value="Notes">
        <label for="notes">notes</label> <br>

        <input type="radio" id="bookmarks" name="activity_type" value="Bookmarks">
        <label for="bookmarks">bookmarks</label> <br><br>
    <input type="submit" value="Go">
</form>
</div>
</body>
</html>
