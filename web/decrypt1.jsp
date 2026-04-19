
<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
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
           String otp=request.getParameter("otp");
           DB db=new DB();
           ResultSet rs=db.Select("select * from booking1 where id='"+id+"' and key1='"+otp+"'");
           if(rs.next())
           {
               session.setAttribute("msg","Verified");
               response.sendRedirect("view_1.jsp?id="+rs.getString("A_Name"));
           }
           else
           {
               session.setAttribute("msg","invalid otp");
               response.sendRedirect("bookingdetails.jsp");
           }
            %>
    </body>
</html>
