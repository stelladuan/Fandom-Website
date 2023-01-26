<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
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

    String chapterNum = "1";
    if (request.getAttribute("chapter_num") != null) {
        chapterNum = (String) request.getAttribute("chapter_num");
    }

    if (workID == null) {
        String[] identifiers = request.getParameter("ID").split("-");
        workID = identifiers[0];
        chapterNum = identifiers[1];
    }
%>

<head>
    <%
        try {
//            Class.forName("oracle.jdbc.driver.OracleDriver");
//            Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1522:stu", "ora_zifgu", "a39585740");
            Connection connection = DataHandler.getConnection();
            Statement statement = connection.createStatement();
            String query = "SELECT * FROM WORK, WRITTENWORK, CHAPTER " +
                    "WHERE WORK.WORKID = " + workID + " AND " +
                    "WORK.WORKID = WRITTENWORK.WORKID AND " +
                    "WORK.WORKID = CHAPTER.WORKID AND " +
                    "CHAPTERNUMBER = " + chapterNum;
            ResultSet result = statement.executeQuery(query);
            while (result.next()) {
    %>

    <title><%=result.getString(2)%> - Chapter <%=chapterNum%> | fanworks.site</title>
    <style>
        .btn {
            text-align: center;
        }
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
        .worktext {
            padding: 0 300px 50px 300px;
        }
        .pagination {
            background-color: white;
            font-family: "Open Sans";
            font-size: 11pt;
            padding: 7px 10px;
            border: 1px solid #bdbdbd;

            text-decoration: none;
            cursor: pointer;
            display: inline-block;
            transition: 0.3s;
            border-radius: 10px;
        }
        .pagination:hover {
            background-color: #e9e9e9;
            cursor: pointer;
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
        String query = "SELECT * FROM WORK, WRITTENWORK, CHAPTER " +
                "WHERE WORK.WORKID = " + workID + " AND " +
                "WORK.WORKID = WRITTENWORK.WORKID AND " +
                "WORK.WORKID = CHAPTER.WORKID AND " +
                "CHAPTERNUMBER = " + chapterNum;
        ResultSet result = statement.executeQuery(query);
        while (result.next()) {
%>

<div class="text">
    <h2 class="title"><%=result.getString(2)%></h2>
    <div class="author"><br>by <%=result.getString(4)%></div>
<div class="summary"><b>summary</b>
    <div class="hr"><hr></div>
    <%=result.getString(3)%></div>
<div class="worktext"><%=result.getString(13)%></div>

<div class="btn">
    <form action="writtenwork.jsp" method="get" id="changeChapter"></form>
    <%
        int work_id = Integer.parseInt(result.getString(1));
        int chapter_number = Integer.parseInt(result.getString(12));
        if (DataHandler.checkIfChapterExists(work_id, (chapter_number - 1))) {
            %>
            <button class="pagination" type="submit" form="changeChapter" name="ID" value="<%=work_id%>-<%=(chapter_number - 1)%>">previous chapter</button>
        <%
        }
        if (DataHandler.checkIfChapterExists(work_id, (chapter_number + 1))) {

        %>
            <button class="pagination" type="submit" form="changeChapter" name="ID" value="<%=work_id%>-<%=(chapter_number + 1)%>">next chapter</button>
        <%
        }%>
</div>

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
    <jsp:param name="isWrittenWork" value="true"/>
</jsp:include></div>
</div>
</body>
</html>
