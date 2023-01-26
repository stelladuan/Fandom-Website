<%--
  Created by IntelliJ IDEA.
  User: markgu
  Date: 6/14/21
  Time: 12:55 PM
  To change this template use File | Settings | File Templates.
--%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>Title</title>--%>
<%--</head>--%>
<%--<body>--%>

<%
    if (session.getAttribute("username") != null) {
        String workID = request.getParameter("workID");
        String isWrittenWork = request.getParameter("isWrittenWork"); %>

<%--Only show interface to add likes, comments, and bookmarks when logged in--%>
<form action="${pageContext.request.contextPath}/AddActivityServlet">
    <input type="hidden" name="workID" value="<%=workID%>">
    <input type="hidden" name="isWrittenWork" value="<%=isWrittenWork%>">
    <input type="hidden" name="activityType" value="Like">

    <input type="submit" value="Like">
</form>

<br>
<p>write a note</p>
<form action="${pageContext.request.contextPath}/AddActivityServlet">
    <input type="hidden" name="workID" value="<%=workID%>">
    <input type="hidden" name="isWrittenWork" value="<%=isWrittenWork%>">
    <input type="hidden" name="activityType" value="Note">

    <textarea name="noteText" required></textarea> <br>
    <input type="submit" value="Post note">
</form>

<br>
<p>bookmark this work</p>
<form action="${pageContext.request.contextPath}/AddActivityServlet">
    <input type="hidden" name="workID" value="<%=workID%>">
    <input type="hidden" name="isWrittenWork" value="<%=isWrittenWork%>">
    <input type="hidden" name="activityType" value="Bookmark">

    <label> note (optional):
        <textarea name="bookmarkText"></textarea>
    </label> <br>
    <label> visible to public?
        <input type="checkbox" name="isPublic">
    </label> <br>
    <input type="submit" value="Bookmark">
</form>

<br>
<p>report this work</p>
<form action="${pageContext.request.contextPath}/AddActivityServlet">
    <input type="hidden" name="workID" value="<%=workID%>">
    <input type="hidden" name="isWrittenWork" value="<%=isWrittenWork%>">
    <input type="hidden" name="activityType" value="Report">

    <label> reason for report
        <select name="reportReason" required>
            <optgroup label="Suspicious or spam">
                <option>Work has been posted before</option>
                <option>Work contains spam</option>
                <option>Tags are unrelated to work</option>
                <option>Includes private information</option>
            </optgroup>
            <optgroup label="Abusive or harmful">
                <option>Malicious or phishing attempt</option>
                <option>Disrespectful or offensive</option>
                <option>Targeted harassment</option>
                <option>Directs hate on a protected group</option>
                <option>Threatening or encouraging harm</option>
            </optgroup>
        </select>
    </label> <br>
    <label> detailed description
        <textarea name="reportDescription"></textarea>
    </label> <br>
    <input type="submit" value="Submit report">
</form>

<%
    }
%>

<%--</body>--%>
<%--</html>--%>
