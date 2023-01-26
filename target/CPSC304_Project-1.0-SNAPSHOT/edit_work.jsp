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
    <title>edit work | fanworks.site</title>
</head>
<body>
<%@include file="navigation.jsp"%>
<div class="text">
<%
    int workID = Integer.parseInt(request.getParameter("workID"));
    String workType = request.getParameter("work_type");
    ResultSet work;

    try {
        work = DataHandler.getWork(workID, workType);
        if (work.next()) {
            Object user = request.getSession().getAttribute("username");
            if ((user == null) || (!user.toString().equals(work.getString(4)))) {
                out.println("Please log in to a (correct) account to edit this work.");
                return;
            }

            String description = work.getString(3);
            if (description == null) {
                description = "";
            }
            %>

<h1>edit the work "<%=work.getString(2)%>"</h1><br>
<form action="editwork" method="post">
    <input type="hidden" name="workID" value="<%=workID%>">
    Title &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <input type="text" name="work_title" placeholder="<%=work.getString(2)%>" required><br><br>
    <label for="description">Description</label><br>
    <textarea id="description" name="description" rows="5" cols="100" placeholder="<%=work.getString(3)%>"></textarea><br><br>
            <%
            if (work.getString(5).equals("digital")) {
            %>
                Image URL &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="url" name="image_url" placeholder="<%=work.getString(6)%>"><br><br><br><br><br><br>
                <input type="hidden" name="work_type" value="digital">
                <input type="submit" value="Update Work">
            <%
            } else {
            %>
                <label for="chapter_num">Select a Chapter</label>
                <select name="chapter_num" id="chapter_num" onchange="chapterDisplay(id)">
                <option value="0"></option>
                <%
                ResultSet allChapters = DataHandler.getAllChapters(workID);
                while (allChapters.next()) {
                    int chapterNumber = allChapters.getInt(1);
                %>
                    <option value="<%=chapterNumber%>"><%=chapterNumber%></option>
                <%
                }
                %>
            </select><br><br>
            <input type="hidden" name="work_type" value="written">
            <p id="chapter_display"></p>
            <%
            }
            %>
</form>

<script>
    function chapterDisplay(id) {
        if (document.getElementById(id).value !== 0) {
            document.getElementById("chapter_display").innerHTML = "<label for=\"textfile\">Work Text</label><br>" +
                "<textarea id=\"textfile\" name=\"text_file\" rows=\"20\" cols=\"150\" required>" +
                "</textarea><br><br>" +
                "Word Count &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                "<input type=\"number\" name=\"word_count\" placeholder=\"<%=work.getInt(6)%>\" required><br><br>" +
                "Language &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                "<input type=\"text\" name=\"language\" placeholder=\"<%=work.getString(7)%>\" required><br><br><br><br><br><br>" +
                "<input type=\"submit\" value=\"Update Work\">";
        } else {
            document.getElementById("chapter_display").innerHTML = "";
        }
    }
</script>

<%
        }
    } catch (SQLException | DBOperationException e) {
        e.printStackTrace();
    }
%>
</div>
</body>
</html>
