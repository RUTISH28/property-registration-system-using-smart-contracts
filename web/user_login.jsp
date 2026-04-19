<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Buyer Login — Innovative Residence</title>
  <link rel="icon" href="img/favicon.png">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;0,900;1,400&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500;9..40,600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="css/ir-theme.css" rel="stylesheet">
</head>
<body>

<div class="ir-bg-shapes">
    <div class="ir-shape ir-shape-1"></div>
  <div class="ir-shape ir-shape-2"></div>
</div>
<div class="ir-bg-dots"></div>

<!-- NAVBAR -->
<nav class="ir-nav scrolled" style="position:fixed">
  <a class="ir-brand" href="index.jsp">
    INNOVATIVE<span class="ir-brand-dot"></span><em>RESIDENCE</em>
  </a>
  <ul class="ir-nav-links" id="navLinks">
    <li><a href="index.jsp">Home</a></li>
    <li><a href="usr.jsp">Buyer Register</a></li>
    <li><a href="seller.jsp">Seller Register</a></li>
    <li><a href="user_login.jsp" class="active">Buyer Login</a></li>
    <li><a href="seller_login.jsp">Seller Login</a></li>
    <li><a href="admin.jsp" class="ir-nav-cta"><i class="fa fa-shield"></i> Admin</a></li>
  </ul>
  <div class="ir-nav-toggle" onclick="document.getElementById('navLinks').classList.toggle('open')">
    <span></span><span></span><span></span>
  </div>
</nav>



  <!-- Visual side -->
  

  <!-- Form side -->
  <div class="ir-login-side">
    <div class="ir-form-page-glow"></div>
    <div class="ir-form-wrap" style="z-index:2;position:relative">

      <div class="ir-form-card">
        <div class="ir-form-head">
          <div class="ir-form-logo-icon">
            <i class="fa fa-sign-in"></i>
          </div>
          <h2>Buyer Login</h2>
          <div class="ir-form-rule"></div>
          <p>Welcome back. Sign in to browse verified properties.</p>
        </div>

        <% String msg=(String)session.getAttribute("msg");
           if(msg!=null){ %>
        <div class="ir-alert ir-a-danger">
          <i class="fa fa-exclamation-circle"></i>
          <span><%= msg %></span>
        </div>
        <% session.removeAttribute("msg"); } %>

        <form action="log" method="post">

          <div class="ir-fg">
            <label>Aadhar Number</label>
            <input type="text" name="A_Name" class="ir-input"
                   placeholder="Enter your 12-digit Aadhar number"
                   onkeypress="return numOnly(event)" maxlength="12" required>
          </div>

          <div class="ir-fg">
            <label>Password</label>
            <div class="ir-pw-wrap">
              <input type="password" name="U_Pass" id="pass" class="ir-input ir-pw-input"
                     placeholder="Enter your password" required>
              <span class="ir-pw-toggle" onclick="togglePw('pass',this)">
                <i class="fa fa-eye"></i> Show
              </span>
            </div>
          </div>

          <button type="submit" class="ir-submit ir-submit-gold" style="margin-top:0.8rem">
            <i class="fa fa-sign-in" style="margin-right:8px"></i>Sign In
          </button>

        </form>

        <div class="ir-form-foot">
          New user? <a href="usr.jsp">Register as Buyer &rarr;</a>
        </div>
      </div>

      <!-- Info chip -->
      <div style="margin-top:1.2rem;padding:0.9rem 1.2rem;background:var(--gold-dim);border:1px solid var(--gold-stroke);border-radius:var(--r);display:flex;align-items:flex-start;gap:10px">
        <i class="fa fa-info-circle" style="color:var(--gold);margin-top:2px;flex-shrink:0"></i>
        <span style="font-size:0.78rem;color:var(--text2);line-height:1.6">Your account must be approved by the admin before you can log in. Check your email for approval status.</span>
      </div>
    </div>
  </div>
</div>

<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>
  function togglePw(id, el) {
    var f = document.getElementById(id);
    if (f.type === 'password') { f.type = 'text'; el.innerHTML = '<i class="fa fa-eye-slash"></i> Hide'; }
    else { f.type = 'password'; el.innerHTML = '<i class="fa fa-eye"></i> Show'; }
  }
  function numOnly(e) {
    var c = e.charCode ? e.charCode : e.keyCode;
    if (c !== 8 && (c < 48 || c > 57)) return false;
  }
</script>
</body>
</html>
