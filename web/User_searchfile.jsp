

<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="Connection.DB"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html lang="en-gb" class="no-js">
    <head>
     <meta charset="utf-8">
  <title>INNOVATIVE RESIDENCE</title>
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <meta content="" name="keywords">
  <meta content="" name="description">

  <!-- Favicons -->
  <link href="img/favicon.png" rel="icon">
  <link href="img/apple-touch-icon.png" rel="apple-touch-icon">

  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700" rel="stylesheet">

  <!-- Bootstrap CSS File -->
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">

  <!-- Libraries CSS Files -->
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="lib/animate/animate.min.css" rel="stylesheet">
  <link href="lib/ionicons/css/ionicons.min.css" rel="stylesheet">
  <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

  <!-- Main Stylesheet File -->
  <link href="css/style.css" rel="stylesheet">

   <script>
		    // You can also use "$(window).load(function() {"
			    $(function () {
			
			      // Slideshow 1
			      $("#slider1").responsiveSlides({
			        maxwidth: 1600,
			        speed: 600
			      });
			});
		  </script>
     
    </head>
    <body>
        <%
                                    Integer id=(Integer)session.getAttribute("U_Id");
                                    String name=(String)session.getAttribute("User");
                                                     session.setAttribute("U_Id",id);
                     session.setAttribute("User",name);
                                    DB db=new DB();
                                    System.out.println(id+","+name);
                                    ResultSet rs=db.Select("select * from register where S_ID='"+id+"' and A_Name='"+name+"'");
                                    if(rs.next())
                                    {
                                        String care=rs.getString("A_Name");
                                    
                                    %>
                                    <div class="contact-info">
					<ul>
                                            <br>
                                            <br>
                                            <br>
                                            <br>
                                            <br>
                                             <br><table border="5">
                                               <tr><th>USER ID :<td><%=id%></td></th>
                                             <th>USER NAME :<td><%=rs.getString("username")%></td></th>
                                             <th> LAND SEARCH  </th></tr>
                                             </table>
					</ul>
				</div>
                                    
        <div class="click-closed"></div>
  <!--/ Form Search Star /-->
  <div class="box-collapse">
    <div class="title-box-d">
      <h3 class="title-d">Search Property</h3>
    </div>
    <span class="close-box-collapse right-boxed ion-ios-close"></span>
        <div class="box-collapse-wrap form">
        <form class="form-a">
        <div class="row">
          <div class="col-md-12 mb-2">
            <div class="form-group">
              <label for="Type">Keyword</label>
              <input type="text" class="form-control form-control-lg form-control-a" placeholder="Keyword">
            </div>
          </div>
          <div class="col-md-12">
            <button type="submit" class="btn btn-b"><a href="User_searchfile.jsp">BOOK HERE</a></button>
          </div>
        </div>
        </form>
        </div>
  </div>
  <!--/ Form Search End /-->

  <!--/ Nav Star /-->
 <nav class="navbar navbar-default navbar-trans navbar-expand-lg fixed-top">
    <div class="container">
         <a class="navbar-brand text-brand" href="index.jsp">INNOVATIVE<span class="color-b"> RESISTANCE</span></a>
      <button type="button" class="btn btn-link nav-search navbar-toggle-box-collapse d-md-none" data-toggle="collapse"
        data-target="#navbarTogglerDemo01" aria-expanded="false">
        <span class="fa fa-search" aria-hidden="true"></span>
      </button>
       <div class="collapse navbar-collapse navbar-right" style="">
        <ul class="nav navbar-nav">
         <li class="nav-item">
             <a  href="user_home.jsp#">HOME</a>
         </li>
         
   
         <li class="nav-item"><a href="about-us.html"class="dropdown-toggle" data-toggle="dropdown">SEARCH<i class="fa fa-angle-down"></i></a>
          <ul class="dropdown-menu">
          <li class="nav-item"><a href="User_searchfile1.jsp">FLAT/HOUSE SEARCH</a></li>
          <li class="nav-item"><a href="User_searchfile.jsp">LAND SEARCH</a></li>
          </ul>
          </li>
          
          <li class="nav-item"><a href="about-us.html"class="dropdown-toggle" data-toggle="dropdown">BOOKING<i class="fa fa-angle-down"></i></a>
          <ul class="dropdown-menu">
          <li><a href="house_buying.jsp">BOOKING HOUSE</a></li>
          <li><a  href="usrhome.jsp">BOOKING LAND</a></li>
          </ul>
          </li>
          <li class="nav-item"><a href="about-us.html"class="dropdown-toggle" data-toggle="dropdown">VIEW BOOKING DETAILS<i class="fa fa-angle-down"></i></a>
          <ul class="dropdown-menu">
          <li><a href="bookingdetails.jsp">HOUSE BOOKING DETAILS</a></li>
          <li><a href="bookingdetails1.jsp">LAND BOOKING DETAILS</a></li>
          </ul>
          </li>
           <li class="nav-item"><a href="buyer_account.jsp">Add Account</a></li>
            <li class="nav-item"><a href="view_buyer_acc.jsp">View Account</a></li>
          <li class="nav-item">
            <a href="index.jsp">LOGOUT</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>

            <div class="container">

                <div class="content_fullwidth">

                    <center>
                        <br>
                        <form method="post" action="User_searchfile.jsp" onsubmit="return frmvalia();">   
                            <input name="samplees" id="samplees" placholder="Enter Search Team" type="text">
                            <input value="SEARCH" type="submit">
                        </form> 
                   
                        <div id="result_123">
                        </div>
                    </center>
                </div><!-- end tab -->

                <div class="clearfix mar_top5"></div>                 

            </div>
            <div style="height:500px;overflow:auto; " >
    <%
                
                String STerm = request.getParameter("samplees");
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/construct", "root", "admin");
                String sql="select * from upload where sts='Approved' and  FType regexp ('" + STerm + "')";
                PreparedStatement ps=con.prepareStatement(sql);
                ResultSet ts=ps.executeQuery();
                     
                    %>
                    <style>
           td{
                border: 2px solid #000;
                text-align: center;
                padding: 8px;
            }
            th{
                border: 2px solid #000;
                padding-top: 12px;
                padding-bottom: 12px;
                text-align: left;
                background-color:#0164F9;
                color: white;
                text-align: center;
            }
            table {
                border:2px solid;
                border-color: #000;
                width:100%;
                border-collapse: collapse;
            }

</style>  
                <div class="clear">
                                        <center>
                                            <br><h4>LAND DETAILS</h4><br>
                                        <br><table border="5">
                                            
                                            <tr><th>S_ID</th><th>ADMIN APPROVAL STATUS</th><th>SELLER NAME</th><th>SELLER NUMBER</th><th>SELLER ADDRESS</th><th>LAND AREA</th><th>LAND CITY</th><th>LAND AMOUNT</th><th>LAND ADVANCE</th><th>SQUARE FEET</th><th>IMAGE</th>
                                               <th>LAND BOOKING</th></tr>                                       
                                           <%
                                        while(ts.next())
                                        {
                                            %>
                                           <tr><td><%=ts.getInt("S_ID")%></td>
                                           <td><%=ts.getString("sts")%></td>
                                           <td><%=ts.getString("S_Name")%></td>
                                           <td><%=ts.getString("S_Number")%></td>
                                           <td><%=ts.getString("S_Addr")%></td>
                                           <td><%=ts.getString("area")%></td>
                                           <td><%=ts.getString("city")%></td>
                                           <td><%=ts.getString("rent")%></td>
                                           <td><%=ts.getString("advance")%></td>
                                           <td><%=ts.getString("FType")%></td>
                                           <td><img src="servlet_1.jsp?name=<%=ts.getInt("S_ID")%> " style="width: 250px; height: 120px;"></td> 
                                           <td><a href="Booking.jsp?B_id=<%=ts.getInt("S_ID")%>">BOOKING</a></td>
                                           
                                           </tr>
                                           <%
                                        }
                                        %>
                                        </table>
                                        </center>
					 </div>
                                                   <%
                                String msg=(String)session.getAttribute("msg");
                                if(msg!=null)
                                {
                                    %>
                                    <script>
                                        var ss='<%=msg%>';
                                        alert(ss);
                                        </script>
                                    <%
                                    session.removeAttribute("msg");
                                }
                                %>

        <div class="clearfix mar_top4"></div>

        <div class="copyright_info">
            <div class="container">                  
            </div>

        </div><!-- end copyright info --> 
        <a href="#" class="scrollup">Scroll</a><!-- end scroll to top of the page-->
    </div>
    <!-- ######### JS FILES ######### -->
    <!-- get jQuery from the google apis -->
   <!-- JavaScript Libraries -->
  <script src="lib/jquery/jquery.min.js"></script>
  <script src="lib/jquery/jquery-migrate.min.js"></script>
  <script src="lib/popper/popper.min.js"></script>
  <script src="lib/bootstrap/js/bootstrap.min.js"></script>
  <script src="lib/easing/easing.min.js"></script>
  <script src="lib/owlcarousel/owl.carousel.min.js"></script>
  <script src="lib/scrollreveal/scrollreveal.min.js"></script>
  <!-- Contact Form JavaScript File -->
  <script src="contactform/contactform.js"></script>

  <!-- Template Main Javascript File -->
  <script src="js/main.js"></script>

    <%
                                    }
                                    else
                                    {
                                        session.setAttribute("msg", "Session Out Please Login");
                                        response.sendRedirect("User_Login.jsp");
                                    }
                                        %>
  
 </div>

</body>
</html>


