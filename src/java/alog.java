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
@WebServlet(urlPatterns = {"/alog"})
public class alog extends HttpServlet {
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
        try {
            DB db=new DB();
            ResultSet rf=null;
        
        //String id = request.getParameter("d_id");
       String gmail = request.getParameter("amail");
        //String address = request.getParameter("uadd");
        //String name = request.getParameter("uname");
        //String contact = request.getParameter("uphone");
        String password=request.getParameter("apwd");
        //String image = request.getParameter("ufimage");
        
        
     //   String sql="select * from register where mail='"+gmail+"' and pwd='"+password+"' ";
      // String sql1="select * from register where mail='"+gmail+"' and pwd='"+password+"' ";
        if(gmail.equalsIgnoreCase("admin")&&password.equalsIgnoreCase("admin"))
        {
                              
                                
                                session.setAttribute("amail", gmail);
                                //session.setAttribute("ucate",rf.getString("cate"));
                                session.setAttribute("msg", "Login Successfully");
                                response.sendRedirect("admin.jsp");
                            }
                            else
                            {
                               
                                 session.setAttribute("msg", "Invalid Credintials");
                                response.sendRedirect("admin.jsp");
                            }

        } catch(Exception e) {            
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
