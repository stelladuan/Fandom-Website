<link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Open+Sans"/>
<link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Lora"/>
<style>
    ul {
        background-color: #5485f5;
        list-style-type: none;
        top: 0;
        margin: 0;
        padding: 0 57px 0 57px;
        overflow: hidden;
        position: -webkit-sticky;
        position: sticky;
    }
    li {
        float: left;
    }
    li a {
        font-family: "Open Sans";
        font-size: 11pt;
        color: white;
        text-decoration: none;

        padding: 8px 22px 8px 22px;
        cursor: pointer;
        display: inline-block;
        transition: 0.3s;
    }
    li a:hover {
        color: white;
        background-color: #536ded;
        border: none;

        cursor: pointer;
    }

    .header {
        font-family: sans-serif;
        font-size: 26pt;
        color: #5485f5;
        font-weight: bold;
        text-decoration: none;

        width: auto;
        float: left;
        padding: 50px 12px 0 75px;
        margin-bottom: -11px;
    }

    .header a {
        color: #5485f5;
        text-decoration: none;
    }

    .subheading {
        font-family: "Open Sans";
        font-size: 11pt;
        color: black;

        width: auto;
        padding: 64px 0 0 0;
        margin-bottom: -11px;
    }

    .subheading2 {
        font-family: "Open Sans";
        font-size: 11pt;
        color: black;

        width: auto;
        float: right;
        padding-right: 30px;
        margin-top: -9px;
    }
    .subheading2 a {
        font-family: "Open Sans";
        font-size: 11pt;
        font-weight: bold;
        color: #5485f5;
        text-decoration: none;
        padding-right: 50px;

        cursor: pointer;
        display: inline-block;
        transition: 0.3s;
    }
    .subheading2 a:hover {
        color: #182ac9;
        cursor: pointer;
    }

    .text {
        font-size: 11pt;
        padding: 30px 80px 50px;
    }

    body {
        font-family: "Open Sans";
        margin: 0;
    }
    body::-webkit-scrollbar {
        display: none;
    }

</style>

<% boolean isLoggedIn = (session.getAttribute("username") != null);%>

<div>
    <div class="header"><a href="${pageContext.request.contextPath}/index.jsp">fanworks.site</a></div>
    <div class="subheading">by fans, for fans</div>
    <%  if (isLoggedIn) {  %>
    <div class="subheading2">welcome back,
        <a href="${pageContext.request.contextPath}/dashboard.jsp"><%=session.getAttribute("username").toString()%>!</a></div>
    <%  }  %>
</div>
<br>
<ul>
    <li><a href="${pageContext.request.contextPath}/displayworks">all works</a></li>
    <li><a href="${pageContext.request.contextPath}/dashboard.jsp">dashboard</a></li>
    <li><a href="${pageContext.request.contextPath}/user_activity.jsp">user activity</a></li>
    <li><a href="${pageContext.request.contextPath}/WorkStats.jsp">site statistics</a></li>
<%  if (isLoggedIn) {  %>
        <li style="float:right"><a href="${pageContext.request.contextPath}/LogoutServlet">log out</a></li>
<%  } else {  %>
        <li style="float:right"><a href="${pageContext.request.contextPath}/sign_up.jsp">sign up</a></li>
        <li style="float:right"><a href="${pageContext.request.contextPath}/login.jsp">log in</a></li>
<%  }%>
</ul>