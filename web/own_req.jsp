<%@page import="java.sql.ResultSet"%>
<%@page import="connection.DatabaseConnection"%>
<!--A Design by W3layouts
  Author: W3layout
  Author URL: http://w3layouts.com
  License: Creative Commons Attribution 3.0 Unported
  License URL: http://creativecommons.org/licenses/by/3.0/
  -->
<!DOCTYPE html>
<html lang="zxx">

<head>
  <title>Banking</title>
  <!--meta tags -->
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="keywords" content="Gateau Responsive web template, Bootstrap Web Templates, Flat Web Templates, Android Compatible web template, 
      Smartphone Compatible web template, free webdesigns for Nokia, Samsung, LG, SonyEricsson, Motorola web design" />
  <script>
    addEventListener("load", function () {
      setTimeout(hideURLbar, 0);
    }, false);

    function hideURLbar() {
      window.scrollTo(0, 1);
    }
  </script>
  <!--//meta tags ends here-->
  <!--booststrap-->
  <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css" media="all">
  <!--//booststrap end-->
  <!-- font-awesome icons -->
  <link href="css/font-awesome.min.css" rel="stylesheet">
  <!-- //font-awesome icons -->
  <!--stylesheets-->
  <link href="css/style.css" rel='stylesheet' type='text/css' media="all">
  <!--//stylesheets-->
  <link href="//fonts.googleapis.com/css?family=Arimo:400,700" rel="stylesheet">
  <link href="//fonts.googleapis.com/css?family=Roboto:400,500,700,900" rel="stylesheet">
</head>
<%
    String msg=(String)session.getAttribute("msg");
    if(msg!=null)
    {
%>
<script>
     var msg1='<%=msg%>';
     alert(msg1);
    </script>
<%
        session.removeAttribute("msg");
    }
%>

<body>
  <!--headder-->
  <div class="header-outs inner_page-banner " id="home">
     <div class="headder-top">
      <!-- nav -->
      <nav>
        <div id="logo">
          <h1>
            <a href="index.jsp">BANKING SECTOR</a>
          </h1>
        </div>
        <label for="drop" class="toggle">Menu</label>
        <input type="checkbox" id="drop">
        <ul class="menu mt-2">
          <li class="active">
            <a href="admin_home.jsp">Home</a>
          </li>
          <li class="mx-lg-3 mx-md-2 my-md-0 my-1">
            <!-- First Tier Drop Down -->
            <label for="drop-2" class="toggle toogle-2">Verification
              <span class="fa fa-angle-down" aria-hidden="true"></span>
            </label>
            <a href="#">Verification
              <span class="fa fa-angle-down" aria-hidden="true"></span>
            </a>
            <input type="checkbox" id="drop-2">
           <ul>
              <li>
                <a href="own_req.jsp" class="drop-text">Public User Details</a>
              </li>
              <li>
                <a href="user_req.jsp" class="drop-text">Banking Details</a>
              </li>
            </ul>
          </li>
          <li class="mx-lg-3 mx-md-2 my-md-0 my-1">
            <!-- First Tier Drop Down -->
            <label for="drop-2" class="toggle toogle-2">File Access
              <span class="fa fa-angle-down" aria-hidden="true"></span>
            </label>
            <a href="#">File Access
              <span class="fa fa-angle-down" aria-hidden="true"></span>
            </a>
            <input type="checkbox" id="drop-2">
            <ul>
              <li>
                <a href="owner_data.jsp" class="drop-text"></a>
              </li>
              <li>
                <a href="user_data.jsp" class="drop-text"></a>
              </li>
            </ul>
          </li>
          
          <li>
            <a href="index.jsp">Logout</a>
          </li>
        </ul>
      </nav>
      <!-- //nav -->
    </div>
  </div>
  <!--//headder-->
  <!-- short -->
  <div class="using-border py-3">
    <div class="inner_breadcrumb  ml-4">
      <ul class="short_ls">
        <li>
          <a href="index.html"></a>
          <span></span>
        </li>
        <li></li>
      </ul>
    </div>
  </div>
  <!-- //short-->
  <!-- about -->

  <!-- //about -->
  <section class="stats-count py-lg-4 py-md-3 py-sm-3 py-3">
    <div class="container-fluid py-lg-5 py-md-4 py-sm-4 py-3">
        <center><h3>PUBLIC USER DETAILS</h3></center>
        <br>
        <br>
       <table border="1" align="center">
           <tr>
               <td>USERNAME</td>
               <td>EMAIL ID</td>
               <td>MOBILE NO</td>
               <td>STATUS</td>
               <td>ACCEPT</td>
               </tr>
               <%
                   DatabaseConnection db1=new DatabaseConnection();
                   String query="select * from ownregister";
                   ResultSet rs=db1.Select(query);
                   while(rs.next())
                   {
               %>

        <tr>
            <td><%=rs.getString("username")%></td>
            <td><%=rs.getString("email")%></td>
            <td><%=rs.getString("mobile_no")%></td>
            <td><%=rs.getString("sts")%></td>
            <td><a href="request.jsp?username=<%=rs.getString("username")%>">Accept</a></td>

        </tr>
           <%
                   }
           %>
       </table>
      <br>
      <br>
      <br>
      <br>
      <br>
    </div>
  </section>
  <!--//counter -->
  <!-- footer -->

  <footer>
    <div class="bottem-wthree-footer text-center py-md-4 py-3">
    </div>
  </footer>
  <!--//footer -->
</body>

</html>