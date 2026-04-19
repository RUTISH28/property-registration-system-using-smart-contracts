<%-- 
    Document   : servlet
    Created on : Jan 4, 2012, 10:56:41 PM
    Author     : vinodth
--%>
<%@page import="Connection.DB" 
        import="java.sql.*"
        %>
<%@page import="java.sql.*"
         import="java.io.*" 
         import="java.util.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<% 
    
    DB db=new DB();
    ResultSet rs;
    Statement st;
    
    
    try{
            String id=request.getParameter("id");
            InputStream sImage;
            System.out.println("select flowp from design where iddes='"+id+"'");
            out.clear();
            st = db.con.createStatement();
            rs = st.executeQuery("select flowp from design where iddes='"+id+"'");
            while(rs.next()) 
            {
                byte[] bytearray = new byte[1048576];
                int size=0;
                sImage = rs.getBinaryStream(1);
                response.reset();
                response.setContentType("file/*");
                while((size=sImage.read(bytearray))!= -1 )
                {
                    response.getOutputStream().write(bytearray,0,size);
                    sImage.close();
                }
            }
           // db.con.close();
           // st.close();
           // rs.close();
    }
    catch(Exception e){}
    
    try{
            String id=request.getParameter("bid");
            InputStream sImage;
            System.out.println("select img from scity where idscity='"+id+"'");
            out.clear();
            st = db.con.createStatement();
            rs = st.executeQuery("select img from scity where idscity='"+id+"'");
            while(rs.next()) 
            {
                byte[] bytearray = new byte[1048576];
                int size=0;
                sImage = rs.getBinaryStream(1);
                response.reset();
                response.setContentType("file/*");
                while((size=sImage.read(bytearray))!= -1 )
                {
                    response.getOutputStream().write(bytearray,0,size);
                    sImage.close();
                }
            }
           // db.con.close();
           // st.close();
           // rs.close();
    }
    catch(Exception e){}
    
    
    %>