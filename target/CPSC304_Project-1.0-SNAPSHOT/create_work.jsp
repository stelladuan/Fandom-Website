<%--
  Created by IntelliJ IDEA.
  User: Helen Yu
  Date: 2021-06-15
  Time: 5:52 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%--<jsp:useBean id="dataHandler" class="project.CPSC304_Project.DataHandler"/>--%>
<html>
<head>
    <title>create work | fanworks.site</title>
</head>
<body>
<%@include file="navigation.jsp"%>
<div class="text">
<h1>create a new work</h1><br>
<form action="creatework" method="post">
    Title &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <input type="text" name="work_title" required><br><br>
    <label for="description">Description</label><br>
    <textarea id="description" name="description" rows="5" cols="100"></textarea><br><br>
    Type of Work &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <input type="radio" id="digitalwork" name="work_type" value="digital" onchange="workDisplay(id)">
    <label for="digitalwork">Digital Work</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <input type="radio" id="writtenwork" name="work_type" value="written" onchange="workDisplay(id)">
    <label for="writtenwork">Written Work</label><br><br>
    <p id="work_display"></p>
</form>


<script>
    function workDisplay(id) {
        const workType = document.getElementById(id).value;
        if (workType === "digital") {
            document.getElementById("work_display").innerHTML = "Image URL &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                "<input type=\"url\" name=\"image_url\" required><br><br><br><br><br><br>" +
                "<input type=\"submit\" value=\"Post Work\">";
        } else if (workType === "written") {
            document.getElementById("work_display").innerHTML = "<label for=\"description\">Work Text</label><br>" +
                "<textarea id=\"textfile\" name=\"text_file\" rows=\"20\" cols=\"150\" required>" +
                "</textarea><br><br>" +
                "Word Count &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                "<input type=\"number\" name=\"word_count\" required><br><br>" +
                "Language &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                "<input type=\"text\" name=\"language\" required><br><br><br><br><br><br>" +
                "<input type=\"submit\" value=\"Post Work\">";
        } else {
            document.getElementById("work_display").innerHTML = "Invalid input detected. Please refresh the page to continue."
        }
    }
</script>
</div>
</body>
</html>
