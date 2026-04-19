<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
/* ─── SESSION GUARD ─── */
String adminUser = (String) session.getAttribute("User_Name");
if(adminUser == null){ response.sendRedirect("admin.jsp"); return; }

/* ─── PLATFORM STATS FROM ALL TABLES ─── */
// Sellers pending
DB d1=new DB(); ResultSet r1=d1.Select("SELECT COUNT(*) c FROM sellerregister WHERE sts='NO'");
int sellerPending=0; if(r1.next()) sellerPending=r1.getInt("c");

// Sellers approved
DB d2=new DB(); ResultSet r2=d2.Select("SELECT COUNT(*) c FROM sellerregister WHERE sts='Approved'");
int sellerApproved=0; if(r2.next()) sellerApproved=r2.getInt("c");

// Buyers pending
DB d3=new DB(); ResultSet r3=d3.Select("SELECT COUNT(*) c FROM register WHERE sts='NO'");
int buyerPending=0; if(r3.next()) buyerPending=r3.getInt("c");

// Buyers approved
DB d4=new DB(); ResultSet r4=d4.Select("SELECT COUNT(*) c FROM register WHERE sts='Approved'");
int buyerApproved=0; if(r4.next()) buyerApproved=r4.getInt("c");

// Land pending
DB d5=new DB(); ResultSet r5=d5.Select("SELECT COUNT(*) c FROM upload WHERE sts='NO'");
int landPending=0; if(r5.next()) landPending=r5.getInt("c");

// Land approved
DB d6=new DB(); ResultSet r6=d6.Select("SELECT COUNT(*) c FROM upload WHERE sts1='Approved'");
int landApproved=0; if(r6.next()) landApproved=r6.getInt("c");

// Flats pending
DB d7=new DB(); ResultSet r7=d7.Select("SELECT COUNT(*) c FROM flat_house WHERE sts='NO'");
int flatPending=0; if(r7.next()) flatPending=r7.getInt("c");

// Flats approved
DB d8=new DB(); ResultSet r8=d8.Select("SELECT COUNT(*) c FROM flat_house WHERE sts1='Approved'");
int flatApproved=0; if(r8.next()) flatApproved=r8.getInt("c");

// Land bookings total
DB d9=new DB(); ResultSet r9=d9.Select("SELECT COUNT(*) c FROM booking");
int landBookings=0; if(r9.next()) landBookings=r9.getInt("c");

// Flat bookings total
DB d10=new DB(); ResultSet r10=d10.Select("SELECT COUNT(*) c FROM bookingss");
int flatBookings=0; if(r10.next()) flatBookings=r10.getInt("c");

int totalPending  = sellerPending + buyerPending + landPending + flatPending;
int totalApproved = sellerApproved + buyerApproved + landApproved + flatApproved;
int totalBookings = landBookings + flatBookings;
int totalListings = landApproved + flatApproved;

// Recent sellers
DB dRS=new DB(); ResultSet rsRS=dRS.Select(
    "SELECT S_ID,username,email,mobile_no,city,sts FROM sellerregister ORDER BY S_ID DESC LIMIT 6");

// Recent buyers
DB dRB=new DB(); ResultSet rsRB=dRB.Select(
    "SELECT S_ID,username,email,mobile,city,sts FROM register ORDER BY S_ID DESC LIMIT 6");

String flashMsg=(String)session.getAttribute("msg"); session.removeAttribute("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Admin Dashboard — Innovative Residence</title>
  <link href="img/favicon.png" rel="icon">
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Fraunces:ital,wght@0,500;0,700;1,700&display=swap" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="css/admin-theme.css" rel="stylesheet">
</head>
<body>
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
          }
          session.removeAttribute("msg");
        
      %>
<%if(flashMsg!=null&&!flashMsg.isEmpty()){%>
<script>window.addEventListener('DOMContentLoaded',()=>adToast('<%=flashMsg%>','info'));</script>
<%}%>

<button class="ad-hamburger" onclick="toggleSidebar()"><i class="fa fa-bars"></i></button>

<!-- ══ SIDEBAR ══ -->
<%@ include file="admin_sidebar.jsp" %>

<!-- ══ TOPBAR ══ -->
<header class="ad-topbar">
  <div class="ad-page-title">
    Dashboard
    <span><%=totalPending%> pending action<%=totalPending!=1?"s":""%> &middot; <%=totalListings%> live listings &middot; <%=totalBookings%> booking<%=totalBookings!=1?"s":""%></span>
  </div>
  <div class="ad-topbar-actions">
    <a href="seller_req.jsp" class="ad-btn ad-btn-rose ad-btn-sm"><i class="fa fa-bell"></i> <%=totalPending%> Pending</a>
    <a href="index.jsp" class="ad-btn ad-btn-outline ad-btn-sm"><i class="fa fa-sign-out"></i> Logout</a>
  </div>
</header>

<!-- ══ MAIN ══ -->
<main class="ad-main">
<div class="ad-page">

  <!-- Hero -->
  <div class="ad-hero ad-fade">
    <div class="ad-hero-tag"><i class="fa fa-shield"></i> Admin Control Panel</div>
    <h2>Welcome, <em><%=adminUser%></em></h2>
    <p>
      <strong style="color:#818CF8"><%=totalPending%></strong> item<%=totalPending!=1?"s":""%> awaiting your approval &mdash;
      <strong style="color:#6EE7B7"><%=totalListings%></strong> properties live for buyers.
    </p>
    <div style="display:flex;gap:.7rem;margin-top:1.1rem;position:relative;z-index:1;flex-wrap:wrap">
      <a href="seller_req.jsp" class="ad-btn ad-btn-primary"><i class="fa fa-user-check"></i> Seller Approvals</a>
      <a href="buyer_req.jsp"  class="ad-btn ad-btn-outline" style="color:#fff;border-color:rgba(255,255,255,.25)"><i class="fa fa-users"></i> Buyer Approvals</a>
    </div>
  </div>

  <!-- STAT CARDS -->
  <div class="ad-stats-grid">
    <div class="ad-stat-card ad-fade">
      <div class="ad-stat-icon ad-si-rose"><i class="fa fa-hourglass-half"></i></div>
      <div>
        <div class="ad-stat-n"><%=totalPending%></div>
        <div class="ad-stat-l">Total Pending</div>
        <div class="ad-stat-delta">sellers:<%=sellerPending%> buyers:<%=buyerPending%> listings:<%=(landPending+flatPending)%></div>
      </div>
    </div>
    <div class="ad-stat-card ad-fade">
      <div class="ad-stat-icon ad-si-indigo"><i class="fa fa-user-secret"></i></div>
      <div>
        <div class="ad-stat-n"><%=sellerApproved%></div>
        <div class="ad-stat-l">Active Sellers</div>
        <div class="ad-stat-delta"><%=sellerPending%> pending · sellerregister</div>
      </div>
    </div>
    <div class="ad-stat-card ad-fade">
      <div class="ad-stat-icon ad-si-sky"><i class="fa fa-users"></i></div>
      <div>
        <div class="ad-stat-n"><%=buyerApproved%></div>
        <div class="ad-stat-l">Active Buyers</div>
        <div class="ad-stat-delta"><%=buyerPending%> pending · register</div>
      </div>
    </div>
    <div class="ad-stat-card ad-fade">
      <div class="ad-stat-icon ad-si-green"><i class="fa fa-building"></i></div>
      <div>
        <div class="ad-stat-n"><%=totalListings%></div>
        <div class="ad-stat-l">Live Listings</div>
        <div class="ad-stat-delta">flat:<%=flatApproved%> · land:<%=landApproved%></div>
      </div>
    </div>
    <div class="ad-stat-card ad-fade">
      <div class="ad-stat-icon ad-si-amber"><i class="fa fa-handshake-o"></i></div>
      <div>
        <div class="ad-stat-n"><%=totalBookings%></div>
        <div class="ad-stat-l">Total Bookings</div>
        <div class="ad-stat-delta">flat:<%=flatBookings%> · land:<%=landBookings%></div>
      </div>
    </div>
    <div class="ad-stat-card ad-fade">
      <div class="ad-stat-icon ad-si-rose"><i class="fa fa-clock-o"></i></div>
      <div>
        <div class="ad-stat-n"><%=(landPending+flatPending)%></div>
        <div class="ad-stat-l">Property Queue</div>
        <div class="ad-stat-delta">land:<%=landPending%> · flat:<%=flatPending%></div>
      </div>
    </div>
  </div>

  <!-- Quick Actions -->
  <div class="ad-card ad-fade">
    <div class="ad-card-head">
      <div class="ad-card-title"><i class="fa fa-bolt"></i> Quick Actions</div>
    </div>
    <div class="ad-card-body">
      <div class="ad-qa-grid">
        <a href="buyer_req.jsp" class="ad-qa-tile">
          <div class="ad-qa-icon ad-si-sky"><i class="fa fa-user-plus"></i></div>
          <div class="ad-qa-label">Buyer Approvals</div>
          <div class="ad-qa-sub"><%=buyerPending%> pending · register</div>
        </a>
        <a href="seller_req.jsp" class="ad-qa-tile">
          <div class="ad-qa-icon ad-si-indigo"><i class="fa fa-user-secret"></i></div>
          <div class="ad-qa-label">Seller Approvals</div>
          <div class="ad-qa-sub"><%=sellerPending%> pending · sellerregister</div>
        </a>
        <a href="LAND_Approval.jsp" class="ad-qa-tile">
          <div class="ad-qa-icon ad-si-green"><i class="fa fa-map-o"></i></div>
          <div class="ad-qa-label">Land Approval</div>
          <div class="ad-qa-sub"><%=landPending%> pending · upload</div>
        </a>
        <a href="Approval.jsp" class="ad-qa-tile">
          <div class="ad-qa-icon ad-si-amber"><i class="fa fa-building"></i></div>
          <div class="ad-qa-label">Flat/House Approval</div>
          <div class="ad-qa-sub"><%=flatPending%> pending · flat_house</div>
        </a>
        <a href="seller details.jsp" class="ad-qa-tile">
          <div class="ad-qa-icon ad-si-rose"><i class="fa fa-id-card"></i></div>
          <div class="ad-qa-label">Seller Details</div>
          <div class="ad-qa-sub"><%=sellerApproved%> active sellers</div>
        </a>
        <a href="buyer details.jsp" class="ad-qa-tile">
          <div class="ad-qa-icon ad-si-sky"><i class="fa fa-address-book"></i></div>
          <div class="ad-qa-label">Buyer Details</div>
          <div class="ad-qa-sub"><%=buyerApproved%> active buyers</div>
        </a>
        <a href="USER BOOKING.jsp" class="ad-qa-tile">
          <div class="ad-qa-icon ad-si-green"><i class="fa fa-calendar-check-o"></i></div>
          <div class="ad-qa-label">Land Bookings</div>
          <div class="ad-qa-sub"><%=landBookings%> total · booking</div>
        </a>
        <a href="USER BOOKING1.jsp" class="ad-qa-tile">
          <div class="ad-qa-icon ad-si-amber"><i class="fa fa-calendar"></i></div>
          <div class="ad-qa-label">Flat Bookings</div>
          <div class="ad-qa-sub"><%=flatBookings%> total · bookingss</div>
        </a>
      </div>
    </div>
  </div>

  <!-- Recent Sellers + Buyers side by side -->
  <div style="display:grid;grid-template-columns:1fr 1fr;gap:1.2rem" class="ad-fade">

    <!-- Recent Sellers -->
    <div class="ad-card" style="margin-bottom:0">
      <div class="ad-card-head">
        <div>
          <div class="ad-card-title"><i class="fa fa-user-secret"></i> Recent Sellers</div>
          <div class="ad-card-sub">sellerregister · latest 6</div>
        </div>
        <a href="seller_req.jsp" class="ad-btn ad-btn-outline ad-btn-sm">View All <i class="fa fa-arrow-right"></i></a>
      </div>
      <div class="ad-table-wrap">
        <table class="ad-table">
          <thead><tr><th>Name</th><th>City</th><th>Status</th></tr></thead>
          <tbody>
          <%boolean sFound=false; while(rsRS.next()){sFound=true;
              String ss=rsRS.getString("sts");
              String sc="Approved".equals(ss)?"ad-badge-green":"NO".equals(ss)?"ad-badge-amber":"ad-badge-rose";
          %>
          <tr>
            <td>
              <div class="ad-table-name"><%=rsRS.getString("username")!=null?rsRS.getString("username"):"—"%></div>
              <div class="ad-table-sub"><%=rsRS.getString("email")!=null?rsRS.getString("email"):"—"%></div>
            </td>
            <td style="font-size:.8rem;color:var(--text2)"><%=rsRS.getString("city")!=null?rsRS.getString("city"):"—"%></td>
            <td><span class="ad-badge <%=sc%> ad-badge-dot"><%=ss!=null?ss:"—"%></span></td>
          </tr>
          <%}if(!sFound){%>
          <tr><td colspan="3"><div class="ad-empty" style="padding:1.5rem"><i class="fa fa-users" style="font-size:1.5rem;color:var(--border3);display:block;margin-bottom:.4rem"></i>No sellers yet</div></td></tr>
          <%}%>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Recent Buyers -->
    <div class="ad-card" style="margin-bottom:0">
      <div class="ad-card-head">
        <div>
          <div class="ad-card-title"><i class="fa fa-users"></i> Recent Buyers</div>
          <div class="ad-card-sub">register · latest 6</div>
        </div>
        <a href="buyer_req.jsp" class="ad-btn ad-btn-outline ad-btn-sm">View All <i class="fa fa-arrow-right"></i></a>
      </div>
      <div class="ad-table-wrap">
        <table class="ad-table">
          <thead><tr><th>Name</th><th>City</th><th>Status</th></tr></thead>
          <tbody>
          <%boolean bFound=false; while(rsRB.next()){bFound=true;
              String bs=rsRB.getString("sts");
              String bc="Approved".equals(bs)?"ad-badge-green":"NO".equals(bs)?"ad-badge-amber":"ad-badge-rose";
          %>
          <tr>
            <td>
              <div class="ad-table-name"><%=rsRB.getString("username")!=null?rsRB.getString("username"):"—"%></div>
              <div class="ad-table-sub"><%=rsRB.getString("email")!=null?rsRB.getString("email"):"—"%></div>
            </td>
            <td style="font-size:.8rem;color:var(--text2)"><%=rsRB.getString("city")!=null?rsRB.getString("city"):"—"%></td>
            <td><span class="ad-badge <%=bc%> ad-badge-dot"><%=bs!=null?bs:"—"%></span></td>
          </tr>
          <%}if(!bFound){%>
          <tr><td colspan="3"><div class="ad-empty" style="padding:1.5rem"><i class="fa fa-user" style="font-size:1.5rem;color:var(--border3);display:block;margin-bottom:.4rem"></i>No buyers yet</div></td></tr>
          <%}%>
          </tbody>
        </table>
      </div>
    </div>

  </div>

</div>
</main>

<div id="adToastBox"></div>
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>
function toggleSidebar(){ document.getElementById('adSidebar').classList.toggle('open'); }
const obs=new IntersectionObserver(e=>e.forEach(en=>{if(en.isIntersecting)en.target.classList.add('vis')}),{threshold:.08});
document.querySelectorAll('.ad-fade').forEach(el=>obs.observe(el));
document.querySelectorAll('.ad-nav-group-toggle').forEach(btn=>{
  btn.addEventListener('click',()=>{
    btn.classList.toggle('open');
    const sub=btn.nextElementSibling;
    if(sub) sub.classList.toggle('open');
  });
});
function adToast(msg,type){
  var c={info:'var(--primary)',success:'var(--green)',warn:'var(--amber)',error:'var(--rose)'};
  var t=document.createElement('div');
  t.style.cssText='background:white;border:1px solid var(--border);border-left:3px solid '+(c[type]||c.info)+
    ';border-radius:var(--r);padding:.8rem 1rem;font-size:.83rem;color:var(--text);box-shadow:var(--sh-md);'+
    'min-width:260px;max-width:340px;animation:adFadeUp .3s both;pointer-events:auto';
  t.textContent=msg;
  document.getElementById('adToastBox').appendChild(t);
  setTimeout(()=>t.remove(),4500);
}
</script>
</body>
</html>
