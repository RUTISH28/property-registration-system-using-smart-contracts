/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import Connection.DB;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author suganya
 */


@WebServlet(urlPatterns = {"/reg"})
public class reg extends HttpServlet {
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
            throws ServletException, IOException, FileUploadException, ClassNotFoundException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session=request.getSession(true);
       
        try {
         
            
            String A_Name="",username="",email="",Gender="",U_Pass="",con_pass="",dob="",mobile="",city="",address="";
            String saveFile="",l="",ln="",mname="",dob1="",celno="",typ="";
                String sex="",voterno="",mail="",bg="",pstreet="",cstreet="",parea="",carea="",pcity="",ccity="";
                   String ppinno="",cpinno="",pass="",repass="";
            int fileidnum=0,downloadcount=0,vc=0;
           // String contentType = request.getContentType();
            // Create a factory for disk-based file items
            DiskFileItemFactory factory = new DiskFileItemFactory();

// Set factory constraints
            factory.setSizeThreshold(4012);
//factory.setRepository("c:");

// Create a new file upload handler
            ServletFileUpload upload = new ServletFileUpload(factory);

// Set overall request size constraint
            //upload.setSizeMax(10024);

// Parse the request
            List items = null;
            try {
                items = upload.parseRequest(request);
            } catch (FileUploadException e) {
                e.printStackTrace();
            }
            byte[] data = null;
            String fileName = null;
// Process the uploaded items
            Iterator iter = items.iterator();
            while (iter.hasNext()) {
                FileItem item = (FileItem) iter.next();

                if (item.isFormField()) {
                    //processFormField(item);

                    String name = item.getFieldName();
                    String value = item.getString();

                    if (name.equalsIgnoreCase("A_Name")) {
                        A_Name = value;
                        System.out.println("A_Name" + A_Name);
                    } 
                    
                  else  if (name.equalsIgnoreCase("username")) {
                        username = value;
                        System.out.println("username" + username);
                    } 
                  
                  else  if (name.equalsIgnoreCase("email")) {
                        email = value;
                        System.out.println("email" + email);
                    }
                  else  if (name.equalsIgnoreCase("Gender")) {
                        Gender = value;
                        System.out.println("Gender" + Gender);
                    }
                  else  if (name.equalsIgnoreCase("U_Pass")) {
                        U_Pass = value;
                        System.out.println("U_Pass" + U_Pass);
                    }
                  else  if (name.equalsIgnoreCase("con_pass")) {
                        con_pass = value;
                        System.out.println("con_pass" + con_pass);
                    }
                   else  if (name.equalsIgnoreCase("dob")) {
                        dob = value;
                        System.out.println("dob" + dob);
                    }
                   
                   else  if (name.equalsIgnoreCase("mobile")) {
                        mobile = value;
                        System.out.println("mobile" + mobile);
                    }
                   else  if (name.equalsIgnoreCase("city")) {
                        city = value;
                        System.out.println("city" + city);
                    }
                     else  if (name.equalsIgnoreCase("address")) {
                        address = value;
                        System.out.println("address" + address);
                    }
                    else {
                        System.out.println("ERROR");
                    }
                } else {
                    data = item.get();
                    fileName = item.getName();
                }
            }
            saveFile = fileName;
                    String path1 = request.getSession().getServletContext().getRealPath("/");
              // String patt=path.replace("\\build", "");
               
               String strPath1 = path1+"\\"+saveFile;
            File ff1 = new File(strPath1);
            FileOutputStream fileOut1 = new FileOutputStream(ff1);
            fileOut1.write(data, 0, data.length);
            fileOut1.flush();
            fileOut1.close();
        out.println(saveFile);
        /////////////////////////////////////////////////////////

FileInputStream fis11 = null;
File image1 = null;
//FileInputStream fis11 = null;
File image11 = null;
	Connection con7=null;
	PreparedStatement st7=null;
      
       
PreparedStatement st11=null;

image1 = new File(strPath1);
fis11 = new FileInputStream(image1);
        
       

     Class.forName("com.mysql.jdbc.Driver");
     con7 = DriverManager.getConnection("jdbc:mysql://localhost:3306/construct","root","admin");
  
 
   
     
         
String query="Select * from register where A_Name='"+A_Name+"' or email='"+email+"'";
System.out.println(query);
            Statement st=con7.createStatement();
ResultSet rs=st.executeQuery(query);

if(rs.next())
{
    
   session.setAttribute("msg","Already exist Please Change The Values");
      response.sendRedirect("user.jsp");  
}
else
{
        st7 =con7.prepareStatement("insert into register values (?,?,?,?,?,?,?,?,?,?,?,'NO',?)");

st7.setInt(1,0);
st7.setString(2,A_Name);
st7.setString(3,username);
st7.setString(4,email);
st7.setString(5,Gender);
st7.setString(6,U_Pass);
st7.setString(7,con_pass);
st7.setString(8,dob);
st7.setString(9,mobile);
st7.setString(10,city);
st7.setString(11,address);
if(fileName != "")
        st7.setBinaryStream(12, (InputStream)fis11, (int)(image1.length()));
else
    st7.setBinaryStream(12, null);

      int i =st7.executeUpdate();
      session.setAttribute("msg","Registered Successfully Please Login");
      response.sendRedirect("user_login.jsp");
}   
      
        }
        catch(Exception e)
        {
       out.println(e);
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
        try {
            processRequest(request, response);
        } catch (FileUploadException ex) {
            Logger.getLogger(flatupload.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(flatupload.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(flatupload.class.getName()).log(Level.SEVERE, null, ex);
        }
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
        try {
            processRequest(request, response);
        } catch (FileUploadException ex) {
            Logger.getLogger(flatupload.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(flatupload.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(flatupload.class.getName()).log(Level.SEVERE, null, ex);
        }
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
