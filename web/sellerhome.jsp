<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Seller Dashboard — Innovative Residence</title>
  <link href="img/favicon.png" rel="icon">
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Fraunces:ital,wght@0,500;0,700;1,500;1,700&display=swap" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="css/seller-theme.css" rel="stylesheet">
</head>
<body>

<%
  String A_Name = (String) session.getAttribute("A_Name");
  String sellerUser = (String) session.getAttribute("User");
  Integer U_Id = (Integer) session.getAttribute("U_Id");
  if (A_Name == null) { response.sendRedirect("index.jsp"); return; }

  // ── Seller profile ──────────────────────────────────────────────────────────
  DB db = new DB();
  ResultSet sellerRs = db.Select("SELECT * FROM sellerregister WHERE A_Name='" + A_Name + "'");
  String sellerName = "Seller"; String sellerEmail = ""; String sellerCity = "";
  if (sellerRs.next()) {
    sellerName = sellerRs.getString("username");
    sellerEmail = sellerRs.getString("email");
    sellerCity  = sellerRs.getString("city");
  }

  // ── flat_house stats — ONE query, all counts ─────────────────────────────
  // Each new DB() gets its own connection so we avoid the shared-Statement bug
  int flatTotalCount = 0, flatPendingCount = 0, flatApprovedCount = 0;
  try {
    DB dbFlat = new DB();
    ResultSet rfh = dbFlat.Select(
      "SELECT " +
      "  COUNT(*) AS total," +
      "  SUM(CASE WHEN sts1='Pending'  THEN 1 ELSE 0 END) AS pending," +
      "  SUM(CASE WHEN sts1='Approved' THEN 1 ELSE 0 END) AS approved " +
      "FROM flat_house WHERE A_Name='" + A_Name + "'"
    );
    if (rfh != null && rfh.next()) {
      flatTotalCount    = rfh.getInt("total");
      flatPendingCount  = rfh.getInt("pending");
      flatApprovedCount = rfh.getInt("approved");
    }
  } catch(Exception eignore) {}

  // ── upload (land) stats — ONE query ──────────────────────────────────────
  int landTotalCount = 0, landPendingCount = 0, landApprovedCount = 0;
  try {
    DB dbLand = new DB();
    ResultSet rul = dbLand.Select(
      "SELECT " +
      "  COUNT(*) AS total," +
      "  SUM(CASE WHEN sts1='Pending'  THEN 1 ELSE 0 END) AS pending," +
      "  SUM(CASE WHEN sts1='Approved' THEN 1 ELSE 0 END) AS approved " +
      "FROM upload WHERE A_Name='" + A_Name + "'"
    );
    if (rul != null && rul.next()) {
      landTotalCount    = rul.getInt("total");
      landPendingCount  = rul.getInt("pending");
      landApprovedCount = rul.getInt("approved");
    }
  } catch(Exception eignore) {}

  // ── booking counts ────────────────────────────────────────────────────────
  int bookedFlatsCount = 0;
  try {
    DB dbBF = new DB();
    ResultSet rbf = dbBF.Select("SELECT COUNT(*) AS cnt FROM bookingss WHERE SA_NAME='" + A_Name + "'");
    if (rbf != null && rbf.next()) bookedFlatsCount = rbf.getInt("cnt");
  } catch(Exception eignore) {}

  int bookedLandsCount = 0;
  try {
    DB dbBL = new DB();
    ResultSet rbl = dbBL.Select("SELECT COUNT(*) AS cnt FROM booking WHERE SA_Name='" + A_Name + "'");
    if (rbl != null && rbl.next()) bookedLandsCount = rbl.getInt("cnt");
  } catch(Exception eignore) {}

  int totalListings = flatTotalCount + landTotalCount;
  int totalPending  = flatPendingCount + landPendingCount;
  int totalApproved = flatApprovedCount + landApprovedCount;
  int totalBooked   = bookedFlatsCount + bookedLandsCount;

  char avatarChar = sellerName.length() > 0 ? sellerName.charAt(0) : 'S';
%>

<button class="sd-hamburger" id="hamburger" onclick="toggleSidebar()"><i class="fa fa-bars"></i></button>

<!-- SIDEBAR — exact same structure as sellerhome.jsp -->
<aside class="sd-sidebar" id="sidebar">
  <div class="sd-logo">
    <div class="sd-logo-text">INNOVATIVE<em> RESIDENCE</em></div>
    <div class="sd-logo-sub">Seller Portal</div>
  </div>
  <div class="sd-user-chip">
    <div class="sd-avatar"><%=avatarChar%></div>
    <div>
      <div class="sd-user-name"><%=sellerName%></div>
      <div class="sd-user-role">Verified Seller</div>
    </div>
  </div>
  <nav class="sd-nav">
    <div class="sd-nav-section">
      <div class="sd-nav-label">Main</div>
      <a href="sellerhome.jsp" class="active"><i class="fa fa-home"></i> Dashboard</a>
      <a href="House.jsp"><i class="fa fa-building"></i> Upload Flat/House</a>
      <a href="sellerhome2.jsp"><i class="fa fa-map-o"></i> Upload Land</a>
    </div>
    <div class="sd-nav-section">
      <div class="sd-nav-label">My Listings</div>
      <a href="seller_flatapprove.jsp"><i class="fa fa-check-circle"></i> Approved Flats</a>
      <a href="seller_landapprove.jsp"><i class="fa fa-check-circle-o"></i> Approved Lands</a>
      <a href="view4.jsp"><i class="fa fa-calendar-check-o"></i> Booked Flats</a>
      <a href="view3.jsp"><i class="fa fa-calendar"></i> Booked Lands</a>
    </div>
    <div class="sd-nav-section">
      <div class="sd-nav-label">Chat Session</div>
      <a href="seller_chat.jsp" ><i class="fa fa-comments"></i> Chat with Buyers </a>
    </div>
    <div class="sd-nav-section">
      <div class="sd-nav-label">Account Session</div>
      <a href="seller_add_acc.jsp"><i class="fa fa-home"></i> Add Acc</a>
      <a href="view_seller_acc.jsp"><i class="fa fa-map-o"></i> View Acc</a>
      <a href="seller_transactions.jsp"><i class="fa fa-list-alt"></i> Transactions</a>
    </div>
   
  </nav>
  <div class="sd-sidebar-footer">
    <a href="index.jsp" class="sd-logout"><i class="fa fa-sign-out"></i> Sign Out</a>
  </div>
</aside>

<!-- TOP BAR -->
<header class="sd-topbar">
  <div class="sd-page-title">
    Dashboard
    <span>Welcome back, <%=sellerName%> — here's what's happening today</span>
  </div>
  <div class="sd-topbar-actions">
    <div class="sd-icon-btn"><i class="fa fa-bell"></i><span class="sd-notif-dot"></span></div>
    <div class="sd-icon-btn" onclick="location.reload()"><i class="fa fa-refresh"></i></div>
    <a href="index.jsp" class="sd-btn sd-btn-outline sd-btn-sm"><i class="fa fa-sign-out"></i> Logout</a>
  </div>
</header>

<!-- MAIN -->
<main class="sd-main">
  <div class="sd-page">

    <%
      String msg = (String)session.getAttribute("msg");
      if(msg != null) { %>
      <div class="sd-alert sd-a-info" style="margin-bottom:1rem"><i class="fa fa-info-circle"></i> <%=msg%></div>
    <% session.removeAttribute("msg"); } %>

    <!-- HERO BANNER -->
    <div class="sd-hero-banner sd-fade">
      <div class="sd-hero-tag"><i class="fa fa-star"></i> Seller Dashboard</div>
      <h2>Manage Your <em>Property Listings</em></h2>
      <p>Upload, track and monitor all your properties in <%=sellerCity.isEmpty()?"your city":sellerCity%>. Admin-verified listings go live instantly for buyers to see.</p>
      <div style="display:flex;gap:.75rem;margin-top:1.2rem;position:relative;z-index:1;flex-wrap:wrap">
        <a href="House.jsp" class="sd-btn sd-btn-primary"><i class="fa fa-plus"></i> Upload Flat/House</a>
        <a href="sellerhome2.jsp" class="sd-btn sd-btn-outline" style="color:#fff;border-color:rgba(255,255,255,0.2)"><i class="fa fa-map-o"></i> Upload Land</a>
      </div>
    </div>

    <!-- STATS GRID (real DB values) -->
    <div class="sd-stats-grid">
      <div class="sd-stat-card sd-fade">
        <div class="sd-stat-icon sd-si-green"><i class="fa fa-home"></i></div>
        <div>
          <div class="sd-stat-n"><%=totalListings%></div>
          <div class="sd-stat-l">Total Listings</div>
          <div class="sd-stat-delta sd-delta-up"><i class="fa fa-building"></i> <%=flatTotalCount%> Flats &bull; <%=landTotalCount%> Lands</div>
        </div>
      </div>
      <div class="sd-stat-card sd-fade">
        <div class="sd-stat-icon sd-si-amber"><i class="fa fa-clock-o"></i></div>
        <div>
          <div class="sd-stat-n"><%=totalPending%></div>
          <div class="sd-stat-l">Pending Approval</div>
          <div class="sd-stat-delta sd-delta-down"><i class="fa fa-minus"></i> Admin reviewing</div>
        </div>
      </div>
      <div class="sd-stat-card sd-fade">
        <div class="sd-stat-icon sd-si-sky"><i class="fa fa-check-circle"></i></div>
        <div>
          <div class="sd-stat-n"><%=totalApproved%></div>
          <div class="sd-stat-l">Approved Listings</div>
          <div class="sd-stat-delta sd-delta-up"><i class="fa fa-arrow-up"></i>
            <%=totalListings>0 ? Math.round((totalApproved*100.0)/totalListings)+"% approval rate" : "No listings yet"%>
          </div>
        </div>
      </div>
      <div class="sd-stat-card sd-fade">
        <div class="sd-stat-icon sd-si-rose"><i class="fa fa-calendar-check-o"></i></div>
        <div>
          <div class="sd-stat-n"><%=totalBooked%></div>
          <div class="sd-stat-l">Booked Properties</div>
          <div class="sd-stat-delta sd-delta-up"><i class="fa fa-building"></i> <%=bookedFlatsCount%> Flats &bull; <%=bookedLandsCount%> Lands</div>
        </div>
      </div>
    </div>

    <!-- QUICK ACTIONS + ACTIVITY -->
    <div style="display:grid;grid-template-columns:1fr 340px;gap:1.2rem;margin-bottom:1.2rem" class="sd-two-col sd-fade">
      <div class="sd-card">
        <div class="sd-card-head">
          <div>
            <div class="sd-card-title"><i class="fa fa-bolt"></i> Quick Actions</div>
            <div class="sd-card-sub">Jump to frequently used tasks</div>
          </div>
        </div>
        <div class="sd-card-body">
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem">
            <a href="House.jsp" class="qa-link" style="display:flex;align-items:center;gap:.8rem;padding:1rem;background:var(--bg);border:1px solid var(--border);border-radius:var(--r-md);transition:all 0.2s">
              <div style="width:42px;height:42px;border-radius:var(--r-md);background:var(--primary-light);display:flex;align-items:center;justify-content:center;color:var(--primary);font-size:1.1rem;flex-shrink:0"><i class="fa fa-building"></i></div>
              <div><div style="font-size:.84rem;font-weight:700;color:var(--text)">Upload Flat</div><div style="font-size:.72rem;color:var(--text3);margin-top:1px">Add flat or house listing</div></div>
            </a>
            <a href="sellerhome2.jsp" class="qa-link" style="display:flex;align-items:center;gap:.8rem;padding:1rem;background:var(--bg);border:1px solid var(--border);border-radius:var(--r-md);transition:all 0.2s">
              <div style="width:42px;height:42px;border-radius:var(--r-md);background:var(--amber-light);display:flex;align-items:center;justify-content:center;color:var(--amber);font-size:1.1rem;flex-shrink:0"><i class="fa fa-map-o"></i></div>
              <div><div style="font-size:.84rem;font-weight:700;color:var(--text)">Upload Land</div><div style="font-size:.72rem;color:var(--text3);margin-top:1px">List land for sale</div></div>
            </a>
            <a href="seller_flatapprove.jsp" class="qa-link" style="display:flex;align-items:center;gap:.8rem;padding:1rem;background:var(--bg);border:1px solid var(--border);border-radius:var(--r-md);transition:all 0.2s">
              <div style="width:42px;height:42px;border-radius:var(--r-md);background:var(--sky-light);display:flex;align-items:center;justify-content:center;color:var(--sky);font-size:1.1rem;flex-shrink:0"><i class="fa fa-check-square-o"></i></div>
              <div><div style="font-size:.84rem;font-weight:700;color:var(--text)">Approved Flats</div><div style="font-size:.72rem;color:var(--text3);margin-top:1px"><%=flatApprovedCount%> approved</div></div>
            </a>
            <a href="seller_landapprove.jsp" class="qa-link" style="display:flex;align-items:center;gap:.8rem;padding:1rem;background:var(--bg);border:1px solid var(--border);border-radius:var(--r-md);transition:all 0.2s">
              <div style="width:42px;height:42px;border-radius:var(--r-md);background:rgba(100,150,50,0.1);display:flex;align-items:center;justify-content:center;color:#4a8c2a;font-size:1.1rem;flex-shrink:0"><i class="fa fa-leaf"></i></div>
              <div><div style="font-size:.84rem;font-weight:700;color:var(--text)">Approved Lands</div><div style="font-size:.72rem;color:var(--text3);margin-top:1px"><%=landApprovedCount%> approved</div></div>
            </a>
            <a href="view4.jsp" class="qa-link" style="display:flex;align-items:center;gap:.8rem;padding:1rem;background:var(--bg);border:1px solid var(--border);border-radius:var(--r-md);transition:all 0.2s">
              <div style="width:42px;height:42px;border-radius:var(--r-md);background:var(--rose-light);display:flex;align-items:center;justify-content:center;color:var(--rose);font-size:1.1rem;flex-shrink:0"><i class="fa fa-calendar-check-o"></i></div>
              <div><div style="font-size:.84rem;font-weight:700;color:var(--text)">Booked Flats</div><div style="font-size:.72rem;color:var(--text3);margin-top:1px"><%=bookedFlatsCount%> bookings</div></div>
            </a>
            <a href="view3.jsp" class="qa-link" style="display:flex;align-items:center;gap:.8rem;padding:1rem;background:var(--bg);border:1px solid var(--border);border-radius:var(--r-md);transition:all 0.2s">
              <div style="width:42px;height:42px;border-radius:var(--r-md);background:rgba(124,58,237,0.08);display:flex;align-items:center;justify-content:center;color:#7c3aed;font-size:1.1rem;flex-shrink:0"><i class="fa fa-calendar"></i></div>
              <div><div style="font-size:.84rem;font-weight:700;color:var(--text)">Booked Lands</div><div style="font-size:.72rem;color:var(--text3);margin-top:1px"><%=bookedLandsCount%> bookings</div></div>
            </a>
          </div>
        </div>
      </div>

      <!-- Seller Profile Card -->
      <div class="sd-card">
        <div class="sd-card-head">
          <div>
            <div class="sd-card-title"><i class="fa fa-user-circle"></i> My Profile</div>
            <div class="sd-card-sub">Your seller account details</div>
          </div>
        </div>
        <div class="sd-card-body" style="padding:0">
          <div style="padding:1.5rem;text-align:center;border-bottom:1px solid var(--border)">
            <div style="width:64px;height:64px;border-radius:50%;background:var(--grad-primary);display:flex;align-items:center;justify-content:center;font-size:1.6rem;font-weight:700;color:#fff;margin:0 auto 0.75rem"><%=avatarChar%></div>
            <div style="font-size:1rem;font-weight:700;color:var(--text)"><%=sellerName%></div>
            <div style="font-size:0.75rem;color:var(--text3);margin-top:2px"><%=sellerEmail%></div>
            <div style="margin-top:.6rem"><span class="sd-badge sd-badge-green sd-badge-dot">Verified Seller</span></div>
          </div>
          <%
            DB dbProfile = new DB();
            ResultSet profileRs = dbProfile.Select("SELECT * FROM sellerregister WHERE A_Name='" + A_Name + "'");
            if(profileRs.next()) {
          %>
          <div style="padding:1rem 1.2rem;display:flex;flex-direction:column;gap:.6rem">
            <div style="display:flex;justify-content:space-between;font-size:.8rem;padding:.4rem 0;border-bottom:1px solid var(--border)">
              <span style="color:var(--text3)"><i class="fa fa-phone" style="width:14px"></i> Mobile</span>
              <span style="color:var(--text);font-weight:600"><%=profileRs.getString("mobile_no")%></span>
            </div>
            <div style="display:flex;justify-content:space-between;font-size:.8rem;padding:.4rem 0;border-bottom:1px solid var(--border)">
              <span style="color:var(--text3)"><i class="fa fa-map-marker" style="width:14px"></i> City</span>
              <span style="color:var(--text);font-weight:600"><%=profileRs.getString("city")%></span>
            </div>
            <div style="display:flex;justify-content:space-between;font-size:.8rem;padding:.4rem 0;border-bottom:1px solid var(--border)">
              <span style="color:var(--text3)"><i class="fa fa-id-card" style="width:14px"></i> Aadhaar</span>
              <span style="color:var(--text);font-weight:600"><%=A_Name%></span>
            </div>
            <div style="display:flex;justify-content:space-between;font-size:.8rem;padding:.4rem 0">
              <span style="color:var(--text3)"><i class="fa fa-toggle-on" style="width:14px"></i> Status</span>
              <span class="sd-badge <%=profileRs.getString("sts").equalsIgnoreCase("Active")?"sd-badge-green":"sd-badge-amber"%>"><%=profileRs.getString("sts")%></span>
            </div>
          </div>
          <% } %>
        </div>
      </div>
    </div>

    <!-- Recent Flat Listings Table -->
    <div class="sd-card sd-fade" style="margin-bottom:1.2rem">
      <div class="sd-card-head">
        <div>
          <div class="sd-card-title"><i class="fa fa-building"></i> Recent Flat/House Listings</div>
          <div class="sd-card-sub">Latest flat and house uploads</div>
        </div>
        <a href="seller_flatapprove.jsp" class="sd-btn sd-btn-outline sd-btn-sm">View All <i class="fa fa-arrow-right"></i></a>
      </div>
      <div class="sd-table-wrap">
        <table class="sd-table">
          <thead>
            <tr>
              <th>#</th><th>Image</th><th>Location</th><th>Type</th><th>Amount</th><th>Advance</th><th>Status</th>
            </tr>
          </thead>
          <tbody>
            <%
              DB dbFlatList = new DB();
              ResultSet flatRs = dbFlatList.Select("SELECT * FROM flat_house WHERE A_Name='" + A_Name + "' ORDER BY S_ID DESC LIMIT 5");
              int flatRowNum = 0; boolean hasFlatRows = false;
              while(flatRs.next()) { hasFlatRows = true; flatRowNum++;
                String fSts1 = flatRs.getString("sts1");
                String fBadge = "sd-badge-amber";
                if("Approved".equalsIgnoreCase(fSts1)) fBadge = "sd-badge-green";
                else if("Rejected".equalsIgnoreCase(fSts1)) fBadge = "sd-badge-rose";
            %>
            <tr>
              <td style="color:var(--text3);font-size:.75rem"><%=flatRowNum%></td>
              <td><img class="sd-table-img" src="servlet_2.jsp?name=<%=flatRs.getInt("S_ID")%>" alt="Flat"></td>
              <td>
                <div class="sd-table-name"><%=flatRs.getString("city")%></div>
                <div class="sd-table-sub"><%=flatRs.getString("area")%>, <%=flatRs.getString("street")%></div>
              </td>
              <td><span class="sd-badge sd-badge-sky"><%=flatRs.getString("FType")%></span></td>
              <td class="sd-table-price">&#8377;<%=flatRs.getString("rent")%></td>
              <td style="font-size:.83rem;color:var(--text2)">&#8377;<%=flatRs.getString("advance")%></td>
              <td><span class="sd-badge <%=fBadge%> sd-badge-dot"><%=fSts1%></span></td>
            </tr>
            <% } %>
            <% if(!hasFlatRows) { %>
            <tr><td colspan="7"><div class="sd-empty" style="padding:2rem"><i class="fa fa-building"></i><h3>No flats uploaded yet</h3><p>Upload your first flat to get started.</p></div></td></tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Recent Land Listings Table -->
    <div class="sd-card sd-fade">
      <div class="sd-card-head">
        <div>
          <div class="sd-card-title"><i class="fa fa-map-o"></i> Recent Land Listings</div>
          <div class="sd-card-sub">Latest land uploads</div>
        </div>
        <a href="seller_landapprove.jsp" class="sd-btn sd-btn-outline sd-btn-sm">View All <i class="fa fa-arrow-right"></i></a>
      </div>
      <div class="sd-table-wrap">
        <table class="sd-table">
          <thead>
            <tr>
              <th>#</th><th>Image</th><th>City</th><th>Area</th><th>Amount</th><th>Advance</th><th>Survey No</th><th>Status</th>
            </tr>
          </thead>
          <tbody>
            <%
              DB dbLandList = new DB();
              ResultSet landRs = dbLandList.Select("SELECT * FROM upload WHERE A_Name='" + A_Name + "' ORDER BY S_ID DESC LIMIT 5");
              int landRowNum = 0; boolean hasLandRows = false;
              while(landRs.next()) { hasLandRows = true; landRowNum++;
                String lSts1 = landRs.getString("sts1");
                String lBadge = "sd-badge-amber";
                if("Approved".equalsIgnoreCase(lSts1)) lBadge = "sd-badge-green";
                else if("Rejected".equalsIgnoreCase(lSts1)) lBadge = "sd-badge-rose";
            %>
            <tr>
              <td style="color:var(--text3);font-size:.75rem"><%=landRowNum%></td>
              <td><img class="sd-table-img" src="servlet_3.jsp?name=<%=landRs.getInt("S_ID")%>" alt="Land"></td>
              <td class="sd-table-name"><%=landRs.getString("city")%></td>
              <td style="font-size:.83rem"><%=landRs.getString("area")%></td>
              <td class="sd-table-price">&#8377;<%=landRs.getString("rent")%></td>
              <td style="font-size:.83rem;color:var(--text2)">&#8377;<%=landRs.getString("advance")%></td>
              <td style="font-size:.78rem;color:var(--text3)"><%=landRs.getString("SUNO") != null ? landRs.getString("SUNO") : "—"%></td>
              <td><span class="sd-badge <%=lBadge%> sd-badge-dot"><%=lSts1%></span></td>
            </tr>
            <% } %>
            <% if(!hasLandRows) { %>
            <tr><td colspan="8"><div class="sd-empty" style="padding:2rem"><i class="fa fa-map-o"></i><h3>No land listings yet</h3><p>Upload your first land to get started.</p></div></td></tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</main>

<!-- TOAST -->
<div id="toastBox" style="position:fixed;bottom:1.5rem;right:1.5rem;z-index:9999;display:flex;flex-direction:column;gap:.5rem;pointer-events:none"></div>

<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>
function toggleSidebar(){ document.getElementById('sidebar').classList.toggle('open'); }
const obs = new IntersectionObserver((e)=>{ e.forEach(en=>{ if(en.isIntersecting) en.target.classList.add('vis'); }); },{threshold:0.1});
document.querySelectorAll('.sd-fade').forEach(el=>obs.observe(el));
document.querySelectorAll('.qa-link').forEach(a=>{
  a.addEventListener('mouseenter',()=>{ a.style.background='var(--bg2)'; a.style.borderColor='var(--primary-mid)'; a.style.transform='translateY(-2px)'; a.style.boxShadow='var(--sh-sm)'; });
  a.addEventListener('mouseleave',()=>{ a.style.background='var(--bg)'; a.style.borderColor='var(--border)'; a.style.transform=''; a.style.boxShadow=''; });
});
function showToast(msg, type){
  const colors={info:'var(--sky)',success:'var(--primary)',warn:'var(--amber)',error:'var(--rose)'};
  const t=document.createElement('div');
  t.style.cssText=`background:white;border:1px solid var(--border);border-left:3px solid ${colors[type]||colors.info};border-radius:var(--r);padding:.8rem 1rem;font-size:.83rem;color:var(--text);box-shadow:var(--sh-md);min-width:260px;max-width:340px;animation:fadeUp .3s both;pointer-events:auto`;
  t.textContent=msg; document.getElementById('toastBox').appendChild(t);
  setTimeout(()=>t.remove(), 4000);
}
<% String sessionMsg = (String)session.getAttribute("msg");
   if(sessionMsg != null && !sessionMsg.isEmpty()) { %>
window.addEventListener('DOMContentLoaded',function(){ showToast('<%=sessionMsg%>','info'); });
<% } %>
</script>
</body>
</html>
