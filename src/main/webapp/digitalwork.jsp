<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="project.CPSC304_Project.DataHandler" %><%--
  Created by IntelliJ IDEA.
  User: Helen Yu
  Date: 2021-06-13
  Time: 2:50 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<%
    String workID = request.getParameter("workID");
    if (workID == null) {
        workID = (String) request.getAttribute("workID");
    }
%>

<head>
    <%
        try {
//            Class.forName("oracle.jdbc.driver.OracleDriver");
//            Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1522:stu", "ora_zifgu", "a39585740");
            Connection connection = DataHandler.getConnection();
            Statement statement = connection.createStatement();
            String query = "SELECT * FROM WORK, DIGITALWORK " +
                    "WHERE WORK.WORKID = " + workID + " AND " +
                    "WORK.WORKID = DIGITALWORK.WORKID";
            ResultSet result = statement.executeQuery(query);
            while (result.next()) {
    %>

    <title><%=result.getString(2)%> | fanworks.site</title>
    <style>
        .title {
            padding-top: 30px;
            margin: 0;
            text-align: center;
        }
        .author {
            padding: 0;
            text-align: center;
            margin-top: -20px;
        }
        .summary {
            padding: 75px 500px;
        }
        hr {
            padding: 0;
            margin: 0;
            background-color: #bdbdbd;
        }
        .hr {
            padding-top: 10px;
            padding-bottom: 20px;
        }
        img {
            display: block;
            margin-left: auto;
            margin-right: auto;
            width: 50%;
            padding-bottom: 150px;
        }
        .text {
            padding: 0 250px;
        }
        .useractivity {
            padding: 75px 300px;
        }
    </style>

    <%
            }
//            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
</head>
<body>
<%@include file="/navigation.jsp"%>

<%
    try {
//        Class.forName("oracle.jdbc.driver.OracleDriver");
//        Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1522:stu", "ora_zifgu", "a39585740");
        Connection connection = DataHandler.getConnection();
        Statement statement = connection.createStatement();
        String query = "SELECT * FROM WORK, DIGITALWORK " +
                "WHERE WORK.WORKID = " + workID + " AND " +
                "WORK.WORKID = DIGITALWORK.WORKID";
        ResultSet result = statement.executeQuery(query);
        while (result.next()) {
%>

<div class="text">
    <h2 class="title"><%=result.getString(2)%></h2>
    <div class="author"><br>by <%=result.getString(4)%></div>
    <div class="summary"><b>summary</b>
        <div class="hr"><hr></div>
        <%=result.getString(3)%></div>
<img src="<%=result.getString(8)%>" alt="Image of <%=result.getString(2)%>">

<%
        }
//        connection.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<div class="useractivity">
<jsp:include page="add_activity_form.jsp">
    <jsp:param name="workID" value="<%=workID%>"/>
    <jsp:param name="isWrittenWork" value="false"/>
</jsp:include>
</div></div>
</body>
</html>