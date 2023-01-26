<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: Helen Yu
  Date: 2021-06-16
  Time: 7:09 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%
        String filterType = request.getParameter("filter_type");
        String filterName = request.getParameter("work_filter");

        if (filterName == null) {
            filterName = "all works";
        } else {
            filterName = "works including the " + filterType + " \"" + filterName + "\"";
        }
    %>
    <title><%=filterName%> | fanworks.site</title>
    <style>
        .work {
            padding: 5px 20px 15px 20px;
            border: 1px solid #bdbdbd;
            width: 900px;
        }

        .work input[type=submit] {
            background-color: transparent;
            font-family: "Open Sans";
            font-size: 11pt;
            font-weight: bold;
            color: #5485f5;
            border: 0;
            padding: 0;
            margin: 0;
            cursor: pointer;
            float: left;

            text-decoration: none;
            cursor: pointer;
            display: inline-block;
            transition: 0.3s;
        }
        .work input[type=submit]:hover {
            color: #182ac9;
            cursor: pointer;
        }

        b {
            font-weight: normal;
            color: #5485f5;
        }

        .btnwrapper {
            background-color: white;
            font-family: "Open Sans";
            font-size: 11pt;
            padding: 0;
            border: 1px solid #bdbdbd;
            border-radius: 10px;

            text-decoration: none;
            cursor: pointer;
            display: inline-block;
            transition: 0.3s;
        }

        .btnwrapper:hover {
            background-color: #e9e9e9;
            cursor: pointer;
        }

        .btnwrapper input[type=submit] {
            background-color: transparent;
            font-family: "Open Sans";
            font-size: 11pt;
            font-weight: normal;
            color: black;
            border: 1px;
            padding: 7px 10px 6px 10px;
            cursor: pointer;
        }

        .brbuttons {
            line-height: 5px;
        }
    </style>
</head>
<body>

<%@include file="/navigation.jsp"%>

<div class="text">

    <%@include file="/display_filters.jsp"%>

<h2><%=filterName%></h2>

<%
    String username = null;
    if (session.getAttribute("username") != null) {
        username = session.getAttribute("username").toString();
    }

    ResultSet filteredWorks = (ResultSet) request.getAttribute("filtered_works");
    while (filteredWorks.next()) {
        String description = filteredWorks.getString(3);
        if (description == null) {
            description = "";
        }
        %>
<div class="work">
<p>
    <form action="<%=filteredWorks.getString(6)%>work.jsp" method="get">
        <input type="hidden" name="workID" value="<%=filteredWorks.getString(1)%>">
        <input type="submit" value="<%=filteredWorks.getString(2)%>"></form>&nbsp;by <b><%=filteredWorks.getString(4)%></b><br>
    posted on <%=filteredWorks.getString(5)%>
    <blockquote><%=description%></blockquote>
    <br class="brbuttons">
    <%
    if (username != null && username.equals(filteredWorks.getString(4))) {
    %>

    <div class="btnwrapper">
    <form action="edit_work.jsp" method="get">
    <input type="hidden" id="workID" name="workID" value="<%=filteredWorks.getString(1)%>">
    <input type="hidden" id="work_type" name="work_type" value="<%=filteredWorks.getString(6)%>">
    <input type="submit" value="edit"></form></div>

    <%
    if (filteredWorks.getString(6).equals("written")) {
    %>

    <div class="btnwrapper">
    <form action="add_chapter.jsp" method="get">
    <input type="hidden" id="workID_chapter" name="workID_chapter" value="<%=filteredWorks.getString(1)%>">
    <input type="hidden" id="workchapter_type" name="workchapter_type" value="<%=filteredWorks.getString(6)%>">
    <input type="hidden" id="author_chapter" name="author_chapter" value="<%=filteredWorks.getString(4)%>">
    <input type="submit" value="add chapter"></form></div>

    <%
    }
    %>

    <div class="btnwrapper">
    <form action="deletework" method="post">
    <input type="hidden" id="work_ID" name="work_ID" value="<%=filteredWorks.getString(1)%>">
    <input type="hidden" id="author" name="author" value="<%=filteredWorks.getString(4)%>">
    <input type="submit" value="delete"></form></div>
<%
    }
%>
</div>
<br>

<%
    }
%>
</div>
</body>
</html>
