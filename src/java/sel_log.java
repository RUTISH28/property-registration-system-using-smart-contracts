/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import Connection.DB;
import java.awt.image.BufferedImage;
import java.awt.image.DataBuffer;
import java.awt.image.Raster;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.imageio.ImageIO;
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
 * @author admin
 */
@MultipartConfig(maxFileSize = 222892715)
@WebServlet(urlPatterns = {"/sel_log"})
public class sel_log extends HttpServlet {
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
        
        try 
        {
          DB connection=new DB();
          String A_Name=request.getParameter("A_Name");
        String pass=request.getParameter("password");
          String query="select * from sellerregister where A_Name='"+A_Name+"' and pass_word='"+pass+"'";
          ResultSet rs=connection.Select(query);
          if(rs.next())
          { 
              String st=rs.getString("sts");
              if(st.equals("Rejected"))
              {
                  session.setAttribute("msg","Accound Is Rejected!...........");
                  response.sendRedirect("seller.jsp");
              }
              else
                   if(st.equals("BLOCK"))
              {
                  session.setAttribute("msg","ACCOUND IS BLOCK!...........");
                  response.sendRedirect("seller.jsp");
              }
                    else
                   if(st.equals("NO"))
              {
                  session.setAttribute("msg","Approval Is Must!...........");
                  response.sendRedirect("seller_login.jsp");
              }
              else
               {
               int id=rs.getInt("S_ID");
                session.setAttribute("msg","Successfully Login");
                   session.setAttribute("U_Id",id);
                     session.setAttribute("A_Name",A_Name);
                     session.setAttribute("username",rs.getString("username"));
              response.sendRedirect("sellerhome.jsp");
          }
          }
          else{
              response.sendRedirect("seller.jsp");
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


   
    
 



   
 