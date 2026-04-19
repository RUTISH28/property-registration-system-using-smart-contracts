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
           
          <li class="nav-item">
              <a href="User_searchfile.jsp">SEARCH</a>
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
                                        ResultSet ts=db.Select("Select * from upload where sts='Approved'");
                                        
                                        %>		
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
