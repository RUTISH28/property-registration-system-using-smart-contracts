<%-- admin_sidebar.jsp ? include in every admin page --%>
<%
/* Read counts for sidebar badges */
Connection.DB _dSP=new Connection.DB();
java.sql.ResultSet _rSP=_dSP.Select("SELECT COUNT(*) c FROM sellerregister WHERE sts='NO'");
int _sP=0; if(_rSP.next()) _sP=_rSP.getInt("c");

Connection.DB _dBP=new Connection.DB();
java.sql.ResultSet _rBP=_dBP.Select("SELECT COUNT(*) c FROM register WHERE sts='NO'");
int _bP=0; if(_rBP.next()) _bP=_rBP.getInt("c");

Connection.DB _dLP=new Connection.DB();
java.sql.ResultSet _rLP=_dLP.Select("SELECT COUNT(*) c FROM upload WHERE sts='NO'");
int _lP=0; if(_rLP.next()) _lP=_rLP.getInt("c");

Connection.DB _dFP=new Connection.DB();
java.sql.ResultSet _rFP=_dFP.Select("SELECT COUNT(*) c FROM flat_house WHERE sts='NO'");
int _fP=0; if(_rFP.next()) _fP=_rFP.getInt("c");

int _totalP = _sP+_bP+_lP+_fP;

String _adminUser = (String) session.getAttribute("User");
if(_adminUser==null) _adminUser="Admin";
String _curPage = request.getServletPath();
%>
<aside class="ad-sidebar" id="adSidebar">
  <div class="ad-logo">
    <div class="ad-logo-text">INNOVATIVE<em> RESIDENCE</em></div>
    <div class="ad-logo-sub">Admin Portal</div>
    <div class="ad-logo-badge"><i class="fa fa-shield"></i> SUPER ADMIN</div>
  </div>

  <div class="ad-user-chip">
    <div class="ad-avatar"><%=String.valueOf(_adminUser.charAt(0)).toUpperCase()%></div>
    <div>
      <div class="ad-user-name"><%=_adminUser%></div>
      <div class="ad-user-role">Administrator</div>
    </div>
  </div>

  <nav class="ad-nav">

    <div class="ad-nav-section">
      <div class="ad-nav-label">Overview</div>
      <a href="admin_home.jsp" class="<%=_curPage.contains("admin_home")?"active":""%>">
        <i class="fa fa-tachometer"></i> Dashboard
        <%if(_totalP>0){%><span class="ad-nav-badge"><%=_totalP%></span><%}%>
      </a>
    </div>

    <div class="ad-nav-section">
      <div class="ad-nav-label">User Approvals</div>
      <a href="buyer_req.jsp" class="<%=_curPage.contains("buyer_req")?"active":""%>">
        <i class="fa fa-users"></i> Buyer Approval
        <%if(_bP>0){%><span class="ad-nav-badge"><%=_bP%></span><%}%>
      </a>
      <a href="seller_req.jsp" class="<%=_curPage.contains("seller_req")?"active":""%>">
        <i class="fa fa-user-secret"></i> Seller Approval
        <%if(_sP>0){%><span class="ad-nav-badge"><%=_sP%></span><%}%>
      </a>
    </div>

    <div class="ad-nav-section">
      <div class="ad-nav-label">Property Approvals</div>
      <a href="LAND_Approval.jsp" class="<%=_curPage.contains("LAND_Approval")?"active":""%>">
        <i class="fa fa-map-o"></i> Land Approval
        <%if(_lP>0){%><span class="ad-nav-badge"><%=_lP%></span><%}%>
      </a>
      <a href="Approval.jsp" class="<%=_curPage.contains("Approval")&&!_curPage.contains("LAND")?"active":""%>">
        <i class="fa fa-building"></i> Flat/House Approval
        <%if(_fP>0){%><span class="ad-nav-badge"><%=_fP%></span><%}%>
      </a>
    </div>

    <div class="ad-nav-section">
      <div class="ad-nav-label">User Management</div>
      <a href="seller details.jsp" class="<%=_curPage.contains("seller details")?"active":""%>">
        <i class="fa fa-id-card"></i> Seller Details
        <span class="ad-nav-badge-green"><%=/* approved */ ""%>Active</span>
      </a>
      <a href="buyer details.jsp" class="<%=_curPage.contains("buyer details")?"active":""%>">
        <i class="fa fa-address-book"></i> Buyer Details
      </a>
    </div>

    <div class="ad-nav-section">
      <div class="ad-nav-label">Bookings</div>
      <a href="USER BOOKING.jsp" class="<%=_curPage.contains("USER BOOKING")&&!_curPage.contains("1")?"active":""%>">
        <i class="fa fa-calendar-check-o"></i> Land Bookings
      </a>
      <a href="USER BOOKING1.jsp" class="<%=_curPage.contains("USER BOOKING1")?"active":""%>">
        <i class="fa fa-calendar"></i> Flat Bookings
      </a>
    </div>

        

  </nav>

  <div class="ad-sidebar-footer">
    <div style="padding:.2rem .5rem .4rem;font-size:.62rem;color:rgba(255,255,255,.18)">
      Session: <%=_adminUser%>
    </div>
    <a href="index.jsp" class="ad-logout"><i class="fa fa-sign-out"></i> Sign Out</a>
  </div>
</aside>
