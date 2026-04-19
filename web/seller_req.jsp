<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String adminUser = (String) session.getAttribute("User_Name");
if(adminUser == null){ response.sendRedirect("admin.jsp"); return; }
String flashMsg=(String)session.getAttribute("msg"); session.removeAttribute("msg");

/* sellerregister: S_ID,A_Name,username,email,Gender,pass_word,con_pass,dob,mobile_no,city,address,sts,Image */
DB db1=new DB();
ResultSet rs=db1.Select("SELECT S_ID,A_Name,username,email,mobile_no,city,dob,Gender,sts FROM sellerregister WHERE sts='NO' ORDER BY S_ID DESC");

DB dC=new DB(); ResultSet rC=dC.Select("SELECT COUNT(*) c FROM sellerregister WHERE sts='NO'");
int pendCount=0; if(rC.next()) pendCount=rC.getInt("c");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Seller Approval — Admin</title>
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
    Seller Approval
    <span>sellerregister table &mdash; sts='NO' &mdash; <%=pendCount%> pending</span>
  </div>
  <div class="ad-topbar-actions">
    <%if(pendCount>0){%><span class="ad-badge ad-badge-rose ad-badge-dot"><%=pendCount%> Pending</span><%}%>
    <a href="admin_home.jsp" class="ad-btn ad-btn-outline ad-btn-sm"><i class="fa fa-home"></i> Dashboard</a>
  </div>
</header>

<main class="ad-main">
<div class="ad-page">

  <div class="ad-card ad-fade">
    <div class="ad-card-head">
      <div>
        <div class="ad-card-title"><i class="fa fa-user-secret"></i> Pending Seller Verifications</div>
        <div class="ad-card-sub">Source: <code>sellerregister</code> WHERE sts='NO' — image via servlet_4.jsp?name=S_ID</div>
      </div>
      <div class="ad-search" style="width:260px">
        <i class="fa fa-search"></i>
        <input type="text" placeholder="Search sellers..." oninput="filterRows(this.value,'sellerBody')">
      </div>
    </div>
    <div class="ad-table-wrap">
      <table class="ad-table">
        <thead>
          <tr>
            <th>Photo</th><th>Aadhaar No</th><th>Username</th><th>Email</th>
            <th>Mobile</th><th>City</th><th>DOB</th><th>Gender</th><th>Status</th><th>Action</th>
          </tr>
        </thead>
        <tbody id="sellerBody">
        <%boolean found=false; while(rs.next()){ found=true; String sts=rs.getString("sts"); %>
        <tr>
          <td><img src="servlet_4.jsp?name=<%=rs.getInt("S_ID")%>" class="ad-table-img-lg" alt="Photo" onerror="this.src='img/user-placeholder.jpg'"></td>
          <td class="ad-table-mono"><%=rs.getString("A_Name")!=null?rs.getString("A_Name"):"—"%></td>
          <td>
            <div class="ad-table-name"><%=rs.getString("username")!=null?rs.getString("username"):"—"%></div>
            <div class="ad-table-sub">ID:<%=rs.getString("S_ID")%></div>
          </td>
          <td style="font-size:.79rem;color:var(--text2)"><%=rs.getString("email")!=null?rs.getString("email"):"—"%></td>
          <td class="ad-table-mono"><%=rs.getString("mobile_no")!=null?rs.getString("mobile_no"):"—"%></td>
          <td style="font-size:.79rem"><%=rs.getString("city")!=null?rs.getString("city"):"—"%></td>
          <td style="font-size:.77rem;color:var(--text2)"><%=rs.getString("dob")!=null?rs.getString("dob"):"—"%></td>
          <td style="font-size:.78rem"><%=rs.getString("Gender")!=null?rs.getString("Gender"):"—"%></td>
          <td><span class="ad-badge ad-badge-amber ad-badge-dot"><%=sts!=null?sts:"NO"%></span></td>
          <td>
            <div style="display:flex;gap:.4rem;flex-wrap:wrap">
              <a href="request1.jsp?username=<%=rs.getString("username")%>" class="ad-btn ad-btn-approve ad-btn-xs" onclick="return confirm('Approve seller?')"><i class="fa fa-check"></i> Approve</a>
              <a href="request2.jsp?username=<%=rs.getString("username")%>" class="ad-btn ad-btn-danger ad-btn-xs" onclick="return confirm('Reject seller?')"><i class="fa fa-times"></i> Reject</a>
            </div>
          </td>
        </tr>
        <%}if(!found){%>
        <tr><td colspan="10">
          <div class="ad-empty"><i class="fa fa-check-circle"></i><h3>All caught up!</h3><p>No sellers pending in <code>sellerregister</code></p></div>
        </td></tr>
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
