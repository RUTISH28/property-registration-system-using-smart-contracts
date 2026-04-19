/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import Connection.DB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Properties;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang.RandomStringUtils;


/**
 *
 * @author sluser
 */
@WebServlet(name = "mail1", urlPatterns = {"/mail1"})
public class mail1 extends HttpServlet {

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
     public String userName;
     public synchronized  boolean sendMail(String userName, String passWord, String host, String port, String starttls, String auth, boolean debug, String socketFactoryClass, String fallback, String[] to, String[] cc, String[] bcc, String subject, String text)
    {
        this.userName=userName;
 

        Properties props = new Properties();

        //Properties props=System.getProperties();

        props.put("mail.smtp.user", userName);

        props.put("mail.smtp.host", host);

        if (!"".equals(port)) {
            props.put("mail.smtp.port", port);
        }

        if (!"".equals(starttls)) {
            props.put("mail.smtp.starttls.enable", starttls);
        }

        props.put("mail.smtp.auth", auth);

        if (debug) {

            props.put("mail.smtp.debug", "true");

        } else {
            props.put("mail.smtp.debug", "false");

        }

        if (!"".equals(port)) {
            props.put("mail.smtp.socketFactory.port", port);
        }

        if (!"".equals(socketFactoryClass)) {
            props.put("mail.smtp.socketFactory.class", socketFactoryClass);
        }

        if (!"".equals(fallback)) {
            props.put("mail.smtp.socketFactory.fallback", fallback);
        }



        try {

            Session session = Session.getDefaultInstance(props, null);

            session.setDebug(debug);

            MimeMessage msg = new MimeMessage(session);

            msg.setText(text);

            msg.setSubject(subject);

            msg.setFrom(new InternetAddress(userName));

            for (int i = 0; i < to.length; i++) {

                msg.addRecipient(Message.RecipientType.TO, new InternetAddress(to[i]));

            }

            for (int i = 0; i < cc.length; i++) {

                msg.addRecipient(Message.RecipientType.CC, new InternetAddress(cc[i]));

            }

            for (int i = 0; i < bcc.length; i++) {

                msg.addRecipient(Message.RecipientType.BCC, new InternetAddress(bcc[i]));

            }

            msg.saveChanges();

            Transport transport = session.getTransport("smtp");

            transport.connect(host, userName, passWord);

            transport.sendMessage(msg, msg.getAllRecipients());

            transport.close();

            return true;

        } catch (Exception mex) {


            mex.printStackTrace();

            return false;

        }
    }
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String id1=request.getParameter("id1");
                String id2=request.getParameter("id2");
             String usrid="triosjavateam@gmail.com";
		String passwd="qxmascdsgyguogcr";
             String t="";  
               

        try {
           
String otp=RandomStringUtils.randomAlphanumeric(5);
System.out.println(otp);
 DB db1=new DB();
ResultSet rs=db1.Select("select * from register where A_Name='"+id1+"'");
if(rs.next())
{
     t=rs.getString("email");
}
rs.close();
 String[] to = {t};

        String[] cc = {usrid};

        String[] bcc = {usrid};
         
         
         int i=db1.Insert("Update booking1 set key1='"+otp+"' where  id='"+id2+"'");
                 String text="Your One Time Password is: "+otp;
                 
             sendMail(usrid, passwd, "smtp.gmail.com", "465", "true", "true", true, "javax.net.ssl.SSLSocketFactory", "false", to, cc, bcc, "mail", text);
//response.sendRedirect("OtpAuthentication.jsp");
    System.out.println("Update booking1 set key1='"+otp+"' where  id='"+id2+"'");
   response.sendRedirect("OtpAuthentication1.jsp?id="+id2);

    
       
    }
        catch(Exception e)
        {
            e.printStackTrace();
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
