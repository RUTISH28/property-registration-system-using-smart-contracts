<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@ page import="java.sql.*,Connection.DB" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Remove Account</title>
</head>
<body>
<%
    String cid = request.getParameter("id");  // Account ID (CA_Id)
if(cid!=null)
{
    Connection con=null;
PreparedStatement ps = null;
    try {
        // Create DB object and get connection
        DB db = new DB();
         con = db.con;

        // Step 1: Delete the selected account
        String query = "DELETE FROM buyer_account WHERE buyer_acc_id=?";
         ps = con.prepareStatement(query);
        ps.setString(1, cid);
        int rows = ps.executeUpdate();

        if (rows > 0) {
            session.setAttribute("msg", "Account removed successfully!");
        } else {
            session.setAttribute("msg", "Account not found or could not be removed.");
        }

        response.sendRedirect("view_buyer_acc.jsp");

        // Close resources
        ps.close();
      

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
}else {
        out.println("<p style='color:red;'>Invalid account or user session.</p>");
    }
%>
</body>
</html>
