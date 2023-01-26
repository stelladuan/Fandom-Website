<%--
  Created by IntelliJ IDEA.
  User: duanx
  Date: 6/16/2021
  Time: 12:47 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>site statistics | fanworks.site</title>
</head>
<body>
<%@include file="navigation.jsp"%>
<div class="text">
<h1><%="site statistics"%></h1>

<form action="agg1.jsp" method="post">
    word count
    <br><select name = "a">
    <option value="AVG">average word count of all written works</option>
    <option value="MAX">written work with the largest word count</option>
    <option value="MIN">written work with the shortest word count</option>
</select>
    <input type="submit" value="submit">
</form>


<form action="agg2.jsp" method="post">
    fandom likes
    <br><select name = "b">
        <option value="AVG">average likes of a work in each fandom</option>
        <option value="MAX">most likes of a work in each fandom</option>
        <option value="MIN">least likes of a work in each fandom</option>
</select>
    <input type="submit" value="submit">
</form>



<form action="div1.jsp" method="post">
    works liked by all moderators
    <br><select name = "d">
    <option value="WorkID">work id</option>
    <option value="Title">title</option>
</select>
    <input type="submit" value="submit">



</form>
</div>
</body>
</html>
