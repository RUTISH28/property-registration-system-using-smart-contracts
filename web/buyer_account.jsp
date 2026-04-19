<%@ page import="java.sql.*,Connection.DB" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String A_Name = (String) session.getAttribute("User");
Integer U_Id  = (Integer) session.getAttribute("U_Id");
if(A_Name == null){ response.sendRedirect("index.jsp"); return; }

DB db = new DB();
ResultSet rs = db.Select("SELECT * FROM register WHERE S_ID='" + U_Id + "'");
String email = "";
String buyerName = "";
if(rs.next()){
  if(rs.getString("email")    != null) email     = rs.getString("email");
  if(rs.getString("username") != null) buyerName = rs.getString("username");
}

String flashMsg = (String) session.getAttribute("msg");
session.removeAttribute("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Add Account — Buyer</title>
  <link href="img/favicon.png" rel="icon">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600;1,700&display=swap" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="css/buyer-theme.css" rel="stylesheet">
  <style>
    /* Live card preview */
    .card-preview {
      width: 100%;
      max-width: 360px;
      height: 210px;
      border-radius: 18px;
      padding: 1.5rem;
      position: relative;
      overflow: hidden;
      box-shadow: 0 20px 60px rgba(0,0,0,0.30);
      transition: transform 0.4s;
      margin: 0 auto;
      background: linear-gradient(135deg, #1a1a2e 0%, #16213e 40%, #0f3460 100%);
    }
    .card-preview:hover { transform: perspective(800px) rotateY(-6deg) rotateX(3deg) scale(1.03); }
    .card-shine {
      position:absolute;top:-50%;left:-50%;width:200%;height:200%;
      background:radial-gradient(ellipse at 60% 30%,rgba(255,255,255,0.12) 0%,transparent 60%);
      pointer-events:none;
    }
    .card-chip {
      width:40px;height:30px;background:linear-gradient(135deg,#d4af37,#f5e27d);
      border-radius:5px;margin-bottom:.8rem;position:relative;z-index:1;
    }
    .card-chip::before {
      content:'';position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);
      width:22px;height:14px;border:1.5px solid rgba(0,0,0,0.3);border-radius:3px;
    }
    .card-num-preview {
      font-size:.95rem;letter-spacing:4px;color:#fff;font-weight:700;
      margin-bottom:.6rem;position:relative;z-index:1;font-family:monospace;
      min-height:1.3em;
    }
    .card-footer-preview {
      display:flex;justify-content:space-between;align-items:flex-end;
      position:relative;z-index:1;
    }
    .card-label-sm { font-size:.52rem;color:rgba(255,255,255,.5);text-transform:uppercase;letter-spacing:1px; }
    .card-val-sm   { font-size:.78rem;color:#fff;font-weight:700;text-transform:uppercase;margin-top:1px; }
    .card-brand-preview {
      position:absolute;bottom:1rem;right:1rem;
      font-size:.9rem;font-weight:900;font-style:italic;color:rgba(255,255,255,0.6);
    }
    .card-contactless-prev {
      position:absolute;top:1rem;right:1rem;
      font-size:1rem;color:rgba(255,255,255,.5);
    }
    /* brand colors */
    .brand-mastercard { background: linear-gradient(135deg,#2d1b69 0%,#11023e 100%); }
    .brand-visa       { background: linear-gradient(135deg,#1a1a2e 0%,#0f3460 100%); }
    .brand-rupay      { background: linear-gradient(135deg,#004b87 0%,#0073bd 100%); }
    .brand-amex       { background: linear-gradient(135deg,#007B5E 0%,#00B48A 100%); }
    .brand-discover   { background: linear-gradient(135deg,#D97706 0%,#F59E0B 100%); }
    .brand-diners     { background: linear-gradient(135deg,#374151 0%,#1F2937 100%); }
    .brand-maestro    { background: linear-gradient(135deg,#DC2626 0%,#9B1C1C 100%); }
  </style>
</head>
<body>
<%if(flashMsg!=null&&!flashMsg.isEmpty()){%>
<script>window.addEventListener('DOMContentLoaded',()=>byToast('<%=flashMsg%>','info'));</script>
<%}%>
<button class="by-hamburger" onclick="toggleSidebar()"><i class="fa fa-bars"></i></button>
<%@ include file="buyer_sidebar.jsp" %>

<header class="by-topbar">
  <div class="by-page-title">
    Add Payment Account
    <span>buyer_account table &mdash; register a new card</span>
  </div>
  <div class="by-topbar-actions">
    <a href="buyer_account.jsp" class="by-btn by-btn-outline by-btn-sm"><i class="fa fa-university"></i> My Accounts</a>
    <a href="buyerhome.jsp" class="by-btn by-btn-outline by-btn-sm"><i class="fa fa-home"></i></a>
  </div>
</header>

<main class="by-main">
<div class="by-page">

  <div class="by-alert by-a-teal by-fade">
    <i class="fa fa-info-circle"></i>
    <span>
      After adding, go to <a href="buyer_account.jsp" style="color:var(--primary);font-weight:700">My Accounts</a>
      and set one account as <strong>Active / Default</strong> to enable payments and bookings.
    </span>
  </div>

  <div style="display:grid;grid-template-columns:1fr 1fr;gap:1.8rem;align-items:start" class="by-fade">

    <!-- LEFT: Live Card Preview -->
    <div>
      <div class="by-card" style="margin-bottom:1.2rem">
        <div class="by-card-head">
          <div class="by-card-title"><i class="fa fa-eye"></i> Live Card Preview</div>
          <span class="by-badge by-badge-teal">Real-time</span>
        </div>
        <div class="by-card-body" style="padding:1.5rem">
          <div class="card-preview" id="cardPreview">
            <div class="card-shine"></div>
            <div class="card-chip"></div>
            <div class="card-num-preview" id="prevNum">•••• •••• •••• ••••</div>
            <div class="card-footer-preview">
              <div>
                <div class="card-label-sm">Card Holder</div>
                <div class="card-val-sm" id="prevName">YOUR NAME</div>
              </div>
              <div>
                <div class="card-label-sm">Expires</div>
                <div class="card-val-sm" id="prevExp">MM/YY</div>
              </div>
            </div>
            <div class="card-brand-preview" id="prevBrand">CARD</div>
            <div class="card-contactless-prev"><i class="fa fa-wifi"></i></div>
          </div>

          <div style="margin-top:1.2rem;display:grid;grid-template-columns:1fr 1fr;gap:.7rem">
            <div style="background:var(--bg);border-radius:var(--r);padding:.75rem 1rem;border:1px solid var(--border);text-align:center">
              <div style="font-size:.63rem;color:var(--text3);text-transform:uppercase;letter-spacing:.5px">Card Type</div>
              <div id="prevType" style="font-size:.9rem;font-weight:700;color:var(--text);margin-top:2px">—</div>
            </div>
            <div style="background:var(--bg);border-radius:var(--r);padding:.75rem 1rem;border:1px solid var(--border);text-align:center">
              <div style="font-size:.63rem;color:var(--text3);text-transform:uppercase;letter-spacing:.5px">Card Brand</div>
              <div id="prevBrandBox" style="font-size:.9rem;font-weight:700;color:var(--text);margin-top:2px">—</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Info panel -->
      <div class="by-card">
        <div class="by-card-head">
          <div class="by-card-title"><i class="fa fa-shield"></i> Security Notice</div>
        </div>
        <div class="by-card-body">
          <div style="display:flex;flex-direction:column;gap:.7rem">
            <div style="display:flex;gap:.75rem;align-items:flex-start">
              <div style="width:30px;height:30px;border-radius:50%;background:var(--primary-light);color:var(--primary);display:flex;align-items:center;justify-content:center;font-size:.75rem;flex-shrink:0"><i class="fa fa-lock"></i></div>
              <div><div style="font-size:.80rem;font-weight:700;color:var(--text)">Encrypted Storage</div><div style="font-size:.73rem;color:var(--text3)">Your card details are stored securely on your account only.</div></div>
            </div>
            <div style="display:flex;gap:.75rem;align-items:flex-start">
              <div style="width:30px;height:30px;border-radius:50%;background:var(--violet-light);color:var(--violet);display:flex;align-items:center;justify-content:center;font-size:.75rem;flex-shrink:0"><i class="fa fa-star"></i></div>
              <div><div style="font-size:.80rem;font-weight:700;color:var(--text)">Default Account</div><div style="font-size:.73rem;color:var(--text3)">Only one account can be Active at a time. Go to My Accounts to set default.</div></div>
            </div>
            <div style="display:flex;gap:.75rem;align-items:flex-start">
              <div style="width:30px;height:30px;border-radius:50%;background:var(--green-light);color:var(--green);display:flex;align-items:center;justify-content:center;font-size:.75rem;flex-shrink:0"><i class="fa fa-check-circle"></i></div>
              <div><div style="font-size:.80rem;font-weight:700;color:var(--text)">Used for Payments</div><div style="font-size:.73rem;color:var(--text3)">Your active account is debited when you book a property.</div></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- RIGHT: Form -->
    <div class="by-card by-fade">
      <div class="by-card-head">
        <div class="by-card-title"><i class="fa fa-plus-circle"></i> Card Details</div>
        <span class="by-badge by-badge-green by-badge-dot">Secure Form</span>
      </div>
      <div class="by-card-body">

        <form action="buyer_account" method="POST" onsubmit="return validateForm()">
          <!-- Hidden fields -->
          <input type="hidden" name="buyer_id"    value="<%=U_Id%>">
          <input type="hidden" name="buyer_name"  value="<%=buyerName%>">
          <input type="hidden" name="buyer_mail"  value="<%=email%>">
          <input type="hidden" name="buyer_aadhar" value="<%=A_Name%>">

          <!-- Card Type -->
          <div class="by-form-group">
            <label class="by-label">Card Type</label>
            <div style="display:flex;gap:.6rem">
              <label style="flex:1;cursor:pointer">
                <input type="radio" name="Card_Type" value="Credit" id="typeCredit" required
                       onchange="updatePreview()" style="display:none">
                <div class="type-pill" id="pillCredit" onclick="selectType('Credit')"
                     style="padding:.7rem;border:2px solid var(--border2);border-radius:var(--r-md);text-align:center;transition:all .2s">
                  <i class="fa fa-credit-card" style="color:var(--primary);font-size:1.1rem;display:block;margin-bottom:.3rem"></i>
                  <div style="font-size:.78rem;font-weight:700">Credit</div>
                </div>
              </label>
              <label style="flex:1;cursor:pointer">
                <input type="radio" name="Card_Type" value="Debit" id="typeDebit"
                       onchange="updatePreview()" style="display:none">
                <div class="type-pill" id="pillDebit" onclick="selectType('Debit')"
                     style="padding:.7rem;border:2px solid var(--border2);border-radius:var(--r-md);text-align:center;transition:all .2s">
                  <i class="fa fa-university" style="color:var(--violet);font-size:1.1rem;display:block;margin-bottom:.3rem"></i>
                  <div style="font-size:.78rem;font-weight:700">Debit</div>
                </div>
              </label>
            </div>
          </div>

          <!-- Card Brand -->
          <div class="by-form-group">
            <label class="by-label" for="cards">Card Brand</label>
            <select name="cards" id="cards" class="by-select" onchange="updatePreview()" required>
              <option value="">— Select Card Brand —</option>
              <option value="Visa">Visa</option>
              <option value="MasterCard">MasterCard</option>
              <option value="Rupay">Rupay</option>
              <option value="American Exp">American Express</option>
              <option value="discover">Discover</option>
              <option value="diners">Diners Club</option>
              <option value="maestro">Maestro</option>
            </select>
          </div>

          <!-- Cardholder Name -->
          <div class="by-form-group">
            <label class="by-label" for="holderName">Cardholder Name</label>
            <div class="by-input-prefix">
              <i class="fa fa-user"></i>
              <input type="text" id="holderName" name="Cardholder_Name"
                     class="by-input" placeholder="As printed on card"
                     maxlength="26" required oninput="updatePreview()">
            </div>
          </div>

          <!-- Card Number -->
          <div class="by-form-group">
            <label class="by-label" for="cardNum">Card Number</label>
            <div class="by-input-prefix">
              <i class="fa fa-credit-card"></i>
              <input type="text" id="cardNum" name="Card_Number"
                     class="by-input" placeholder="•••• •••• •••• ••••"
                     maxlength="19" required
                     oninput="formatCardNum(this);updatePreview()">
            </div>
          </div>

          <!-- Expiry + CVV row -->
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:.8rem">
            <div class="by-form-group">
              <label class="by-label" for="expiry">Expiry Date</label>
              <div class="by-input-prefix">
                <i class="fa fa-calendar"></i>
                <input type="text" id="expiry" name="Expire_Date"
                       class="by-input" placeholder="MM/YY"
                       maxlength="5" required
                       oninput="formatExpiry(this);updatePreview()">
              </div>
            </div>
            <div class="by-form-group">
              <label class="by-label" for="cvv">CVV / CVC</label>
              <div class="by-input-prefix">
                <i class="fa fa-lock"></i>
                <input type="password" id="cvv" name="Cvv"
                       class="by-input" placeholder="•••"
                       maxlength="4" pattern="[0-9]{3,4}"
                       inputmode="numeric" required>
              </div>
            </div>
          </div>

          <!-- PIN -->
          <div class="by-form-group">
            <label class="by-label" for="pin">Set 4-digit PIN</label>
            <div class="by-input-prefix">
              <i class="fa fa-key"></i>
              <input type="password" id="pin" name="Pin"
                     class="by-input" placeholder="4-digit secure PIN"
                     maxlength="4" pattern="[0-9]{4}" inputmode="numeric" required>
            </div>
            <div style="font-size:.70rem;color:var(--text3);margin-top:.35rem"><i class="fa fa-info-circle"></i> You will enter this PIN when confirming transactions.</div>
          </div>

          <!-- Confirm PIN -->
          <div class="by-form-group">
            <label class="by-label" for="pinConfirm">Confirm PIN</label>
            <div class="by-input-prefix">
              <i class="fa fa-key"></i>
              <input type="password" id="pinConfirm"
                     class="by-input" placeholder="Re-enter your PIN"
                     maxlength="4" pattern="[0-9]{4}" inputmode="numeric" required>
            </div>
          </div>

          <div id="formError" style="display:none" class="by-alert by-a-danger" style="margin-bottom:1rem">
            <i class="fa fa-times-circle"></i> <span id="formErrorMsg"></span>
          </div>

          <button type="submit" class="by-btn by-btn-primary" style="width:100%;justify-content:center;padding:12px;font-size:.9rem">
            <i class="fa fa-plus-circle"></i> Add Account
          </button>

          <p style="text-align:center;font-size:.70rem;color:var(--text3);margin-top:.8rem">
            <i class="fa fa-lock"></i> Data is stored securely in your account.
            After adding, set as default in <a href="buyer_account.jsp" style="color:var(--primary)">My Accounts</a>.
          </p>
        </form>

      </div>
    </div>

  </div><!-- /grid -->
</div>
</main>

<div id="byToastBox"></div>
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>
function toggleSidebar(){document.getElementById('bySidebar').classList.toggle('open');}
const obs=new IntersectionObserver(e=>e.forEach(en=>{if(en.isIntersecting)en.target.classList.add('vis')}),{threshold:.08});
document.querySelectorAll('.by-fade').forEach(el=>obs.observe(el));

/* ── Brand → card color class ── */
const brandClasses={
  'visa':'brand-visa','mastercard':'brand-mastercard','rupay':'brand-rupay',
  'american exp':'brand-amex','discover':'brand-discover','diners':'brand-diners','maestro':'brand-maestro'
};

function updatePreview(){
  var brand  = document.getElementById('cards').value.toLowerCase();
  var name   = document.getElementById('holderName').value.trim() || 'YOUR NAME';
  var num    = document.getElementById('cardNum').value.trim() || '';
  var exp    = document.getElementById('expiry').value.trim() || 'MM/YY';
  var typeEl = document.querySelector('input[name="Card_Type"]:checked');
  var type   = typeEl ? typeEl.value : '—';

  /* masked number preview */
  var rawNum = num.replace(/\s/g,'');
  var masked = '';
  for(var i=0;i<16;i++){
    if(i>0&&i%4===0) masked+=' ';
    masked += (i<rawNum.length) ? rawNum[i] : '•';
  }

  document.getElementById('prevNum').textContent  = masked;
  document.getElementById('prevName').textContent = name.toUpperCase().substring(0,22);
  document.getElementById('prevExp').textContent  = exp;
  document.getElementById('prevBrand').textContent = brand.toUpperCase();
  document.getElementById('prevBrandBox').textContent = brand ? brand.toUpperCase() : '—';
  document.getElementById('prevType').textContent = type;

  /* brand color */
  var card = document.getElementById('cardPreview');
  Object.values(brandClasses).forEach(c=>card.classList.remove(c));
  var bClass = brandClasses[brand];
  if(bClass) card.classList.add(bClass);
  else { card.style.background=''; card.className='card-preview'; }
}

function selectType(val){
  document.getElementById('typeCredit').checked = val==='Credit';
  document.getElementById('typeDebit').checked  = val==='Debit';
  var pillC = document.getElementById('pillCredit');
  var pillD = document.getElementById('pillDebit');
  if(val==='Credit'){
    pillC.style.borderColor='var(--primary)'; pillC.style.background='var(--primary-light)';
    pillD.style.borderColor='var(--border2)'; pillD.style.background='';
  } else {
    pillD.style.borderColor='var(--violet)'; pillD.style.background='var(--violet-light)';
    pillC.style.borderColor='var(--border2)'; pillC.style.background='';
  }
  updatePreview();
}

function formatCardNum(el){
  var v = el.value.replace(/\D/g,'').substring(0,16);
  el.value = v.replace(/(.{4})/g,'$1 ').trim();
}

function formatExpiry(el){
  var v = el.value.replace(/\D/g,'');
  if(v.length>=3) el.value = v.substring(0,2)+'/'+v.substring(2,4);
  else el.value = v;
}

function validateForm(){
  var pin    = document.getElementById('pin').value;
  var pinCnf = document.getElementById('pinConfirm').value;
  var errEl  = document.getElementById('formError');
  var errMsg = document.getElementById('formErrorMsg');
  function showErr(msg){ errMsg.textContent=msg; errEl.style.display='flex'; return false; }
  if(pin!==pinCnf) return showErr('PINs do not match. Please re-enter.');
  if(!/^\d{4}$/.test(pin)) return showErr('PIN must be exactly 4 digits.');
  var cvv = document.getElementById('cvv').value;
  if(!/^\d{3,4}$/.test(cvv)) return showErr('CVV must be 3 or 4 digits.');
  var expiry = document.getElementById('expiry').value;
  if(!/^\d{2}\/\d{2}$/.test(expiry)) return showErr('Expiry must be in MM/YY format.');
  errEl.style.display='none';
  return true;
}

function byToast(msg,type){
  var c={info:'var(--primary)',success:'var(--green)',warn:'var(--amber)',error:'var(--rose)'};
  var t=document.createElement('div');
  t.style.cssText='background:white;border:1px solid var(--border);border-left:3px solid '+(c[type]||c.info)+
    ';border-radius:var(--r);padding:.8rem 1rem;font-size:.84rem;color:var(--text);box-shadow:var(--sh-md);'+
    'min-width:260px;max-width:340px;animation:byFadeUp .3s both;pointer-events:auto;font-family:var(--ff-body)';
  t.textContent=msg;
  document.getElementById('byToastBox').appendChild(t);
  setTimeout(()=>t.remove(),4500);
}

/* Tilt card on hover */
var card=document.getElementById('cardPreview');
card.addEventListener('mousemove',function(e){
  var r=card.getBoundingClientRect();
  var x=(e.clientX-r.left)/r.width-.5;
  var y=(e.clientY-r.top)/r.height-.5;
  card.style.transform='perspective(800px) rotateY('+(x*18)+'deg) rotateX('+(-y*10)+'deg) scale(1.03)';
});
card.addEventListener('mouseleave',function(){ card.style.transform=''; });
</script>
</body>
</html>
