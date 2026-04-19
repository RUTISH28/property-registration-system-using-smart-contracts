<!--A Design by W3layouts
Author: W3layout
Author URL: http://w3layouts.com
License: Creative Commons Attribution 3.0 Unported
License URL: http://creativecommons.org/licenses/by/3.0/
-->
<!DOCTYPE html>
<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
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
<link href='http://fonts.googleapis.com/css?family=Arimo:400,700,400italic,700italic' rel='stylesheet' type='text/css'>
 <script src="https://api.tomtom.com/maps-sdk-for-web/cdn/5.x/5.64.0/services/services-web.min.js"></script>
</head>
<body>
   
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
          <li class="nav-item">
            <a href="index.jsp">LOGOUT</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
	<!--start-header-->
    <script type="text/javascript">
    	var map = null;
        var latLong =null;
			function showlocation() {
			   // One-shot position request.
			    navigator.geolocation.getCurrentPosition(callback);
			}
    	
      function callback(position) {
      	
      	var lat = position.coords.latitude;
      	var lon = position.coords.longitude;
      	            document.getElementById("lat").value=lat;
                     document.getElementById("lan").value=lon;

           	latLong	= new google.maps.LatLng(lat, lon);
       
      	   var latlng = new google.maps.LatLng(lat, lon);
           var  geocoder = new google.maps.Geocoder();
            geocoder.geocode
            ({ 'latLng': latlng }, 
            function (results, status)
            {
                var add=document.getElementById("loc1").value=results[0].formatted_address;
                alert(add); 
            });
            var addr=document.getElementById("loc1").value;
            if(addr === '' || addr === null || addr === undefined){
              tt.services.reverseGeocode({key:"1MmbJI1SBWF7Yht63JQXbpE5Yp5BvAge",   position: latLong})

                                        .go()
                                        .then(function (results) {
                                       // alert("success");
                                        var add=document.getElementById("loc1").value=results.addresses[0].address.freeformAddress;
                                    //alert(add); 
                                        //alert(results.addresses[0].address.freeformAddress);
                                    });
            initMap();
        }  }
      function initMap() {
        var mapOptions = {
          center: latLong,
          zoom: 8,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById("map-canvas"), 
                                          mapOptions);
     var marker = new google.maps.Marker({
				    position: latLong
				});      
				
				marker.setMap(map);
                                     	map.setZoom(8);
      	map.setCenter(marker.getPosition());
      } 
  
      //   google.maps.event.addDomListener(window, 'load', initMap);
    </script>
			
				 <script>
						$(document).ready(function() {
						$('.popup-with-zoom-anim').magnificPopup({
							type: 'inline',
							fixedContentPos: false,
							fixedBgPos: true,
							overflowY: 'auto',
							closeBtnInside: true,
							preloader: false,
							midClick: true,
							removalDelay: 300,
							mainClass: 'my-mfp-zoom-in'
						});
																						
						});
				</script>					
		<!--End-header-->
		
		<!--starts-blog-->
                <br>
                <br>
                <br>
                <br>
                <br>
        <div class="blog">
            <div class="container">
                <center>
                    <form action="locationSeeds.jsp" method="post">
                        <h3>User  Location</h3>
                        <div>Current  Location : <input  type="text" value="" id="loc1" name="loc1" style="width: 845px;" readonly></div>
                            Current  latitude : <input type="text" value="" id="lat" name="lat" style="width: 360px;" readonly><br>
                            Current  longitude : <input type="text" value="" id="lan" name="lan" style="width: 360px;" readonly><br>
                    </form>
                </center>
        <div id="map-canvas" style="width: 1340px; height: 500px">
        </div>
            </div>
		</div>
		<!--end-blog-->
		 <div class="footer">
                         <div class="container">
                                    <div class="footer-text">
                                        <center>	<script  src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBOU-GKNx-YL5o-b8cvlqgyn0rso6iQtUk&callback=showlocation"
  type="text/javascript"></script></center>
									</div>
                         </div>
					<a href="#home" id="toTop" class="scroll" style="display: block;"> <span id="toTopHover" style="opacity: 1;"> </span></a>
     </div>
                
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