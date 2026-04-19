<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String adminUser = (String) session.getAttribute("User_Name");
if(adminUser == null){ response.sendRedirect("admin.jsp"); return; }
String flashMsg=(String)session.getAttribute("msg"); session.removeAttribute("msg");

/* upload: S_ID,S_Name,S_Number,S_Addr,area,city,rent,advance,image,FType,SR_NO,D_NO,sts,SUNO,S_MAIL,fess,A_Name,sts1 */
DB db1=new DB();
ResultSet rs=db1.Select("SELECT S_ID,S_Name,S_Number,S_Addr,area,city,rent,advance,FType,D_NO,SUNO,sts,A_Name FROM upload WHERE sts='NO' ORDER BY S_ID DESC");

DB dC=new DB(); ResultSet rC=dC.Select("SELECT COUNT(*) c FROM upload WHERE sts='NO'");
int pendCount=0; if(rC.next()) pendCount=rC.getInt("c");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Land Approval — Admin</title>
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
    Land Approval
    <span>upload table &mdash; sts='NO' &mdash; <%=pendCount%> properties pending</span>
  </div>
  <div class="ad-topbar-actions">
    <%if(pendCount>0){%><span class="ad-badge ad-badge-amber ad-badge-dot"><%=pendCount%> Pending</span><%}%>
    <a href="admin_home.jsp" class="ad-btn ad-btn-outline ad-btn-sm"><i class="fa fa-home"></i> Dashboard</a>
  </div>
</header>

<main class="ad-main">
<div class="ad-page">

  <div class="ad-alert ad-a-info ad-fade">
    <i class="fa fa-info-circle" style="margin-top:2px"></i>
    <span>Verify land documents on <strong>TSReginet</strong> before approving. Click the <strong>Verify</strong> button to open the government portal in a new tab.</span>
  </div>

  <div class="ad-card ad-fade">
    <div class="ad-card-head">
      <div>
        <div class="ad-card-title"><i class="fa fa-map-o"></i> Pending Land Verifications</div>
        <div class="ad-card-sub">Source: <code>upload</code> WHERE sts='NO' — image via servlet_3.jsp?name=S_ID</div>
      </div>
      <div class="ad-search" style="width:240px">
        <i class="fa fa-search"></i>
        <input type="text" placeholder="Search land..." oninput="filterRows(this.value,'landBody')">
      </div>
    </div>
    <div class="ad-table-wrap">
      <table class="ad-table">
        <thead>
          <tr>
            <th>S_ID</th><th>Image</th><th>Seller</th><th>Mobile</th>
            <th>Area / City</th><th>Doc No</th><th>Survey No</th>
            <th>Sq.ft</th><th>Rent</th><th>Status</th>
            <th>TS Verify</th><th>Action</th>
          </tr>
        </thead>
        <tbody id="landBody">
        <%boolean found=false; while(rs.next()){ found=true; %>
        <tr>
          <td class="ad-table-mono" style="font-size:.72rem"><%=rs.getString("S_ID")%></td>
          <td><img src="servlet_3.jsp?name=<%=rs.getInt("S_ID")%>" class="ad-table-img" alt="Land" onclick="openImg(this.src)"></td>
          <td>
            <div class="ad-table-name"><%=rs.getString("S_Name")!=null?rs.getString("S_Name"):"—"%></div>
            <div class="ad-table-sub"><%=rs.getString("A_Name")!=null?rs.getString("A_Name"):""%></div>
          </td>
          <td class="ad-table-mono" style="font-size:.77rem"><%=rs.getString("S_Number")!=null?rs.getString("S_Number"):"—"%></td>
          <td>
            <div style="font-size:.8rem;font-weight:600"><%=rs.getString("area")!=null?rs.getString("area"):"—"%></div>
            <div class="ad-table-sub"><%=rs.getString("city")!=null?rs.getString("city"):"—"%></div>
          </td>
          <td class="ad-table-mono" style="font-size:.77rem"><%=rs.getString("D_NO")!=null?rs.getString("D_NO"):"—"%></td>
          <td class="ad-table-mono" style="font-size:.77rem"><%=rs.getString("SUNO")!=null?rs.getString("SUNO"):"—"%></td>
          <td style="font-size:.8rem;color:var(--text2)"><%=rs.getString("FType")!=null?rs.getString("FType"):"—"%></td>
          <td class="ad-table-price">₹<%=rs.getString("rent")!=null?rs.getString("rent"):"—"%></td>
          <td><span class="ad-badge ad-badge-amber ad-badge-dot"><%=rs.getString("sts")!=null?rs.getString("sts"):"NO"%></span></td>
          <td>
            <a href="https://bhubharati.telangana.gov.in/knowLandStatus" class="ad-btn ad-btn-info ad-btn-xs" target="_blank">
              <i class="fa fa-external-link"></i> TS Reg
            </a>
          </td>
          <td>
            <div style="display:flex;gap:.4rem;flex-wrap:wrap">
              <a href="landrequest.jsp?D_NO=<%=rs.getString("D_NO")%>" class="ad-btn ad-btn-approve ad-btn-xs" onclick="return confirm('Approve this land?')"><i class="fa fa-check"></i> Approve</a>
              <a href="landrequest1.jsp?D_NO=<%=rs.getString("D_NO")%>" class="ad-btn ad-btn-danger ad-btn-xs" onclick="return confirm('Reject this land?')"><i class="fa fa-times"></i> Reject</a>
            </div>
          </td>
         
        </tr>
        <%}if(!found){%>
        <tr><td colspan="13">
          <div class="ad-empty"><i class="fa fa-map-o"></i><h3>No land pending</h3><p>All land in <code>upload</code> has been reviewed</p></div>
        </td></tr>
        <%}%>
        </tbody>
      </table>
    </div>
  </div>

</div>
</main>

<!-- Image preview modal -->
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
