<%-- 
    Document   : modify
    Created on : 30 Jun, 2023, 3:14:39 PM
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

  <!-- =======================================================
    Theme Name: EstateAgency
    Theme URL: https://bootstrapmade.com/real-estate-agency-bootstrap-template/
    Author: BootstrapMade.com
    License: https://bootstrapmade.com/license/
  ======================================================= -->
</head>
<body>
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
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">DETAILS<i class="fa fa-angle-down"></i></a>
                                <ul class="dropdown-menu">
                                    <li><a href="USER BOOKING.jsp">LAND BOOKING</a></li><br>
                                    <li><a href="USER BOOKING1.jsp ">FLAT/HOUSE BOOKING</a></li><br>
                                    <li><a href="seller details.jsp ">SELLER DETAILS</a></li><br>
                                    <li><a href="buyer details.jsp ">BUYER DETAILS</a></li>
                                </ul>

                            </li>
                            <li class="nav-item">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">MODIFY<i class="fa fa-angle-down"></i></a>
                                <ul class="dropdown-menu">
                                    <li><a href="modify.jsp">LAND APPROVAL</a></li>
                                    <li><a href="modify1.jsp">FLAT/HOUSE APPROVAL</a></li>
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

  <!--/ Carousel Star /-->
  <div style="margin-top:15%;" class="container">
              <div class="row">
                  <div class="col-3"></div>
                <section class="stats-count py-lg-4 py-md-3 py-sm-3 py-3">
<div class="container-fluid py-lg-5 py-md-4 py-sm-4 py-3">
    <center><h3 class="mb-4">FLAT/HOUSE BOOKING DETAILS</h3></center>
    <div class="table-responsive">
        <table class="table table-bordered table-striped text-center">
            <thead class="table-dark">
                <tr>
                    <th>AADHAAR NO</th>
                    <th>USERNAME</th>
                    <th>EMAIL ID</th>
                    <th>MOBILE NO</th>
                    <th>STREET</th>
                    <th>HOUSE NO</th>
                    <th>STATUS</th>
                    <th>BUYER STS</th>
                    <th>HOUSE STS</th>
                </tr>
            </thead>
            <tbody>
                <%
                    DB db1 = new DB();
                    String query = "SELECT * FROM bookingss WHERE STS='Approved'";
                    ResultSet rs = db1.Select(query);
                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("A_NAME") %></td>
                    <td><%= rs.getString("U_NAME") %></td>
                    <td><%= rs.getString("U_MAIL") %></td>
                    <td><%= rs.getString("U_NUMBER") %></td>
                    <td><%= rs.getString("street") %></td>
                    <td><%= rs.getString("H_NO") %></td>
                    <td><span class="badge bg-success"><%= rs.getString("STS") %></span></td>
                    <td>
                        <a href="request7.jsp?A_NAME=<%= rs.getString("A_NAME") %>" class="btn btn-warning btn-sm">
                            SOLD OUT
                        </a>
                    </td>
                    <td>
                        <a href="request8.jsp?S_ID=<%= rs.getString("S_ID") %>" class="btn btn-warning btn-sm">
                            SOLD OUT
                        </a>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

      <br>
      <br>
      <br>
      <br>
      <br>
    </div>
  </section>
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
