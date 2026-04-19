`<%-- 
    Document   : charges1
    Created on : Jun 13, 2023, 11:29:55 AM
    Author     : elangovan
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

  <!-- =======================================================
    Theme Name: EstateAgency
    Theme URL: https://bootstrapmade.com/real-estate-agency-bootstrap-template/
    Author: BootstrapMade.com
    License: https://bootstrapmade.com/license/
  ======================================================= -->
</head>
<body style="background-color: lightcyan">
    <%--  String ses=(String)session.getAttribute("umail");
        if(ses!=null){
    --%>
    
     <% String msg=(String)session.getAttribute("msg");
    if(msg!=null){
    %>
    <script> alert("<%=msg %>"); </script>
    <% } session.removeAttribute("msg");  %>
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
      <button class="navbar-toggler collapsed" type="button" data-toggle="collapse" data-target="#navbarDefault"
        aria-controls="navbarDefault" aria-expanded="false" aria-label="Toggle navigation">
        <span></span>
        <span></span>
        <span></span>
      </button>
      <a class="navbar-brand text-brand" href="index.jsp">INNOVATIVE<span class="color-b"> RESISTANCE</span></a>
      <button type="button" class="btn btn-link nav-search navbar-toggle-box-collapse d-md-none" data-toggle="collapse"
        data-target="#navbarTogglerDemo01" aria-expanded="false">
        <span class="fa fa-search" aria-hidden="true"></span>
      </button>
      <div class="navbar-collapse collapse justify-content-center" id="navbarDefault">
        <ul class="navbar-nav">
          <li class="nav-item"><a href="admin_home.jsp">Home</a></li>
                            <li class="nav-item"><a href="about-us.html"class="dropdown-toggle" data-toggle="dropdown">APPROVAL<i class="fa fa-angle-down"></i></a>
                                    <ul class="dropdown-menu">
                                        <li><a href="buyer_req.jsp">BUYER APPROVAL</a></li>                 
                                        <li><a href="seller_req.jsp">SELLER APPROVAL</a></li>
                                    </ul>

                                </li>
                            <li class="nav-item">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">LAND/HOUSE APPROVAL<i class="fa fa-angle-down"></i></a>
                                <ul class="dropdown-menu">
                                    <li><a href="LAND_Approval.jsp">LAND APPROVAL</a></li>
                                    <li><a href="Approval.jsp">FLAT/HOUSE</a></li>
                                </ul>

                            </li>
                            <li class="nav-item">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">BOOKING DETAILS<i class="fa fa-angle-down"></i></a>
                                <ul class="dropdown-menu">
                                    <li><a href="USER BOOKING.jsp">LAND BOOKING</a></li>
                                    <li><a href="USER BOOKING1.jsp ">FLAT/HOUSE BOOKING</a></li>
                                </ul>

                            </li>
                            <li class="nav-item"><a href="index.jsp">Logout</a></li>
          <!--li class="nav-item">
            <a class="nav-link" href="property-grid.html">Property</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="blog-grid.html">Blog</a>
          </li>
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown"
              aria-haspopup="true" aria-expanded="false">
              Pages
            </a>
            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
              <a class="dropdown-item" href="property-single.html">Property Single</a>
              <a class="dropdown-item" href="blog-single.html">Blog Single</a>
              <a class="dropdown-item" href="agents-grid.html">Agents Grid</a>
              <a class="dropdown-item" href="agent-single.html">Agent Single</a>
            </div>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="contact.html">Contact</a>
          </li-->
        </ul>
      </div>

    </div>
  </nav>
  <!--/ Nav End /-->

 <div class="container" style="margin-top: 10%;">
    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="card shadow-lg p-4">
                <h4 class="text-center text-success fw-bold">BOOKING CHARGE</h4>
                <hr>
                    <form action="charges1" method="post">
                       <div class="table-responsive">
                        <table class="table table-bordered text-center">          
                      
                         
                               
                                <%
                                                  DB db1=new DB();
                                         String id=request.getParameter("S_ID");
                                      ResultSet rs1=db1.Select("select * from flat_house where S_ID='"+id+"'");
                                      while(rs1.next())
                                      {
                                          
                                        %>
                                        
                                         <tr>
                                    <td class="fw-bold">ID</td>
                                    <td>:</td>
                                    <td><input type="text" name="S_ID" id="S_ID" class="form-control" value="<%= rs1.getInt("S_ID") %>" readonly></td>
                                </tr>
                                
                                 <tr>
                                    <td class="fw-bold">Booking Charge</td>
                                    <td>:</td>
                                    <td><input type="text" name="fess" id="fess" class="form-control" value="<%= rs1.getInt("fess") %>" required></td>
                                </tr>
                                
                                        <%
                                      }
                                        
                                        %>
                            </tbody>
                        </table>
                    </div>
                            <div class="text-center">
                        <button type="submit" class="btn btn-success px-4">MODIFY</button>
                    </div>
                                </form>
                    </div>
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
</body>
</html>

