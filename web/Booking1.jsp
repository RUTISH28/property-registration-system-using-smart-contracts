<%-- 
    Document   : Booking1
    Created on : Apr 5, 2023, 5:26:40 PM
    Author     : elangovan
--%>


<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>

		<!DOCTYPE HTML>
<html>
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

  <!-- =======================================================
    Theme Name: EstateAgency
    Theme URL: https://bootstrapmade.com/real-estate-agency-bootstrap-template/
    Author: BootstrapMade.com
    License: https://bootstrapmade.com/license/
  ======================================================= -->
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
        <body style="background: url(img/854.jpg) #0069d9">
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
            <button type="submit" class="btn btn-b">Search Property</button>
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
             <a  href="user_home.jsp">HOME</a>
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
            
			<div class="header">
				<div class="wrap">
				<div class="logo">
					<a href="#"><img src="images/logo.png" title="logo" /></a>
				</div>
                                    <br>
                                    <br>
                                    <br>
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
					
				</div>
				<div class="clear"> </div>
				</div>
			</div>
				
		
		<div class="clear"> </div>
			<!--start-image-slider---->
				
					<!--End-image-slider---->
		    <div class="clear"> </div>
		    <div class="wrap">
		    	<div class="content">
                            
              <form action="BOOKING2" method="post" onsubmit="return Validate1(true);" name="form">
                            <%
                                        String hh=request.getParameter("B_id");
                                        session.setAttribute("B_id", hh);
                                        int B_id=Integer.parseInt(hh);
                                        ResultSet ts=db.Select("Select * from flat_house where S_ID='"+B_id+"' ");
                                        
                                        %>		
						 <div class="clear">
                                        <center>
                                            <hr>
                                            <hr><hr>
                                            <br><h4 style="color: gold">FLAT/HOUSE BOOKING</h4><br>
                                            <hr>
                                        <table border="1">                                      
                                           <%
                                        while(ts.next())
                                        {
                                            %>
                <input type="hidden" name="SA_NAME" value="<%=ts.getString("A_Name")%>"  readonly />
                                            <span class="heading" style="color: silver">SELLER ID</span><br></br>
                <input type="text" name="S_ID" value="<%=ts.getInt("S_ID")%>" id="S_ID" size="35" readonly /><input type="checkbox" name="cb" id="cb" value="1"><br><br>
                
                                 <span class="heading" style="color: silver">SELLER NAME </span><br><br>
                <input type="text" name="S_NAME" value="<%=ts.getString("S_Name")%>" id="S_NAME" size="35" readonly /><input type="checkbox" name="cb" id="cb" value="2"><br><br>
                
                <span class="heading" style="color: silver">LAND APPROVAL STATUS</span><br></br>
                <input type="text" name="STS" value="<%=ts.getString("sts")%>" id="STS" size="35" readonly /><input type="checkbox" name="cb" id="cb" value="3"><br><br>
                
                 <span class="heading" style="color: silver">BOOKING CHARGE</span><br></br>
                <input type="text" name="B_fess" value="<%=ts.getInt("fess")%>" id="fess" size="35" readonly /><input type="checkbox" name="cb" id="cb" value="4"><br><br>
                
                <span class="heading" style="color: silver"> LAND AREA</span><br></br>
                <input type="text" name="street" value="<%=ts.getString("area")%>" id="S_NU" size="35" readonly /><input type="checkbox" name="cb" id="cb" value="5"><br><br>
                 
                <span class="heading" style="color: silver">HOUSE NUMBER </span><br></br>
                <input type="text" name="H_NO" value="<%=ts.getString("H_NO")%>" id="D_NO" size="35" readonly /><input type="checkbox" name="cb" id="cb" value="6"><br><br>
                
                 <span class="heading" style="color: silver">USER NAME</span><br></br>
                 <input type="text" value="" id="U_NAME" name="U_NAME" size="35" required /><input type="checkbox" name="cb" id="cb" value="7"><br><br>
      
                   <span class="heading" style="color: silver">USER NUMBER</span><br></br>
                   <input type="text" value="" id="U_NUMBER" name="U_NUMBER" size="35" required /><input type="checkbox" name="cb" id="cb" value="8"><br><br>
                  
                   <span class="heading" style="color: silver">USER MAIL ID</span><br></br>
                   <input type="text" value="" id="U_MAIL" name="U_MAIL" size="35" required /><input type="checkbox" name="cb" id="cb" value="9"><br><br>
                   
                    <span class="heading" style="color: silver">USER AADHAR NO</span><br></br>
                   <input type="text" value="" id="A_NAME" name="A_NAME" size="35" required /><br><br>
                   
                   <span class="heading" hidden="" style="color: silver">SELLER MAIL </span><br></br>
                <input type="text" name="S_MAIL" value="<%=ts.getString("S_MAIL")%>" id="S_MAIL" size="35" hidden="">
                   
                                           <%
                                        }
                                        
                                         ResultSet ts1=db.Select("Select * from admin1");
                                        
                                   %>
                                        </table>
                                      
                                        <h4 style="color: gold">ACCOUNT DETAILS</h4><br>
                                         <table border="2" style="color: #ffffff">
                                              <%
                                        while(ts1.next())
                                        {
                                            %>
                                              <tr>
                                                  <td>Select Account Number</td><td>
                                                      <select name="A_ACC"  id="A_ACC" onchange="showState(this.value)">
                                           <option value="<%=ts1.getString("Acc")%>"><%=ts1.getString("Acc")%></option>
                                          </select><input type="checkbox" name="cb" id="cb" value="10">
                                                  </td>
                                              </tr>                   
                                              <tr>
                                                  <td>Select CARD TYPE</td><td>
                                                      <select name="C_Type" id="C_Type" onchange="showState(this.value)">
                                                       
                                                          <option value="visa">visa</option>
                                                          <option value="visa">master</option>
                                                          <option value="visa">rupay</option>
                                          </select><input type="checkbox" name="cb" id="cb" value="11">
                                                  </td>
                                              </tr>
                                               <tr>
                                                  <td>USER ACCOUNT NUMBER</td>
                                                  <td><input type="text" name="U_ACC" value="" id="U_ACC" ><input type="checkbox" name="cb" id="cb" value="12"></td>
                                              </tr>
                                              
                                              <%
                                        }
                                        %>
                                        </table>
                                      
                                          <div id="state">
                                          </div>
                                  
                                          <div id="state1"></div>
                                          <br>
                                        <input type="SUBMIT" value="SUBMIT"> <br>
                                        <br>
                                        </center>
					 </div>
                                          </form>
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
	
						 <div class="clear"> </div>
  
		</div>
		<div class="clear"> </div>
		
			
                    <%
                                    }
                                    else
                                    {
                                        session.setAttribute("msg", "Session Out Please Login");
                                        response.sendRedirect("usrhome.jsp");
                                    }
                                        %>
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

</body>
</html>

