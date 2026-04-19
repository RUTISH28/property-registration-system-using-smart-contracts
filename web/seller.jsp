<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Seller Registration — Innovative Residence</title>
  <link rel="icon" href="img/favicon.png">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;0,900;1,400&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500;9..40,600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="css/ir-theme.css" rel="stylesheet">
</head>
<body>
 <!-- Session Message -->
      <%
        String msg = (String) session.getAttribute("msg");
        if (msg != null) {
          boolean isSuccess = msg.toLowerCase().contains("success") || msg.toLowerCase().contains("register");
      %>
      <script>alert("<%=msg%>");</script>
        <div class="ir-alert <%= isSuccess ? "ir-a-success" : "ir-a-danger" %>">
          <i class="fa fa-<%= isSuccess ? "check-circle" : "exclamation-circle" %>"></i>
          <span><%= msg %></span>
        </div>
      <%
          session.removeAttribute("msg");
        }
      %>


<div class="ir-bg-shapes">
    <div class="ir-shape ir-shape-1"></div>
  <div class="ir-shape ir-shape-2"></div>
</div>



<!-- NAVBAR -->
<nav class="ir-nav scrolled" id="mainNav">
  <a class="ir-brand" href="index.jsp">
    INNOVATIVE<span class="ir-brand-dot"></span><em>RESIDENCE</em>
  </a>
  <ul class="ir-nav-links" id="navLinks">
    <li><a href="index.jsp">Home</a></li>
    <li><a href="usr.jsp">Buyer Register</a></li>
    <li><a href="seller.jsp" class="active">Seller Register</a></li>
    <li><a href="user_login.jsp">Buyer Login</a></li>
    <li><a href="seller_login.jsp">Seller Login</a></li>
    <li><a href="admin.jsp" class="ir-nav-cta"><i class="fa fa-shield"></i> Admin</a></li>
  </ul>
  <div class="ir-nav-toggle" onclick="document.getElementById('navLinks').classList.toggle('open')">
    <span></span><span></span><span></span>
  </div>
</nav>

<!-- FORM PAGE -->
<div class="ir-form-page" style="padding:calc(var(--nav-h) + 2rem) 1.5rem 3rem">
  <div class="ir-form-page-glow"></div>

  <div class="ir-form-wrap ir-form-wrap-wide" style="max-width:680px">
    <div class="ir-form-card" style="position:relative">
      <div class="ir-form-card-corner"></div>

      <div class="ir-form-head">
        <div class="ir-form-logo-icon" style="background:rgba(23,195,168,0.1);border-color:rgba(23,195,168,0.25)">
          <i class="fa fa-home" style="color:var(--teal)"></i>
        </div>
        <h2>Seller Registration</h2>
        <div class="ir-form-rule"></div>
        <p>Create your seller account. Admin approval required before listing goes live.</p>
      </div>

      <% if(msg != null){ %>
      <div id="sessionMsg" class="ir-alert ir-a-info" style="display:flex">
        <i class="fa fa-info-circle"></i>
        <span><%= msg %></span>
      </div>
      <% } %>

      <form action="sel_reg" enctype="multipart/form-data" method="post" onsubmit="return validateSeller()">

        <div class="ir-row-2">
          <div class="ir-fg">
            <label>Aadhar Number <span style="color:var(--err)">*</span></label>
            <input type="text" id="lnum" name="A_Name" class="ir-input"
                   placeholder="12-digit Aadhar number"
                   onkeypress="return numOnly(event)" maxlength="12" required>
          </div>
          <div class="ir-fg">
            <label>Full Name <span style="color:var(--err)">*</span></label>
            <input type="text" id="hname" name="username" class="ir-input"
                   placeholder="Enter your full name" required>
          </div>
        </div>

        <div class="ir-row-2">
          <div class="ir-fg">
            <label>Email Address <span style="color:var(--err)">*</span></label>
            <input type="text" id="mail" name="email" class="ir-input"
                   placeholder="example@email.com" required>
          </div>
          <div class="ir-fg">
            <label>Gender <span style="color:var(--err)">*</span></label>
            <select name="Gender" id="sex" class="ir-input" required>
              <option value="Sex">Select Gender</option>
              <option value="Male">Male</option>
              <option value="Female">Female</option>
              <option value="Other">Other</option>
            </select>
          </div>
        </div>

        <div class="ir-row-2">
          <div class="ir-fg">
            <label>Password <span style="color:var(--err)">*</span></label>
            <div class="ir-pw-wrap">
              <input type="password" name="pass_word" id="pass" class="ir-input ir-pw-input"
                     placeholder="Create a strong password" required>
              <span class="ir-pw-toggle" onclick="togglePw('pass',this)">
                <i class="fa fa-eye"></i> Show
              </span>
            </div>
          </div>
          <div class="ir-fg">
            <label>Confirm Password <span style="color:var(--err)">*</span></label>
            <input type="password" name="con_pass" id="rpass" class="ir-input"
                   placeholder="Repeat password" required>
          </div>
        </div>

        <div class="ir-row-2">
          <div class="ir-fg">
            <label>Date of Birth <span style="color:var(--err)">*</span></label>
            <input type="date" name="dob" id="Dob" class="ir-input" required>
          </div>
          <div class="ir-fg">
            <label>Mobile Number <span style="color:var(--err)">*</span></label>
            <input type="text" name="mobile_no" id="con" class="ir-input"
                   placeholder="10-digit mobile" maxlength="10"
                   onkeypress="return numOnly(event)" required>
          </div>
        </div>

        <div class="ir-row-2">
          <div class="ir-fg">
            <label>City <span style="color:var(--err)">*</span></label>
            <input type="text" name="city" id="cit" class="ir-input"
                   placeholder="Your city" required>
          </div>
          <div class="ir-fg">
            <label>Address <span style="color:var(--err)">*</span></label>
            <input type="text" name="address" id="ad" class="ir-input"
                   placeholder="Full address" required>
          </div>
        </div>

        <div class="ir-fg">
          <label>Profile Photo <span style="color:var(--err)">*</span></label>
          <input type="file" id="image" name="Image" class="ir-input"
                 accept="image/*" required>
        </div>

        <div class="ir-btn-pair">
          <button type="submit" class="ir-submit ir-submit-gold">
            <i class="fa fa-paper-plane" style="margin-right:7px"></i>Register Now
          </button>
          <button type="reset" class="ir-submit ir-submit-dark">
            <i class="fa fa-undo" style="margin-right:7px"></i>Clear Form
          </button>
        </div>

      </form>

      <div class="ir-form-foot">
        Already registered? <a href="seller_login.jsp">Seller Login &rarr;</a>
      </div>
    </div>
  </div>
</div>

<!-- FOOTER -->
<footer class="ir-footer">
  <div class="ir-footer-grid">
    <div>
      <span class="ir-footer-logo">INNOVATIVE<em> RESIDENCE</em></span>
      <p class="ir-footer-desc">Premium property marketplace with admin-verified listings ensuring transparency and trust.</p>
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
  function validateSeller() {
    var hname = document.getElementById('hname').value.trim();
    if (!hname || !/^[a-zA-Z ]+$/.test(hname)) { alert('Enter a valid name (letters only)'); return false; }
    var lnum = document.getElementById('lnum').value.trim();
    if (!lnum || lnum.length !== 12) { alert('Aadhar number must be exactly 12 digits'); return false; }
    var mail = document.getElementById('mail').value.trim();
    if (!mail || !/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z]{2,4})+$/.test(mail)) {
      alert('Invalid Email ID'); return false;
    }
    if (document.getElementById('sex').value === 'Sex') { alert('Please select Gender'); return false; }
    var pass = document.getElementById('pass').value;
    if (!pass) { alert('Password cannot be empty'); return false; }
    if (pass !== document.getElementById('rpass').value) { alert('Passwords do not match'); return false; }
    var con = document.getElementById('con').value.trim();
    if (!con || !['9','8','7'].includes(con.charAt(0)) || con.length !== 10) {
      alert('Enter a valid 10-digit mobile number starting with 9, 8 or 7'); return false;
    }
    if (!document.getElementById('ad').value.trim()) { alert('Enter your address'); return false; }
    var cit = document.getElementById('cit').value.trim();
    if (!cit || !/^[a-zA-Z]+$/.test(cit)) { alert('City name should contain only letters'); return false; }
    return true;
  }
</script>
</body>
</html>
