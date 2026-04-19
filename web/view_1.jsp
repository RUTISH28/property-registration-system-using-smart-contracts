<%-- 
    Document   : view_1
    Created on : 30 Jun, 2023, 10:18:48 AM
    Author     : Admin1
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<!DOCTYPE html>
<html lang="en">
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
  <!-- =======================================================
    Theme Name: EstateAgency
    Theme URL: https://bootstrapmade.com/real-estate-agency-bootstrap-template/
    Author: BootstrapMade.com
    License: https://bootstrapmade.com/license/
  ======================================================= -->
</head>
<body>
    <style>
body {
  background-image: url('2CLOUD.jpg');}
</style>
    <div class="header">
				<div class="wrap">
				<div class="logo">
					<a href="#"><img src="images/logo.png" title="logo" /></a>
				</div>
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
                                             <th>USER NAME :<td><%=care%></td></th>
                                             <th> LAND BOOKING  </th></tr>
                                             </table>
					</ul>
				</div>
				<div class="clear"> </div>
				</div>
			</div>
  <div class="click-closed"></div>
  <!--/ Form Search Star /-->
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
         
          <li class="nav-item">
              <a href="UUSER_MAIL.jsp">MAIL</a>
          </li>
          
           <li class="nav-item">
               <a href="location.jsp">LOCATION</a>
           </li>
           
  <li class="nav-item"><a href="about-us.html"class="dropdown-toggle" data-toggle="dropdown">SEARCH<i class="fa fa-angle-down"></i></a>
          <ul class="dropdown-menu">
          <li class="nav-item"><a href="User_searchfile1.jsp">FLAT/HOUSE SEARCH</a></li>
          <li class="nav-item"><a href="User_searchfile.jsp">LAND SEARCH</a></li>
          </ul>
          </li>
          
          <li class="nav-item"><a href="about-us.html"class="dropdown-toggle" data-toggle="dropdown">BUYING<i class="fa fa-angle-down"></i></a>
          <ul class="dropdown-menu">
          <li><a href="house_buying.jsp">BUYING HOUSE</a></li>
          <li><a  href="usrhome.jsp">BUYING LAND</a></li>
          </ul>
          </li>
          <li class="nav-item"><a href="about-us.html"class="dropdown-toggle" data-toggle="dropdown">VIEW DETAILS<i class="fa fa-angle-down"></i></a>
          <ul class="dropdown-menu">
          <li><a href="bookingdetails.jsp">HOUSE BOOKING DETAILS</a></li>
          <li><a href="bookingdetails1.jsp">LAND BOOKING DETAILS</a></li>
          </ul>
          </li>
          <li class="nav-item">
            <a href="index.jsp">LOGOUT</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
  <!--/ Nav End /-->

  <!--/ Carousel Star /-->
                     
                      <div class="clear"> </div>
		    <div class="wrap">
		    	<div class="content">
                            <%
                                        ResultSet ts=db.Select("Select * from booking where A_Name='"+name+"' ");
                                        
                                        %>		
						 <div class="clear">
                     <form name="Check1"  action="recepit.jsp" method="post">
                                        <center>
                                            <br><h4>LAND BOOKING DETAILS</h4><br>                                     
                                           <%
                                        while(ts.next())
                                        {
                                            %>
                                            <div class="col-lg-6"> 
                                                <table>
                                                    <tr>
                                                        <td>FLAT ID</td><td>:</td> <td><input class="form-control" type="text" value="<%=ts.getString("S_ID")%>" name="S_ID" readonly=""></td>
                                                    </tr>
                                                    <tr>
                                                        <td>SELLER NAME</td><td>:</td> <td><input class="form-control" type="text" value="<%=ts.getString("S_Name")%>" name="S_Name" readonly=""></td>
                                                    </tr>
                                                    <tr>
                                                        <td>LAND AREA</td><td>:</td> <td><input class="form-control" type="text" value="<%=ts.getString("area")%>" name="H_NO" readonly=""></td>
                                                    </tr>
                                                    <tr>
                                                        <td>DOCUMENT NUMBER</td><td>:</td> <td><input class="form-control" type="text" value="<%=ts.getString("D_NO")%>" name="street" readonly=""></td>
                                                    </tr>
                                                    <tr>
                                                        <td>SURVEY NUMBER</td><td>:</td> <td><input class="form-control" type="text" value="<%=ts.getString("SUNO")%>" name="street" readonly=""></td>
                                                    </tr>
                                                    <tr>
                                                        <td>BUYER NAME</td><td>:</td> <td><input class="form-control" type="text" value="<%=ts.getString("U_NAME")%>" name="U_NAME" readonly=""></td>
                                                    </tr>
                                                    <tr>
                                                        <td>BUYER NUMBER</td><td>:</td> <td><input class="form-control" type="text" value="<%=ts.getString("U_NUMBER")%>" name="U_NUMBER" readonly=""></td>
                                                    </tr>
                                                    <tr>
                                                        <td>BUYER MAIL-ID</td><td>:</td> <td><input class="form-control" type="text" value="<%=ts.getString("U_MAIL")%>" name="U_MAIL" readonly=""></td>
                                                    </tr>
                                                    <tr>
                                                        <td>LAND STS</td><td>:</td> <td><input class="form-control" type="text" value="<%=ts.getString("STS")%>" name="STS" readonly=""></td>
                                                    </tr>                        
                                                    <tr>
                                                        <td>BOOKING FESS</td><td>:</td> <td><input class="form-control" type="text" value="<%=ts.getString("B_fess")%>" name="B_fess" readonly=""></td>
                                                    </tr>
                                                    <tr>
                                                        <td>ADMIN ACCOUNT NUMBER</td><td>:</td> <td><input class="form-control" type="text" value="<%=ts.getString("A_ACC")%>" name="A_ACC" readonly=""></td>
                                                    </tr>
                                                    <tr>
                                                        <td>CARD TYPE</td><td>:</td> <td><input class="form-control" type="text" value="<%=ts.getString("C_Type")%>" name="C_Type" readonly=""></td>
                                                    </tr>
                                                    <tr>
                                                        <td>BUYER ACCOUNT NUMBER</td><td>:</td> <td><input class="form-control" type="text" value="<%=ts.getString("U_ACC")%>" name="U_ACC" readonly=""></td>
                                                    </tr>
                                                    <tr>
                                                        <td>AADHAAR CARD NO</td><td>:</td> <td><input class="form-control" type="text" value="<%=ts.getString("A_Name")%>" name="A_Name" readonly=""></td>
                                                    <br><br>
                                                </table>     
                                                    <br><br>
            </div>                                        
                                            
                                           
                                           <%
                                        }
                                        %>
                                       
                                        </center>
                     </form>
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
  
		</div>
                  
                </div>
  
        
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
  
</body>
</html>
