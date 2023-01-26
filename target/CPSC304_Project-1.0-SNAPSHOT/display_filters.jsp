<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.xml.crypto.Data" %>
<%@ page import="project.CPSC304_Project.DataHandler" %><%--
  Created by IntelliJ IDEA.
  User: Helen Yu
  Date: 2021-06-13
  Time: 1:55 a.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <title>Work Library</title>
    <style>
        .filter {
            background-color: #e9e9e9;
            border: 1px solid #bdbdbd;
            padding: 10px 30px 20px 30px;
            margin-top: 67px;
            float: right;
        }
        select {
            font-family: "Open Sans";
            font-size: 11pt;
            border: 1px solid #bdbdbd;
            border-radius: 10px;
            width: 450px;
            height: 35px;
            padding-left: 10px;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;       /* Remove default arrow */
        }
        input[type=submit] {
            background-color: transparent;
            font-family: "Open Sans";
            font-size: 11pt;
            border: 1px;
            padding: 7px 10px 6px 10px;
            cursor: pointer;
        }

        .filterbtn {
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

        .filterbtn:hover {
            background-color: #e9e9e9;
            cursor: pointer;
        }

        .filterbtn a {
            text-decoration: none;
        }

        .label {
            font-family: "Open Sans";
            font-size: 11pt;
            padding-bottom: 5px;
        }

        hr {
            height: 1px;
            border: none;
            margin-bottom: 20px;
            background-color: #bdbdbd;
        }
        .hrh2 {
            height: 1px;
            border: none;
            margin-bottom: 20px;
            background-color: white;
        }
    </style>
</head>
<body>

<div class="filter">
<h2>filters</h2>
    <hr class="hrh2">
<form action="displayworks" method="get">
    <div class="label"><label for="fandoms">Fandoms</label><br></div>
    <select id="fandoms" name="work_filter" value="var">
    <%
    try {
        ResultSet fandoms = DataHandler.getFandoms();
        while (fandoms.next()) {
    %>
    <option><%=fandoms.getString(1)%></option>
    <%
        }
        fandoms.close();
    %>
</select>
    <input type="hidden" name="filter_type" value="fandom">
    <div class="filterbtn"><input type="submit" value="submit"></div>
</form>

<form action="displayworks" method="get">
    <div class="label"><label for="relationships">Relationships</label><br></div>
    <select id="relationships" name="work_filter" value="var">
    <%
        ResultSet relationships = DataHandler.getRelationships();
        while (relationships.next()) {
    %>
    <option><%=relationships.getString(1)%></option>
    <%
        }
        relationships.close();
    %>
</select>
    <input type="hidden" name="filter_type" value="relationship">
    <div class="filterbtn"><input type="submit" value="submit"></div>
</form>

<form action="displayworks" method="get">
    <div class="label"><label for="characters">Characters</label><br></div>
    <select id="characters" name="work_filter" value="var">
    <%
        ResultSet characters = DataHandler.getCharacters();
        while (characters.next()) {
    %>
    <option><%=characters.getString(1)%> (<%=characters.getString(2)%>)</option>
    <%
        }
        characters.close();
    %>
</select>
    <input type="hidden" name="filter_type" value="character">
    <div class="filterbtn"><input type="submit" value="submit"></div>
</form>

    <%
    } catch (Exception e) {
        e.printStackTrace();
    }
    %>
</div>
</body>
</html>
