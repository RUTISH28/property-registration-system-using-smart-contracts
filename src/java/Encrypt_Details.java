/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import Connection.DB;
import Connection.Encryption;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.InvalidAlgorithmParameterException;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import sun.misc.BASE64Encoder;

/**
 *
 * @author Admin1
 */
@WebServlet(urlPatterns = {"/Encrypt_Details"})
public class Encrypt_Details extends HttpServlet {

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
         String S_ID=request.getParameter("S_ID");
         String S_Name=request.getParameter("S_Name");
         String H_NO=request.getParameter("H_NO");
         String street=request.getParameter("street");
         String U_NAME=request.getParameter("U_NAME");
         String U_NUMBER=request.getParameter("U_NUMBER");
         String U_MAIL=request.getParameter("U_MAIL");
         String STS=request.getParameter("STS");
         String B_fess=request.getParameter("B_fess");
         String A_ACC=request.getParameter("A_ACC");
         String C_Type=request.getParameter("C_Type");
         String U_ACC=request.getParameter("U_ACC");
         String[] values=request.getParameterValues("S_ID");
         String[] formval={"S_Name","street","U_NAME","U_NUMBER","U_MAIL","STS","B_fess","A_ACC","C_Type","U_ACC",};
    int j=0;
     Encryption ed=new Encryption();
    for(String str: values)
          {
              System.out.println(str);
              if(str.equals("S_Name"))
              {
                  
                  S_Name=ed.Encryption1(S_Name);
                     
              }
              if(str.equals("street"))
              {
                  
                  street=ed.Encryption1(street);
                     
              }
              if(str.equals("U_NAME"))
              {
                
                  U_NAME=ed.Encryption1(U_NAME);
                     
              }
              if(str.equals("U_NUMBER"))
              {
                 
                  U_NUMBER=ed.Encryption1(U_NUMBER);
                     
              }
              if(str.equals("U_MAIL"))
              {
                  
                  U_MAIL=ed.Encryption1(U_MAIL);
                     
              }
              if(str.equals("STS"))
              {
                  
                  STS=ed.Encryption1(STS);
                     
              }
              if(str.equals("B_fess"))
              {
                  
                  B_fess=ed.Encryption1(B_fess);
                     
              }
               if(str.equals("A_ACC"))
              {
                  
                  A_ACC=ed.Encryption1(A_ACC);
                     
              }
              if(str.equals("C_Type"))
              {
                  
                  C_Type=ed.Encryption1(C_Type);
                     
              }
               if(str.equals("U_ACC"))
              {
                  
                  U_ACC=ed.Encryption1(U_ACC);
                     
              }
              }
          
        
        DB db1=new DB();
        int id1=Integer.parseInt(S_ID);
    
        String query1="insert into bookingss values('"+S_ID+"','"+S_Name+"','"+H_NO+"','"+street+"','"+U_NAME+"','"+U_NUMBER+"','"+U_MAIL+"','"+STS+"','"+B_fess+"','"+A_ACC+"','"+C_Type+"','"+U_ACC+"') ";
         String query="Select * from bookingss where S_ID='"+id1+"'";
         ResultSet rsd=db1.Select(query);
         if(rsd.next())
         {
             session.setAttribute("msg","All ready Phr Encrypted");
                   response.sendRedirect("Phr_Information.jsp");
         }
         else
         {
                    int i=db1.Insert(query1);
                    if(i>0)
                    {
                         session.setAttribute("msg","Add PHR Successfully Added");
                   response.sendRedirect("yes.jsp");
                    }
         }
           
          
        }
       catch(Exception e)
       {
           out.println(e);
       } finally {            
          
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
