<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String A_Name = (String) session.getAttribute("A_Name");
String sellerUser = (String) session.getAttribute("User");
Integer U_Id = (Integer) session.getAttribute("U_Id");
if (A_Name == null) { response.sendRedirect("index.jsp"); return; }

/* ── Seller profile ── */
DB db = new DB();
ResultSet sellerRs = db.Select("SELECT * FROM sellerregister WHERE A_Name='" + A_Name + "'");
String sellerName = "Seller"; char avatarChar = 'S';
if (sellerRs.next()) {
  sellerName = sellerRs.getString("username");
  avatarChar = sellerName.length() > 0 ? sellerName.charAt(0) : 'S';
}

/* ── Seller account: current balance ── */
double sellerBalance = 0;
String sellerAccNo = "—";
try {
  DB dbAcc = new DB();
  ResultSet rsAcc = dbAcc.Select("SELECT Card_Number, Amount FROM seller_account WHERE seller_aadhar='" + A_Name + "' AND status='Active' LIMIT 1");
  if (rsAcc.next()) {
    sellerBalance = rsAcc.getDouble("Amount");
    String cn = rsAcc.getString("Card_Number");
    if (cn != null && cn.length() >= 4) sellerAccNo = "••••" + cn.substring(cn.length()-4);
  }
} catch (Exception ex) {}

/* ── Transaction history from seller_account_log (if exists) or derive from bookingss + booking ──
   Since we don't have a dedicated txn table, we pull from bookingss + booking as payment records.
   Each booking row = one or more payments made by buyer to this seller.
   We show: Property, Buyer, Payment Type, Amount, Date(key1 or id as reference)
   The B_fess column holds booking fee, advance from booking, rent from booking.
   C_Type holds what was paid (Booking/Advance/Rent/Multiple).
*/

/* Flat bookings (bookingss) for this seller */
java.util.List<String[]> txns = new java.util.ArrayList<>();
try {
  DB dbT1 = new DB();
  ResultSet rsT1 = dbT1.Select(
    "SELECT S_NAME, H_NO, U_NAME, U_MAIL, B_fess, C_Type, A_ACC, U_ACC, key1, id " +
    "FROM bookingss WHERE SA_NAME='" + A_Name + "' ORDER BY id DESC");
  while (rsT1.next()) {
    txns.add(new String[]{
      "Flat",
      rsT1.getString("H_NO")    != null ? rsT1.getString("H_NO")    : "—",
      rsT1.getString("S_NAME")  != null ? rsT1.getString("S_NAME")  : "—",
      rsT1.getString("U_NAME")  != null ? rsT1.getString("U_NAME")  : "—",
      rsT1.getString("U_MAIL")  != null ? rsT1.getString("U_MAIL")  : "—",
      rsT1.getString("B_fess")  != null ? rsT1.getString("B_fess")  : "0",
      rsT1.getString("C_Type")  != null ? rsT1.getString("C_Type")  : "—",
      rsT1.getString("key1")    != null ? rsT1.getString("key1")    : "—",
      rsT1.getString("id")      != null ? rsT1.getString("id")      : "—"
    });
  }
} catch (Exception ex) {}

/* Land bookings (booking) for this seller */
try {
  DB dbT2 = new DB();
  ResultSet rsT2 = dbT2.Select(
    "SELECT S_NAME, D_NO, U_NAME, U_MAIL, B_fess, C_Type, A_ACC, U_ACC, key1, id " +
    "FROM booking WHERE SA_Name='" + A_Name + "' ORDER BY id DESC");
  while (rsT2.next()) {
    txns.add(new String[]{
      "Land",
      rsT2.getString("D_NO")    != null ? rsT2.getString("D_NO")    : "—",
      rsT2.getString("S_NAME")  != null ? rsT2.getString("S_NAME")  : "—",
      rsT2.getString("U_NAME")  != null ? rsT2.getString("U_NAME")  : "—",
      rsT2.getString("U_MAIL")  != null ? rsT2.getString("U_MAIL")  : "—",
      rsT2.getString("B_fess")  != null ? rsT2.getString("B_fess")  : "0",
      rsT2.getString("C_Type")  != null ? rsT2.getString("C_Type")  : "—",
      rsT2.getString("key1")    != null ? rsT2.getString("key1")    : "—",
      rsT2.getString("id")      != null ? rsT2.getString("id")      : "—"
    });
  }
} catch (Exception ex) {}

/* ── Summary totals ── */
double totalReceived = 0;
int totalTxns = txns.size();
for (String[] t : txns) {
  try { totalReceived += Double.parseDouble(t[5]); } catch(Exception ex){}
}

/* ── Unread chat count for nav badge ── */
int chatUnread = 0;
try {
  DB dbCU = new DB();
  ResultSet rsCU = dbCU.Select("SELECT COUNT(*) c FROM chat_messages WHERE receiver_aadhar='" + A_Name + "' AND is_read=0");
  if (rsCU.next()) chatUnread = rsCU.getInt("c");
} catch(Exception ex){}

String flashMsg = (String)session.getAttribute("msg"); session.removeAttribute("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Transactions — Innovative Residence</title>
  <link href="img/favicon.png" rel="icon">
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Fraunces:ital,wght@0,500;0,700;1,500;1,700&display=swap" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="css/seller-theme.css" rel="stylesheet">
  <style>
    .txn-summary { display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:1rem; margin-bottom:1.2rem; }
    .txn-sum-card { background:#fff; border:1px solid var(--border,#e5e7eb); border-radius:var(--r-md,10px); padding:1.1rem 1.3rem; display:flex; align-items:center; gap:.9rem; }
    .txn-sum-icon { width:44px; height:44px; border-radius:10px; display:flex; align-items:center; justify-content:center; font-size:1.1rem; flex-shrink:0; }
    .txn-sum-n { font-size:1.35rem; font-weight:800; color:var(--text,#0f172a); font-family:'Fraunces',serif; line-height:1; }
    .txn-sum-l { font-size:.72rem; color:var(--text3,#94a3b8); margin-top:.18rem; }

    .txn-filters { display:flex; gap:.5rem; flex-wrap:wrap; margin-bottom:1rem; }
    .txn-filter-btn { padding:.32rem .85rem; border-radius:20px; border:1px solid var(--border,#e5e7eb); background:#fff; font-size:.77rem; font-weight:600; color:var(--text2,#475569); cursor:pointer; transition:all .15s; }
    .txn-filter-btn:hover, .txn-filter-btn.active { background:var(--primary,#059669); color:#fff; border-color:var(--primary,#059669); }

    .txn-table th { font-size:.73rem; font-weight:700; color:var(--text3); text-transform:uppercase; letter-spacing:.04em; padding:.65rem .9rem; background:var(--bg,#F8FAFC); border-bottom:2px solid var(--border,#e5e7eb); white-space:nowrap; }
    .txn-table td { font-size:.81rem; padding:.7rem .9rem; border-bottom:1px solid var(--border,#e5e7eb); color:var(--text,#0f172a); vertical-align:middle; }
    .txn-table tr:last-child td { border-bottom:none; }
    .txn-table tr:hover td { background:#f0fdf4; }
    .txn-prop-badge { display:inline-flex; align-items:center; gap:.28rem; padding:.2rem .55rem; border-radius:6px; font-size:.72rem; font-weight:700; }
    .txn-flat { background:#dbeafe; color:#1d4ed8; }
    .txn-land { background:#dcfce7; color:#166534; }
    .txn-type-pill { display:inline-block; padding:.18rem .5rem; border-radius:12px; font-size:.70rem; font-weight:700; background:#f1f5f9; color:#475569; }
    .txn-amount { font-size:.88rem; font-weight:700; color:#059669; }
    .txn-ref { font-size:.70rem; color:#94a3b8; font-family:monospace; }

    .txn-search { position:relative; width:220px; }
    .txn-search input { width:100%; padding:.38rem .75rem .38rem 2rem; border-radius:20px; border:1px solid var(--border,#e5e7eb); font-size:.78rem; color:var(--text,#0f172a); outline:none; background:#fff; }
    .txn-search input:focus { border-color:var(--primary,#059669); }
    .txn-search i { position:absolute; left:.68rem; top:50%; transform:translateY(-50%); color:#94a3b8; font-size:.75rem; }
  </style>
</head>
<body>
<%if(flashMsg!=null&&!flashMsg.isEmpty()){%><script>window.addEventListener('DOMContentLoaded',()=>showToast('<%=flashMsg%>','info'));</script><%}%>

<button class="sd-hamburger" id="hamburger" onclick="toggleSidebar()"><i class="fa fa-bars"></i></button>

<!-- SIDEBAR — exact same structure as sellerhome.jsp -->
<aside class="sd-sidebar" id="sidebar">
  <div class="sd-logo">
    <div class="sd-logo-text">INNOVATIVE<em> RESIDENCE</em></div>
    <div class="sd-logo-sub">Seller Portal</div>
  </div>
  <div class="sd-user-chip">
    <div class="sd-avatar"><%=avatarChar%></div>
    <div>
      <div class="sd-user-name"><%=sellerName%></div>
      <div class="sd-user-role">Verified Seller</div>
    </div>
  </div>
  <nav class="sd-nav">
    <div class="sd-nav-section">
      <div class="sd-nav-label">Main</div>
      <a href="sellerhome.jsp"><i class="fa fa-home"></i> Dashboard</a>
      <a href="House.jsp"><i class="fa fa-building"></i> Upload Flat/House</a>
      <a href="sellerhome2.jsp"><i class="fa fa-map-o"></i> Upload Land</a>
    </div>
    <div class="sd-nav-section">
      <div class="sd-nav-label">My Listings</div>
      <a href="seller_flatapprove.jsp"><i class="fa fa-check-circle"></i> Approved Flats</a>
      <a href="seller_landapprove.jsp"><i class="fa fa-check-circle-o"></i> Approved Lands</a>
      <a href="view4.jsp"><i class="fa fa-calendar-check-o"></i> Booked Flats</a>
      <a href="view3.jsp"><i class="fa fa-calendar"></i> Booked Lands</a>
    </div>
    <div class="sd-nav-section">
      <div class="sd-nav-label">Chat Session</div>
      <a href="seller_chat.jsp"><i class="fa fa-comments"></i> Chat with Buyers <%if(chatUnread>0){%><span class="sd-nav-badge"><%=chatUnread%></span><%}%></a>
    </div>
    <div class="sd-nav-section">
      <div class="sd-nav-label">Account Session</div>
      <a href="seller_add_acc.jsp"><i class="fa fa-home"></i> Add Acc</a>
      <a href="view_seller_acc.jsp"><i class="fa fa-map-o"></i> View Acc</a>
      <a href="seller_transactions.jsp" class="active"><i class="fa fa-list-alt"></i> Transactions</a>
    </div>
    
  </nav>
  <div class="sd-sidebar-footer">
    <a href="index.jsp" class="sd-logout"><i class="fa fa-sign-out"></i> Sign Out</a>
  </div>
</aside>

<!-- TOP BAR -->
<header class="sd-topbar">
  <div class="sd-page-title">
    Transactions
    <span>All payments received from buyers</span>
  </div>
  <div class="sd-topbar-actions">
    <a href="view_seller_acc.jsp" class="sd-btn sd-btn-outline sd-btn-sm"><i class="fa fa-university"></i> My Accounts</a>
    <a href="index.jsp" class="sd-btn sd-btn-outline sd-btn-sm"><i class="fa fa-sign-out"></i> Logout</a>
  </div>
</header>

<main class="sd-main">
<div class="sd-page">

  <!-- Summary cards -->
  <div class="txn-summary sd-fade">
    <div class="txn-sum-card">
      <div class="txn-sum-icon" style="background:#dcfce7;color:#059669"><i class="fa fa-inr"></i></div>
      <div>
        <div class="txn-sum-n">₹<%=String.format("%,.0f",totalReceived)%></div>
        <div class="txn-sum-l">Total Received</div>
      </div>
    </div>
    <div class="txn-sum-card">
      <div class="txn-sum-icon" style="background:#dbeafe;color:#1d4ed8"><i class="fa fa-exchange"></i></div>
      <div>
        <div class="txn-sum-n"><%=totalTxns%></div>
        <div class="txn-sum-l">Total Transactions</div>
      </div>
    </div>
    <div class="txn-sum-card">
      <div class="txn-sum-icon" style="background:#fef9c3;color:#b45309"><i class="fa fa-university"></i></div>
      <div>
        <div class="txn-sum-n" style="font-size:1rem"><%=sellerAccNo%></div>
        <div class="txn-sum-l">Active Account · ₹<%=String.format("%,.0f",sellerBalance)%></div>
      </div>
    </div>
  </div>

  <!-- Filter + Search bar -->
  <div class="sd-card sd-fade">
    <div class="sd-card-head" style="flex-wrap:wrap;gap:.6rem">
      <div>
        <div class="sd-card-title"><i class="fa fa-list-alt"></i> Payment History</div>
        <div class="sd-card-sub">All bookings where buyers paid you</div>
      </div>
      <div style="display:flex;align-items:center;gap:.5rem;flex-wrap:wrap">
        <div class="txn-filters">
          <button class="txn-filter-btn active" onclick="filterType('all',this)">All</button>
          <button class="txn-filter-btn" onclick="filterType('flat',this)">Flats</button>
          <button class="txn-filter-btn" onclick="filterType('land',this)">Lands</button>
        </div>
        <div class="txn-search">
          <i class="fa fa-search"></i>
          <input type="text" id="txnSearch" placeholder="Search buyer, property…" oninput="searchTxn(this.value)">
        </div>
      </div>
    </div>

    <div class="sd-table-wrap">
      <table class="sd-table txn-table" id="txnTable">
        <thead>
          <tr>
            <th>#</th>
            <th>Type</th>
            <th>Property Ref</th>
            <th>Property Name</th>
            <th>Buyer</th>
            <th>Payment Type</th>
            <th>Amount</th>
            <th>Ref / TXN</th>
          </tr>
        </thead>
        <tbody id="txnBody">
          <%
          if (txns.isEmpty()) {%>
          <tr><td colspan="8">
            <div class="sd-empty" style="padding:2.5rem;text-align:center">
              <i class="fa fa-exchange" style="font-size:1.8rem;color:#e2e8f0;display:block;margin-bottom:.7rem"></i>
              <b style="color:#475569;font-size:.9rem">No transactions yet</b>
              <div style="font-size:.77rem;color:#94a3b8;margin-top:.3rem">Payments made by buyers will appear here once they book your properties.</div>
            </div>
          </td></tr>
          <%} else {
            int rowNum = 0;
            for (String[] t : txns) {
              rowNum++;
              String propType = t[0]; // Flat / Land
              String propRef  = t[1]; // H_NO / D_NO
              String propName = t[2]; // S_NAME
              String buyerAadhar = t[3];
              String buyerEmail  = t[4];
              String amount      = t[5];
              String cType       = t[6]; // Booking/Advance/Rent/Multiple
              String key1        = t[7];
              String id          = t[8];
              String typeClass   = "Flat".equals(propType) ? "txn-flat" : "txn-land";
              String typeIcon    = "Flat".equals(propType) ? "fa-building" : "fa-leaf";
              double amtVal = 0;
              try { amtVal = Double.parseDouble(amount); } catch(Exception ex){}
          %>
          <tr data-type="<%=propType.toLowerCase()%>" data-search="<%=(propName+buyerAadhar+buyerEmail+propRef+cType).toLowerCase()%>">
            <td style="color:#94a3b8;font-size:.72rem"><%=rowNum%></td>
            <td><span class="txn-prop-badge <%=typeClass%>"><i class="fa <%=typeIcon%>"></i> <%=propType%></span></td>
            <td style="font-size:.78rem;font-weight:600;color:#0f172a"><%=propRef%></td>
            <td>
              <div style="font-size:.82rem;font-weight:600;color:#0f172a"><%=propName%></div>
            </td>
            <td>
              <div style="font-size:.81rem;font-weight:600;color:#0f172a"><%=buyerAadhar%></div>
              <div style="font-size:.69rem;color:#94a3b8;margin-top:.05rem"><%=buyerEmail%></div>
            </td>
            <td><span class="txn-type-pill"><%=cType%></span></td>
            <td class="txn-amount">₹<%=String.format("%,.0f",amtVal)%></td>
            <td>
              <div class="txn-ref"><%=key1.equals("—")?id:key1%></div>
            </td>
          </tr>
          <%}}%>
        </tbody>
      </table>
    </div>
  </div>

</div>
</main>

<div id="toastBox" style="position:fixed;bottom:1.5rem;right:1.5rem;z-index:9999;display:flex;flex-direction:column;gap:.5rem;pointer-events:none"></div>
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>
function toggleSidebar() { document.getElementById('sidebar').classList.toggle('open'); }

const obs = new IntersectionObserver(e=>e.forEach(en=>{ if(en.isIntersecting) en.target.classList.add('vis'); }),{threshold:0.08});
document.querySelectorAll('.sd-fade').forEach(el=>obs.observe(el));

let currentFilter = 'all';
function filterType(type, btn) {
  currentFilter = type;
  document.querySelectorAll('.txn-filter-btn').forEach(b=>b.classList.remove('active'));
  btn.classList.add('active');
  applyFilters();
}
function searchTxn(q) { applyFilters(q); }
function applyFilters(q) {
  q = (q || document.getElementById('txnSearch').value).toLowerCase();
  document.querySelectorAll('#txnBody tr[data-type]').forEach(tr => {
    const typeMatch = currentFilter==='all' || tr.dataset.type===currentFilter;
    const searchMatch = !q || tr.dataset.search.includes(q);
    tr.style.display = (typeMatch && searchMatch) ? '' : 'none';
  });
}

function showToast(msg, type) {
  const colors = {info:'#0891B2',success:'#059669',warn:'#D97706',error:'#E11D48'};
  const t = document.createElement('div');
  t.style.cssText = 'background:#fff;border:1px solid #e5e7eb;border-left:3px solid '+(colors[type]||colors.info)+';border-radius:8px;padding:.75rem 1rem;font-size:.82rem;color:#374151;box-shadow:0 4px 12px rgba(0,0,0,.1);min-width:220px;pointer-events:auto';
  t.textContent = msg; document.getElementById('toastBox').appendChild(t); setTimeout(()=>t.remove(),4000);
}
</script>
</body>
</html>
