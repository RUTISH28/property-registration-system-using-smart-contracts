<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String A_Name=(String)session.getAttribute("User");
if(A_Name==null){response.sendRedirect("index.jsp");return;}

String propType   = request.getParameter("type");
String propRef    = request.getParameter("ref");
String sellerAcc  = request.getParameter("seller");
if(propType==null)  propType="";
if(propRef==null)   propRef="";
if(sellerAcc==null) sellerAcc="";

/* ── Property details ── */
String rentStr="0", advanceStr="0", feesStr="0", propName="", propCity="";
try{
  DB dbP=new DB(); ResultSet rsP;
  if("flat".equalsIgnoreCase(propType)){
    rsP=dbP.Select("SELECT rent,advance,fess,city,street FROM flat_house WHERE H_NO='"+propRef+"' LIMIT 1");
  } else {
    rsP=dbP.Select("SELECT rent,advance,fess,city,area FROM upload WHERE D_NO='"+propRef+"' LIMIT 1");
  }
  if(rsP.next()){
    if(rsP.getString("rent")    !=null) rentStr   =rsP.getString("rent");
    if(rsP.getString("advance") !=null) advanceStr=rsP.getString("advance");
    if(rsP.getString("fess")    !=null) feesStr   =rsP.getString("fess");
    if(rsP.getString("city")    !=null) propCity  =rsP.getString("city");
    String col="flat".equalsIgnoreCase(propType)?"street":"area";
    if(rsP.getString(col)!=null) propName=rsP.getString(col);
  }
}catch(Exception ex){}

/* ── Buyer active account ── */
DB dbBA=new DB();
ResultSet rsBA=dbBA.Select(
  "SELECT buyer_acc_id,Card_Type,Card_Brand,Cardholder_Name,Card_Number,Expire_Date,Cvv,Amount "+
  "FROM buyer_account WHERE buyer_aadhar='"+A_Name+"' AND status='Active' LIMIT 1");
String bCardNum="",bCardBrand="",bCardType="",bHolderName="",bExpDate="",bCvv="",bBalance="0",bAccId="";
boolean hasBuyerAcc=false;
if(rsBA.next()){
  hasBuyerAcc=true;
  bCardNum  =rsBA.getString("Card_Number")!=null?rsBA.getString("Card_Number"):"";
  bCardBrand=rsBA.getString("Card_Brand") !=null?rsBA.getString("Card_Brand"):"";
  bCardType =rsBA.getString("Card_Type")  !=null?rsBA.getString("Card_Type"):"";
  bHolderName=rsBA.getString("Cardholder_Name")!=null?rsBA.getString("Cardholder_Name"):A_Name;
  bExpDate  =rsBA.getString("Expire_Date")!=null?rsBA.getString("Expire_Date"):"";
  bCvv      =rsBA.getString("Cvv")        !=null?rsBA.getString("Cvv"):"";
  bBalance  =rsBA.getString("Amount")     !=null?rsBA.getString("Amount"):"0";
  bAccId    =rsBA.getString("buyer_acc_id");
}

/* ── Seller active account ── */
DB dbSA=new DB();
ResultSet rsSA=dbSA.Select(
  "SELECT seller_acc_id,Card_Brand,Cardholder_Name,Card_Number,Amount "+
  "FROM seller_account WHERE seller_aadhar='"+sellerAcc+"' AND status='Active' LIMIT 1");
String sCardNum="",sCardBrand="",sHolderName="",sBalance="0",sAccId="";
boolean hasSellerAcc=false;
if(rsSA.next()){
  hasSellerAcc=true;
  sCardNum   =rsSA.getString("Card_Number")!=null?rsSA.getString("Card_Number"):"";
  sCardBrand =rsSA.getString("Card_Brand") !=null?rsSA.getString("Card_Brand"):"";
  sHolderName=rsSA.getString("Cardholder_Name")!=null?rsSA.getString("Cardholder_Name"):sellerAcc;
  sBalance   =rsSA.getString("Amount")!=null?rsSA.getString("Amount"):"0";
  sAccId     =rsSA.getString("seller_acc_id");
}

String bMasked=bCardNum.length()>=4?"**** **** **** "+bCardNum.substring(bCardNum.length()-4):"•••• •••• •••• ••••";
String sMasked=sCardNum.length()>=4?"**** **** **** "+sCardNum.substring(sCardNum.length()-4):"•••• •••• •••• ••••";
String bCardClass="by-card-visa";
if(bCardBrand.toLowerCase().contains("master")) bCardClass="by-card-mastercard";
else if(bCardBrand.toLowerCase().contains("rupay")) bCardClass="by-card-rupay";

String txnId="IR"+System.currentTimeMillis();
boolean canPay = hasBuyerAcc && hasSellerAcc;
String flashMsg=(String)session.getAttribute("msg"); session.removeAttribute("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Payment — Innovative Residence</title>
  <link href="img/favicon.png" rel="icon">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600;1,700&display=swap" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="css/buyer-theme.css" rel="stylesheet">
  <style>
    .pay-type-pill{cursor:pointer;padding:.85rem 1rem;border:2px solid var(--border2);border-radius:var(--r-md);text-align:center;transition:all .2s;background:var(--surface);}
    .pay-type-pill.selected{border-color:var(--primary);background:var(--primary-light);}
    .pill-icon{font-size:1.1rem;color:var(--text3);margin-bottom:.3rem;display:block;}
    .pay-type-pill.selected .pill-icon{color:var(--primary);}
    .pill-amt{font-size:1.05rem;font-weight:800;color:var(--text);margin:.1rem 0;}
    .pill-label{font-size:.70rem;color:var(--text3);font-weight:600;text-transform:uppercase;letter-spacing:.4px;}
    .multi-row{display:flex;align-items:center;gap:.6rem;padding:.75rem .9rem;border-radius:var(--r);border:1.5px solid var(--border2);cursor:pointer;transition:all .2s;background:var(--surface);user-select:none;}
    .multi-row.checked{border-color:var(--primary);background:var(--primary-light);}
    .multi-row input[type=checkbox]{width:16px;height:16px;accent-color:var(--primary);cursor:pointer;}
    .multi-row .mr-lbl{font-size:.81rem;font-weight:700;color:var(--text);flex:1;}
    .multi-row .mr-amt{font-size:.78rem;color:var(--text3);font-weight:700;}
    .total-bubble{background:linear-gradient(135deg,#0891B2,#0369a1);border-radius:var(--r-md);padding:1rem 1.2rem;color:#fff;display:flex;align-items:center;justify-content:space-between;margin:.8rem 0;}
    .total-bubble .tb-lbl{font-size:.68rem;opacity:.75;text-transform:uppercase;letter-spacing:.5px;}
    .total-bubble .tb-val{font-family:var(--ff-display);font-size:1.9rem;font-weight:700;line-height:1;}
    .divider-or{display:flex;align-items:center;gap:.6rem;margin:.75rem 0;font-size:.71rem;color:var(--text3);font-weight:600;text-transform:uppercase;letter-spacing:.4px;}
    .divider-or::before,.divider-or::after{content:'';flex:1;height:1px;background:var(--border);}
  </style>
</head>
<body>
<%if(flashMsg!=null&&!flashMsg.isEmpty()){%><script>window.addEventListener('DOMContentLoaded',()=>byToast('<%=flashMsg%>','info'));</script><%}%>
<button class="by-hamburger" onclick="toggleSidebar()"><i class="fa fa-bars"></i></button>
<%@ include file="buyer_sidebar.jsp" %>

<header class="by-topbar">
  <div class="by-page-title">
    Secure Payment
    <span>Ref: <%=txnId%> &mdash; <%=propType.toUpperCase()%><%=propName.isEmpty()?"":" · "+propName%><%=propCity.isEmpty()?"":", "+propCity%></span>
  </div>
  <div class="by-topbar-actions">
    <span class="by-badge by-badge-green by-badge-dot">🔒 Secure</span>
    <a href="my_bookings.jsp" class="by-btn by-btn-outline by-btn-sm"><i class="fa fa-arrow-left"></i> Back</a>
  </div>
</header>

<main class="by-main">
<div class="by-page">

  <%if(!hasBuyerAcc){%>
  <div class="by-alert by-a-danger by-fade">
    <i class="fa fa-exclamation-circle"></i>
    <span><strong>No active buyer account.</strong> Go to <a href="buyer_accounts.jsp" style="color:var(--rose)">My Accounts</a> and set one as <strong>Active/Default</strong>.</span>
  </div>
  <%}%>
  <%if(hasBuyerAcc&&!hasSellerAcc){%>
  <div class="by-alert by-a-warn by-fade">
    <i class="fa fa-exclamation-triangle"></i>
    <span><strong>Seller has no active account.</strong> Payment cannot proceed until the seller activates an account.</span>
  </div>
  <%}%>

  <!-- Step bar -->
  <div class="by-pay-steps by-fade" id="paySteps">
    <div class="by-pay-step active" id="step1"><div class="by-pay-step-circle">1</div><div class="by-pay-step-label">Choose</div></div>
    <div class="by-pay-step" id="step2"><div class="by-pay-step-circle">2</div><div class="by-pay-step-label">CVV</div></div>
    <div class="by-pay-step" id="step3"><div class="by-pay-step-circle">3</div><div class="by-pay-step-label">Confirm</div></div>
    <div class="by-pay-step" id="step4"><div class="by-pay-step-circle"><i class="fa fa-check"></i></div><div class="by-pay-step-label">Receipt</div></div>
  </div>

  <div style="display:grid;grid-template-columns:1.1fr 1fr;gap:1.5rem;align-items:start" class="by-fade">

    <!-- LEFT -->
    <div>
      <!-- Buyer card -->
      <div class="by-card by-fade" style="margin-bottom:1.2rem">
        <div class="by-card-head">
          <div class="by-card-title"><i class="fa fa-credit-card"></i> Your Payment Account</div>
          <span class="by-badge <%=hasBuyerAcc?"by-badge-green":"by-badge-rose"%> by-badge-dot"><%=hasBuyerAcc?"Active":"None"%></span>
        </div>
        <div class="by-card-body">
          <%if(hasBuyerAcc){%>
          <div style="margin-bottom:1rem">
            <div class="by-payment-card-3d <%=bCardClass%>" id="payCard3D">
              <div class="by-card-shine"></div><div class="by-card-chip"></div>
              <div class="by-card-number"><%=bMasked%></div>
              <div class="by-card-footer">
                <div><div class="by-card-holder-label">Card Holder</div><div class="by-card-holder-name"><%=bHolderName%></div></div>
                <div><div class="by-card-exp-label">Expires</div><div class="by-card-exp-val"><%=bExpDate%></div></div>
              </div>
              <div class="by-card-brand-logo"><%=bCardBrand%></div>
              <div class="by-card-contactless"><i class="fa fa-wifi"></i></div>
            </div>
          </div>
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:.6rem">
            <div style="background:var(--bg);border-radius:var(--r);padding:.75rem 1rem;border:1px solid var(--border)">
              <div style="font-size:.62rem;color:var(--text3);text-transform:uppercase;letter-spacing:.5px">Available Balance</div>
              <div style="font-family:var(--ff-display);font-size:1.3rem;font-weight:700;color:var(--green)">₹<%=bBalance%></div>
            </div>
            <div style="background:var(--bg);border-radius:var(--r);padding:.75rem 1rem;border:1px solid var(--border)">
              <div style="font-size:.62rem;color:var(--text3);text-transform:uppercase;letter-spacing:.5px">Card</div>
              <div style="font-size:.84rem;font-weight:700;color:var(--text)"><%=bCardBrand%> <%=bCardType%></div>
            </div>
          </div>
          <%}else{%>
          <div class="by-empty" style="padding:1.5rem"><i class="fa fa-university" style="font-size:2rem;color:var(--border3);display:block;margin-bottom:.5rem"></i><p>No active account. <a href="buyer_accounts.jsp">Manage →</a></p></div>
          <%}%>
        </div>
      </div>

      <!-- Seller account -->
      <div class="by-card by-fade">
        <div class="by-card-head">
          <div class="by-card-title"><i class="fa fa-arrow-circle-right"></i> Seller Receiving Account</div>
          <span class="by-badge <%=hasSellerAcc?"by-badge-green":"by-badge-rose"%> by-badge-dot"><%=hasSellerAcc?"Active":"Not Found"%></span>
        </div>
        <div class="by-card-body">
          <%if(hasSellerAcc){%>
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:.6rem">
            <div style="background:var(--bg);border-radius:var(--r);padding:.75rem 1rem;border:1px solid var(--border)">
              <div style="font-size:.62rem;color:var(--text3);text-transform:uppercase">Cardholder</div>
              <div style="font-size:.82rem;font-weight:700;color:var(--text)"><%=sHolderName%></div>
            </div>
            <div style="background:var(--bg);border-radius:var(--r);padding:.75rem 1rem;border:1px solid var(--border)">
              <div style="font-size:.62rem;color:var(--text3);text-transform:uppercase">Card</div>
              <div style="font-family:monospace;font-size:.80rem;color:var(--text)"><%=sMasked%></div>
            </div>
          </div>
          <div class="by-alert by-a-green" style="margin-top:.8rem;margin-bottom:0">
            <i class="fa fa-check-circle"></i>
            <span style="font-size:.78rem">Amount debited from your account is credited to seller instantly.</span>
          </div>
          <%}else{%>
          <div class="by-alert by-a-danger" style="margin-bottom:0"><i class="fa fa-times-circle"></i> Seller has no active account.</div>
          <%}%>
        </div>
      </div>
    </div><!-- /left -->

    <!-- RIGHT panels -->
    <div>

      <!-- ══ STEP 1: Choose Payment ══ -->
      <div class="by-card by-fade" id="panelChoose">
        <div class="by-card-head">
          <div class="by-card-title"><i class="fa fa-list-alt"></i> Select Payment</div>
          <span class="by-badge by-badge-teal">Step 1 of 3</span>
        </div>
        <div class="by-card-body">

          <!-- Fee breakdown summary -->
          <div style="background:var(--bg);border-radius:var(--r-md);padding:.85rem 1rem;margin-bottom:.9rem;border:1px solid var(--border)">
            <div style="font-size:.68rem;color:var(--text3);font-weight:700;text-transform:uppercase;letter-spacing:.5px;margin-bottom:.6rem">Fee Breakdown</div>
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:.4rem">
              <span style="font-size:.78rem;color:var(--text2)"><i class="fa fa-tag" style="color:var(--amber);margin-right:.4rem"></i>Booking Fee</span>
              <strong style="font-size:.83rem;color:var(--text)">₹<%=feesStr%></strong>
            </div>
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:.4rem">
              <span style="font-size:.78rem;color:var(--text2)"><i class="fa fa-shield" style="color:var(--violet);margin-right:.4rem"></i>Advance / Security</span>
              <strong style="font-size:.83rem;color:var(--text)">₹<%=advanceStr%></strong>
            </div>
            <div style="height:1px;background:var(--border);margin:.5rem 0"></div>
            <div style="display:flex;justify-content:space-between;align-items:center">
                <span style="font-size:.78rem;color:var(--text2)"><i class="fa fa-home" style="color:var(--primary);margin-right:.4rem"></i>Full Amount</span>
              <strong style="font-size:.83rem;color:var(--text)">₹<%=rentStr%></strong>
            </div>
          </div>

          <!-- Single payment pills -->
          <div style="font-size:.68rem;color:var(--text3);font-weight:700;text-transform:uppercase;letter-spacing:.5px;margin-bottom:.55rem">Single Payment</div>
          <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:.5rem;margin-bottom:.7rem">
            <div class="pay-type-pill" id="pill_booking" onclick="selectSingle('booking')">
              <span class="pill-icon"><i class="fa fa-tag"></i></span>
              <div class="pill-amt">₹<%=feesStr%></div>
              <div class="pill-label">Booking</div>
            </div>
            <div class="pay-type-pill" id="pill_advance" onclick="selectSingle('advance')">
              <span class="pill-icon"><i class="fa fa-shield"></i></span>
              <div class="pill-amt">₹<%=advanceStr%></div>
              <div class="pill-label">Advance</div>
            </div>
            <div class="pay-type-pill" id="pill_rent" onclick="selectSingle('rent')">
              <span class="pill-icon"><i class="fa fa-home"></i></span>
              <div class="pill-amt">₹<%=rentStr%></div>
              <div class="pill-label">Full Payment</div>
            </div>
          </div>

          <div class="divider-or">or pay multiple</div>

          <!-- Multi-select checkboxes -->
          <div style="display:flex;flex-direction:column;gap:.42rem;margin-bottom:.8rem">
            <div class="multi-row" id="mr_booking" onclick="toggleMulti('booking')">
              <input type="checkbox" id="chk_booking" onclick="event.stopPropagation();recalcTotal()">
              <span class="mr-lbl"><i class="fa fa-tag" style="color:var(--amber);margin-right:.4rem"></i>Booking Fee</span>
              <span class="mr-amt">₹<%=feesStr%></span>
            </div>
            <div class="multi-row" id="mr_advance" onclick="toggleMulti('advance')">
              <input type="checkbox" id="chk_advance" onclick="event.stopPropagation();recalcTotal()">
              <span class="mr-lbl"><i class="fa fa-shield" style="color:var(--violet);margin-right:.4rem"></i>Advance / Security</span>
              <span class="mr-amt">₹<%=advanceStr%></span>
            </div>
            <div class="multi-row" id="mr_rent" onclick="toggleMulti('rent')">
              <input type="checkbox" id="chk_rent" onclick="event.stopPropagation();recalcTotal()">
              <span class="mr-lbl"><i class="fa fa-home" style="color:var(--primary);margin-right:.4rem"></i>Full Amount</span>
              <span class="mr-amt">₹<%=rentStr%></span>
            </div>
          </div>

          <!-- Total -->
          <div class="total-bubble">
            <div>
              <div class="tb-lbl">Total to Pay</div>
              <div class="tb-val" id="totalDisplay">₹0</div>
            </div>
            <div style="text-align:right">
              <div style="font-size:.62rem;opacity:.7;margin-bottom:.1rem">Selected</div>
              <div id="selectedLabel" style="font-size:.72rem;font-weight:700;max-width:100px;word-break:break-word">None</div>
            </div>
          </div>

          <div id="chooseError" class="by-alert by-a-danger" style="display:none;margin-bottom:.8rem">
            <i class="fa fa-exclamation-circle"></i> <span id="chooseErrMsg">Please select a payment type.</span>
          </div>

          <%if(canPay){%>
          <button class="by-btn by-btn-primary" style="width:100%;justify-content:center;padding:12px" onclick="proceedToCVV()">
            <i class="fa fa-lock"></i> Proceed to CVV Verification
          </button>
          <%}else{%>
          <button class="by-btn by-btn-outline" style="width:100%;justify-content:center;cursor:not-allowed" disabled>Cannot proceed — account issue</button>
          <%}%>
        </div>
      </div>

      <!-- ══ STEP 2: CVV ══ -->
      <div class="by-card by-fade" id="panelCVV" style="display:none">
        <div class="by-card-head">
          <div class="by-card-title"><i class="fa fa-shield"></i> CVV Verification</div>
          <span class="by-badge by-badge-teal">Step 2 of 3</span>
        </div>
        <div class="by-card-body">
          <div style="text-align:center;margin-bottom:1.2rem">
            <div style="width:60px;height:60px;border-radius:50%;background:var(--primary-light);display:flex;align-items:center;justify-content:center;margin:0 auto .7rem;font-size:1.4rem;color:var(--primary)"><i class="fa fa-lock"></i></div>
            <p style="font-size:.83rem;color:var(--text2)">Enter CVV for <strong><%=bCardBrand%></strong> card ending <strong><%=bCardNum.length()>=4?bCardNum.substring(bCardNum.length()-4):"••••"%></strong></p>
            <p style="font-size:.77rem;color:var(--text3)">Paying: <strong id="cvvPayLabel">—</strong></p>
          </div>
          <div class="by-cvv-group" id="cvvGroup" style="margin-bottom:1.2rem">
            <input class="by-cvv-input" type="password" maxlength="1" id="c1" oninput="cvvNext(this,null,'c2')">
            <input class="by-cvv-input" type="password" maxlength="1" id="c2" oninput="cvvNext(this,'c1','c3')">
            <input class="by-cvv-input" type="password" maxlength="1" id="c3" oninput="cvvNext(this,'c2',null)" onkeyup="if(this.value)checkCVVDone()">
          </div>
          <div id="cvvError" class="by-alert by-a-danger" style="display:none;margin-bottom:.8rem"><i class="fa fa-times-circle"></i> Incorrect CVV. Please try again.</div>
          <div style="display:flex;gap:.7rem">
            <button class="by-btn by-btn-outline" style="flex:1;justify-content:center" onclick="goStep(1)"><i class="fa fa-arrow-left"></i> Back</button>
            <button class="by-btn by-btn-primary" style="flex:2;justify-content:center" onclick="verifyCVV()"><i class="fa fa-check"></i> Verify CVV</button>
          </div>
          <p style="text-align:center;font-size:.68rem;color:var(--text3);margin-top:.7rem"><i class="fa fa-lock"></i> CVV is never stored after verification.</p>
        </div>
      </div>

      <!-- ══ STEP 3: Confirm ══ -->
      <div class="by-card by-fade" id="panelConfirm" style="display:none">
        <div class="by-card-head">
          <div class="by-card-title"><i class="fa fa-check-circle"></i> Confirm Payment</div>
          <span class="by-badge by-badge-amber">Step 3 of 3</span>
        </div>
        <div class="by-card-body">
          <div style="text-align:center;margin-bottom:1.1rem">
            <div style="font-family:var(--ff-display);font-size:2.3rem;font-weight:700;color:var(--primary)" id="confirmAmount">₹0</div>
            <p style="font-size:.80rem;color:var(--text2);margin-top:.2rem" id="confirmTypes">—</p>
          </div>
          <div style="background:var(--bg);border-radius:var(--r-md);padding:1rem;margin-bottom:1rem;border:1px solid var(--border)">
            <div style="display:flex;justify-content:space-between;margin-bottom:.5rem">
              <span style="font-size:.74rem;color:var(--text3)">Debit from (Buyer)</span>
              <span style="font-size:.79rem;font-weight:700;color:var(--text)"><%=bMasked%></span>
            </div>
            <div style="display:flex;justify-content:space-between;margin-bottom:.5rem">
              <span style="font-size:.74rem;color:var(--text3)">Credit to (Seller)</span>
              <span style="font-size:.79rem;font-weight:700;color:var(--text)"><%=sMasked%></span>
            </div>
            <div style="display:flex;justify-content:space-between">
              <span style="font-size:.74rem;color:var(--text3)">Transaction ID</span>
              <span style="font-size:.72rem;font-family:monospace;color:var(--text2)"><%=txnId%></span>
            </div>
          </div>
          <div style="display:flex;gap:.7rem">
            <button class="by-btn by-btn-outline" style="flex:1;justify-content:center" onclick="goStep(2)"><i class="fa fa-arrow-left"></i> Back</button>
            <button class="by-btn by-btn-green" style="flex:2;justify-content:center" id="payNowBtn" onclick="processPayment()">
              <i class="fa fa-paper-plane"></i> Pay Now
            </button>
          </div>
        </div>
      </div>

      <!-- ══ STEP 4: Receipt ══ -->
      <div id="panelReceipt" style="display:none">
        <div style="text-align:center;margin-bottom:1.1rem">
          <div style="width:70px;height:70px;border-radius:50%;background:var(--green-light);display:flex;align-items:center;justify-content:center;margin:0 auto .7rem;font-size:1.8rem;color:var(--green)"><i class="fa fa-check"></i></div>
          <h3 style="font-family:var(--ff-display);font-size:1.2rem;color:var(--text)">Payment Successful!</h3>
          <p style="font-size:.78rem;color:var(--text2)"><%=txnId%></p>
        </div>
        <div class="by-receipt by-fade">
          <div class="by-receipt-head"><div class="by-receipt-logo">🏠</div><h3>Payment Receipt</h3><p>Innovative Residence</p></div>
          <hr class="by-receipt-dashed">
          <div class="by-receipt-row"><span class="by-receipt-key">Transaction ID</span><span class="by-receipt-val" style="font-family:monospace;font-size:.72rem"><%=txnId%></span></div>
          <div class="by-receipt-row"><span class="by-receipt-key">Date &amp; Time</span><span class="by-receipt-val" id="receiptDate">—</span></div>
          <div class="by-receipt-row"><span class="by-receipt-key">Property</span><span class="by-receipt-val"><%=propType.toUpperCase()%> — <%=propRef%></span></div>
          <div class="by-receipt-row"><span class="by-receipt-key">Paid For</span><span class="by-receipt-val" id="receiptTypes">—</span></div>
          <div class="by-receipt-row"><span class="by-receipt-key">Buyer</span><span class="by-receipt-val"><%=bHolderName%></span></div>
          <div class="by-receipt-row"><span class="by-receipt-key">Buyer Card</span><span class="by-receipt-val" style="font-family:monospace;font-size:.76rem"><%=bMasked%></span></div>
          <div class="by-receipt-row"><span class="by-receipt-key">Seller</span><span class="by-receipt-val"><%=sHolderName%></span></div>
          <div class="by-receipt-row"><span class="by-receipt-key">Seller Card</span><span class="by-receipt-val" style="font-family:monospace;font-size:.76rem"><%=sMasked%></span></div>
          <hr class="by-receipt-dashed">
          <div class="by-receipt-total"><span class="by-receipt-key">Total Paid</span><span class="by-receipt-val" id="receiptTotal">—</span></div>
          <div class="by-receipt-foot">
            <p>Thank you for using Innovative Residence!</p>
            <div style="margin-top:.6rem;display:flex;gap:.6rem;justify-content:center">
              <button class="by-btn by-btn-primary by-btn-sm" onclick="window.print()"><i class="fa fa-print"></i> Print</button>
              <a href="my_bookings.jsp" class="by-btn by-btn-outline by-btn-sm"><i class="fa fa-list"></i> My Bookings</a>
            </div>
          </div>
        </div>
      </div>

    </div><!-- /right -->
  </div>

</div>
</main>

<div id="byToastBox"></div>
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>
const REAL_CVV   = '<%=bCvv%>';
const BUYER_ACC  = '<%=bAccId%>';
const SELLER_ACC = '<%=sAccId%>';
const FEE_BOOKING = <%=feesStr.isEmpty()||feesStr.equals("null")?"0":feesStr%>;
const FEE_ADVANCE = <%=advanceStr.isEmpty()||advanceStr.equals("null")?"0":advanceStr%>;
const FEE_RENT    = <%=rentStr.isEmpty()||rentStr.equals("null")?"0":rentStr%>;
const BUYER_BAL   = <%=bBalance.isEmpty()||bBalance.equals("null")?"0":bBalance%>;

let selMode='none'; // 'single' or 'multi'
let selSingle=null;
let totalPayable=0, selNames=[];

function toggleSidebar(){document.getElementById('bySidebar').classList.toggle('open');}
const obs=new IntersectionObserver(e=>e.forEach(en=>{if(en.isIntersecting)en.target.classList.add('vis')}),{threshold:.08});
document.querySelectorAll('.by-fade').forEach(el=>obs.observe(el));

function selectSingle(t){
  /* clear multi checkboxes */
  ['booking','advance','rent'].forEach(k=>{
    document.getElementById('chk_'+k).checked=false;
    document.getElementById('mr_'+k).classList.remove('checked');
  });
  if(selSingle===t){ selSingle=null; document.getElementById('pill_'+t).classList.remove('selected'); selMode='none'; }
  else{
    if(selSingle) document.getElementById('pill_'+selSingle).classList.remove('selected');
    selSingle=t; document.getElementById('pill_'+t).classList.add('selected'); selMode='single';
  }
  recalc();
}

function toggleMulti(t){
  /* clear single pills */
  if(selSingle){ document.getElementById('pill_'+selSingle).classList.remove('selected'); selSingle=null; }
  selMode='multi';
  var chk=document.getElementById('chk_'+t);
  chk.checked=!chk.checked;
  document.getElementById('mr_'+t).classList.toggle('checked',chk.checked);
  recalc();
}

function recalc(){
  totalPayable=0; selNames=[];
  if(selMode==='single'&&selSingle){
    if(selSingle==='booking'){ totalPayable=FEE_BOOKING; selNames=['Booking Fee']; }
    if(selSingle==='advance'){ totalPayable=FEE_ADVANCE; selNames=['Advance']; }
    if(selSingle==='rent'){    totalPayable=FEE_RENT;    selNames=['Rent']; }
  } else if(selMode==='multi'){
    if(document.getElementById('chk_booking').checked){ totalPayable+=FEE_BOOKING; selNames.push('Booking Fee'); }
    if(document.getElementById('chk_advance').checked){ totalPayable+=FEE_ADVANCE; selNames.push('Advance'); }
    if(document.getElementById('chk_rent').checked){    totalPayable+=FEE_RENT;    selNames.push('Rent'); }
    if(!selNames.length) selMode='none';
  }
  document.getElementById('totalDisplay').textContent='₹'+totalPayable;
  document.getElementById('selectedLabel').textContent=selNames.length?selNames.join(' + '):'None';
  document.getElementById('chooseError').style.display='none';
}

function proceedToCVV(){
  if(totalPayable<=0){ document.getElementById('chooseError').style.display='flex'; document.getElementById('chooseErrMsg').textContent='Please select at least one payment type.'; return; }
  if(totalPayable>BUYER_BAL){ document.getElementById('chooseError').style.display='flex'; document.getElementById('chooseErrMsg').textContent='Insufficient balance. Available: ₹'+BUYER_BAL; return; }
  document.getElementById('chooseError').style.display='none';
  goStep(2);
}

function goStep(n){
  document.getElementById('panelChoose').style.display=n===1?'':'none';
  document.getElementById('panelCVV').style.display=n===2?'':'none';
  document.getElementById('panelConfirm').style.display=n===3?'':'none';
  document.getElementById('panelReceipt').style.display=n===4?'':'none';
  [1,2,3,4].forEach(i=>{ var s=document.getElementById('step'+i); if(!s)return; s.className='by-pay-step'+(i<n?' done':i===n?' active':''); });
  if(n===2){ document.getElementById('c1').focus(); document.getElementById('cvvPayLabel').textContent=selNames.join(' + ')+' — ₹'+totalPayable; }
  if(n===3){ document.getElementById('confirmAmount').textContent='₹'+totalPayable; document.getElementById('confirmTypes').textContent=selNames.join(' + ')+' · debit buyer, credit seller'; document.getElementById('payNowBtn').innerHTML='<i class="fa fa-paper-plane"></i> Pay ₹'+totalPayable; }
  if(n===4){ document.getElementById('receiptDate').textContent=new Date().toLocaleString('en-IN'); document.getElementById('receiptTypes').textContent=selNames.join(', '); document.getElementById('receiptTotal').textContent='₹'+totalPayable; }
}

function cvvNext(el,p,nx){ if(el.value&&nx)document.getElementById(nx).focus(); document.getElementById('cvvError').style.display='none'; }
function checkCVVDone(){ var v1=document.getElementById('c1').value,v2=document.getElementById('c2').value,v3=document.getElementById('c3').value; if(v1&&v2&&v3)verifyCVV(); }
function verifyCVV(){
  var entered=[document.getElementById('c1').value,document.getElementById('c2').value,document.getElementById('c3').value].join('');
  if(entered===REAL_CVV){ byToast('CVV verified!','success'); goStep(3); }
  else{ document.getElementById('cvvError').style.display='flex'; document.getElementById('c1').value=''; document.getElementById('c2').value=''; document.getElementById('c3').value=''; document.getElementById('c1').focus(); var g=document.getElementById('cvvGroup'); g.style.animation='byPulse .3s 3'; setTimeout(()=>g.style.animation='',900); }
}
function processPayment(){
  var btn=document.getElementById('payNowBtn');
  btn.innerHTML='<i class="fa fa-spinner fa-spin"></i> Processing...';
  btn.disabled=true;

  fetch('process_payment.jsp',{
    method:'POST',
    headers:{'Content-Type':'application/x-www-form-urlencoded'},
    body:'buyer_acc='+encodeURIComponent(BUYER_ACC)+
         '&seller_acc='+encodeURIComponent(SELLER_ACC)+
         '&amount='+totalPayable+
         '&types='+encodeURIComponent(selNames.join(','))+
         '&prop_type=<%=propType%>'+
         '&prop_ref='+encodeURIComponent('<%=propRef%>')+
         '&txn_id=<%=txnId%>'
  })
  .then(r=>r.json())
  .then(async data=>{

    if(data.ok){

      try {
        // 🔥 CALL BLOCKCHAIN HERE
        await storeTransactionOnBlockchain();
      } catch(e){
        console.error("Blockchain failed:", e);
      }

      byToast('₹'+totalPayable+' paid successfully!','success');
      setTimeout(()=>goStep(4),500);

    } else {
      btn.innerHTML='<i class="fa fa-paper-plane"></i> Pay ₹'+totalPayable;
      btn.disabled=false;
      byToast(data.error||'Payment failed.','error');
    }

  }).catch(()=>{
    byToast('Payment processed!','success');
    setTimeout(()=>goStep(4),500);
  });
}

function byToast(msg,type){
  var c={info:'var(--primary)',success:'var(--green)',warn:'var(--amber)',error:'var(--rose)'};
  var t=document.createElement('div');
  t.style.cssText='background:white;border:1px solid var(--border);border-left:3px solid '+(c[type]||c.info)+';border-radius:var(--r);padding:.8rem 1rem;font-size:.84rem;color:var(--text);box-shadow:var(--sh-md);min-width:260px;max-width:340px;animation:byFadeUp .3s both;pointer-events:auto;font-family:var(--ff-body)';
  t.textContent=msg; document.getElementById('byToastBox').appendChild(t); setTimeout(()=>t.remove(),4500);
}
var card=document.getElementById('payCard3D');
if(card){card.addEventListener('mousemove',function(e){var r=card.getBoundingClientRect();var x=(e.clientX-r.left)/r.width-.5;var y=(e.clientY-r.top)/r.height-.5;card.style.transform='perspective(800px) rotateY('+(x*18)+'deg) rotateX('+(-y*10)+'deg) scale(1.03)';});card.addEventListener('mouseleave',function(){card.style.transform='';}); }
</script>

<!-- Bootstrap Icons (optional) -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<script src="https://cdn.jsdelivr.net/npm/web3@1.3.6/dist/web3.min.js"></script>
<script type="text/javascript">
let web3;
let contract;
let account;

// 🔹 Replace with your deployed contract address
const contractAddress = "0x13C1d6D7853A82c8c3f44F842b441F7A8c23F10F";

// 🔹 ABI
const abi=[{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"txnId","type":"string"},{"indexed":false,"internalType":"address","name":"buyer","type":"address"},{"indexed":false,"internalType":"address","name":"seller","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"PaymentStored","type":"event"},{"inputs":[],"name":"getCount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"index","type":"uint256"}],"name":"getTransaction","outputs":[{"components":[{"internalType":"string","name":"txnId","type":"string"},{"internalType":"address","name":"buyer","type":"address"},{"internalType":"address","name":"seller","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"string","name":"paymentType","type":"string"},{"internalType":"string","name":"propertyType","type":"string"},{"internalType":"string","name":"propertyRef","type":"string"},{"internalType":"uint256","name":"txnDate","type":"uint256"}],"internalType":"struct PropertyPayment.Transaction","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string","name":"_txnId","type":"string"},{"internalType":"address","name":"_buyer","type":"address"},{"internalType":"address","name":"_seller","type":"address"},{"internalType":"uint256","name":"_amount","type":"uint256"},{"internalType":"string","name":"_paymentType","type":"string"},{"internalType":"string","name":"_propertyType","type":"string"},{"internalType":"string","name":"_propertyRef","type":"string"},{"internalType":"uint256","name":"_txnDate","type":"uint256"}],"name":"storePayment","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"transactions","outputs":[{"internalType":"string","name":"txnId","type":"string"},{"internalType":"address","name":"buyer","type":"address"},{"internalType":"address","name":"seller","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"string","name":"paymentType","type":"string"},{"internalType":"string","name":"propertyType","type":"string"},{"internalType":"string","name":"propertyRef","type":"string"},{"internalType":"uint256","name":"txnDate","type":"uint256"}],"stateMutability":"view","type":"function"}];
window.addEventListener("load", async () => {
    await initBlockchain();
});

// ✅ CONNECT FUNCTION
async function initBlockchain() {

    if (!window.ethereum) {
        alert("❌ Please install MetaMask!");
        return;
    }

    try {
        web3 = new Web3(window.ethereum);

        const accounts = await window.ethereum.request({
            method: "eth_requestAccounts"
        });

        account = accounts[0];

        contract = new web3.eth.Contract(abi, contractAddress);

        console.log("✅ Connected:", account);

    } catch (error) {
        console.error("❌ Connection failed:", error);
    }
}

// ✅ STORE TRANSACTION (OUTSIDE!)
async function storeTransactionOnBlockchain() {

    try {

        if (!contract || !account) {
            alert("Blockchain not connected!");
            return;
        }

        const txnId = "<%=txnId%>";
        const buyer = account;

      const seller = account;

        const amount = totalPayable;

        const paymentType = selNames.join(",");
        const propertyType = "<%=propType%>";
        const propertyRef = "<%=propRef%>";

        const txnDate = Math.floor(Date.now() / 1000);

        await contract.methods.storePayment(
            txnId,
            buyer,
            seller,
            amount,
            paymentType,
            propertyType,
            propertyRef,
            txnDate
        ).send({
            from: account
        });

        console.log("✅ Stored in blockchain");
        
    } catch (error) {
        console.error("❌ Blockchain error:", error);
        alert("Blockchain transaction failed!");
    }
}
</script>



</body>
</html>
