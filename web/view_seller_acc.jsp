    <%@page import="java.sql.ResultSet"%>
    <%@page import="Connection.DB"%>
    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%
    String A_Name=(String)session.getAttribute("A_Name");
    String buyer_name=(String)session.getAttribute("username");
    if(A_Name==null){response.sendRedirect("index.jsp");return;}

      if (A_Name == null) { response.sendRedirect("index.jsp"); return; }
      DB db = new DB();
    ResultSet sellerRs = db.Select("SELECT * FROM sellerregister WHERE A_Name='" + A_Name + "'");

    String sellerName = "Seller";
    String email = "";

    if (sellerRs.next()) {
        sellerName = sellerRs.getString("username");
        email = sellerRs.getString("email");
    }

    char avatarChar = sellerName.length() > 0 ? sellerName.charAt(0) : 'S';
    /* ── handle actions ──
       buyer_account: buyer_acc_id, buyer_id, buyer_aadhar, buyer_email,
       Card_Type, Card_Brand, Cardholder_Name, Card_Number, Expire_Date, Cvv, Pin, Amount, status */
    String action=request.getParameter("act");
    String accId =request.getParameter("acc_id");
    if(action!=null && accId!=null){
      try{
        Class.forName("com.mysql.jdbc.Driver");
        java.sql.Connection con = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/construct","root","admin");
        java.sql.Statement st = con.createStatement();

        if("set_default".equals(action)){
          st.executeUpdate("UPDATE seller_account SET status='Inactive' WHERE seller_aadhar='"+A_Name+"'");
          st.executeUpdate("UPDATE seller_account SET status='Active' WHERE seller_acc_id='"+accId+"' AND seller_aadhar='"+A_Name+"'");
          session.setAttribute("msg","Account set as default successfully.");
        } 
        else if("set_inactive".equals(action)){
          st.executeUpdate("UPDATE seller_account SET status='Inactive' WHERE seller_acc_id='"+accId+"' AND seller_aadhar='"+A_Name+"'");
          session.setAttribute("msg","Account set to inactive.");
        } 
        else if("set_normal".equals(action)){
          st.executeUpdate("UPDATE seller_account SET status='Normal' WHERE seller_acc_id='"+accId+"' AND seller_aadhar='"+A_Name+"'");
          session.setAttribute("msg","Account status updated to Normal.");
        }

        st.close();
        con.close();

      }catch(Exception e){
        out.println(e);
      }

      response.sendRedirect("view_seller_acc.jsp"); 
      return;
    }

    /* ── load accounts ── */
    DB dbA=new DB();
    ResultSet rsA=dbA.Select(
      "SELECT seller_acc_id,Card_Type,Card_Brand,Cardholder_Name,Card_Number,Expire_Date,Cvv,Pin,Amount,status,seller_email "+
      "FROM seller_account WHERE seller_aadhar='"+A_Name+"' ORDER BY CASE status WHEN 'Active' THEN 0 WHEN 'Normal' THEN 1 ELSE 2 END, seller_acc_id ASC");

    /* count summary */
    DB dC1=new DB(); ResultSet rC1=dC1.Select("SELECT COUNT(*) c FROM seller_account WHERE seller_aadhar='"+A_Name+"'");
    int totalAcc=0; if(rC1.next()) totalAcc=rC1.getInt("c");
    DB dC2=new DB(); ResultSet rC2=dC2.Select("SELECT COUNT(*) c FROM seller_account WHERE seller_aadhar='"+A_Name+"' AND status='Active'");
    int activeAcc=0; if(rC2.next()) activeAcc=rC2.getInt("c");

    /* running balance */
    DB dBal=new DB(); ResultSet rBal=dBal.Select("SELECT SUM(Amount) total FROM seller_account WHERE seller_aadhar='"+A_Name+"' AND status='Active'");
    String totalBal="0"; if(rBal.next()&&rBal.getString("total")!=null) totalBal=rBal.getString("total");

    String flashMsg=(String)session.getAttribute("msg"); session.removeAttribute("msg");
    %>
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
      <title>My Accounts — Buyer</title>
      <link href="img/favicon.png" rel="icon">
      <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600;1,700&display=swap" rel="stylesheet">
      <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
      <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/seller-theme.css" rel="stylesheet">
      <link href="css/buyer-theme.css" rel="stylesheet">
    </head>
    <body>
      <%
                String msg = (String) session.getAttribute("msg");
                if (msg != null) {
            %>
            <script> alert("<%=msg%>");</script>
            <%
                }
                session.removeAttribute("msg");
            %>  
    
    <aside class="sd-sidebar" id="sidebar">
      <div class="sd-logo"><div class="sd-logo-text">INNOVATIVE<em> RESIDENCE</em></div><div class="sd-logo-sub">Seller Portal</div></div>
      <div class="sd-user-chip">
        <div class="sd-avatar"><%=avatarChar%></div>
        <div><div class="sd-user-name"><%=buyer_name%></div><div class="sd-user-role">Verified Seller</div></div>
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
          <a href="view3.jsp" ><i class="fa fa-calendar"></i> Booked Lands</a>
        </div>
  <div class="sd-nav-section">
      <div class="sd-nav-label">Chat Session</div>
      <a href="seller_chat.jsp" ><i class="fa fa-comments"></i> Chat with Buyers </a>
    </div>
            <div class="sd-nav-section">
          <div class="sd-nav-label">Account Session</div>
          <a href="seller_add_acc.jsp"><i class="fa fa-home"></i> Add Acc</a>

          <a href="view_seller_acc.jsp"  class="active"><i class="fa fa-map-o"></i> View Acc</a>
           <a href="seller_transactions.jsp"><i class="fa fa-list-alt"></i> Transactions</a>
        </div> 
        
      </nav>
      <div class="sd-sidebar-footer"><a href="index.jsp" class="sd-logout"><i class="fa fa-sign-out"></i> Sign Out</a></div>
    </aside>
    <header class="by-topbar">
      <div class="by-page-title">
        My Accounts
        <span>buyer_account table &mdash; <%=totalAcc%> registered &middot; <%=activeAcc%> active</span>
      </div>
      <div class="by-topbar-actions">
        <a href="buyerhome.jsp" class="by-btn by-btn-outline by-btn-sm"><i class="fa fa-home"></i> Home</a>
      </div>
    </header>

    <main class="by-main">
    <div class="by-page">

      <!-- Summary -->
      <div class="by-stats-grid by-fade" style="grid-template-columns:repeat(3,1fr);max-width:560px;margin-bottom:1.5rem">
        <div class="by-stat-card">
          <div class="by-stat-icon by-si-teal"><i class="fa fa-university"></i></div>
          <div><div class="by-stat-n"><%=totalAcc%></div><div class="by-stat-l">Total Accounts</div></div>
        </div>
        <div class="by-stat-card">
          <div class="by-stat-icon by-si-green"><i class="fa fa-check-circle"></i></div>
          <div><div class="by-stat-n"><%=activeAcc%></div><div class="by-stat-l">Active (Default)</div></div>
        </div>
        <div class="by-stat-card">
          <div class="by-stat-icon by-si-violet"><i class="fa fa-inr"></i></div>
          <div><div class="by-stat-n" style="font-size:1.3rem">₹<%=totalBal%></div><div class="by-stat-l">Active Balance</div></div>
        </div>
      </div>

      <%if(activeAcc==0){%>
      <div class="by-alert by-a-warn by-fade"><i class="fa fa-exclamation-triangle"></i> <span><strong>No active account!</strong> Please set one account as default to make payments. Without an active account, bookings cannot be completed.</span></div>
      <%}else if(activeAcc>1){%>
      <div class="by-alert by-a-teal by-fade"><i class="fa fa-info-circle"></i> <span>Only <strong>one account</strong> can be Active (default) at a time. Setting a new default will deactivate the current one.</span></div>
      <%}%>

      <div class="by-alert by-a-teal by-fade">
        <i class="fa fa-info-circle"></i>
        <span><strong>Account Rules:</strong> <em>Active</em> = your default payment account (only 1 allowed). <em>Normal</em> = enrolled but not default. <em>Inactive</em> = disabled/suspended.</span>
      </div>

      <!-- Account Cards Grid -->
      <%
      boolean hasAcc=false;
      while(rsA.next()){
        hasAcc=true;
        String accStatus=rsA.getString("status");
        String cardNum=rsA.getString("Card_Number"); if(cardNum==null) cardNum="";
        String maskedNum = cardNum.length()>=4 ? "**** **** **** "+cardNum.substring(cardNum.length()-4) : "•••• •••• •••• ••••";
        String cardBrand=rsA.getString("Card_Brand"); if(cardBrand==null) cardBrand="";
        String cardType=rsA.getString("Card_Type"); if(cardType==null) cardType="";
        String holderName=rsA.getString("Cardholder_Name"); if(holderName==null) holderName=A_Name;
        String expDate=rsA.getString("Expire_Date"); if(expDate==null) expDate="--/--";
        String amount=rsA.getString("Amount"); if(amount==null) amount="0";
        String accEmail=rsA.getString("seller_email"); if(accEmail==null) accEmail="";
        String aid=rsA.getString("seller_acc_id");
        boolean isActive="Active".equals(accStatus);
        boolean isInactive="Inactive".equals(accStatus);
        String cardClass="by-card-visa"; // default
        if(cardBrand.toLowerCase().contains("master")) cardClass="by-card-mastercard";
        else if(cardBrand.toLowerCase().contains("rupay")) cardClass="by-card-rupay";
      %>
      <div class="by-fade" style="margin-bottom:1.2rem">
        <div class="by-account-card <%=isActive?"is-default":isInactive?"is-inactive":""%>">
          <div class="by-acc-glow"></div>
          <div class="by-acc-header">
            <span class="by-acc-brand"><%=cardBrand%> <%=cardType%></span>
            <%if(isActive){%>
            <span class="by-acc-status-default"><i class="fa fa-star"></i> Default / Active</span>
            <%}else if(isInactive){%>
            <span class="by-acc-status-inactive"><i class="fa fa-ban"></i> Inactive</span>
            <%}else{%>
            <span class="by-acc-status-inactive"><i class="fa fa-circle-o"></i> Normal</span>
            <%}%>
          </div>

          <!-- Visual payment card mini preview -->
          <div style="margin-bottom:1rem">
            <div class="by-payment-card-3d <%=cardClass%>" style="height:170px;max-width:320px;font-size:.9em">
              <div class="by-card-shine"></div>
              <div class="by-card-chip"></div>
              <div class="by-card-number" style="font-size:.95rem;letter-spacing:3px"><%=maskedNum%></div>
              <div class="by-card-footer">
                <div>
                  <div class="by-card-holder-label">Card Holder</div>
                  <div class="by-card-holder-name" style="font-size:.74rem"><%=holderName%></div>
                </div>
                <div>
                  <div class="by-card-exp-label">Expires</div>
                  <div class="by-card-exp-val" style="font-size:.74rem"><%=expDate%></div>
                </div>
              </div>
              <div class="by-card-brand-logo" style="font-size:1rem;bottom:.8rem;right:.9rem"><%=cardBrand%></div>
              <div class="by-card-contactless" style="top:.9rem;right:.9rem;font-size:.9rem"><i class="fa fa-wifi"></i></div>
            </div>
          </div>

          <div style="display:grid;grid-template-columns:1fr 1fr;gap:.5rem 1.5rem">
            <div>
              <div class="by-acc-balance-label">Account Balance</div>
              <div class="by-acc-balance">₹<%=amount%></div>
            </div>
            <div>
              <div class="by-acc-balance-label">Card Number</div>
              <div class="by-acc-number" style="font-size:.82rem;letter-spacing:2px"><%=maskedNum%></div>
            </div>
            <div>
              <div class="by-acc-balance-label">Cardholder</div>
              <div class="by-acc-holder" style="font-size:.78rem"><%=holderName%></div>
            </div>
            <div>
              <div class="by-acc-balance-label">Linked Email</div>
              <div style="font-size:.77rem;color:var(--text2)"><%=accEmail%></div>
            </div>
          </div>

          <div class="by-acc-actions">
            <%if(!isActive){%>
            <a href="view_seller_acc.jsp?act=set_default&acc_id=<%=aid%>"
               class="by-btn by-btn-green by-btn-sm"
               onclick="return confirm('Set this as your default payment account? Current default will be deactivated.')">
              <i class="fa fa-star"></i> Set Default
            </a>
            <%}%>
            <%if(!isInactive){%>
            <a href="view_seller_acc.jsp?act=set_inactive&acc_id=<%=aid%>"
               class="by-btn by-btn-ghost-rose by-btn-sm"
               onclick="return confirm('Mark this account as Inactive?')">
              <i class="fa fa-ban"></i> Set Inactive
            </a>
            <%}%>
            <%if(isInactive||(!isActive&&!isInactive)){%>
            <a href="view_seller_acc.jsp?act=set_normal&acc_id=<%=aid%>"
               class="by-btn by-btn-outline by-btn-sm">
              <i class="fa fa-refresh"></i> Set Normal
            </a>
            <%}%>
          </div>
        </div>
      </div>
      <%}%>

      <%if(!hasAcc){%>
      <div class="by-card by-fade">
        <div class="by-empty">
          <i class="fa fa-university"></i>
          <h3>No accounts registered</h3>
          <p>You have no accounts in <code>buyer_account</code> with aadhar: <%=A_Name%></p>
        </div>
      </div>
      <%}%>

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
