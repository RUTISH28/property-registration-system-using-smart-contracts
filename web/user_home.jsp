<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String A_Name = (String) session.getAttribute("User");
Integer U_Id  = (Integer) session.getAttribute("U_Id");
if(A_Name==null){ response.sendRedirect("index.jsp"); return; }

/* ── buyer profile ── */
DB dbB=new DB(); ResultSet rsB=dbB.Select(
  "SELECT S_ID,username,email,mobile,city,sts FROM register WHERE A_Name='"+A_Name+"' LIMIT 1");
String bName="Buyer",bCity="",bEmail="",bMobile=""; int bSID=0;
if(rsB.next()){
  if(rsB.getString("username")!=null) bName=rsB.getString("username");
  if(rsB.getString("city")    !=null) bCity=rsB.getString("city");
  if(rsB.getString("email")   !=null) bEmail=rsB.getString("email");
  if(rsB.getString("mobile")  !=null) bMobile=rsB.getString("mobile");
  bSID=rsB.getInt("S_ID");
}

/* ── stats ── */
DB d1=new DB(); ResultSet r1=d1.Select("SELECT COUNT(*) c FROM booking WHERE U_NAME='"+A_Name+"'"); int landBk=0; if(r1.next()) landBk=r1.getInt("c");
DB d2=new DB(); ResultSet r2=d2.Select("SELECT COUNT(*) c FROM bookingss WHERE U_NAME='"+A_Name+"'"); int flatBk=0; if(r2.next()) flatBk=r2.getInt("c");
DB d3=new DB(); ResultSet r3=d3.Select("SELECT COUNT(*) c FROM upload WHERE sts1='Approved'"); int avLand=0; if(r3.next()) avLand=r3.getInt("c");
DB d4=new DB(); ResultSet r4=d4.Select("SELECT COUNT(*) c FROM flat_house WHERE sts1='Approved'"); int avFlat=0; if(r4.next()) avFlat=r4.getInt("c");
DB d5=new DB(); ResultSet r5=d5.Select("SELECT COUNT(*) c FROM buyer_account WHERE buyer_aadhar='"+A_Name+"' AND status='Active'"); int accCount=0; if(r5.next()) accCount=r5.getInt("c");

/* Unread chats */
int chatUnread=0;
try{ DB dCH=new DB(); ResultSet rCH=dCH.Select("SELECT COUNT(*) c FROM chat_messages WHERE receiver_aadhar='"+A_Name+"' AND is_read=0"); if(rCH.next()) chatUnread=rCH.getInt("c"); }catch(Exception ex){}

int totalBk=landBk+flatBk, avProp=avLand+avFlat;

/* Recent approved land */
DB dRL=new DB(); ResultSet rsRL=dRL.Select(
  "SELECT S_ID,area,city,FType,rent,advance,D_NO,sts1 FROM upload WHERE sts1='Approved' ORDER BY S_ID DESC LIMIT 4");
/* Recent approved flats */
DB dRF=new DB(); ResultSet rsRF=dRF.Select(
  "SELECT S_ID,city,area,street,FType,rent,advance,H_NO,sts1 FROM flat_house WHERE sts1='Approved' ORDER BY S_ID DESC LIMIT 4");

String flashMsg=(String)session.getAttribute("msg"); session.removeAttribute("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Buyer Dashboard — Innovative Residence</title>
  <link href="img/favicon.png" rel="icon">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600;1,700&display=swap" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="css/buyer-theme.css" rel="stylesheet">
</head>
<body>
<%if(flashMsg!=null&&!flashMsg.isEmpty()){%><script>window.addEventListener('DOMContentLoaded',()=>byToast('<%=flashMsg%>','info'));</script><%}%>
<button class="by-hamburger" onclick="toggleSidebar()"><i class="fa fa-bars"></i></button>
<%@ include file="buyer_sidebar.jsp" %>

<header class="by-topbar">
  <div class="by-page-title">
    Dashboard
    <span>Welcome back, <%=bName%> &middot; <%=avProp%> properties available</span>
  </div>
  <div class="by-topbar-actions">
    <a href="buyer_chat.jsp" class="by-btn by-btn-outline by-btn-sm" style="position:relative">
      <i class="fa fa-comments"></i> Chat
      <%if(chatUnread>0){%><span style="position:absolute;top:-6px;right:-6px;background:var(--rose);color:#fff;border-radius:50%;width:16px;height:16px;font-size:.6rem;display:flex;align-items:center;justify-content:center;font-weight:700"><%=chatUnread%></span><%}%>
    </a>
    <a href="browse_flat.jsp" class="by-btn by-btn-primary by-btn-sm"><i class="fa fa-search"></i> Find Property</a>
  </div>
</header>

<main class="by-main">
<div class="by-page">

  <!-- Hero -->
  <div class="by-hero by-fade">
    <div class="by-hero-tag"><i class="fa fa-home"></i> Buyer Portal</div>
    <h2>Hello, <em><%=bName%></em></h2>
    <p>
      <strong style="color:var(--primary3)"><%=avProp%></strong> verified properties ready for you &mdash;
      <strong style="color:#C4B5FD"><%=totalBk%></strong> active booking<%=totalBk!=1?"s":""%>.
      <%if(!bCity.isEmpty()){%>Searching near <strong style="color:#fff"><%=bCity%></strong>.<%}%>
    </p>
    <div class="by-hero-actions">
      <a href="browse_flat.jsp" class="by-btn by-btn-primary"><i class="fa fa-building"></i> Browse Flats</a>
      <a href="browse_land.jsp" class="by-btn by-btn-outline" style="color:#fff;border-color:rgba(255,255,255,.25)"><i class="fa fa-map-o"></i> Browse Land</a>
      <a href="buyer_chat.jsp"  class="by-btn by-btn-outline" style="color:#fff;border-color:rgba(255,255,255,.25)"><i class="fa fa-comments"></i> Chat Sellers</a>
    </div>
  </div>

  <!-- Stats -->
  <div class="by-stats-grid">
    <div class="by-stat-card by-fade">
      <div class="by-stat-icon by-si-teal"><i class="fa fa-building"></i></div>
      <div>
        <div class="by-stat-n"><%=avFlat%></div>
        <div class="by-stat-l">Flats Available</div>
        <div class="by-stat-sub">flat_house · Approved</div>
      </div>
    </div>
    <div class="by-stat-card by-fade">
      <div class="by-stat-icon by-si-green"><i class="fa fa-map-o"></i></div>
      <div>
        <div class="by-stat-n"><%=avLand%></div>
        <div class="by-stat-l">Lands Available</div>
        <div class="by-stat-sub">upload · Approved</div>
      </div>
    </div>
    <div class="by-stat-card by-fade">
      <div class="by-stat-icon by-si-violet"><i class="fa fa-handshake-o"></i></div>
      <div>
        <div class="by-stat-n"><%=totalBk%></div>
        <div class="by-stat-l">My Bookings</div>
        <div class="by-stat-sub">land:<%=landBk%> · flat:<%=flatBk%></div>
      </div>
    </div>
    <div class="by-stat-card by-fade">
      <div class="by-stat-icon by-si-amber"><i class="fa fa-university"></i></div>
      <div>
        <div class="by-stat-n"><%=accCount%></div>
        <div class="by-stat-l">Active Accounts</div>
        <div class="by-stat-sub">buyer_account · Active</div>
      </div>
    </div>
    <div class="by-stat-card by-fade">
      <div class="by-stat-icon by-si-rose"><i class="fa fa-comments"></i></div>
      <div>
        <div class="by-stat-n"><%=chatUnread%></div>
        <div class="by-stat-l">Unread Messages</div>
        <div class="by-stat-sub"><a href="buyer_chat.jsp" style="color:var(--primary)">Open Chat →</a></div>
      </div>
    </div>
  </div>

  <!-- Recent Properties row -->
  <div style="display:grid;grid-template-columns:1fr 1fr;gap:1.3rem" class="by-fade">

    <!-- Recent Flats -->
    <div class="by-card" style="margin-bottom:0">
      <div class="by-card-head">
        <div>
          <div class="by-card-title"><i class="fa fa-building"></i> New Flat/Houses</div>
          <div class="by-card-sub">flat_house · sts1='Approved' · latest 4</div>
        </div>
        <a href="browse_flat.jsp" class="by-btn by-btn-outline by-btn-sm">View All →</a>
      </div>
      <div class="by-table-wrap">
        <table class="by-table">
          <thead><tr><th>Area/City</th><th>Type</th><th>Rent</th><th></th></tr></thead>
          <tbody>
          <%boolean ff=false; while(rsRF.next()){ ff=true; %>
          <tr>
            <td>
              <div class="by-table-name"><%=rsRF.getString("city")!=null?rsRF.getString("city"):"—"%></div>
              <div class="by-table-sub"><%=rsRF.getString("area")!=null?rsRF.getString("area"):""%> <%=rsRF.getString("street")!=null?"· "+rsRF.getString("street"):""%></div>
            </td>
            <td><span class="by-badge by-badge-teal"><%=rsRF.getString("FType")!=null?rsRF.getString("FType"):"—"%></span></td>
            <td class="by-table-price">₹<%=rsRF.getString("rent")!=null?rsRF.getString("rent"):"—"%></td>
            <td><a href="browse_flat.jsp" class="by-btn by-btn-ghost-teal by-btn-xs"><i class="fa fa-eye"></i></a></td>
          </tr>
          <%}if(!ff){%>
          <tr><td colspan="4"><div class="by-empty" style="padding:1.5rem"><i class="fa fa-building" style="font-size:1.5rem;color:var(--border3);display:block;margin-bottom:.4rem"></i>No listings yet</div></td></tr>
          <%}%>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Recent Land -->
    <div class="by-card" style="margin-bottom:0">
      <div class="by-card-head">
        <div>
          <div class="by-card-title"><i class="fa fa-map-o"></i> New Lands</div>
          <div class="by-card-sub">upload · sts1='Approved' · latest 4</div>
        </div>
        <a href="browse_land.jsp" class="by-btn by-btn-outline by-btn-sm">View All →</a>
      </div>
      <div class="by-table-wrap">
        <table class="by-table">
          <thead><tr><th>Area/City</th><th>Sq.ft</th><th>Rent</th><th></th></tr></thead>
          <tbody>
          <%boolean lf=false; while(rsRL.next()){ lf=true; %>
          <tr>
            <td>
              <div class="by-table-name"><%=rsRL.getString("area")!=null?rsRL.getString("area"):"—"%></div>
              <div class="by-table-sub"><%=rsRL.getString("city")!=null?rsRL.getString("city"):""%></div>
            </td>
            <td style="font-size:.8rem"><%=rsRL.getString("FType")!=null?rsRL.getString("FType"):"—"%></td>
            <td class="by-table-price">₹<%=rsRL.getString("rent")!=null?rsRL.getString("rent"):"—"%></td>
            <td><a href="browse_land.jsp" class="by-btn by-btn-ghost-teal by-btn-xs"><i class="fa fa-eye"></i></a></td>
          </tr>
          <%}if(!lf){%>
          <tr><td colspan="4"><div class="by-empty" style="padding:1.5rem"><i class="fa fa-map-o" style="font-size:1.5rem;color:var(--border3);display:block;margin-bottom:.4rem"></i>No listings yet</div></td></tr>
          <%}%>
          </tbody>
        </table>
      </div>
    </div>

  </div>

</div>
</main>

<div id="byToastBox"></div>
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>
function toggleSidebar(){ document.getElementById('bySidebar').classList.toggle('open'); }
const obs=new IntersectionObserver(e=>e.forEach(en=>{if(en.isIntersecting)en.target.classList.add('vis')}),{threshold:.08});
document.querySelectorAll('.by-fade').forEach(el=>obs.observe(el));
function byToast(msg,type){
  var c={info:'var(--primary)',success:'var(--green)',warn:'var(--amber)',error:'var(--rose)'};
  var t=document.createElement('div');
  t.style.cssText='background:white;border:1px solid var(--border);border-left:3px solid '+(c[type]||c.info)+
    ';border-radius:var(--r);padding:.8rem 1rem;font-size:.84rem;color:var(--text);box-shadow:var(--sh-md);'+
    'min-width:260px;max-width:340px;animation:byFadeUp .3s both;pointer-events:auto;font-family:var(--ff-body)';
  t.textContent=msg;
  document.getElementById('byToastBox').appendChild(t);
  setTimeout(()=>t.remove(),4500);
}
</script>
</body>
</html>
