<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String A_Name=(String)session.getAttribute("User");
if(A_Name==null){response.sendRedirect("index.jsp");return;}

/* land bookings: booking table
   S_ID,S_NAME,S_MAIL,area,D_NO,U_NAME,U_NUMBER,U_MAIL,STS,A_ACC,C_Type,U_ACC,B_fess,key1,id,A_NAME,SUNO,SA_Name */
DB db1=new DB();
ResultSet rsL=db1.Select(
  "SELECT b.S_ID,b.S_NAME,b.S_MAIL,b.area,b.D_NO,b.STS,b.B_fess,b.C_Type,b.SA_Name "+
  "FROM booking b WHERE b.U_NAME='"+A_Name+"' ORDER BY b.S_ID DESC");

/* flat bookings: bookingss table */
DB db2=new DB();
ResultSet rsF=db2.Select(
  "SELECT b.S_ID,b.S_NAME,b.S_MAIL,b.street,b.H_NO,b.STS,b.B_fess,b.C_Type,b.SA_NAME "+
  "FROM bookingss b WHERE b.U_NAME='"+A_Name+"' ORDER BY b.S_ID DESC");

DB dC1=new DB(); ResultSet rC1=dC1.Select("SELECT COUNT(*) c FROM booking WHERE U_NAME='"+A_Name+"'"); int lCount=0; if(rC1.next()) lCount=rC1.getInt("c");
DB dC2=new DB(); ResultSet rC2=dC2.Select("SELECT COUNT(*) c FROM bookingss WHERE U_NAME='"+A_Name+"'"); int fCount=0; if(rC2.next()) fCount=rC2.getInt("c");

String flashMsg=(String)session.getAttribute("msg"); session.removeAttribute("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>My Bookings — Buyer</title>
  <link href="img/favicon.png" rel="icon">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600;1,700&display=swap" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="css/buyer-theme.css" rel="stylesheet">
</head>
<body>
<%if(flashMsg!=null&&!flashMsg.isEmpty()){%><script>window.addEventListener('DOMContentLoaded',()=>byToast('<%=flashMsg%>','success'));</script><%}%>
<button class="by-hamburger" onclick="toggleSidebar()"><i class="fa fa-bars"></i></button>
<%@ include file="buyer_sidebar.jsp" %>

<header class="by-topbar">
  <div class="by-page-title">
    My Bookings
    <span>booking + bookingss · total <%=lCount+fCount%> booking<%=(lCount+fCount)!=1?"s":""%></span>
  </div>
  <div class="by-topbar-actions">
    <a href="browse_flat.jsp" class="by-btn by-btn-primary by-btn-sm"><i class="fa fa-plus"></i> Book More</a>
    <a href="buyerhome.jsp" class="by-btn by-btn-outline by-btn-sm"><i class="fa fa-home"></i></a>
  </div>
</header>

<main class="by-main">
<div class="by-page">

  <div class="by-stats-grid by-fade" style="grid-template-columns:repeat(3,1fr);max-width:520px;margin-bottom:1.5rem">
    <div class="by-stat-card">
      <div class="by-stat-icon by-si-teal"><i class="fa fa-handshake-o"></i></div>
      <div><div class="by-stat-n"><%=lCount+fCount%></div><div class="by-stat-l">Total Bookings</div></div>
    </div>
    <div class="by-stat-card">
      <div class="by-stat-icon by-si-green"><i class="fa fa-map-o"></i></div>
      <div><div class="by-stat-n"><%=lCount%></div><div class="by-stat-l">Land</div></div>
    </div>
    <div class="by-stat-card">
      <div class="by-stat-icon by-si-violet"><i class="fa fa-building"></i></div>
      <div><div class="by-stat-n"><%=fCount%></div><div class="by-stat-l">Flat/House</div></div>
    </div>
  </div>

  <!-- Land Bookings -->
  <div class="by-card by-fade">
    <div class="by-card-head">
      <div>
        <div class="by-card-title"><i class="fa fa-map-o"></i> Land Bookings</div>
        <div class="by-card-sub">booking table · U_NAME='<%=A_Name%>'</div>
      </div>
      <span class="by-badge by-badge-green"><%=lCount%> records</span>
    </div>
    <div class="by-table-wrap">
      <table class="by-table">
        <thead><tr><th>Seller</th><th>Area</th><th>Doc No</th><th>Survey No</th><th>Booking Fee</th><th>Type</th><th>Status</th><th>Action</th></tr></thead>
        <tbody>
        <%boolean lf=false; while(rsL.next()){ lf=true;
          String sts=rsL.getString("STS");
          String bc="Confirmed".equalsIgnoreCase(sts)?"by-badge-green":"Booked".equalsIgnoreCase(sts)?"by-badge-teal":"by-badge-amber";
          String sellerAadhar=rsL.getString("SA_Name"); if(sellerAadhar==null)sellerAadhar="";
        %>
        <tr>
          <td>
            <div class="by-table-name"><%=rsL.getString("S_NAME")!=null?rsL.getString("S_NAME"):"—"%></div>
            <div class="by-table-sub"><%=rsL.getString("S_MAIL")!=null?rsL.getString("S_MAIL"):""%></div>
          </td>
          <td style="font-size:.82rem;font-weight:600"><%=rsL.getString("area")!=null?rsL.getString("area"):"—"%></td>
          <td class="by-table-mono"><%=rsL.getString("D_NO")!=null?rsL.getString("D_NO"):"—"%></td>
          <td style="font-size:.78rem"></td>
          <td class="by-table-price">₹<%=rsL.getString("B_fess")!=null?rsL.getString("B_fess"):"—"%></td>
          <td><span class="by-badge by-badge-slate"><%=rsL.getString("C_Type")!=null?rsL.getString("C_Type"):"—"%></span></td>
          <td><span class="by-badge <%=bc%> by-badge-dot"><%=sts!=null?sts:"Pending"%></span></td>
          <td>
            <div style="display:flex;gap:.4rem;flex-wrap:wrap">
              <a href="buyer_payment.jsp?type=land&ref=<%=rsL.getString("D_NO")%>&amount=<%=rsL.getString("B_fess")%>&seller=<%=sellerAadhar%>"
                 class="by-btn by-btn-ghost-teal by-btn-xs"><i class="fa fa-credit-card"></i> Pay</a>
              <a href="buyer_chat.jsp?seller=<%=sellerAadhar%>"
                 class="by-btn by-btn-outline by-btn-xs"><i class="fa fa-comments"></i></a>
            </div>
          </td>
        </tr>
        <%}if(!lf){%>
        <tr><td colspan="8"><div class="by-empty" style="padding:1.5rem"><i class="fa fa-map-o" style="font-size:1.8rem;color:var(--border3);display:block;margin-bottom:.4rem"></i><p>No land bookings yet</p></div></td></tr>
        <%}%>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Flat Bookings -->
  <div class="by-card by-fade">
    <div class="by-card-head">
      <div>
        <div class="by-card-title"><i class="fa fa-building"></i> Flat/House Bookings</div>
        <div class="by-card-sub">bookingss table · U_NAME='<%=A_Name%>'</div>
      </div>
      <span class="by-badge by-badge-violet"><%=fCount%> records</span>
    </div>
    <div class="by-table-wrap">
      <table class="by-table">
        <thead><tr><th>Seller</th><th>Street</th><th>H_NO</th><th>Booking Fee</th><th>Type</th><th>Status</th><th>Action</th></tr></thead>
        <tbody>
        <%boolean ff=false; while(rsF.next()){ ff=true;
          String sts=rsF.getString("STS");
          String bc="Confirmed".equalsIgnoreCase(sts)?"by-badge-green":"Booked".equalsIgnoreCase(sts)?"by-badge-teal":"by-badge-amber";
          String sellerAadhar=rsF.getString("SA_NAME"); if(sellerAadhar==null)sellerAadhar="";
        %>
        <tr>
          <td>
            <div class="by-table-name"><%=rsF.getString("S_NAME")!=null?rsF.getString("S_NAME"):"—"%></div>
            <div class="by-table-sub"><%=rsF.getString("S_MAIL")!=null?rsF.getString("S_MAIL"):""%></div>
          </td>
          <td style="font-size:.82rem"><%=rsF.getString("street")!=null?rsF.getString("street"):"—"%></td>
          <td class="by-table-mono"><%=rsF.getString("H_NO")!=null?rsF.getString("H_NO"):"—"%></td>
          <td class="by-table-price">₹<%=rsF.getString("B_fess")!=null?rsF.getString("B_fess"):"—"%></td>
          <td><span class="by-badge by-badge-slate"><%=rsF.getString("C_Type")!=null?rsF.getString("C_Type"):"—"%></span></td>
          <td><span class="by-badge <%=bc%> by-badge-dot"><%=sts!=null?sts:"Pending"%></span></td>
          <td>
            <div style="display:flex;gap:.4rem;flex-wrap:wrap">
              <a href="buyer_payment.jsp?type=flat&ref=<%=rsF.getString("H_NO")%>&amount=<%=rsF.getString("B_fess")%>&seller=<%=sellerAadhar%>"
                 class="by-btn by-btn-ghost-teal by-btn-xs"><i class="fa fa-credit-card"></i> Pay</a>
              <a href="buyer_chat.jsp?seller=<%=sellerAadhar%>"
                 class="by-btn by-btn-outline by-btn-xs"><i class="fa fa-comments"></i></a>
            </div>
          </td>
        </tr>
        <%}if(!ff){%>
        <tr><td colspan="7"><div class="by-empty" style="padding:1.5rem"><i class="fa fa-building" style="font-size:1.8rem;color:var(--border3);display:block;margin-bottom:.4rem"></i><p>No flat bookings yet</p></div></td></tr>
        <%}%>
        </tbody>
      </table>
    </div>
  </div>

</div>
</main>
<div id="byToastBox"></div>
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>
function toggleSidebar(){document.getElementById('bySidebar').classList.toggle('open');}
const obs=new IntersectionObserver(e=>e.forEach(en=>{if(en.isIntersecting)en.target.classList.add('vis')}),{threshold:.08});
document.querySelectorAll('.by-fade').forEach(el=>obs.observe(el));
function byToast(msg,type){var c={info:'var(--primary)',success:'var(--green)',warn:'var(--amber)',error:'var(--rose)'};var t=document.createElement('div');t.style.cssText='background:white;border:1px solid var(--border);border-left:3px solid '+(c[type]||c.info)+';border-radius:var(--r);padding:.8rem 1rem;font-size:.84rem;color:var(--text);box-shadow:var(--sh-md);min-width:260px;max-width:340px;animation:byFadeUp .3s both;pointer-events:auto;font-family:var(--ff-body)';t.textContent=msg;document.getElementById('byToastBox').appendChild(t);setTimeout(()=>t.remove(),4500);}
</script>
</body>
</html>
