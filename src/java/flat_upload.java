import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.*;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

@WebServlet("/flat_upload")
public class flat_upload extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        response.setContentType("text/html;charset=UTF-8");

        try {

            String S_Name="",S_Number="",S_Addr="",city="",area="",street="";
            String rent="",advance="",FType="",H_NO="",S_MAIL="",A_Name="";

            InputStream imageStream = null;
            InputStream documentStream = null;

            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);

            List<FileItem> items = upload.parseRequest(request);

            for(FileItem item : items){

                if(item.isFormField()){

                    String name = item.getFieldName();
                    String value = item.getString();

                    if(name.equals("S_Name")) S_Name=value;
                    if(name.equals("S_Number")) S_Number=value;
                    if(name.equals("S_Addr")) S_Addr=value;
                    if(name.equals("city")) city=value;
                    if(name.equals("area")) area=value;
                    if(name.equals("street")) street=value;
                    if(name.equals("rent")) rent=value;
                    if(name.equals("advance")) advance=value;
                    if(name.equals("FTYPE")) FType=value;
                    if(name.equals("H_NO")) H_NO=value;
                    if(name.equals("S_MAIL")) S_MAIL=value;
                    if(name.equals("A_Name")) A_Name=value;

                }

                else{

                    if(item.getFieldName().equals("Image")){
                        imageStream = item.getInputStream();
                    }

                    if(item.getFieldName().equals("document")){
                        documentStream = item.getInputStream();
                    }

                }
            }

            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/construct","root","admin");

            PreparedStatement check = con.prepareStatement(
                    "select * from flat_house where H_NO=?");
            check.setString(1,H_NO);

            ResultSet rs = check.executeQuery();

            if(rs.next()){

                session.setAttribute("msg","House already exists");
                response.sendRedirect("House.jsp");

            }else{

PreparedStatement ps = con.prepareStatement(
"insert into flat_house values (?,?,?,?,?,?,?,?,?,?,?,?,'NO',?,1000,?,'NO',?)");

                ps.setInt(1,0);
                ps.setString(2,S_Name);
                ps.setString(3,S_Number);
                ps.setString(4,S_Addr);
                ps.setString(5,city);
                ps.setString(6,area);
                ps.setString(7,street);
                ps.setString(8,rent);
                ps.setString(9,advance);
                ps.setBlob(10,imageStream);
                ps.setString(11,FType);
                ps.setString(12,H_NO);
                ps.setBlob(15,documentStream);
                ps.setString(13,S_MAIL);
                ps.setString(14,A_Name);

                ps.executeUpdate();

                session.setAttribute("msg","Successfully Uploaded House");
                response.sendRedirect("House.jsp");
            }

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}