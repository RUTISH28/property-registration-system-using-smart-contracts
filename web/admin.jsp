<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Admin Login — Innovative Residence</title>
  <link rel="icon" href="img/favicon.png">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;0,900;1,400&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500;9..40,600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="css/ir-theme.css" rel="stylesheet">
  <style>
    .admin-glow {
      position:absolute; inset:0;
      background:
        radial-gradient(ellipse 60% 50% at 50% 20%, rgba(201,168,76,0.12) 0%, transparent 60%),
        radial-gradient(ellipse 40% 40% at 80% 80%, rgba(59,130,246,0.08) 0%, transparent 50%);
      pointer-events:none;
    }
    .admin-badge {
      display:inline-flex; align-items:center; gap:8px;
      padding:5px 14px 5px 8px;
      background:rgba(239,68,68,0.1);
      border:1px solid rgba(239,68,68,0.2);
      border-radius:var(--r-pill);
      font-size:0.65rem; font-weight:700;
      letter-spacing:2px; text-transform:uppercase;
      color:#fca5a5; margin-bottom:1.5rem;
      font-family:var(--ff-mono);
    }
    .admin-badge-dot {
      width:16px; height:16px;
      background:rgba(239,68,68,0.15);
      border:1px solid rgba(239,68,68,0.3);
      border-radius:50%;
      display:flex; align-items:center; justify-content:center;
    }
    .admin-badge-dot::before {
      content:'';
      width:5px; height:5px;
      background:#ef4444;
      border-radius:50%;
      animation:pulse 2.5s infinite;
    }
  </style>
</head>
<body>

<div class="ir-bg-shapes">
    <div class="ir-shape ir-shape-1" style="width:500px;height:500px;top:-100px;right:-100px"></div>
  <div class="ir-shape ir-shape-2"></div>
</div>

<!-- Session msg -->
<% String msg=(String)session.getAttribute("msg");
   if(msg!=null){ %>
<script>
  window.addEventListener('DOMContentLoaded',function(){
    var el = document.getElementById('sessionMsg');
    if(el) el.style.display='flex';
  });
</script>
<% } session.removeAttribute("msg"); %>

<!-- NAVBAR -->
<nav class="ir-nav scrolled" style="position:fixed">
  <a class="ir-brand" href="index.jsp">
    INNOVATIVE<span class="ir-brand-dot"></span><em>RESIDENCE</em>
  </a>
  <ul class="ir-nav-links" id="navLinks">
    <li><a href="index.jsp">Home</a></li>
    <li><a href="usr.jsp">Buyer Register</a></li>
    <li><a href="seller.jsp">Seller Register</a></li>
    <li><a href="user_login.jsp">Buyer Login</a></li>
    <li><a href="seller_login.jsp">Seller Login</a></li>
    <li><a href="admin.jsp" class="ir-nav-cta active"><i class="fa fa-shield"></i> Admin</a></li>
  </ul>
  <div class="ir-nav-toggle" onclick="document.getElementById('navLinks').classList.toggle('open')">
    <span></span><span></span><span></span>
  </div>
</nav>

<!-- CENTERED FORM -->
<div class="ir-form-page">
  <div class="admin-glow"></div>

  <div class="ir-form-wrap" style="z-index:2;position:relative">
    <!-- Admin eyebrow -->
    <div style="text-align:center;margin-bottom:0.5rem">
      <div class="admin-badge">
        <span class="admin-badge-dot"></span>
        Restricted Access
      </div>
    </div>

    <div class="ir-form-card" style="position:relative">
      <!-- Red accent top instead of gold -->
      <div style="position:absolute;top:0;left:12%;right:12%;height:1px;background:linear-gradient(90deg,transparent,rgba(239,68,68,0.4),transparent)"></div>
      <div class="ir-form-card-corner"></div>

      <div class="ir-form-head">
        <div class="ir-form-logo-icon" style="background:rgba(239,68,68,0.1);border-color:rgba(239,68,68,0.25)">
          <i class="fa fa-shield" style="color:#ef4444"></i>
        </div>
        <h2>Admin Portal</h2>
        <div class="ir-form-rule" style="background:linear-gradient(135deg,#ef4444,#f87171)"></div>
        <p>Authorized personnel only. All access is logged and monitored.</p>
      </div>

     

      <form action="admin_log" method="post">

        <div class="ir-fg">
          <label>Admin Username</label>
          <input type="text" name="User_Name" class="ir-input"
                 placeholder="Enter admin username"
                  required>
        </div>

        <div class="ir-fg">
          <label>Password</label>
          <div class="ir-pw-wrap">
            <input type="password" name="password" id="pass" class="ir-input ir-pw-input"
                   placeholder="Enter admin password" required>
            <span class="ir-pw-toggle" onclick="togglePw('pass',this)">
              <i class="fa fa-eye"></i> Show
            </span>
          </div>
        </div>

        <button type="submit" class="ir-submit" style="width:100%;padding:13px;border:none;border-radius:var(--r);font-family:var(--ff-body);font-size:0.9rem;font-weight:700;cursor:pointer;transition:all 0.25s;margin-top:0.5rem;background:linear-gradient(135deg,#dc2626,#ef4444);color:#fff;box-shadow:0 8px 30px rgba(239,68,68,0.3)">
          <i class="fa fa-lock" style="margin-right:8px"></i>Access Admin Panel
        </button>

      </form>

      <div class="ir-form-foot">
        <a href="index.jsp" style="color:var(--text2)"><i class="fa fa-arrow-left" style="margin-right:5px"></i>Back to Home</a>
      </div>
    </div>

    <!-- Warning note -->
    <div style="margin-top:1.2rem;padding:0.9rem 1.2rem;background:rgba(239,68,68,0.07);border:1px solid rgba(239,68,68,0.15);border-radius:var(--r);display:flex;align-items:flex-start;gap:10px">
      <i class="fa fa-exclamation-triangle" style="color:#f87171;margin-top:2px;flex-shrink:0"></i>
      <span style="font-size:0.76rem;color:var(--text2);line-height:1.6">This is a secure admin area. Unauthorized access attempts are recorded. If you are not an authorized administrator, please leave this page immediately.</span>
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
