<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String A_Name=(String)session.getAttribute("User");
if(A_Name==null){response.sendRedirect("index.jsp");return;}

String filterCity=request.getParameter("city"); if(filterCity==null) filterCity="";
String filterType=request.getParameter("ftype"); if(filterType==null) filterType="";

/* Exclude flats already booked: H_NO exists in bookingss table */
String sql="SELECT f.S_ID,f.S_Name,f.city,f.area,f.street,f.FType,f.rent,f.advance,f.H_NO,f.fess,f.A_Name,f.S_MAIL,f.S_Number "+
           "FROM flat_house f WHERE f.sts='Approved' "+
           "AND NOT EXISTS (SELECT 1 FROM bookingss b WHERE b.H_NO=f.H_NO) ";
if(!filterCity.isEmpty()) sql+=" AND f.city LIKE '%"+filterCity+"%'";
if(!filterType.isEmpty()) sql+=" AND f.FType='"+filterType+"'";
sql+=" ORDER BY f.S_ID DESC";

DB db1=new DB(); ResultSet rs=db1.Select(sql);
DB dC=new DB(); ResultSet rC=dC.Select(
  "SELECT COUNT(*) c FROM flat_house f WHERE f.sts='Approved' AND NOT EXISTS (SELECT 1 FROM bookingss b WHERE b.H_NO=f.H_NO)");
int totalFlats=0; if(rC.next()) totalFlats=rC.getInt("c");
String flashMsg=(String)session.getAttribute("msg"); session.removeAttribute("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Browse Flats — Innovative Residence</title>
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
    Browse Flats &amp; Houses
    <span>Available only &mdash; <%=totalFlats%> listing<%=totalFlats!=1?"s":""%></span>
  </div>
  <div class="by-topbar-actions">
    <a href="browse_land.jsp" class="by-btn by-btn-outline by-btn-sm"><i class="fa fa-map-o"></i> Land</a>
    <a href="buyerhome.jsp" class="by-btn by-btn-outline by-btn-sm"><i class="fa fa-home"></i></a>
  </div>
</header>

<main class="by-main">
<div class="by-page">

  <div class="by-alert by-a-teal by-fade" style="margin-bottom:1rem">
    <i class="fa fa-check-circle"></i>
    <span>Only <strong>available</strong> properties shown. Already-booked flats are automatically hidden.</span>
  </div>

  <div class="by-card by-fade" style="margin-bottom:1.3rem">
    <div class="by-card-body" style="padding:.85rem 1.2rem">
      <form method="GET" action="browse_flat.jsp" style="display:flex;gap:.7rem;flex-wrap:wrap;align-items:flex-end">
        <div style="flex:1;min-width:160px">
          <label class="by-label">City</label>
          <div class="by-input-prefix"><i class="fa fa-map-marker"></i>
            <input type="text" name="city" class="by-input" value="<%=filterCity%>" placeholder="Filter by city...">
          </div>
        </div>
        <div style="min-width:140px">
          <label class="by-label">Type</label>
          <select name="ftype" class="by-select">
            <option value="">All Types</option>
            <option value="Flat"  <%="Flat".equals(filterType)?"selected":""%>>Flat</option>
            <option value="House" <%="House".equals(filterType)?"selected":""%>>House</option>
            <option value="Villa" <%="Villa".equals(filterType)?"selected":""%>>Villa</option>
          </select>
        </div>
        <div style="display:flex;gap:.5rem;align-items:flex-end">
          <button type="submit" class="by-btn by-btn-primary"><i class="fa fa-search"></i> Search</button>
          <a href="browse_flat.jsp" class="by-btn by-btn-outline"><i class="fa fa-times"></i> Clear</a>
        </div>
      </form>
    </div>
  </div>

  <div class="by-prop-grid by-fade">
    <%boolean found=false; while(rs.next()){ found=true;
      String sellerAadhar=rs.getString("A_Name"); if(sellerAadhar==null)sellerAadhar="";
      String ftype=rs.getString("FType"); if(ftype==null)ftype="Flat";
      String rent=rs.getString("rent"); if(rent==null)rent="0";
      String advance=rs.getString("advance"); if(advance==null)advance="0";
      String fess=rs.getString("fess"); if(fess==null)fess="0";
      String hno=rs.getString("H_NO"); if(hno==null)hno="";
      String city=rs.getString("city"); if(city==null)city="";
      String area=rs.getString("area"); if(area==null)area="";
      String street=rs.getString("street"); if(street==null)street="";
      String sellerName=rs.getString("S_Name"); if(sellerName==null)sellerName="Seller";
      String sellerPhone=rs.getString("S_Number"); if(sellerPhone==null)sellerPhone="";
      int sid=rs.getInt("S_ID");
    %>
    <div class="by-prop-card">
      <div class="by-prop-img">
        <img src="servlet_2.jsp?name=<%=sid%>" alt="Property" onerror="this.src='img/prop-placeholder.jpg'">
        <span class="by-prop-badge"><span class="by-badge by-badge-teal"><%=ftype%></span></span>
        <span class="by-prop-sts"><span class="by-badge by-badge-green by-badge-dot">Available</span></span>
      </div>
      <div class="by-prop-body">
        <div class="by-prop-price">₹<%=rent%><span style="font-size:.65rem;font-weight:400;color:var(--text3)">/mo</span></div>
        <div class="by-prop-advance">Advance: ₹<%=advance%> &middot; Booking fee: ₹<%=fess%></div>
        <div class="by-prop-title"><%=ftype%> in <%=city%></div>
        <div class="by-prop-loc"><i class="fa fa-map-marker"></i> <%=area.isEmpty()?city:area+", "+city%><%=street.isEmpty()?"":" · "+street%></div>
        <div class="by-prop-meta">
          <div class="by-prop-meta-item"><i class="fa fa-user"></i> <%=sellerName%></div>
          <div class="by-prop-meta-item"><i class="fa fa-phone"></i> <%=sellerPhone.isEmpty()?"—":sellerPhone%></div>
        </div>
      </div>
      <div class="by-prop-actions">
        <a href="buyer_payment.jsp?type=flat&ref=<%=hno%>&seller=<%=sellerAadhar%>"
           class="by-btn by-btn-primary by-btn-sm" style="flex:1;justify-content:center">
          <i class="fa fa-credit-card"></i> Book &amp; Pay
        </a>
        <a href="buyer_chat.jsp?seller=<%=sellerAadhar%>"
           class="by-btn by-btn-ghost-teal by-btn-sm" title="Chat with seller">
          <i class="fa fa-comments"></i>
        </a>
      </div>
    </div>
    <%}
    if(!found){%>
    <div style="grid-column:1/-1">
      <div class="by-empty">
        <i class="fa fa-building"></i>
        <h3>No flats available</h3>
        <p><%=filterCity.isEmpty()&&filterType.isEmpty()?"All flats have been booked or none are listed yet.":"No results match your filters."%></p>
        <%if(!filterCity.isEmpty()||!filterType.isEmpty()){%><a href="browse_flat.jsp" class="by-btn by-btn-outline" style="margin-top:.8rem"><i class="fa fa-times"></i> Clear Filters</a><%}%>
      </div>
    </div>
    <%}%>
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
