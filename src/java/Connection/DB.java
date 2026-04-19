/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.annotation.WebServlet;
/**
 *
 * @author ELCOT
 */
@WebServlet(name = "DB", urlPatterns = {"/DB"})
public class DB
{ 
    public Connection con;
    PreparedStatement pst;
    public Statement st;
    public ResultSet rs;       
    
    public DB()
    {
        try 
        {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/construct","root","admin");
            System.out.println("Connected");
        }
        catch (Exception e)
        {
            System.out.println("Error Inside DataBase class :\nError in DataBaseConstructor\n" + e);
        }
    }
    public int Insert(String Query)
    {
        int i = 0;
        try 
        {
            con = new DB().con;
            st = con.createStatement();
            i = st.executeUpdate(Query);
            st.close();
            con.close();

        }
        catch (Exception ex)
        {
            System.out.println("Error Insert DataBase class " + ex);

        }
        return i;
    }
    
    public int Update(String Query) {
        int i = 0;
        try {
            con = new DB().con;
            pst = con.prepareStatement(Query);
            i = pst.executeUpdate(Query);
            pst.close();
            con.close();
        } catch (Exception ex) {
            System.out.println("Error Insert DataBase class " + ex);
        }
        return i;
    }

    public ResultSet Select(String Query) 
    {
        try
        {
            if (st != null && con != null) 
            {
                st.close();
                con.close();
            }
            con = new DB().con;
            st = con.createStatement();
            rs = st.executeQuery(Query);

        }
        catch (Exception e) 
        {
            e.printStackTrace(); 
        } 
        finally 
        {
            return rs;
        }
    }
    public static void main(String[] args)
    {
    DB db=new DB();    
    }

    public int Delete(String update_data_contents_set_Doc_Very_Status_) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
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
     *
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
     *
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     *
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>*/
}

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 *
package Connection;

import java.sql.*;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.*;

@WebServlet(name = "DB", urlPatterns = {"/DB"})
public class DB
{ 
    public Connection con;
    public Statement st;
    public ResultSet rs;       
    
    /**
     *
     *
    public DB()
    {
        try 
        {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/image_upload","root","admin");
            System.out.println("Connected");
        }
        catch (Exception e)
        {
            System.out.println("Error Inside DataBase class :\nError in DataBaseConstructor\n" + e);
        }
    }
    public int Insert(String Query)
    {
        int i = 0;
        try 
        {
            con=new DB().con;
            st = con.createStatement();
            i = st.executeUpdate(Query);
            st.close();
            con.close();

        }
        catch (Exception ex)
        {
            System.out.println("Error Insert DataBase class " + ex);

        }
        return i;
    }

    public ResultSet Select(String Query) 
    {
        try
        {
            if (st != null && con != null) 
            {
                st.close();
                con.close();
            }
            con = new DB().con;
            st = con.createStatement();
            rs = st.executeQuery(Query);

        }
        catch (Exception e) 
        {
            e.printStackTrace(); 
        } 
        finally 
        {
            return rs;
        }
    }
    
/*public static void main(String[] args)
{
DB db=new DB();
}*
}*/
