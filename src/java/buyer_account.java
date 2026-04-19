import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/buyer_account")
public class buyer_account extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Donor details (hidden fields)
            int buyer_id = Integer.parseInt(request.getParameter("buyer_id"));
            String buyer_name = request.getParameter("buyer_name");
            String buyer_email = request.getParameter("buyer_mail");

            // Card details
            String cardType = request.getParameter("Card_Type");
            String cardBrand = request.getParameter("cards");
            String cardHolder = request.getParameter("Cardholder_Name");
            String cardNumber = request.getParameter("Card_Number");
            String expireDate = request.getParameter("Expire_Date");
            String cvv = request.getParameter("Cvv");
            String pin = request.getParameter("Pin");
            String buyer_aadhar=request.getParameter("buyer_aadhar");

            // Load Driver
            Class.forName("com.mysql.jdbc.Driver");

            // Connect to DB
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/construct", "root", "admin");

            // 1. Check if card number already exists
            String checkSql = "SELECT * FROM buyer_account WHERE Card_Number = ?";
            PreparedStatement checkStmt = con.prepareStatement(checkSql);
            checkStmt.setString(1, cardNumber);
            ResultSet rsCheck = checkStmt.executeQuery();

            if (rsCheck.next()) {
                // Card number exists
                HttpSession session = request.getSession();
                session.setAttribute("msg", "This card number is already in use. Please use another card.");
                response.sendRedirect("buyer_account.jsp");
                con.close();
                return;
            }

            // 2. Insert new account
         String sql = "INSERT INTO buyer_account VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
PreparedStatement ps = con.prepareStatement(sql);

ps.setInt(1, 0); // auto increment
ps.setInt(2, buyer_id);
ps.setString(3, buyer_email);
ps.setString(4, cardType);
ps.setString(5, cardBrand);
ps.setString(6, cardHolder);
ps.setString(7, cardNumber);
ps.setString(8, expireDate);
ps.setString(9, cvv);
ps.setString(10, pin);
ps.setInt(11, 1000); // default amount
ps.setString(12, "NO"); // status
ps.setString(13, buyer_aadhar);

            int row = ps.executeUpdate();

            HttpSession session = request.getSession();
            if (row > 0) {
                session.setAttribute("msg", "Account added successfully!");
                response.sendRedirect("buyer_accounts.jsp");
            } else {
                session.setAttribute("msg", "Failed to add account. Try again!");
                response.sendRedirect("buyer_account.jsp");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("msg", "Error: " + e.getMessage());
            response.sendRedirect("buyer_account.jsp");
        }
    }
}
