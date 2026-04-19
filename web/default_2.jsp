<%-- 
    Document   : default_1
    Created on : 16 Oct, 2025, 11:55:10 AM
    Author     : Admin
--%>

<!DOCTYPE html>
<html>
<html>
<%@ page import="java.sql.*,Connection.DB" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>



<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
    // Get session user id
    Integer seller_id = (Integer) session.getAttribute("U_Id");
    String accid = request.getParameter("id");

  
    if (seller_id != null && accid != null && !accid.isEmpty()) {
        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement ps1 = null;
        try {
            // Initialize DB object
            DB db = new DB();
            con = db.con; // Using the public 'con' field from your DB class

            // 1️⃣ Set all accounts to NO for the user
            String query = "UPDATE seller_account SET status='NO' WHERE seller_id=?";
            ps = con.prepareStatement(query);
            ps.setInt(1, seller_id);
            ps.executeUpdate();

            // 2️⃣ Set selected account to YES
            String query1 = "UPDATE seller_account SET status='YES' WHERE seller_acc_id=?";
            ps1 = con.prepareStatement(query1);
            ps1.setString(1, accid);
            ps1.executeUpdate();

            // Success message
            session.setAttribute("msg", "Default account updated successfully!");
            response.sendRedirect("view_seller_acc.jsp");
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error updating account: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            // Close resources safely
            try { if(ps != null) ps.close(); } catch(Exception e){}
            try { if(ps1 != null) ps1.close(); } catch(Exception e){}
            try { if(con != null) con.close(); } catch(Exception e){}
        }
    } else {
        out.println("<p style='color:red;'>Invalid account or user session.</p>");
    }
%>
        
        
    </body>
</html>
