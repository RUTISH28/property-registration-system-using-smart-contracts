<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String adminUser = (String) session.getAttribute("User_Name");
if(adminUser == null){ response.sendRedirect("admin.jsp"); return; }
String flashMsg=(String)session.getAttribute("msg"); session.removeAttribute("msg");

/* flat_house: S_ID,S_Name,S_Number,S_Addr,city,area,street,rent,advance,image,FType,H_NO,sts,S_MAIL,fess,A_Name,sts1 */
DB db1=new DB();
ResultSet rs=db1.Select("SELECT S_ID,S_Name,S_Number,city,area,street,rent,advance,FType,H_NO,sts,A_Name,S_MAIL FROM flat_house WHERE sts='NO' ORDER BY S_ID DESC");

DB dC=new DB(); ResultSet rC=dC.Select("SELECT COUNT(*) c FROM flat_house WHERE sts='NO'");
int pendCount=0; if(rC.next()) pendCount=rC.getInt("c");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Flat/House Approval — Admin</title>
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
    Flat / House Approval
    <span>flat_house table &mdash; sts='NO' &mdash; <%=pendCount%> properties pending</span>
  </div>
  <div class="ad-topbar-actions">
    <%if(pendCount>0){%><span class="ad-badge ad-badge-amber ad-badge-dot"><%=pendCount%> Pending</span><%}%>
    <a href="admin_home.jsp" class="ad-btn ad-btn-outline ad-btn-sm"><i class="fa fa-home"></i> Dashboard</a>
  </div>
</header>

<main class="ad-main">
<div class="ad-page">

  <div class="ad-card ad-fade">
    <div class="ad-card-head">
      <div>
        <div class="ad-card-title"><i class="fa fa-building"></i> Pending Flat/House Verifications</div>
        <div class="ad-card-sub">Source: <code>flat_house</code> WHERE sts='NO' — image via servlet_2.jsp?name=S_ID</div>
      </div>
      <div class="ad-search" style="width:240px">
        <i class="fa fa-search"></i>
        <input type="text" placeholder="Search properties..." oninput="filterRows(this.value,'flatBody')">
      </div>
    </div>
    <div class="ad-table-wrap">
      <table class="ad-table">
        <thead>
          <tr>
            <th>S_ID</th><th>Image</th><th>Seller</th><th>Contact</th>
            <th>City / Area</th><th>Street</th><th>H_NO</th>
            <th>Type</th><th>Rent</th><th>Advance</th>
            <th>Status</th><th>Action</th>
          </tr>
        </thead>
        <tbody id="flatBody">
        <%boolean found=false; while(rs.next()){ found=true; %>
        <tr>
          <td class="ad-table-mono" style="font-size:.72rem"><%=rs.getString("S_ID")%></td>
          <td><img src="servlet_2.jsp?name=<%=rs.getInt("S_ID")%>" class="ad-table-img" alt="Property" onclick="openImg(this.src)"></td>
          <td>
            <div class="ad-table-name"><%=rs.getString("S_Name")!=null?rs.getString("S_Name"):"—"%></div>
            <div class="ad-table-sub"><%=rs.getString("S_MAIL")!=null?rs.getString("S_MAIL"):""%></div>
          </td>
          <td class="ad-table-mono" style="font-size:.77rem"><%=rs.getString("S_Number")!=null?rs.getString("S_Number"):"—"%></td>
          <td>
            <div style="font-size:.8rem;font-weight:600"><%=rs.getString("city")!=null?rs.getString("city"):"—"%></div>
            <div class="ad-table-sub"><%=rs.getString("area")!=null?rs.getString("area"):"—"%></div>
          </td>
          <td style="font-size:.78rem;color:var(--text2)"><%=rs.getString("street")!=null?rs.getString("street"):"—"%></td>
          <td class="ad-table-mono" style="font-size:.77rem"><%=rs.getString("H_NO")!=null?rs.getString("H_NO"):"—"%></td>
          <td><span class="ad-badge ad-badge-indigo"><%=rs.getString("FType")!=null?rs.getString("FType"):"—"%></span></td>
          <td class="ad-table-price">₹<%=rs.getString("rent")!=null?rs.getString("rent"):"—"%></td>
          <td style="font-size:.8rem;color:var(--text2)">₹<%=rs.getString("advance")!=null?rs.getString("advance"):"—"%></td>
          <td><span class="ad-badge ad-badge-amber ad-badge-dot"><%=rs.getString("sts")!=null?rs.getString("sts"):"NO"%></span></td>
          <td>
            <div style="display:flex;gap:.4rem;flex-wrap:wrap">
              <a href="houserequest.jsp?H_No=<%=rs.getString("H_NO")%>" class="ad-btn ad-btn-approve ad-btn-xs" onclick="return confirm('Approve this property?')"><i class="fa fa-check"></i> Approve</a>
              <a href="houserequest1.jsp?H_No=<%=rs.getString("H_NO")%>" class="ad-btn ad-btn-danger ad-btn-xs" onclick="return confirm('Reject this property?')"><i class="fa fa-times"></i> Reject</a>
            </div>
          </td>
         
        </tr>
        <%}if(!found){%>
        <tr><td colspan="13">
          <div class="ad-empty"><i class="fa fa-building"></i><h3>No properties pending</h3><p>All flat/house in <code>flat_house</code> has been reviewed</p></div>
        </td></tr>
        <%}%>
        </tbody>
      </table>
    </div>
  </div>

</div>
</main>

<div id="imgModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:9999;align-items:center;justify-content:center" onclick="this.style.display='none'">
  <img id="imgPreview" style="max-width:90vw;max-height:85vh;border-radius:var(--r-lg);box-shadow:var(--sh-lg)">
</div>

<div id="adToastBox"></div>
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>
function toggleSidebar(){ document.getElementById('adSidebar').classList.toggle('open'); }
const obs=new IntersectionObserver(e=>e.forEach(en=>{if(en.isIntersecting)en.target.classList.add('vis')}),{threshold:.08});
document.querySelectorAll('.ad-fade').forEach(el=>obs.observe(el));
function filterRows(q,id){ q=q.toLowerCase(); document.querySelectorAll('#'+id+' tr').forEach(tr=>{ tr.style.display=tr.textContent.toLowerCase().includes(q)?'':'none'; }); }
function openImg(src){ document.getElementById('imgPreview').src=src; document.getElementById('imgModal').style.display='flex'; }
function adToast(msg,type){ var c={info:'var(--primary)',success:'var(--green)',warn:'var(--amber)',error:'var(--rose)'}; var t=document.createElement('div'); t.style.cssText='background:white;border:1px solid var(--border);border-left:3px solid '+(c[type]||c.info)+';border-radius:var(--r);padding:.8rem 1rem;font-size:.83rem;color:var(--text);box-shadow:var(--sh-md);min-width:260px;max-width:340px;animation:adFadeUp .3s both;pointer-events:auto'; t.textContent=msg; document.getElementById('adToastBox').appendChild(t); setTimeout(()=>t.remove(),4500); }
</script>
</body>
</html>
