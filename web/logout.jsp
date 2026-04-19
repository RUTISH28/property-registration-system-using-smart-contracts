<%-- 
    Document   : logout
    Created on : Mar 20, 2021, 10:58:28 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <% session.invalidate();
    response.sendRedirect("index.jsp");
     %>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
