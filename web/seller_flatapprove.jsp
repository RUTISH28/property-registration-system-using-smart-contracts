<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Approved Flats — Innovative Residence</title>
  <link href="img/favicon.png" rel="icon">
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Fraunces:ital,wght@0,500;0,700;1,500;1,700&display=swap" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="css/seller-theme.css" rel="stylesheet">
</head>
<body>
<%
  String A_Name = (String) session.getAttribute("A_Name");
  if (A_Name == null) { response.sendRedirect("index.jsp"); return; }
  DB db = new DB();
  ResultSet sellerRs = db.Select("SELECT * FROM sellerregister WHERE A_Name='" + A_Name + "'");
  String sellerName = "Seller";
  if (sellerRs.next()) sellerName = sellerRs.getString("username");
  char avatarChar = sellerName.length() > 0 ? sellerName.charAt(0) : 'S';
%>

<button class="sd-hamburger" onclick="toggleSidebar()"><i class="fa fa-bars"></i></button>

<aside class="sd-sidebar" id="sidebar">
  <div class="sd-logo"><div class="sd-logo-text">INNOVATIVE<em> RESIDENCE</em></div><div class="sd-logo-sub">Seller Portal</div></div>
  <div class="sd-user-chip">
    <div class="sd-avatar"><%=avatarChar%></div>
    <div><div class="sd-user-name"><%=sellerName%></div><div class="sd-user-role">Verified Seller</div></div>
  </div>
  <nav class="sd-nav">
    <div class="sd-nav-section">
      <div class="sd-nav-label">Main</div>
      <a href="sellerhome.jsp"><i class="fa fa-home"></i> Dashboard</a>
      <a href="House.jsp"><i class="fa fa-building"></i> Upload Flat/House</a>
      <a href="sellerhome2.jsp"><i class="fa fa-map-o"></i> Upload Land</a>
    </div>
    <div class="sd-nav-section">
      <div class="sd-nav-label">My Listings</div>
      <a href="seller_flatapprove.jsp" class="active"><i class="fa fa-check-circle"></i> Approved Flats</a>
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
  <div class="sd-sidebar-footer"><a href="index.jsp" class="sd-logout"><i class="fa fa-sign-out"></i> Sign Out</a></div>
</aside>

<header class="sd-topbar">
  <div class="sd-page-title">
    Approved Flats / Houses
    <span><a href="sellerhome.jsp" style="color:var(--primary)">Dashboard</a> &rsaquo; Approved Flats</span>
  </div>
  <div class="sd-topbar-actions">
    <a href="House.jsp" class="sd-btn sd-btn-primary sd-btn-sm"><i class="fa fa-plus"></i> Upload New</a>
    <a href="index.jsp" class="sd-btn sd-btn-outline sd-btn-sm"><i class="fa fa-sign-out"></i> Logout</a>
  </div>
</header>

<main class="sd-main">
  <div class="sd-page-wide" style="padding:2rem">

    <%
      String msg = (String)session.getAttribute("msg");
      if(msg != null) { %>
      <div class="sd-alert sd-a-info" style="margin-bottom:1rem"><i class="fa fa-info-circle"></i> <%=msg%></div>
    <% session.removeAttribute("msg"); } %>

    <!-- Stats row -->
    <%
      DB dbC1 = new DB(); ResultSet cAll = dbC1.Select("SELECT COUNT(*) AS cnt FROM flat_house WHERE A_Name='" + A_Name + "'");
      int cAllCount = 0; if(cAll.next()) cAllCount = cAll.getInt("cnt");
      DB dbC2 = new DB(); ResultSet cAppr = dbC2.Select("SELECT COUNT(*) AS cnt FROM flat_house WHERE A_Name='" + A_Name + "' AND sts1='Approved'");
      int cApprCount = 0; if(cAppr.next()) cApprCount = cAppr.getInt("cnt");
      DB dbC3 = new DB(); ResultSet cPend = dbC3.Select("SELECT COUNT(*) AS cnt FROM flat_house WHERE A_Name='" + A_Name + "' AND sts1='Pending'");
      int cPendCount = 0; if(cPend.next()) cPendCount = cPend.getInt("cnt");
    %>
    <div class="sd-stats-grid" style="margin-bottom:1.5rem">
      <div class="sd-stat-card">
        <div class="sd-stat-icon sd-si-sky"><i class="fa fa-building"></i></div>
        <div><div class="sd-stat-n"><%=cAllCount%></div><div class="sd-stat-l">Total Flats Uploaded</div></div>
      </div>
      <div class="sd-stat-card">
        <div class="sd-stat-icon sd-si-green"><i class="fa fa-check-circle"></i></div>
        <div><div class="sd-stat-n"><%=cApprCount%></div><div class="sd-stat-l">Approved Flats</div></div>
      </div>
      <div class="sd-stat-card">
        <div class="sd-stat-icon sd-si-amber"><i class="fa fa-clock-o"></i></div>
        <div><div class="sd-stat-n"><%=cPendCount%></div><div class="sd-stat-l">Pending Review</div></div>
      </div>
    </div>

    <!-- All Flats Table -->
    <div class="sd-card">
      <div class="sd-card-head">
        <div>
          <div class="sd-card-title"><i class="fa fa-check-circle"></i> Flat / House Listings</div>
          <div class="sd-card-sub">All your uploaded flats and houses with admin approval status</div>
        </div>
      </div>
      <div class="sd-table-wrap">
        <table class="sd-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Image</th>
              <th>Seller Name</th>
              <th>Mobile</th>
              <th>Email</th>
              <th>City</th>
              <th>Area</th>
              <th>Street</th>
              <th>House No</th>
              <th>Type</th>
              <th>Amount (&#8377;)</th>
              <th>Advance (&#8377;)</th>
              <th>Booking Fee</th>
              <th>Status</th>
              <th>Admin Status</th>
            </tr>
          </thead>
          <tbody>
            <%
              DB dbFlat = new DB();
              ResultSet flatRs = dbFlat.Select("SELECT * FROM flat_house WHERE A_Name='" + A_Name + "' ORDER BY S_ID DESC");
              boolean hasRows = false;
              while(flatRs.next()) { hasRows = true;
                String sts = flatRs.getString("sts");
                String sts1 = flatRs.getString("sts1");
                String badge1 = "sd-badge-slate";
                if("Approved".equalsIgnoreCase(sts)) badge1 = "sd-badge-green";
                else if("Rejected".equalsIgnoreCase(sts)) badge1 = "sd-badge-rose";
                String badge2 = "sd-badge-amber";
                if("Approved".equalsIgnoreCase(sts1)) badge2 = "sd-badge-green";
                else if("Rejected".equalsIgnoreCase(sts1)) badge2 = "sd-badge-rose";
            %>
            <tr>
              <td style="color:var(--text3);font-size:.75rem;font-weight:600"><%=flatRs.getString("S_ID")%></td>
              <td><img class="sd-table-img" src="servlet_2.jsp?name=<%=flatRs.getInt("S_ID")%>" alt="Flat"></td>
              <td><div class="sd-table-name"><%=flatRs.getString("S_Name")%></div></td>
              <td style="font-size:.8rem"><%=flatRs.getString("S_Number")%></td>
              <td style="font-size:.78rem;color:var(--text2)"><%=flatRs.getString("S_MAIL")%></td>
              <td style="font-size:.83rem"><%=flatRs.getString("city")%></td>
              <td style="font-size:.83rem"><%=flatRs.getString("area")%></td>
              <td style="font-size:.78rem;color:var(--text2)"><%=flatRs.getString("street")%></td>
              <td style="font-size:.78rem"><%=flatRs.getString("H_NO")%></td>
              <td><span class="sd-badge sd-badge-sky"><%=flatRs.getString("FType")%></span></td>
              <td class="sd-table-price">&#8377;<%=flatRs.getString("rent")%></td>
              <td style="font-size:.83rem;color:var(--text2)">&#8377;<%=flatRs.getString("advance")%></td>
              <td style="font-size:.83rem;color:var(--text2)">&#8377;<%=flatRs.getString("fess") != null ? flatRs.getString("fess") : "—"%></td>
              <td><span class="sd-badge <%=badge1%> sd-badge-dot"><%=sts != null ? sts : "Pending"%></span></td>
              <td><span class="sd-badge <%=badge2%> sd-badge-dot"><%=sts1 != null ? sts1 : "Pending"%></span></td>
            </tr>
            <% } %>
            <% if(!hasRows) { %>
            <tr>
              <td colspan="15">
                <div class="sd-empty">
                  <i class="fa fa-building"></i>
                  <h3>No flat listings found</h3>
                  <p>You haven't uploaded any flats yet. <a href="House.jsp" style="color:var(--primary)">Upload your first flat</a></p>
                </div>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</main>

<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>
function toggleSidebar(){ document.getElementById('sidebar').classList.toggle('open'); }
</script>
</body>
</html>
