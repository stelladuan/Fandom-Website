<%--
  Created by IntelliJ IDEA.
  User: markgu
  Date: 6/14/21
  Time: 6:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>view reports | fanworks.site</title>
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
<h1>
    search for reports
</h1>

<form action="ShowReportsServlet" method="post">
    <label> report id
        <input name="reportID" type="number"/>
    </label> <br>
    <label> issue
        <select name="issue">
            <option></option>
            <option>Suspicious or spam</option>
            <option>Abusive or harmful</option>
        </select>
    </label> <br>
    <label> reason
        <select name="reason">
            <option></option>
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
    <label> maximum date (inclusive)
        <input name="maxDate" type="date"/>
    </label> <br>
    <label> minimum date (inclusive)
        <input name="minDate" type="date"/>
    </label> <br>
    <label> reporter's username
        <input name="username" type="text"/>
    </label> <br>
    <label> id of reported work
        <input name="workID" type="number">
    </label> <br><br>

    <input type="submit" value="Go">
    <input type="reset" value="Reset conditions">
</form>
</div>
</body>
</html>
