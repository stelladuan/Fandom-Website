<%--
  Created by IntelliJ IDEA.
  User: markgu
  Date: 6/16/21
  Time: 12:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>welcome | fanworks.site</title>
</head>
<body>
<%@include file="navigation.jsp"%>
<div class="text">
    <h2>Welcome!</h2>
    The final project is a web application with basic functionality for a user to create, manage, search for, and interact with written or digital fanworks, created using JDBC, Java Servlet/JSP, and HTML/CSS technologies.
    <br><br>
    The website is able to display a list of all fanworks, which can be filtered by fandoms, characters, and relationships. Individual works can be viewed, including images (for digital works) and chapters (for written works). A person using the site may sign up and log in; when logged in, they have access to interfaces to post written or digital (image-based) works, and delete or edit the information of works they have posted. When viewing others' works, a logged-in user can like, comment on, bookmark, or report the work.
    <br><br>
    Any visitor to the site is able to search for a user's likes, comments, and public bookmarks. Furthermore, the site displays summary statistics about the works it hosts, such as word count averages, the number of likes received, and works that have been liked by all users who are moderators.
    <br><br>
    Certain site users, who have moderator privileges in addition to regular user privileges, can see all reports and choose to approve or deny them. Moderators are also able to see the usernames, emails, etc. of all users on the site.
</div>
</body>
</html>
