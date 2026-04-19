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
String sellerName = "Seller"; String sellerCity = "";
char avatarChar = 'S';
if (sellerRs.next()) {
  sellerName  = sellerRs.getString("username");
  sellerCity  = sellerRs.getString("city") != null ? sellerRs.getString("city") : "";
  avatarChar  = sellerName.length() > 0 ? sellerName.charAt(0) : 'S';
}

/* ── Active buyer from URL ── */
String activeBuyer = request.getParameter("buyer");
if (activeBuyer == null) activeBuyer = "";

/* ── Buyer contact list:
   Buyers who booked this seller's properties OR exchanged messages ── */
DB dbB = new DB();
ResultSet rsBuyers = dbB.Select(
  "SELECT DISTINCT r.A_Name, r.username, r.city " +
  "FROM register r WHERE r.sts='Approved' AND (" +
  "  EXISTS(SELECT 1 FROM bookingss b WHERE b.SA_NAME='" + A_Name + "' AND b.U_NAME=r.A_Name) " +
  "  OR EXISTS(SELECT 1 FROM booking bk WHERE bk.SA_Name='" + A_Name + "' AND bk.U_NAME=r.A_Name) " +
  "  OR EXISTS(SELECT 1 FROM chat_messages cm WHERE " +
  "    (cm.sender_aadhar=r.A_Name AND cm.receiver_aadhar='" + A_Name + "') OR " +
  "    (cm.sender_aadhar='" + A_Name + "' AND cm.receiver_aadhar=r.A_Name))) " +
  "ORDER BY r.username");

/* ── Messages for active conversation ── */
java.util.List<String[]> messages = new java.util.ArrayList<>();
String activeBuyerName = "", activeBuyerCity = "";
if (!activeBuyer.isEmpty()) {
  DB dbBN = new DB();
  ResultSet rsBN = dbBN.Select("SELECT username,city FROM register WHERE A_Name='" + activeBuyer + "' LIMIT 1");
  if (rsBN.next()) {
    activeBuyerName = rsBN.getString("username") != null ? rsBN.getString("username") : "";
    activeBuyerCity = rsBN.getString("city")     != null ? rsBN.getString("city")     : "";
  }
  DB dbMsg = new DB();
  ResultSet rsMsg = dbMsg.Select(
    "SELECT sender_aadhar, message, sent_at, is_read FROM chat_messages " +
    "WHERE (sender_aadhar='" + A_Name + "' AND receiver_aadhar='" + activeBuyer + "') " +
    "   OR (sender_aadhar='" + activeBuyer + "' AND receiver_aadhar='" + A_Name + "') " +
    "ORDER BY sent_at ASC LIMIT 100");
  while (rsMsg.next()) {
    messages.add(new String[]{
      rsMsg.getString("sender_aadhar"),
      rsMsg.getString("message"),
      rsMsg.getString("sent_at"),
      rsMsg.getString("is_read")
    });
  }
  /* Mark incoming as read */
  try {
    DB dbR = new DB();
    dbR.Select("UPDATE chat_messages SET is_read=1 WHERE receiver_aadhar='" + A_Name + "' AND sender_aadhar='" + activeBuyer + "' AND is_read=0");
  } catch (Exception ex) {}
}

/* ── Unread counts per buyer ── */
java.util.Map<String,Integer> unreadMap = new java.util.HashMap<>();
int totalUnread = 0;
try {
  DB dbUR = new DB();
  ResultSet rsUR = dbUR.Select("SELECT sender_aadhar, COUNT(*) c FROM chat_messages WHERE receiver_aadhar='" + A_Name + "' AND is_read=0 GROUP BY sender_aadhar");
  while (rsUR.next()) { int u = rsUR.getInt("c"); unreadMap.put(rsUR.getString("sender_aadhar"), u); totalUnread += u; }
} catch (Exception ex) {}
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Chat with Buyers — Innovative Residence</title>
  <link href="img/favicon.png" rel="icon">
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Fraunces:ital,wght@0,500;0,700;1,500;1,700&display=swap" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="css/seller-theme.css" rel="stylesheet">
  <style>
    body { overflow: hidden; }
    .sc-wrap { display:flex; height:calc(100vh - 64px); overflow:hidden; }

    /* ── Left contact panel ── */
    .sc-contacts { width:260px; flex-shrink:0; background:#0d1f2f; display:flex; flex-direction:column; overflow:hidden; border-right:1px solid rgba(255,255,255,.07); }
    .sc-contacts-head { padding:.9rem 1rem .7rem; border-bottom:1px solid rgba(255,255,255,.07); flex-shrink:0; }
    .sc-contacts-head h3 { font-size:.82rem; font-weight:700; color:rgba(255,255,255,.8); margin:0 0 .5rem; display:flex; align-items:center; gap:.5rem; }
    .sc-search { position:relative; }
    .sc-search input { width:100%; padding:.38rem .7rem .38rem 1.9rem; border-radius:20px; border:1px solid rgba(255,255,255,.1); background:rgba(255,255,255,.06); font-size:.77rem; color:#fff; outline:none; }
    .sc-search input::placeholder { color:rgba(255,255,255,.28); }
    .sc-search input:focus { border-color:#059669; }
    .sc-search i { position:absolute; left:.62rem; top:50%; transform:translateY(-50%); color:rgba(255,255,255,.28); font-size:.73rem; }
    .sc-list { overflow-y:auto; flex:1; }
    .sc-item { display:flex; align-items:center; gap:.62rem; padding:.65rem 1rem; cursor:pointer; transition:background .12s; border-bottom:1px solid rgba(255,255,255,.04); }
    .sc-item:hover { background:rgba(255,255,255,.06); }
    .sc-item.active { background:rgba(5,150,105,.2); border-right:3px solid #059669; }
    .sc-av { width:35px; height:35px; border-radius:50%; background:#059669; color:#fff; display:flex; align-items:center; justify-content:center; font-size:.78rem; font-weight:700; flex-shrink:0; text-transform:uppercase; }
    .sc-item-info { flex:1; min-width:0; }
    .sc-item-name { font-size:.80rem; font-weight:700; color:rgba(255,255,255,.88); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    .sc-item-sub { font-size:.67rem; color:rgba(255,255,255,.36); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; margin-top:.03rem; }
    .sc-badge-unread { background:#059669; color:#fff; border-radius:10px; font-size:.61rem; font-weight:700; padding:.08rem .38rem; min-width:17px; text-align:center; flex-shrink:0; }

    /* ── Chat window ── */
    .sc-window { flex:1; display:flex; flex-direction:column; overflow:hidden; background:#F8FAFC; }
    .sc-win-head { padding:.65rem 1.1rem; background:#fff; border-bottom:1px solid #e5e7eb; display:flex; align-items:center; gap:.8rem; flex-shrink:0; box-shadow:0 1px 4px rgba(0,0,0,.04); }
    .sc-win-av { width:37px; height:37px; border-radius:50%; background:#0284C7; color:#fff; display:flex; align-items:center; justify-content:center; font-size:.82rem; font-weight:700; flex-shrink:0; }
    .sc-win-name { font-size:.87rem; font-weight:700; color:#0f172a; }
    .sc-win-sub { font-size:.67rem; color:#94a3b8; margin-top:.04rem; }

    .sc-messages { flex:1; overflow-y:auto; padding:1rem 1.1rem; display:flex; flex-direction:column; gap:.28rem; }
    .sc-date-sep { text-align:center; font-size:.64rem; color:#94a3b8; margin:.45rem 0; display:flex; align-items:center; gap:.5rem; }
    .sc-date-sep::before, .sc-date-sep::after { content:''; flex:1; height:1px; background:#e5e7eb; }

    /* Seller = right (emerald), Buyer = left (white card) */
    .sc-msg { display:flex; align-items:flex-end; gap:.38rem; max-width:78%; }
    .sc-msg-in  { align-self:flex-start; }
    .sc-msg-out { align-self:flex-end; flex-direction:row-reverse; }
    .sc-bubble { padding:.5rem .82rem; border-radius:18px; font-size:.82rem; line-height:1.46; word-break:break-word; }
    .sc-msg-in  .sc-bubble { background:#fff; color:#0f172a; border-bottom-left-radius:4px; border:1px solid #e5e7eb; }
    .sc-msg-out .sc-bubble { background:#059669; color:#fff; border-bottom-right-radius:4px; }
    .sc-msg-time { font-size:.59rem; color:#94a3b8; flex-shrink:0; padding-bottom:.18rem; }

    .sc-typing { align-self:flex-start; background:#fff; border:1px solid #e5e7eb; border-radius:18px; padding:.42rem .82rem; display:none; }
    .sc-typing span { display:inline-block; width:6px; height:6px; border-radius:50%; background:#94a3b8; margin:0 2px; animation:scBounce 1.2s infinite; }
    .sc-typing span:nth-child(2){animation-delay:.2s} .sc-typing span:nth-child(3){animation-delay:.4s}
    @keyframes scBounce{0%,60%,100%{transform:translateY(0)}30%{transform:translateY(-5px)}}

    .sc-input-bar { padding:.6rem 1.1rem; background:#fff; border-top:1px solid #e5e7eb; display:flex; align-items:flex-end; gap:.48rem; flex-shrink:0; position:relative; }
    .sc-input-wrap { flex:1; background:#F8FAFC; border:1px solid #cbd5e1; border-radius:22px; display:flex; align-items:center; padding:.38rem .75rem; gap:.38rem; transition:border-color .2s; }
    .sc-input-wrap:focus-within { border-color:#059669; }
    .sc-input-wrap textarea { flex:1; border:none; background:transparent; resize:none; font-size:.82rem; color:#0f172a; outline:none; max-height:90px; font-family:'DM Sans',sans-serif; }
    .sc-emoji-btn { color:#94a3b8; cursor:pointer; font-size:.88rem; background:none; border:none; padding:.14rem .22rem; transition:color .15s; }
    .sc-emoji-btn:hover { color:#059669; }
    .sc-send-btn { width:37px; height:37px; border-radius:50%; background:#059669; color:#fff; border:none; cursor:pointer; display:flex; align-items:center; justify-content:center; font-size:.82rem; transition:background .15s; flex-shrink:0; }
    .sc-send-btn:hover { background:#047857; }
    .sc-send-btn:disabled { background:#94a3b8; cursor:not-allowed; }
    .sc-emoji-panel { position:absolute; bottom:62px; left:1.1rem; background:#fff; border:1px solid #e5e7eb; border-radius:10px; padding:.52rem; display:none; flex-wrap:wrap; gap:.26rem; max-width:228px; z-index:20; box-shadow:0 4px 16px rgba(0,0,0,.1); }
    .sc-emoji-panel span { cursor:pointer; font-size:1.08rem; padding:.16rem .2rem; border-radius:4px; transition:background .1s; }
    .sc-emoji-panel span:hover { background:#F8FAFC; }

    .sc-empty-win { display:flex; flex-direction:column; align-items:center; justify-content:center; height:100%; color:#94a3b8; gap:.48rem; text-align:center; padding:2rem; }
    .sc-empty-win i { font-size:2.6rem; color:#e2e8f0; }
    .sc-empty-win h3 { font-size:.88rem; font-weight:700; color:#475569; margin:0; }
    .sc-empty-win p { font-size:.76rem; max-width:200px; margin:0; }

    @media(max-width:680px){
      .sc-contacts{width:56px;}
      .sc-item-info,.sc-badge-unread,.sc-contacts-head h3,.sc-search{display:none;}
      .sc-item{justify-content:center;}
    }
  </style>
</head>
<body>

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
      <a href="seller_chat.jsp" class="active"><i class="fa fa-comments"></i> Chat with Buyers <%if(totalUnread>0){%><span class="sd-nav-badge"><%=totalUnread%></span><%}%></a>
    </div>
    <div class="sd-nav-section">
      <div class="sd-nav-label">Account Session</div>
      <a href="seller_add_acc.jsp"><i class="fa fa-home"></i> Add Acc</a>
      <a href="view_seller_acc.jsp"><i class="fa fa-map-o"></i> View Acc</a>
      <a href="seller_transactions.jsp"><i class="fa fa-list-alt"></i> Transactions</a>
    </div>
   
  </nav>
  <div class="sd-sidebar-footer">
    <a href="index.jsp" class="sd-logout"><i class="fa fa-sign-out"></i> Sign Out</a>
  </div>
</aside>

<!-- TOP BAR -->
<header class="sd-topbar">
  <div class="sd-page-title">
    Chat with Buyers
    <span>Read buyer messages and send replies<%=totalUnread>0?" — <strong>"+totalUnread+" unread</strong>":""%></span>
  </div>
  <div class="sd-topbar-actions">
    <a href="sellerhome.jsp" class="sd-btn sd-btn-outline sd-btn-sm"><i class="fa fa-home"></i> Dashboard</a>
    <a href="index.jsp" class="sd-btn sd-btn-outline sd-btn-sm"><i class="fa fa-sign-out"></i> Logout</a>
  </div>
</header>

<!-- MAIN: full-height chat layout, no padding -->
<main class="sd-main" style="padding:0;overflow:hidden">
<div class="sc-wrap">

  <!-- ── Left: Buyer list ── -->
  <div class="sc-contacts">
    <div class="sc-contacts-head">
      <h3><i class="fa fa-users" style="opacity:.65"></i> Buyers
        <%if(totalUnread>0){%><span class="sc-badge-unread"><%=totalUnread%></span><%}%>
      </h3>
      <div class="sc-search"><i class="fa fa-search"></i>
        <input type="text" id="buyerSearch" placeholder="Search…" oninput="filterContacts(this.value)">
      </div>
    </div>
    <div class="sc-list" id="contactList">
      <%
      boolean anyBuyer = false;
      java.util.List<String[]> buyerList = new java.util.ArrayList<>();
      while (rsBuyers.next()) {
        anyBuyer = true;
        String bAadhar = rsBuyers.getString("A_Name");   if(bAadhar==null) bAadhar="";
        String bUname  = rsBuyers.getString("username"); if(bUname==null)  bUname=bAadhar;
        String bCity   = rsBuyers.getString("city");     if(bCity==null)   bCity="";
        buyerList.add(new String[]{bAadhar, bUname, bCity});
      }
      for (String[] bArr : buyerList) {
        String bAadhar=bArr[0], bUname=bArr[1], bCity=bArr[2];
        int unread = unreadMap.containsKey(bAadhar) ? unreadMap.get(bAadhar) : 0;
        boolean isActive = bAadhar.equals(activeBuyer);
        char bi = bUname.length()>0 ? Character.toUpperCase(bUname.charAt(0)) : 'B';
      %>
      <div class="sc-item<%=isActive?" active":""%>" data-name="<%=bUname.toLowerCase()%>"
           onclick="location.href='seller_chat.jsp?buyer=<%=bAadhar%>'">
        <div class="sc-av" style="<%=isActive?"background:#0284C7":""%>"><%=bi%></div>
        <div class="sc-item-info">
          <div class="sc-item-name"><%=bUname%></div>
          <div class="sc-item-sub"><%=bCity.isEmpty()?"Buyer":"📍 "+bCity%></div>
        </div>
        <%if(unread>0){%><div class="sc-badge-unread"><%=unread%></div><%}%>
      </div>
      <%}
      if (!anyBuyer) {%>
      <div style="padding:2rem .8rem;text-align:center;color:rgba(255,255,255,.28)">
        <i class="fa fa-users" style="font-size:1.7rem;display:block;margin-bottom:.6rem;opacity:.35"></i>
        <div style="font-size:.73rem;line-height:1.6">No buyers yet.<br>Buyers who book your properties or message you will appear here.</div>
      </div>
      <%}%>
    </div>
  </div>

  <!-- ── Right: Chat window ── -->
  <div class="sc-window">
    <%if(activeBuyer.isEmpty()){%>
    <div class="sc-empty-win">
      <i class="fa fa-comments"></i>
      <h3>Select a Buyer</h3>
      <p>Pick a buyer from the list to read their messages and send a reply.</p>
    </div>

    <%}else{%>
    <!-- Chat header -->
    <div class="sc-win-head">
      <div class="sc-win-av"><%=activeBuyerName.length()>0 ? String.valueOf(Character.toUpperCase(activeBuyerName.charAt(0))) : "B"%></div>
      <div style="flex:1">
        <div class="sc-win-name"><%=activeBuyerName.isEmpty()?activeBuyer:activeBuyerName%></div>
        <div class="sc-win-sub">
          <span style="display:inline-block;width:7px;height:7px;border-radius:50%;background:#10b981;margin-right:.3rem;vertical-align:middle"></span>
          Buyer<%=activeBuyerCity.isEmpty()?"":" · "+activeBuyerCity%>
        </div>
      </div>
      <a href="seller_chat.jsp" class="sd-btn sd-btn-outline sd-btn-sm"><i class="fa fa-arrow-left"></i> Back</a>
    </div>

    <!-- Messages -->
    <div class="sc-messages" id="msgArea">
      <%
      String lastDay = "";
      for (String[] m : messages) {
        String mSender = m[0]; if(mSender==null) mSender="";
        String mText   = m[1]; if(mText==null)   mText="";
        String mTs     = m[2]; if(mTs==null)     mTs="";
        String mRead   = m[3]; if(mRead==null)   mRead="0";
        boolean isOut  = mSender.equals(A_Name); // seller sent → right
        String mDay = mTs.length()>=10 ? mTs.substring(0,10) : "";
        if (!mDay.isEmpty() && !mDay.equals(lastDay)) {
          lastDay = mDay;
      %><div class="sc-date-sep"><%=mDay%></div><%
        }
        String tDisp = mTs.length()>=16 ? mTs.substring(11,16) : "";
        mText = mText.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\n","<br>");
      %>
      <div class="sc-msg <%=isOut?"sc-msg-out":"sc-msg-in"%>">
        <div class="sc-bubble"><%=mText%></div>
        <span class="sc-msg-time"><%=tDisp%>
          <%if(isOut){%>&nbsp;<i class="fa fa-check<%="1".equals(mRead)?"-circle":""%>" style="font-size:.55rem;opacity:.65"></i><%}%>
        </span>
      </div>
      <%}
      if (messages.isEmpty()) {%>
      <div class="sc-empty-win">
        <i class="fa fa-comment-o"></i>
        <h3>No messages yet</h3>
        <p>Start the conversation by sending a message to <%=activeBuyerName.isEmpty()?activeBuyer:activeBuyerName%>.</p>
      </div>
      <%}%>
      <div class="sc-typing" id="typingInd"><span></span><span></span><span></span></div>
    </div>

    <!-- Emoji panel -->
    <div class="sc-emoji-panel" id="emojiPanel">
      <%String[] emjArr={"😊","😄","👍","🙏","❤️","🏠","💰","✅","🔑","📋","📞","⏰","🤝","💯","🌟","📅","⚡","🚪","😂","🏡"};
        for(String em:emjArr){%><span onclick="insertEmoji('<%=em%>')"><%=em%></span><%}%>
    </div>

    <!-- Input bar -->
    <div class="sc-input-bar">
      <button class="sc-emoji-btn" onclick="toggleEmoji()" title="Emoji"><i class="fa fa-smile-o"></i></button>
      <div class="sc-input-wrap">
        <textarea id="msgInput" rows="1" placeholder="Type your reply…"
          onkeydown="handleKey(event)" oninput="autoResize(this)"></textarea>
      </div>
      <button class="sc-send-btn" id="sendBtn" onclick="sendMsg()" title="Send">
        <i class="fa fa-paper-plane"></i>
      </button>
    </div>
    <%}%>
  </div>

</div><!-- sc-wrap -->
</main>

<div id="toastBox" style="position:fixed;bottom:1.5rem;right:1.5rem;z-index:9999;display:flex;flex-direction:column;gap:.5rem;pointer-events:none"></div>
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>
const MY_AADHAR    = '<%=A_Name%>';
const OTHER_AADHAR = '<%=activeBuyer%>';
let msgCount = <%=messages.size()%>;
let emojiOpen = false;

function toggleSidebar() { document.getElementById('sidebar').classList.toggle('open'); }

function scrollBottom() { var a = document.getElementById('msgArea'); if(a) a.scrollTop = a.scrollHeight; }
window.addEventListener('DOMContentLoaded', scrollBottom);

/* Send message */
function sendMsg() {
  var input = document.getElementById('msgInput');
  var text  = input.value.trim();
  if (!text || !OTHER_AADHAR) return;
  document.getElementById('sendBtn').disabled = true;
  appendBubble(text, true, nowTime()); // optimistic render
  input.value = ''; autoResize(input);
  fetch('chat_send.jsp', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'sender=' + encodeURIComponent(MY_AADHAR) +
          '&receiver=' + encodeURIComponent(OTHER_AADHAR) +
          '&msg=' + encodeURIComponent(text)
  }).then(r => r.json()).then(d => {
    if (!d.ok) showToast('Send failed: ' + (d.error || 'error'), 'error');
    document.getElementById('sendBtn').disabled = false;
  }).catch(() => { document.getElementById('sendBtn').disabled = false; });
}
function handleKey(e) { if (e.key==='Enter' && !e.shiftKey) { e.preventDefault(); sendMsg(); } }
function autoResize(el) { el.style.height='auto'; el.style.height=Math.min(el.scrollHeight,90)+'px'; }

function appendBubble(text, isOut, time) {
  var area  = document.getElementById('msgArea');
  var typing = document.getElementById('typingInd');
  var d = document.createElement('div');
  d.className = 'sc-msg ' + (isOut ? 'sc-msg-out' : 'sc-msg-in');
  var safe = text.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/\n/g,'<br>');
  d.innerHTML = '<div class="sc-bubble">' + safe + '</div><span class="sc-msg-time">' + time + '</span>';
  area.insertBefore(d, typing);
  scrollBottom();
}
function nowTime() { var d=new Date(); return d.getHours().toString().padStart(2,'0')+':'+d.getMinutes().toString().padStart(2,'0'); }

/* Poll for new messages every 4 seconds */
<%if(!activeBuyer.isEmpty()){%>
setInterval(function() {
  fetch('chat_poll.jsp?me=' + encodeURIComponent(MY_AADHAR) +
        '&other=' + encodeURIComponent(OTHER_AADHAR) + '&since=' + msgCount)
  .then(r => r.json()).then(data => {
    if (data.messages && data.messages.length > 0) {
      data.messages.forEach(m => appendBubble(m.text, m.out, m.time));
      msgCount = data.total || (msgCount + data.messages.length);
    }
  }).catch(() => {});
}, 4000);
<%}%>

function filterContacts(q) {
  document.querySelectorAll('.sc-item').forEach(el => {
    el.style.display = el.dataset.name.includes(q.toLowerCase()) ? '' : 'none';
  });
}
function toggleEmoji() { emojiOpen=!emojiOpen; document.getElementById('emojiPanel').style.display=emojiOpen?'flex':'none'; }
function insertEmoji(e) { var i=document.getElementById('msgInput'); i.value+=e; i.focus(); document.getElementById('emojiPanel').style.display='none'; emojiOpen=false; }
document.addEventListener('click', function(ev) {
  if (emojiOpen && !ev.target.closest('.sc-emoji-btn') && !ev.target.closest('#emojiPanel')) {
    document.getElementById('emojiPanel').style.display='none'; emojiOpen=false;
  }
});

function showToast(msg, type) {
  const colors = {info:'#0891B2',success:'#059669',warn:'#D97706',error:'#E11D48'};
  const t = document.createElement('div');
  t.style.cssText = 'background:#fff;border:1px solid #e5e7eb;border-left:3px solid '+(colors[type]||colors.info)+';border-radius:8px;padding:.75rem 1rem;font-size:.82rem;color:#374151;box-shadow:0 4px 12px rgba(0,0,0,.1);min-width:220px;pointer-events:auto';
  t.textContent = msg; document.getElementById('toastBox').appendChild(t); setTimeout(()=>t.remove(),4000);
}
</script>
</body>
</html>
