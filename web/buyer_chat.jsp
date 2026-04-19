<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String A_Name=(String)session.getAttribute("User");
if(A_Name==null){response.sendRedirect("index.jsp");return;}

/* Active seller from URL param */
String activeSeller=request.getParameter("seller");
if(activeSeller==null) activeSeller="";

/* ── chat_messages table schema:
   id, sender_aadhar, receiver_aadhar, message, sent_at(TIMESTAMP), is_read(0/1), room_id ── */

/* Load seller list who have active listings or bookings with this buyer */
DB dbSellers=new DB();
ResultSet rsSellers=dbSellers.Select(
  "SELECT DISTINCT s.A_Name, s.username, s.city "+
  "FROM sellerregister s WHERE s.sts='Approved' "+
  "AND (EXISTS(SELECT 1 FROM flat_house f WHERE f.A_Name=s.A_Name AND f.sts='Approved') "+
  "  OR EXISTS(SELECT 1 FROM upload u WHERE u.A_Name=s.A_Name AND u.sts='Approved')) "+
  "ORDER BY s.username");

/* Load messages for active conversation */
java.util.List<String[]> messages = new java.util.ArrayList<>();
if(!activeSeller.isEmpty()){
  DB dbMsg=new DB();
  ResultSet rsMsg=dbMsg.Select(
    "SELECT sender_aadhar,message,sent_at,is_read "+
    "FROM chat_messages "+
    "WHERE (sender_aadhar='"+A_Name+"' AND receiver_aadhar='"+activeSeller+"') "+
    "   OR (sender_aadhar='"+activeSeller+"' AND receiver_aadhar='"+A_Name+"') "+
    "ORDER BY sent_at ASC LIMIT 100");
  while(rsMsg.next()){
    messages.add(new String[]{
      rsMsg.getString("sender_aadhar"),
      rsMsg.getString("message"),
      rsMsg.getString("sent_at"),
      rsMsg.getString("is_read")
    });
  }
  /* mark as read */
  try{
    DB dbRead=new DB();
    dbRead.Update("UPDATE chat_messages SET is_read=1 WHERE receiver_aadhar='"+A_Name+"' AND sender_aadhar='"+activeSeller+"' AND is_read=0");
  }catch(Exception ex){}
}

/* Unread per seller */
java.util.Map<String,Integer> unreadMap = new java.util.HashMap<>();
try{
  DB dbUR=new DB();
  ResultSet rsUR=dbUR.Select("SELECT sender_aadhar,COUNT(*) c FROM chat_messages WHERE receiver_aadhar='"+A_Name+"' AND is_read=0 GROUP BY sender_aadhar");
  while(rsUR.next()) unreadMap.put(rsUR.getString("sender_aadhar"),rsUR.getInt("c"));
}catch(Exception ex){}

String flashMsg=(String)session.getAttribute("msg"); session.removeAttribute("msg");

/* format date helper — group by day */
String lastDate="";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Chat with Sellers — Innovative Residence</title>
  <link href="img/favicon.png" rel="icon">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600;1,700&display=swap" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="css/buyer-theme.css" rel="stylesheet">
  <style>
  /* Chat page uses full height without main padding */
  body{overflow:hidden;}
  .by-topbar{position:fixed;}
  </style>
</head>
<body>
<button class="by-hamburger" onclick="toggleSidebar()"><i class="fa fa-bars"></i></button>
<%@ include file="buyer_sidebar.jsp" %>

<header class="by-topbar">
  <div class="by-page-title">
    Messages
    <span>Real-time chat with property sellers</span>
  </div>
  <div class="by-topbar-actions">
    <span id="connStatus" class="by-badge by-badge-green by-badge-dot">Connected</span>
    <a href="buyerhome.jsp" class="by-btn by-btn-outline by-btn-sm"><i class="fa fa-home"></i> Home</a>
  </div>
</header>

<!-- Full-height chat layout -->
<div class="by-chat-wrap">

  <!-- Contact list -->
  <div class="by-chat-list" id="chatList">
    <div class="by-chat-list-head">
      <h3>Sellers</h3>
      <div class="by-chat-search">
        <i class="fa fa-search"></i>
        <input type="text" id="contactSearch" placeholder="Search sellers..." oninput="filterContacts(this.value)">
      </div>
    </div>
    <div class="by-chat-contacts" id="contactList">
    <%
      boolean hasSellers=false;
      while(rsSellers.next()){
        hasSellers=true;
        String sAadhar=rsSellers.getString("A_Name");
        String sUsername=rsSellers.getString("username");
        String sCity=rsSellers.getString("city"); if(sCity==null)sCity="";
        if(sUsername==null) sUsername=sAadhar;
        boolean isActive=sAadhar.equals(activeSeller);
        int unread=unreadMap.getOrDefault(sAadhar,0);
        char si = sUsername.length()>0 ? Character.toUpperCase(sUsername.charAt(0)) : 'S';
    %>
    <div class="by-chat-contact <%=isActive?"active":""%> contact-item"
         onclick="openChat('<%=sAadhar%>','<%=sUsername%>')"
         data-name="<%=sUsername.toLowerCase()%>">
      <div class="by-chat-c-avatar" style="background:hsl(<%=Math.abs(sAadhar.hashCode())%360%>,55%,45%)"><%=si%></div>
      <div style="flex:1;min-width:0">
        <div class="by-chat-c-name"><%=sUsername%></div>
        <div class="by-chat-c-last"><%=sCity.isEmpty()?"Seller":"📍 "+sCity%></div>
      </div>
      <%if(unread>0){%>
      <div class="by-chat-c-unread"><%=unread%></div>
      <%}else{%>
      <span class="by-chat-c-time" style="font-size:.62rem;color:var(--green)">●</span>
      <%}%>
    </div>
    <%}
    if(!hasSellers){%>
    <div style="text-align:center;padding:3rem 1rem;color:var(--text3)">
      <i class="fa fa-users" style="font-size:2.5rem;margin-bottom:.8rem;display:block;color:var(--border3)"></i>
      <p style="font-size:.82rem">No sellers with approved listings</p>
    </div>
    <%}%>
    </div>
  </div>

  <!-- Chat window -->
  <div class="by-chat-window" id="chatWindow">
    <%if(!activeSeller.isEmpty()){%>
    <!-- Header -->
    <div class="by-chat-win-head">
      <div class="by-chat-win-avatar" style="background:hsl(<%=Math.abs(activeSeller.hashCode())%360%>,55%,45%)">
        <%=activeSeller.length()>0?Character.toUpperCase(activeSeller.charAt(0)):'S'%>
      </div>
      <div>
        <div class="by-chat-win-name" id="chatSellerName"><%=activeSeller%></div>
        <div class="by-chat-win-status"><span class="by-online-dot"></span> Online</div>
      </div>
      <div class="by-chat-win-actions">
        <a href="browse_flat.jsp" class="by-btn by-btn-ghost-teal by-btn-sm"><i class="fa fa-building"></i> View Listings</a>
      </div>
    </div>

    <!-- Messages area -->
    <div class="by-chat-messages" id="msgArea">
      <%
      String lastDay="";
      for(String[] msg : messages){
        String sender=msg[0]; String text=msg[1]; String ts=msg[2];
        boolean isOut=sender.equals(A_Name);
        /* day separator */
        String dayStr="";
        if(ts!=null && ts.length()>=10){
          String msgDay=ts.substring(0,10);
          if(!msgDay.equals(lastDay)){
            lastDay=msgDay;
            dayStr=msgDay;
          }
        }
        String timeStr = ts!=null&&ts.length()>=16 ? ts.substring(11,16) : "";
      %>
      <%if(!dayStr.isEmpty()){%>
      <div class="by-msg-date-sep"><span><%=dayStr%></span></div>
      <%}%>
      <div class="by-msg <%=isOut?"by-msg-out":"by-msg-in"%>">
        <%=text!=null?text.replace("<","&lt;").replace(">","&gt;"):""%>
        <div class="by-msg-time"><%=timeStr%><%if(isOut){%><i class="fa fa-check-circle by-msg-tick"></i><%}%></div>
      </div>
      <%}%>

      <%if(messages.isEmpty()){%>
      <div style="flex:1;display:flex;align-items:center;justify-content:center;flex-direction:column;color:var(--text3)">
        <i class="fa fa-comments" style="font-size:3rem;margin-bottom:1rem;color:var(--border3)"></i>
        <p style="font-size:.85rem;font-weight:600">Say hello to the seller!</p>
        <p style="font-size:.75rem;margin-top:.3rem">Start the conversation about properties</p>
      </div>
      <%}%>

      <!-- Typing indicator (hidden by default) -->
      <div id="typingInd" style="display:none">
        <div class="by-msg by-msg-in" style="padding:.5rem .9rem">
          <div class="by-typing">
            <span></span><span></span><span></span>
          </div>
        </div>
      </div>
    </div>

    <!-- Input bar -->
    <div class="by-chat-input-bar">
      <button class="by-chat-emoji-btn" onclick="toggleEmojiPanel()"><i class="fa fa-smile-o"></i></button>
      <button class="by-chat-attach-btn"><i class="fa fa-paperclip"></i></button>
      <textarea class="by-chat-input" id="msgInput" rows="1" placeholder="Type a message..."
        onkeydown="if(event.key==='Enter'&&!event.shiftKey){event.preventDefault();sendMessage();}"
        oninput="autoResize(this)"></textarea>
      <button class="by-chat-send" onclick="sendMessage()"><i class="fa fa-paper-plane"></i></button>
    </div>

    <!-- Quick emoji panel (simple) -->
    <div id="emojiPanel" style="display:none;padding:.5rem 1rem;background:var(--bg2);border-top:1px solid var(--border);flex-wrap:wrap;gap:.3rem">
      <%String[] emojis={"😊","👍","🏠","💰","📞","✅","❌","🤝","⏰","📍","🔑","💳","❓","😄","🙏"};
      for(String em:emojis){%>
      <button onclick="appendEmoji('<%=em%>')" style="border:none;background:none;font-size:1.3rem;cursor:pointer;padding:.2rem;border-radius:4px;transition:background .15s" onmouseover="this.style.background='var(--bg3)'" onmouseout="this.style.background='none'"><%=em%></button>
      <%}%>
    </div>

    <%}else{%>
    <!-- No seller selected state -->
    <div style="flex:1;display:flex;align-items:center;justify-content:center;flex-direction:column;color:var(--text3);background:var(--bg)">
      <div style="text-align:center;max-width:320px">
        <i class="fa fa-comments" style="font-size:4rem;margin-bottom:1.2rem;display:block;background:var(--grad-primary);-webkit-background-clip:text;-webkit-text-fill-color:transparent"></i>
        <h3 style="font-family:var(--ff-display);font-size:1.2rem;color:var(--text);margin-bottom:.5rem">Chat with Sellers</h3>
        <p style="font-size:.84rem">Select a seller from the list to start a conversation about their properties.</p>
      </div>
    </div>
    <%}%>
  </div>

</div>

<div id="byToastBox"></div>
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>
const BUYER  = '<%=A_Name%>';
const SELLER = '<%=activeSeller%>';

function toggleSidebar(){document.getElementById('bySidebar').classList.toggle('open');}

/* ── Open a chat conversation ── */
function openChat(sellerAadhar,sellerName){
  window.location.href='buyer_chat.jsp?seller='+encodeURIComponent(sellerAadhar);
}

/* ── Send message via AJAX ── */
function sendMessage(){
  var input=document.getElementById('msgInput');
  if(!input||!SELLER) return;
  var text=input.value.trim();
  if(!text) return;
  input.value=''; input.style.height='auto';
  /* Append optimistically */
  appendMsg(text,true,new Date().toTimeString().slice(0,5));
  /* Ajax save */
  fetch('chat_send.jsp',{
    method:'POST',
    headers:{'Content-Type':'application/x-www-form-urlencoded'},
    body:'sender='+encodeURIComponent(BUYER)+'&receiver='+encodeURIComponent(SELLER)+'&msg='+encodeURIComponent(text)
  }).catch(()=>{});
  scrollBottom();
}

function appendMsg(text,isOut,time){
  var area=document.getElementById('msgArea');
  if(!area)return;
  var d=document.createElement('div');
  d.className='by-msg '+(isOut?'by-msg-out':'by-msg-in');
  d.innerHTML=escHtml(text)+'<div class="by-msg-time">'+time+(isOut?'<i class="fa fa-check-circle by-msg-tick"></i>':'')+'</div>';
  /* insert before typing indicator */
  var ti=document.getElementById('typingInd');
  area.insertBefore(d,ti||null);
  scrollBottom();
}

function escHtml(t){return t.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');}
function scrollBottom(){var a=document.getElementById('msgArea');if(a)a.scrollTop=a.scrollHeight;}
function autoResize(el){el.style.height='auto';el.style.height=Math.min(el.scrollHeight,120)+'px';}

function filterContacts(q){
  q=q.toLowerCase();
  document.querySelectorAll('.contact-item').forEach(el=>{
    el.style.display=el.dataset.name.includes(q)?'':'none';
  });
}

function toggleEmojiPanel(){
  var p=document.getElementById('emojiPanel');
  if(p.style.display==='none'||!p.style.display){p.style.display='flex';}else{p.style.display='none';}
}
function appendEmoji(e){
  var inp=document.getElementById('msgInput');
  if(inp){inp.value+=e;inp.focus();}
}

/* ── Poll for new messages every 4s ── */
let lastMsgCount=<%=messages.size()%>;
<%if(!activeSeller.isEmpty()){%>
setInterval(function(){
  fetch('chat_poll.jsp?buyer='+encodeURIComponent(BUYER)+'&seller='+encodeURIComponent(SELLER)+'&since='+lastMsgCount)
  .then(r=>r.json())
  .then(data=>{
    if(data.messages&&data.messages.length>0){
      data.messages.forEach(function(m){
        lastMsgCount++;
        appendMsg(m.text,m.out,m.time);
      });
    }
  }).catch(()=>{});
},4000);
<%}%>

/* scroll to bottom on load */
window.addEventListener('DOMContentLoaded',()=>{
  scrollBottom();
  /* animate contacts */
  const obs=new IntersectionObserver(e=>e.forEach(en=>{if(en.isIntersecting)en.target.classList.add('vis')}),{threshold:.08});
  document.querySelectorAll('.by-fade').forEach(el=>obs.observe(el));
});
</script>
</body>
</html>
