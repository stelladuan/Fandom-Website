<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="project.CPSC304_Project.DataHandler" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="project.CPSC304_Project.exception.DBOperationException" %><%--
  Created by IntelliJ IDEA.
  User: Helen Yu
  Date: 2021-06-16
  Time: 8:19 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>add chapter | fanworks.site</title>
</head>
<body>
<%@include file="navigation.jsp"%>
<div class="text">
<%
    int workID = Integer.parseInt(request.getParameter("workID_chapter"));
    String workType = request.getParameter("workchapter_type");
    ResultSet work;

    try {
        work = DataHandler.getWork(workID, workType);
        if (work.next()) {
            Object user = request.getSession().getAttribute("username");
            if ((user == null) || (!user.toString().equals(work.getString(4)))) {
                out.println("Please log in to a (correct) account to edit this work.");
                return;
            }

            int chapter_number = Integer.parseInt(work.getString(8)) + 1;
%>

<h1>add a chapter to the work "<%=work.getString(2)%>"</h1><br>
<form action="addchapter" method="post">
    <input type="hidden" name="workID" value="<%=workID%>">
    <input type="hidden" name="chapter_count" value="<%=chapter_number%>">
    <label for="text_file">Chapter Text</label><br>
    <textarea id="text_file" name="text_file" rows="20" cols="150" required></textarea><br><br>
    <label for="word_count">Chapter Word Count &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
    <input type="number" id="word_count" name="word_count" placeholder="<%=work.getInt(6)%>" required><br><br><br><br><br><br>
    <input type="submit" value="Add Chapter">
    <%
        }
    %>
</form>

<%
    } catch (SQLException | DBOperationException e) {
        e.printStackTrace();
    }
%>
</div>
</body>
</html>