<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Innovative Residence — Premium Property Platform</title>
  <link rel="icon" href="img/favicon.png">
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;0,700;1,400;1,600&family=Plus+Jakarta+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300&display=swap" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="css/ir-theme.css" rel="stylesheet">
</head>
<body>

<!-- Warm decorative background -->
<div class="ir-bg-shapes">
  <div class="ir-shape ir-shape-1"></div>
  <div class="ir-shape ir-shape-2"></div>
  <div class="ir-shape ir-shape-3"></div>
</div>
<div class="ir-bg-dots"></div>

<!-- NAVBAR -->
<nav class="ir-nav" id="mainNav">
  <a class="ir-brand" href="index.jsp">INNOVATIVE<span class="ir-brand-dot"></span><em>RESIDENCE</em></a>
  <ul class="ir-nav-links" id="navLinks">
    <li><a href="index.jsp" class="active">Home</a></li>
    <li><a href="usr.jsp">Buyer Register</a></li>
    <li><a href="seller.jsp">Seller Register</a></li>
    <li><a href="user_login.jsp">Buyer Login</a></li>
    <li><a href="seller_login.jsp">Seller Login</a></li>
    <li><a href="admin.jsp" class="ir-nav-cta"><i class="fa fa-shield"></i> Admin</a></li>
  </ul>
  <div class="ir-nav-toggle" id="navToggle" onclick="toggleNav()">
    <span></span><span></span><span></span>
  </div>
</nav>

<!-- HERO — Deep navy with warm amber accents -->
<section class="ir-hero" id="home">
  <div class="ir-hero-img-layer"></div>
  <div class="ir-hero-overlay"></div>
  <div class="ir-hero-stripe"></div>

  <div class="ir-hero-content">
    <div class="ir-hero-eyebrow">
      <span class="ir-hero-eyebrow-dot"></span>
      Admin-Verified Listings Only
    </div>
    <h1>
      Find Your<br>
      <span class="accent-italic">Dream</span>
      Property
    </h1>
    <p>Every listing is personally reviewed and price-validated by our admin team. A marketplace built on trust, transparency, and verified data.</p>
    <div class="ir-hero-btns">
      <a href="usr.jsp" class="ir-btn ir-btn-gold"><i class="fa fa-search"></i> Browse Properties</a>
      <a href="seller.jsp" class="ir-btn ir-btn-white"><i class="fa fa-plus-circle"></i> List Your Property</a>
    </div>
  </div>

  <!-- Floating property card -->
  <div class="ir-hero-floatcard d-lg-block" style="display:none">
    <div class="ir-float-card">
      <div class="ir-float-img"><img src="img/property-6.jpg" alt="Property"></div>
      <div class="ir-float-badges">
        <span class="badge-approved">APPROVED</span>
        <span class="badge-verified"><i class="fa fa-check-circle"></i> Verified</span>
      </div>
      <div class="ir-float-price">&#8377;85 Lakhs</div>
      <div class="ir-float-title">Premium 3BHK Apartment</div>
      <div class="ir-float-loc"><i class="fa fa-map-marker"></i>Banjara Hills, Hyderabad</div>
      <div class="ir-float-feats">
        <span class="ir-float-feat"><i class="fa fa-bed"></i> 3 Beds</span>
        <span class="ir-float-feat"><i class="fa fa-bath"></i> 2 Baths</span>
        <span class="ir-float-feat"><i class="fa fa-expand"></i> 1450 sq.ft</span>
      </div>
    </div>
  
  </div>

  <div class="ir-hero-stats">
    <div class="ir-stat"><div class="ir-stat-n">500+</div><div class="ir-stat-l">Properties Listed</div></div>
    <div class="ir-stat"><div class="ir-stat-n">1,200+</div><div class="ir-stat-l">Registered Buyers</div></div>
    <div class="ir-stat"><div class="ir-stat-n">350+</div><div class="ir-stat-l">Active Sellers</div></div>
    <div class="ir-stat"><div class="ir-stat-n">100%</div><div class="ir-stat-l">Admin Verified</div></div>
  </div>
</section>

<!-- SERVICES — Warm ivory bg -->
<section class="ir-section ir-section-cream">
  <div class="ir-section-head">
    <div class="ir-section-tag">What We Offer</div>
    <h2>Our <em>Services</em></h2>
    <p>Everything you need to buy, sell and discover properties with complete confidence.</p>
  </div>
  <div class="ir-services-grid">
    <div class="ir-service-card ir-fade-up">
      <div class="ir-service-num">01</div>
      <div class="ir-service-icon"><i class="fa fa-home"></i></div>
      <h3>Buy Property</h3>
      <p>Browse admin-verified listings with accurate pricing. Register as a buyer to access full seller contact details and arrange site visits.</p>
      <a href="usr.jsp" class="ir-service-link">Register as Buyer <i class="fa fa-arrow-right"></i></a>
    </div>
    <div class="ir-service-card ir-fade-up">
      <div class="ir-service-num">02</div>
      <div class="ir-service-icon"><i class="fa fa-tags"></i></div>
      <h3>Sell Property</h3>
      <p>List your land or property. Our admin validates pricing and approves your listing before it goes live — only serious buyers see it.</p>
      <a href="seller.jsp" class="ir-service-link">Register as Seller <i class="fa fa-arrow-right"></i></a>
    </div>
    <div class="ir-service-card ir-fade-up">
      <div class="ir-service-num">03</div>
      <div class="ir-service-icon"><i class="fa fa-shield"></i></div>
      <h3>Admin Verified</h3>
      <p>Every buyer, seller and listing undergoes admin review — creating a fully transparent, fraud-free marketplace for all.</p>
      <a href="admin.jsp" class="ir-service-link">Admin Portal <i class="fa fa-arrow-right"></i></a>
    </div>
    <div class="ir-service-card ir-fade-up">
      <div class="ir-service-num">04</div>
      <div class="ir-service-icon"><i class="fa fa-bank"></i></div>
      <h3>Loan Assistance</h3>
      <p>Get connected with trusted financial institutions for home loans. We guide you through the complete financing process.</p>
      <a href="#" class="ir-service-link">Learn More <i class="fa fa-arrow-right"></i></a>
    </div>
    <div class="ir-service-card ir-fade-up">
      <div class="ir-service-num">05</div>
      <div class="ir-service-icon"><i class="fa fa-map-marker"></i></div>
      <h3>Area Insights</h3>
      <p>Detailed insights on neighborhoods, infrastructure, schools and upcoming development plans to help make informed decisions.</p>
      <a href="#" class="ir-service-link">Explore Areas <i class="fa fa-arrow-right"></i></a>
    </div>
    <div class="ir-service-card ir-fade-up">
      <div class="ir-service-num">06</div>
      <div class="ir-service-icon"><i class="fa fa-headphones"></i></div>
      <h3>24/7 Support</h3>
      <p>Our dedicated support team is always available to assist with queries, property concerns or any platform-related questions.</p>
      <a href="#" class="ir-service-link">Contact Support <i class="fa fa-arrow-right"></i></a>
    </div>
  </div>
</section>



<!-- FOOTER -->
<footer class="ir-footer">
  <div class="ir-footer-grid">
    <div>
      <span class="ir-footer-logo">INNOVATIVE<em> RESIDENCE</em></span>
      <p class="ir-footer-desc">Premium property marketplace with admin-verified listings ensuring transparency and trust for every buyer and seller transaction in Tamil Nadu.</p>
    </div>
    <div>
      <h5>Navigation</h5>
      <ul>
        <li><a href="index.jsp">Home</a></li>
        <li><a href="usr.jsp">Buyer Register</a></li>
        <li><a href="seller.jsp">Seller Register</a></li>
        <li><a href="admin.jsp">Admin Portal</a></li>
      </ul>
    </div>
    <div>
      <h5>Account</h5>
      <ul>
        <li><a href="user_login.jsp">Buyer Login</a></li>
        <li><a href="seller_login.jsp">Seller Login</a></li>
        <li><a href="usr.jsp">New Buyer</a></li>
        <li><a href="seller.jsp">New Seller</a></li>
      </ul>
    </div>
    <div>
      <h5>Contact</h5>
      <ul>
        <li><a href="#">info@innovativeresidence.com</a></li>
        <li><a href="#">+91 98765 43210</a></li>
        <li><a href="#">Hyderabad, Telangana, India</a></li>
      </ul>
    </div>
  </div>
  
</footer>

<a href="#" class="ir-btt" id="btt"><i class="fa fa-chevron-up"></i></a>

<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>
  window.addEventListener('scroll', function(){
    document.getElementById('mainNav').classList.toggle('scrolled', window.scrollY > 60);
    document.getElementById('btt').classList.toggle('show', window.scrollY > 300);
  });
  function toggleNav(){ document.getElementById('navLinks').classList.toggle('open'); }
  const observer = new IntersectionObserver((entries)=>{
    entries.forEach(e=>{ if(e.isIntersecting) e.target.classList.add('visible'); });
  }, {threshold:0.12});
  document.querySelectorAll('.ir-fade-up').forEach(el=>observer.observe(el));
  document.getElementById('btt').addEventListener('click',function(e){
    e.preventDefault(); window.scrollTo({top:0,behavior:'smooth'});
  });
</script>
</body>
</html>
