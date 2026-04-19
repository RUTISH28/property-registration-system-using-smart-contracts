<%-- buyer_sidebar.jsp ? include in every buyer page --%>
<%@page import="Connection.DB"%>
<%@page import="java.sql.ResultSet"%>
<%
/* ?? live badge counts ?? */
String _bA_Name = (String) session.getAttribute("User");
Integer _bU_Id  = (Integer) session.getAttribute("U_Id");
if(_bA_Name==null) _bA_Name="Buyer";
String _curPage2 = request.getServletPath();

DB dbA=new DB(); ResultSet rsA=dbA.Select(
  "SELECT S_ID,username,email,mobile,city,sts FROM register WHERE A_Name='"+_bA_Name+"' LIMIT 1");
String Name="Buyer",City="",Email="",Mobile=""; int SID=0;
if(rsA.next()){
  if(rsA.getString("username")!=null) Name=rsA.getString("username");
  if(rsA.getString("city")    !=null) City=rsA.getString("city");
  if(rsA.getString("email")   !=null) Email=rsA.getString("email");
  if(rsA.getString("mobile")  !=null) Mobile=rsA.getString("mobile");
  SID=rsA.getInt("S_ID");
}
/* unread chat count */
int _chatUnread = 0;
try{
  DB _dCU = new DB();
  ResultSet _rCU = _dCU.Select(
    "SELECT COUNT(*) c FROM chat_messages WHERE receiver_aadhar='"+_bA_Name+"' AND is_read=0");
  if(_rCU.next()) _chatUnread = _rCU.getInt("c");
}catch(Exception _ex){}

int _bkTotal = 0;
try{
  DB _dBK = new DB();
  ResultSet _rBK = _dBK.Select(
    "SELECT (SELECT COUNT(*) FROM booking WHERE U_NAME='"+_bA_Name+"')+(SELECT COUNT(*) FROM bookingss WHERE U_NAME='"+_bA_Name+"') c");
  if(_rBK.next()) _bkTotal = _rBK.getInt("c");
}catch(Exception _ex){}

char _initials = Name.length()>0 ? Character.toUpperCase(Name.charAt(0)) : 'B';
%>
<aside class="by-sidebar" id="bySidebar">
  <div class="by-logo">
    <div class="by-logo-text">INNOVATIVE<em> RESIDENCE</em></div>
    <div class="by-logo-sub">Buyer Portal</div>
    <div class="by-logo-badge"><i class="fa fa-home"></i> VERIFIED BUYER</div>
  </div>

  <div class="by-user-chip">
    <div class="by-avatar"><%=_initials%></div>
    <div>
      <div class="by-user-name"><%=Name%></div>
      <div class="by-user-role">Active Buyer</div>
    </div>
  </div>

  <nav class="by-nav">
    <div class="by-nav-section">
      <div class="by-nav-label">Overview</div>
      <a href="user_home.jsp" class="<%=_curPage2.contains("buyerhome")?"active":""%>">
        <i class="fa fa-th-large"></i> Dashboard
      </a>
    </div>

    <div class="by-nav-section">
      <div class="by-nav-label">Properties</div>
      <a href="browse_land.jsp" class="<%=_curPage2.contains("browse_land")?"active":""%>">
        <i class="fa fa-map-o"></i> Browse Land
      </a>
      <a href="browse_flat.jsp" class="<%=_curPage2.contains("browse_flat")?"active":""%>">
        <i class="fa fa-building"></i> Browse Flat/House
      </a>
    </div>

    <div class="by-nav-section">
      <div class="by-nav-label">My Activity</div>
      <a href="my_bookings.jsp" class="<%=_curPage2.contains("my_bookings")?"active":""%>">
        <i class="fa fa-calendar-check-o"></i> My Bookings
        <%if(_bkTotal>0){%><span class="by-nav-badge-green"><%=_bkTotal%></span><%}%>
      </a>
      <a href="buyer_payment.jsp" class="<%=_curPage2.contains("buyer_payment")?"active":""%>">
        <i class="fa fa-credit-card"></i> Payments
      </a>
    </div>

    <div class="by-nav-section">
      <div class="by-nav-label">Messages</div>
      <a href="buyer_chat.jsp" class="<%=_curPage2.contains("buyer_chat")?"active":""%>">
        <i class="fa fa-comments"></i> Chat with Sellers
        <%if(_chatUnread>0){%><span class="by-nav-badge"><%=_chatUnread%></span><%}%>
      </a>
    </div>

    <div class="by-nav-section">
      <div class="by-nav-label">Account</div>
      <a href="buyer_account.jsp" class="<%=_curPage2.contains("buyer_account")?"active":""%>">
        <i class="fa fa-university"></i> Create Account
      </a>
      <a href="buyer_accounts.jsp" class="<%=_curPage2.contains("buyer_accounts")?"active":""%>">
        <i class="fa fa-map-o"></i> View Accs
      </a>
    </div>
  </nav>

  <div class="by-sidebar-footer">
    <div style="padding:.2rem .5rem .4rem;font-size:.60rem;color:rgba(255,255,255,.16)">
      Session: <%=_bA_Name%>
    </div>
    <a href="index.jsp" class="by-logout"><i class="fa fa-sign-out"></i> Sign Out</a>
  </div>
</aside>
