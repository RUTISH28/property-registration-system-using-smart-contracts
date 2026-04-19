<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String adminUser = (String) session.getAttribute("User_Name");
if(adminUser == null){ response.sendRedirect("admin.jsp"); return; }
String flashMsg=(String)session.getAttribute("msg"); session.removeAttribute("msg");

/* bookingss: S_ID,S_NAME,S_MAIL,street,H_NO,U_NAME,U_NUMBER,U_MAIL,STS,A_ACC,C_Type,U_ACC,B_fess,key1,id,A_NAME,SA_NAME */
DB db1=new DB();
ResultSet rs=db1.Select("SELECT S_ID,S_NAME,S_MAIL,street,H_NO,U_NAME,U_NUMBER,U_MAIL,STS,C_Type,B_fess,A_NAME,SA_NAME FROM bookingss ORDER BY S_ID DESC");

DB dC=new DB(); ResultSet rC=dC.Select("SELECT COUNT(*) c FROM bookingss");
int total=0; if(rC.next()) total=rC.getInt("c");
DB dConf=new DB(); ResultSet rConf=dConf.Select("SELECT COUNT(*) c FROM bookingss WHERE STS='Confirmed'");
int confirmed=0; if(rConf.next()) confirmed=rConf.getInt("c");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Flat Bookings — Admin</title>
  <link href="img/favicon.png" rel="icon">
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Fraunces:ital,wght@0,500;0,700;1,700&display=swap" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="css/admin-theme.css" rel="stylesheet">
</head>
<body>
<%if(flashMsg!=null&&!flashMsg.isEmpty()){%><script>window.addEventListener('DOMContentLoaded',()=>adToast('<%=flashMsg%>','info'));</script><%}%>
<button class="ad-hamburger" onclick="toggleSidebar()"><i class="fa fa-bars"></i></button>
<%@ include file="admin_sidebar.jsp" %>

<header class="ad-topbar">
  <div class="ad-page-title">
    Flat / House Bookings
    <span>bookingss table &mdash; <%=total%> total &middot; <%=confirmed%> confirmed</span>
  </div>
  <div class="ad-topbar-actions">
    <span class="ad-badge ad-badge-indigo"><%=total%> Bookings</span>
    <a href="admin_home.jsp" class="ad-btn ad-btn-outline ad-btn-sm"><i class="fa fa-home"></i> Dashboard</a>
  </div>
</header>

<main class="ad-main">
<div class="ad-page">

  <div class="ad-stats-grid ad-fade" style="grid-template-columns:repeat(3,1fr);max-width:500px;margin-bottom:1.5rem">
    <div class="ad-stat-card">
      <div class="ad-stat-icon ad-si-indigo"><i class="fa fa-calendar"></i></div>
      <div><div class="ad-stat-n"><%=total%></div><div class="ad-stat-l">Total</div></div>
    </div>
    <div class="ad-stat-card">
      <div class="ad-stat-icon ad-si-green"><i class="fa fa-check-circle"></i></div>
      <div><div class="ad-stat-n"><%=confirmed%></div><div class="ad-stat-l">Confirmed</div></div>
    </div>
    <div class="ad-stat-card">
      <div class="ad-stat-icon ad-si-amber"><i class="fa fa-clock-o"></i></div>
      <div><div class="ad-stat-n"><%=total-confirmed%></div><div class="ad-stat-l">Other</div></div>
    </div>
  </div>

  <div class="ad-card ad-fade">
    <div class="ad-card-head">
      <div>
        <div class="ad-card-title"><i class="fa fa-calendar"></i> All Flat/House Bookings — bookingss table</div>
        <div class="ad-card-sub">Cols: S_ID, S_NAME, street, H_NO, U_NAME, U_NUMBER, STS, B_fess, C_Type</div>
      </div>
      <div class="ad-search" style="width:240px">
        <i class="fa fa-search"></i>
        <input type="text" placeholder="Search bookings..." oninput="filterRows(this.value,'bkBody')">
      </div>
    </div>
    <div class="ad-table-wrap">
      <table class="ad-table">
        <thead>
          <tr>
            <th>S_ID</th><th>Seller</th><th>Street</th><th>H_NO</th>
            <th>Buyer Name</th><th>Buyer Mobile</th><th>Buyer Email</th>
            <th>Type</th><th>Fee</th><th>Admin</th><th>Status</th>
          </tr>
        </thead>
        <tbody id="bkBody">
        <%boolean found=false; while(rs.next()){ found=true;
            String sts=rs.getString("STS");
            String bc="Confirmed".equalsIgnoreCase(sts)?"ad-badge-green":"Booked".equalsIgnoreCase(sts)?"ad-badge-sky":"ad-badge-amber";
        %>
        <tr>
          <td class="ad-table-mono" style="font-size:.72rem"><%=rs.getString("S_ID")%></td>
          <td>
            <div class="ad-table-name"><%=rs.getString("S_NAME")!=null?rs.getString("S_NAME"):"—"%></div>
            <div class="ad-table-sub"><%=rs.getString("S_MAIL")!=null?rs.getString("S_MAIL"):""%></div>
          </td>
          <td style="font-size:.8rem;color:var(--text2)"><%=rs.getString("street")!=null?rs.getString("street"):"—"%></td>
          <td class="ad-table-mono" style="font-size:.77rem"><%=rs.getString("H_NO")!=null?rs.getString("H_NO"):"—"%></td>
          <td>
            <div class="ad-table-name"><%=rs.getString("U_NAME")!=null?rs.getString("U_NAME"):"—"%></div>
            <div class="ad-table-sub"><%=rs.getString("SA_NAME")!=null?"Seller: "+rs.getString("SA_NAME"):""%></div>
          </td>
          <td class="ad-table-mono" style="font-size:.77rem"><%=rs.getString("U_NUMBER")!=null?rs.getString("U_NUMBER"):"—"%></td>
          <td style="font-size:.78rem;color:var(--text2)"><%=rs.getString("U_MAIL")!=null?rs.getString("U_MAIL"):"—"%></td>
          <td><span class="ad-badge ad-badge-indigo" style="font-size:.65rem"><%=rs.getString("C_Type")!=null?rs.getString("C_Type"):"—"%></span></td>
          <td class="ad-table-price">₹<%=rs.getString("B_fess")!=null?rs.getString("B_fess"):"—"%></td>
          <td style="font-size:.75rem;color:var(--text2)"><%=rs.getString("A_NAME")!=null?rs.getString("A_NAME"):"—"%></td>
          <td><span class="ad-badge <%=bc%> ad-badge-dot"><%=sts!=null?sts:"Pending"%></span></td>
        </tr>
        <%}if(!found){%>
        <tr><td colspan="11"><div class="ad-empty"><i class="fa fa-calendar"></i><h3>No flat bookings yet</h3><p>bookingss table is empty</p></div></td></tr>
        <%}%>
        </tbody>
      </table>
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
function filterRows(q,id){ q=q.toLowerCase(); document.querySelectorAll('#'+id+' tr').forEach(tr=>{ tr.style.display=tr.textContent.toLowerCase().includes(q)?'':'none'; }); }
function adToast(msg,type){ var c={info:'var(--primary)',success:'var(--green)',warn:'var(--amber)',error:'var(--rose)'}; var t=document.createElement('div'); t.style.cssText='background:white;border:1px solid var(--border);border-left:3px solid '+(c[type]||c.info)+';border-radius:var(--r);padding:.8rem 1rem;font-size:.83rem;color:var(--text);box-shadow:var(--sh-md);min-width:260px;max-width:340px;animation:adFadeUp .3s both;pointer-events:auto'; t.textContent=msg; document.getElementById('adToastBox').appendChild(t); setTimeout(()=>t.remove(),4500); }
</script>
</body>
</html>
