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
            $(function() {

                // Slideshow 1
                $("#slider1").responsiveSlides({
                    maxwidth: 1600,
                    speed: 600
                });
            });
        </script>
          <style>
   

    .container1 {
        max-width: 900px;
        margin: 0 auto;
        padding: 20px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }

    h4 {
        text-align: center;
        color: #333;
        margin-bottom: 30px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 30px;
    }

    table td {
        padding: 10px;
        text-align: left;
        font-size: 14px;
        color: #333;
    }

    table tr:nth-child(even) {
        background-color: #f9f9f9;
    }

    input.form-control {
        width: 100%;
        padding: 10px;
        font-size: 14px;
        border: 1px solid #ddd;
        border-radius: 5px;
        margin-top: 5px;
        box-sizing: border-box;
    }

    input.form-control:focus {
        border-color: #0056b3;
        outline: none;
    }

    .col-lg-6 {
        display: inline-block;
        width: 100%;
        padding: 10px;
        box-sizing: border-box;
    }

    .btn {
        background-color: #007bff;
        color: #fff;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        transition: background-color 0.3s;
    }

    .btn:hover {
        background-color: #0056b3;
    }
</style>
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
                height:100vh;
                width: 100%;
                background-position:center;
                background-repeat: no-repeat;
                background-size: cover;
                background-attachment: fixed;
            }
        </style>
        <div class="header">
            <div class="wrap">
                <div class="logo">
                    <a href="#"><img src="images/logo.png" title="logo" /></a>
                </div>
                <%
                    Integer id = (Integer) session.getAttribute("U_Id");
                    String name = (String) session.getAttribute("User");
                    session.setAttribute("U_Id", id);
                    session.setAttribute("User", name);
                    DB db = new DB();
                    System.out.println(id + "," + name);
                    ResultSet rs = db.Select("select * from register where S_ID='" + id + "' and A_Name='" + name + "'");
                    if (rs.next()) {
                        String care = rs.getString("A_Name");

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
                                <th> LAND BOOKING DETAILS </th></tr>
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
        <!--/ Nav End /-->

        <style>
            tr, td, th {
                border: 4px solid;
                text-align: center;
                padding: 8px;

            }
        </style>

        <!--/ Carousel Star /-->

        <div class="clear"> </div>
        <div class="wrap">
            <div class="content">
                <%
                    ResultSet ts = db.Select("Select * from booking1 where A_NAME='" + name + "' ");

                %>	
                  <div class="container1">
                <div class="clear">
                    <form name="Check1"  action="Encrypt_Details" method="post" onsubmit="return ValidateDate(true);">
                        <center>
                            <br><h4>LAND DETAILS</h4><br>                                     
                            <%
                                while (ts.next()) {
                            %>
                            <div class="col-lg-6"> 
                                <table border="1">
                                    
                                    <tr>
                                        <td>SELLER NAME</td> <td><%=ts.getString("S_Name")%></td>
                                    </tr>
                                    <tr>
                                        <td>SURVEY NUMBER</td> <td><%=ts.getString("SUNO")%></td>
                                    </tr>
                                    <tr>
                                        <td>DOCUMENT NUMBER</td> <td><%=ts.getString("D_NO")%></td>
                                    </tr>
                                    <tr>
                                        <td>LAND STREET</td> <td>"<%=ts.getString("area")%></td>
                                    </tr>
                                    <tr>
                                        <td>BUYER NAME</td> <td><%=ts.getString("U_NAME")%></td>
                                    </tr>
                                    <tr>
                                        <td>BUYER NUMBER</td> <td><%=ts.getString("U_NUMBER")%></td>
                                    </tr>
                                    <tr>
                                        <td>BUYER MAIL-ID</td> <td><%=ts.getString("U_MAIL")%></td>
                                    </tr>
                                    <tr>
                                        <td>LAND APPROVAL STS</td><td><%=ts.getString("STS")%>></td>
                                    </tr>                        
                                    <tr>
                                        <td>BOOKING FESS</td><td><%=ts.getString("B_fess")%></td>
                                    </tr>
                                    <tr>
                                        <td>ADMIN ACCOUNT NUMBER</td> <td><%=ts.getString("A_ACC")%></td>
                                    </tr>
                                    <tr>
                                        <td>CARD TYPE</td> <td><%=ts.getString("C_Type")%></td>
                                    </tr>
                                    <tr>
                                        <td>BUYER ACCOUNT NUMBER</td><td><%=ts.getString("U_ACC")%></td>
                                    </tr>
                                    <tr>
                                        <td>AADHAR CARD NO</td> <td><%=ts.getString("A_Name")%></td>
                                    <br><br>
                                    <tr>
                                        <td>DECRYPTION</td>

                                        <td color:black>
                                            <a href="mail1?id1=<%=ts.getString("A_Name")%>&id2=<%=ts.getInt("id")%>">View</a>
                                        </td>
                                    </tr>
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
                    String msg = (String) session.getAttribute("msg");
                    if (msg != null) {
                %>
                <script>
            var ss = '<%=msg%>';
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
            } else {
                session.setAttribute("msg", "Session Out Please Login");
                response.sendRedirect("User_Login.jsp");
            }
        %>

    </body>
</html>
