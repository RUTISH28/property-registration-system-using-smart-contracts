<%@page import="java.sql.ResultSet"%>


<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Booked Lands — Innovative Residence</title>
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
      <a href="seller_flatapprove.jsp"><i class="fa fa-check-circle"></i> Approved Flats</a>
      <a href="seller_landapprove.jsp"><i class="fa fa-check-circle-o"></i> Approved Lands</a>
      <a href="view4.jsp"><i class="fa fa-calendar-check-o"></i> Booked Flats</a>
      <a href="view3.jsp" class="active"><i class="fa fa-calendar"></i> Booked Lands</a>
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
    Booked Lands
    <span><a href="sellerhome.jsp" style="color:var(--primary)">Dashboard</a> &rsaquo; Booked Lands</span>
  </div>
  <div class="sd-topbar-actions">
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

    <%
      DB dbCount = new DB();
      ResultSet countRs = dbCount.Select("SELECT COUNT(*) AS cnt FROM booking WHERE SA_Name='" + A_Name + "'");
      int bookingCount = 0; if(countRs.next()) bookingCount = countRs.getInt("cnt");
    %>

    <div class="sd-stats-grid" style="margin-bottom:1.5rem">
      <div class="sd-stat-card">
        <div class="sd-stat-icon sd-si-sky"><i class="fa fa-calendar"></i></div>
        <div><div class="sd-stat-n"><%=bookingCount%></div><div class="sd-stat-l">Total Land Bookings</div></div>
      </div>
    </div>

    <% if(bookingCount == 0) { %>
    <div class="sd-card">
      <div class="sd-card-body">
        <div class="sd-empty">
          <i class="fa fa-map-o"></i>
          <h3>No land bookings yet</h3>
          <p>When buyers book your approved lands, they will appear here.</p>
        </div>
      </div>
    </div>
    <% } else { %>

    <div class="sd-card" style="margin-bottom:1.5rem">
      <div class="sd-card-head">
        <div>
          <div class="sd-card-title"><i class="fa fa-calendar"></i> Land Booking Details</div>
          <div class="sd-card-sub">All land bookings made by buyers for your listings</div>
        </div>
      </div>
      <div class="sd-table-wrap">
        <table class="sd-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Land ID</th>
              <th>Seller Name</th>
              <th>Area</th>
              <th>Doc No</th>
              <th>Survey No</th>
              <th>Buyer Name</th>
              <th>Buyer Mobile</th>
              <th>Buyer Email</th>
              <th>Booking Fee</th>
              <th>Payment Type</th>
              <th>Buyer A/C</th>
              <th>Admin A/C</th>
              <th>Aadhaar</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <%
              DB dbBooks = new DB();
              ResultSet ts = dbBooks.Select("SELECT * FROM booking WHERE SA_Name='" + A_Name + "' ORDER BY id DESC");
              int rowNum = 0;
              while(ts.next()) { rowNum++;
                String sts = ts.getString("STS");
                String stsBadge = "sd-badge-amber";
                if("Confirmed".equalsIgnoreCase(sts) || "Booked".equalsIgnoreCase(sts)) stsBadge = "sd-badge-green";
                else if("Cancelled".equalsIgnoreCase(sts)) stsBadge = "sd-badge-rose";
            %>
            <tr>
              <td style="color:var(--text3);font-size:.75rem"><%=rowNum%></td>
              <td style="font-weight:700;color:var(--primary)"><%=ts.getString("S_ID")%></td>
              <td><div class="sd-table-name"><%=ts.getString("S_NAME")%></div></td>
              <td style="font-size:.82rem"><%=ts.getString("area")%></td>
              <td style="font-size:.78rem;color:var(--text2)"><%=ts.getString("D_NO") != null ? ts.getString("D_NO") : "—"%></td>
              <td style="font-size:.78rem;color:var(--text2)"><%=ts.getString("SUNO") != null ? ts.getString("SUNO") : "—"%></td>
              <td><div class="sd-table-name" style="font-size:.84rem"><%=ts.getString("U_NAME")%></div></td>
              <td style="font-size:.8rem"><%=ts.getString("U_NUMBER")%></td>
              <td style="font-size:.78rem;color:var(--text2)"><%=ts.getString("U_MAIL")%></td>
              <td class="sd-table-price">&#8377;<%=ts.getString("B_fess")%></td>
              <td><span class="sd-badge sd-badge-sky"><%=ts.getString("C_Type")%></span></td>
              <td style="font-size:.78rem;color:var(--text2)"><%=ts.getString("U_ACC")%></td>
              <td style="font-size:.78rem;color:var(--text2)"><%=ts.getString("A_ACC")%></td>
              <td style="font-size:.78rem;color:var(--text3)"><%=ts.getString("A_NAME")%></td>
              <td><span class="sd-badge <%=stsBadge%> sd-badge-dot"><%=sts != null ? sts : "Pending"%></span></td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Detailed card view -->
    <div>
      <div style="font-size:.9rem;font-weight:700;color:var(--text);margin-bottom:1rem;display:flex;align-items:center;gap:.5rem"><i class="fa fa-list" style="color:var(--primary)"></i> Detailed Booking Records</div>
      <%
        DB dbBooks2 = new DB();
        ResultSet ts2 = dbBooks2.Select("SELECT * FROM booking WHERE SA_Name='" + A_Name + "' ORDER BY id DESC");
        while(ts2.next()) {
          String sts2 = ts2.getString("STS");
          String stsBadge2 = "sd-badge-amber";
          if("Confirmed".equalsIgnoreCase(sts2) || "Booked".equalsIgnoreCase(sts2)) stsBadge2 = "sd-badge-green";
          else if("Cancelled".equalsIgnoreCase(sts2)) stsBadge2 = "sd-badge-rose";
      %>
      <div class="sd-booking-card">
        <div class="sd-booking-head">
          <div class="sd-booking-id"><i class="fa fa-map-o" style="color:var(--primary);margin-right:.4rem"></i> Land #<%=ts2.getString("S_ID")%></div>
          <span class="sd-badge <%=stsBadge2%> sd-badge-dot"><%=sts2 != null ? sts2 : "Pending"%></span>
        </div>
        <div class="sd-booking-body">
          <div class="sd-booking-grid">
            <div class="sd-booking-field"><div class="sd-bf-label">Seller Name</div><div class="sd-bf-value"><%=ts2.getString("S_NAME")%></div></div>
            <div class="sd-booking-field"><div class="sd-bf-label">Seller Email</div><div class="sd-bf-value" style="font-size:.82rem"><%=ts2.getString("S_MAIL")%></div></div>
            <div class="sd-booking-field"><div class="sd-bf-label">Land Area</div><div class="sd-bf-value"><%=ts2.getString("area")%></div></div>
            <div class="sd-booking-field"><div class="sd-bf-label">Document Number</div><div class="sd-bf-value"><%=ts2.getString("D_NO") != null ? ts2.getString("D_NO") : "—"%></div></div>
            <div class="sd-booking-field"><div class="sd-bf-label">Survey Number</div><div class="sd-bf-value"><%=ts2.getString("SUNO") != null ? ts2.getString("SUNO") : "—"%></div></div>
            <div class="sd-booking-field"><div class="sd-bf-label">Buyer Name</div><div class="sd-bf-value"><%=ts2.getString("U_NAME")%></div></div>
            <div class="sd-booking-field"><div class="sd-bf-label">Buyer Mobile</div><div class="sd-bf-value"><%=ts2.getString("U_NUMBER")%></div></div>
            <div class="sd-booking-field"><div class="sd-bf-label">Buyer Email</div><div class="sd-bf-value" style="font-size:.82rem"><%=ts2.getString("U_MAIL")%></div></div>
            <div class="sd-booking-field"><div class="sd-bf-label">Booking Fee</div><div class="sd-bf-value" style="color:var(--primary)">&#8377;<%=ts2.getString("B_fess")%></div></div>
            <div class="sd-booking-field"><div class="sd-bf-label">Admin Account</div><div class="sd-bf-value" style="font-size:.82rem"><%=ts2.getString("A_ACC")%></div></div>
            <div class="sd-booking-field"><div class="sd-bf-label">Payment Mode</div><div class="sd-bf-value"><%=ts2.getString("C_Type")%></div></div>
            <div class="sd-booking-field"><div class="sd-bf-label">Buyer Account</div><div class="sd-bf-value" style="font-size:.82rem"><%=ts2.getString("U_ACC")%></div></div>
            <div class="sd-booking-field"><div class="sd-bf-label">Buyer Aadhaar</div><div class="sd-bf-value"><%=ts2.getString("A_NAME")%></div></div>
          </div>
        </div>
      </div>
      <% } %>
    </div>

    <% } %>
  </div>
</main>

<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>function toggleSidebar(){ document.getElementById('sidebar').classList.toggle('open'); }</script>
</body>
</html>
