/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import Connection.DB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author suganya
 */

@MultipartConfig(maxFileSize = 222892715)
@WebServlet(urlPatterns = {"/account"})
public class account extends HttpServlet {

        private String extractFN(Part part) 
     {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length()-1);
            }
        }
        return "";
    }
    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session=request.getSession(true);
        String Acc=request.getParameter("Acc");
       String ifsc=request.getParameter("ifsc");
       String A_HName=request.getParameter("A_HName");
       try {
             DB db1=new DB();
             String query="select Acc from admin1 where Acc='"+Acc+"'";
             ResultSet rs=db1.Select(query);
             if(rs.next())
             {
                session.setAttribute("msg", "Already ACCOUNT NO Exits");
                session.setAttribute(Acc, "Acc");
                
                response.sendRedirect("admin_home.jsp");
             }
             else
             {
                 int  i = db1.Insert("insert into admin1(Acc, ifsc, A_HName, Amount) values ('"+Acc+"','"+ifsc+"','"+A_HName+"','0')");
                if(i>0)
                {
                 session.setAttribute("msg", "Successfully ACCOUNT NO ADD");
                 response.sendRedirect("admin_home.jsp");
                } 
             }
       }
             catch(Exception ex)
             {
                 out.println(ex);
             }
        finally {            
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}