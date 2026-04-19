<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String adminUser = (String) session.getAttribute("User_Name");
if(adminUser == null){ response.sendRedirect("admin.jsp"); return; }
String flashMsg=(String)session.getAttribute("msg"); session.removeAttribute("msg");

/* sellerregister — Approved sellers */
DB db1=new DB();
ResultSet rs=db1.Select("SELECT S_ID,A_Name,username,email,mobile_no,city,Gender,dob,address,sts FROM sellerregister WHERE sts='Approved' ORDER BY S_ID DESC");

DB dT=new DB(); ResultSet rT=dT.Select("SELECT COUNT(*) c FROM sellerregister WHERE sts='Approved'");
int total=0; if(rT.next()) total=rT.getInt("c");

DB dB=new DB(); ResultSet rB=dB.Select("SELECT COUNT(*) c FROM sellerregister WHERE sts='Blocked'");
int blocked=0; if(rB.next()) blocked=rB.getInt("c");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Seller Details — Admin</title>
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
    Seller Details
    <span>sellerregister table &mdash; <%=total%> active &middot; <%=blocked%> blocked</span>
  </div>
  <div class="ad-topbar-actions">
    <span class="ad-badge ad-badge-green ad-badge-dot"><%=total%> Active</span>
    <a href="seller_req.jsp" class="ad-btn ad-btn-outline ad-btn-sm"><i class="fa fa-user-plus"></i> Pending</a>
    <a href="admin_home.jsp" class="ad-btn ad-btn-outline ad-btn-sm"><i class="fa fa-home"></i> Dashboard</a>
  </div>
</header>

<main class="ad-main">
<div class="ad-page">

  <!-- Stats row -->
  <div class="ad-stats-grid ad-fade" style="grid-template-columns:repeat(3,1fr);max-width:600px;margin-bottom:1.5rem">
    <div class="ad-stat-card">
      <div class="ad-stat-icon ad-si-green"><i class="fa fa-user-secret"></i></div>
      <div><div class="ad-stat-n"><%=total%></div><div class="ad-stat-l">Active Sellers</div></div>
    </div>
    <div class="ad-stat-card">
      <div class="ad-stat-icon ad-si-rose"><i class="fa fa-ban"></i></div>
      <div><div class="ad-stat-n"><%=blocked%></div><div class="ad-stat-l">Blocked</div></div>
    </div>
    <div class="ad-stat-card">
      <div class="ad-stat-icon ad-si-indigo"><i class="fa fa-database"></i></div>
      <div><div class="ad-stat-n"><%=total+blocked%></div><div class="ad-stat-l">Total Registered</div></div>
    </div>
  </div>

  <div class="ad-card ad-fade">
    <div class="ad-card-head">
      <div>
        <div class="ad-card-title"><i class="fa fa-id-card"></i> Active Sellers — sellerregister</div>
        <div class="ad-card-sub">sts='Approved' — click BLOCK to restrict access</div>
      </div>
      <div class="ad-search" style="width:240px">
        <i class="fa fa-search"></i>
        <input type="text" placeholder="Search sellers..." oninput="filterRows(this.value,'sBody')">
      </div>
    </div>
    <div class="ad-table-wrap">
      <table class="ad-table">
        <thead>
          <tr>
            <th>S_ID</th><th>Aadhaar</th><th>Username</th><th>Email</th>
            <th>Mobile</th><th>City</th><th>Gender</th><th>DOB</th><th>Status</th><th>Action</th>
          </tr>
        </thead>
        <tbody id="sBody">
        <%boolean found=false; while(rs.next()){ found=true; %>
        <tr>
          <td class="ad-table-mono" style="font-size:.72rem"><%=rs.getString("S_ID")%></td>
          <td class="ad-table-mono" style="font-size:.74rem"><%=rs.getString("A_Name")!=null?rs.getString("A_Name"):"—"%></td>
          <td><div class="ad-table-name"><%=rs.getString("username")!=null?rs.getString("username"):"—"%></div></td>
          <td style="font-size:.79rem;color:var(--text2)"><%=rs.getString("email")!=null?rs.getString("email"):"—"%></td>
          <td class="ad-table-mono" style="font-size:.77rem"><%=rs.getString("mobile_no")!=null?rs.getString("mobile_no"):"—"%></td>
          <td style="font-size:.79rem"><%=rs.getString("city")!=null?rs.getString("city"):"—"%></td>
          <td style="font-size:.78rem"><%=rs.getString("Gender")!=null?rs.getString("Gender"):"—"%></td>
          <td style="font-size:.77rem;color:var(--text2)"><%=rs.getString("dob")!=null?rs.getString("dob"):"—"%></td>
          <td><span class="ad-badge ad-badge-green ad-badge-dot"><%=rs.getString("sts")%></span></td>
          <td>
            <a href="request4.jsp?username=<%=rs.getString("username")%>"
               class="ad-btn ad-btn-danger ad-btn-xs"
               onclick="return confirm('Block seller <%=rs.getString("username")%>? They will lose access.')">
              <i class="fa fa-ban"></i> Block
            </a>
          </td>
        </tr>
        <%}if(!found){%>
        <tr><td colspan="10"><div class="ad-empty"><i class="fa fa-user-secret"></i><h3>No active sellers</h3><p>No sellers with sts='Approved' in sellerregister</p></div></td></tr>
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
