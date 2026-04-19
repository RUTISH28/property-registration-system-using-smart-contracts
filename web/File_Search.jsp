
<%@page import="Connection.DB"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String STerm = request.getParameter("TERM");
    System.out.println(STerm);
    DB nh = new DB();
    System.out.println("SELECT * FROM upload where FType regexp ('" + STerm + "') and sts!='NO'");
    ResultSet rs = nh.Select("SELECT * FROM upload where FType regexp ('" + STerm + "') and sts!='NO'");
    while (rs.next()) {
%>
<center>
    <div class="content_left">
        <div class="blog_post">	
            <div class="blog_postcontent">
                <div class="image_frame"><a href="#"><img src="http://placehold.it/680x300" alt="" /></a></div>
                <a href="#" class="date"><strong><%=rs.getString(1)%></strong><i>Ju</i></a>
                <h3><a href="#"><%=rs.getString(3)%></a></h3>                
                <div class="post_info_content">
                    <p><%=rs.getString(7)%></p>
                </div>
            </div>
        </div><!-- /# end post -->      
        <div class="clearfix divider_line"></div>
    </div><!-- end content left area -->
</center>
<%    }
%>
