<%-- 
    Document   : new
    Created on : Apr 3, 2021, 3:54:17 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
        String id=request.getParameter("id");
        %>
        
        <a href="usrhome.jsp">Go Back to Home</a>
        
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <img height="200px" src="new1.jsp?id=<%=id %>">
                </div>   
            </div>
        </div>
        
    </body>
</html>
