<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Upload Flat/House — Innovative Residence</title>
  <link href="img/favicon.png" rel="icon">
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Fraunces:ital,wght@0,500;0,700;1,500;1,700&display=swap" rel="stylesheet">
  <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="css/seller-theme.css" rel="stylesheet">
</head>
<body>
    
     <%
        String msg = (String) session.getAttribute("msg");
        if (msg != null) {
          boolean isSuccess = msg.toLowerCase().contains("success") || msg.toLowerCase().contains("register");
      %>
      <script>alert("<%=msg%>");</script>
        <div class="ir-alert <%= isSuccess ? "ir-a-success" : "ir-a-danger" %>">
          <i class="fa fa-<%= isSuccess ? "check-circle" : "exclamation-circle" %>"></i>
          <span><%= msg %></span>
        </div>
      <%
          session.removeAttribute("msg");
        }
      %>
    
    
    
    
    
    
    
    
<%
  String A_Name = (String) session.getAttribute("A_Name");
  if (A_Name == null) { response.sendRedirect("index.jsp"); return; }
  DB db = new DB();
  ResultSet sellerRs = db.Select("SELECT * FROM sellerregister WHERE A_Name='" + A_Name + "'");
  String sellerName = "Seller";
  if (sellerRs.next()) sellerName = sellerRs.getString("username");
  char avatarChar = sellerName.length() > 0 ? sellerName.charAt(0) : 'S';
%>

<button class="sd-hamburger" onclick="toggleSidebar()"><i class="fa fa-bars"></i></button>

<aside class="sd-sidebar" id="sidebar">
  <div class="sd-logo"><div class="sd-logo-text">INNOVATIVE<em> RESIDENCE</em></div><div class="sd-logo-sub">Seller Portal</div></div>
  <div class="sd-user-chip">
    <div class="sd-avatar"><%=avatarChar%></div>
    <div><div class="sd-user-name"><%=sellerName%></div><div class="sd-user-role">Verified Seller</div></div>
  </div>
  <nav class="sd-nav">
    <div class="sd-nav-section">
      <div class="sd-nav-label">Main</div>
      <a href="sellerhome.jsp"><i class="fa fa-home"></i> Dashboard</a>
      <a href="House.jsp" class="active"><i class="fa fa-building"></i> Upload Flat/House</a>
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
      <div class="sd-nav-label">Account Session</div>
      <a href="seller_add_acc.jsp"><i class="fa fa-home"></i> Add Acc</a>
      <a href="view_seller_acc.jsp"><i class="fa fa-map-o"></i> View Acc</a>
       <a href="seller_transactions.jsp"><i class="fa fa-list-alt"></i> Transactions</a>
    </div> 
    
  </nav>
  <div class="sd-sidebar-footer"><a href="index.jsp" class="sd-logout"><i class="fa fa-sign-out"></i> Sign Out</a></div>
</aside>

<header class="sd-topbar">
  <div class="sd-page-title">
    Upload Flat / House
    <span>Fill in your property details for admin review</span>
  </div>
  <div class="sd-topbar-actions">
    <div class="sd-breadcrumb">
      <a href="sellerhome.jsp">Dashboard</a>
      <i class="fa fa-chevron-right"></i>
      <span>Upload Flat/House</span>
    </div>
    <a href="index.jsp" class="sd-btn sd-btn-outline sd-btn-sm"><i class="fa fa-sign-out"></i> Logout</a>
  </div>
</header>

<div class="sd-form-header">
  <div class="sd-form-header-content">
    <div class="sd-form-header-breadcrumb">
      <a href="sellerhome.jsp">Dashboard</a> <i class="fa fa-chevron-right"></i> Upload Flat/House
    </div>
    <h1><i class="fa fa-building" style="color:var(--primary3);margin-right:.5rem"></i> Flat / House Details Upload</h1>
    <p>All details are auto-filled from your seller profile. Add property specifics below. After admin approval, your listing will go live for buyers.</p>
  </div>
</div>

<main class="sd-main" style="padding-top:0">
 

  <%
    long k=1000;
    DB dbForm = new DB();
    ResultSet rs = dbForm.Select("SELECT * FROM sellerregister WHERE A_Name='" + A_Name + "'");
    while(rs.next()) {
  %>
  <div class="sd-upload-layout">
    <div>
      <form id="addFlatHouseForm" action="flat_upload" enctype="multipart/form-data" method="post" onsubmit="return Validate_Data()">

        <!-- Seller Info (read-only from DB) -->
        <div class="sd-card" style="margin-bottom:1.2rem">
          <div class="sd-card-head">
            <div class="sd-card-title"><i class="fa fa-user-circle"></i> Seller Information</div>
            <span class="sd-badge sd-badge-green sd-badge-dot">Auto-filled from profile</span>
          </div>
          <div class="sd-card-body">
            <div class="sd-form-row-2">
              <div class="sd-fg">
                <label>Aadhaar Number</label>
                <input type="text" class="sd-input" value="<%=rs.getString("A_Name")%>" id="A_Name" name="A_Name" readonly>
              </div>
              <div class="sd-fg">
                <label>Seller Name</label>
                <input type="text" class="sd-input" value="<%=rs.getString("username")%>" id="S_Name" name="S_Name" readonly>
              </div>
              <div class="sd-fg">
                <label>Mobile Number</label>
                <input type="text" class="sd-input" value="<%=rs.getString("mobile_no")%>" id="S_Number" name="S_Number" readonly>
              </div>
              <div class="sd-fg">
                <label>Email ID</label>
                <input type="text" class="sd-input" value="<%=rs.getString("email")%>" id="S_MAIL" name="S_MAIL" readonly>
              </div>
            </div>
            <div class="sd-fg">
              <label>Registered Address</label>
              <input type="text" class="sd-input" value="<%=rs.getString("address")%>" id="S_Addr" name="S_Addr" readonly>
            </div>
          </div>
        </div>

        <!-- Property Location -->
        <div class="sd-card" style="margin-bottom:1.2rem">
          <div class="sd-card-head">
            <div class="sd-card-title"><i class="fa fa-map-marker"></i> Property Location</div>
          </div>
          <div class="sd-card-body">
            <div class="sd-form-row-3">
              <div class="sd-fg">
                <label>City <span class="req">*</span></label>
                <input type="text" class="sd-input" placeholder="e.g. Chennai" id="cit" name="city">
              </div>
              <div class="sd-fg">
                <label>Area <span class="req">*</span></label>
                <input type="text" class="sd-input" placeholder="e.g. Anna Nagar" id="area" name="area">
              </div>
              <div class="sd-fg">
                <label>Street <span class="req">*</span></label>
                <input type="text" class="sd-input" placeholder="Street name" id="str" name="street">
              </div>
            </div>
            <div class="sd-fg">
              <label>House Number <span class="req">*</span></label>
              <input type="text" class="sd-input" placeholder="e.g. No. 42-B" id="H_No" name="H_NO" style="max-width:260px">
            </div>
              <div class="sd-fg">
              <label>House Document <span class="req">*</span></label>
              <input type="file" class="sd-input" placeholder="Choose Document" id="document" name="document" style="max-width:260px">
            </div>
          </div>
        </div>

        <!-- Financial Details -->
        <div class="sd-card" style="margin-bottom:1.2rem">
          <div class="sd-card-head">
            <div class="sd-card-title"><i class="fa fa-inr"></i> Financial Details</div>
          </div>
          <div class="sd-card-body">
            <div class="sd-form-row-3">
              <div class="sd-fg">
                <label>Sale Amount (&#8377;) <span class="req">*</span></label>
                <input type="text" class="sd-input" placeholder="e.g. 8500000" id="rent" name="rent">
              </div>
              <div class="sd-fg">
                <label>Advance Amount (&#8377;) <span class="req">*</span></label>
                <input type="text" class="sd-input" placeholder="e.g. 500000" id="adv" name="advance">
              </div>
              <div class="sd-fg">
                <label>Booking Charge (&#8377;) <span class="req">*</span></label>
                <input type="text" class="sd-input" value="<%=k%>"  id="fess" name="fess" readonly>
              </div>
            </div>
          </div>
        </div>

        <!-- Property Specs -->
        <div class="sd-card" style="margin-bottom:1.2rem">
          <div class="sd-card-head">
            <div class="sd-card-title"><i class="fa fa-info-circle"></i> Property Specifications</div>
          </div>
          <div class="sd-card-body">
            <div class="sd-form-row-2">
              <div class="sd-fg">
                <label>Flat / House Type <span class="req">*</span></label>
                <select class="sd-input" name="FTYPE" id="F_Type">
                 
                  <option value="1BHK">1 BHK</option>
                  <option value="2BHK">2 BHK</option>
                  <option value="3BHK">3 BHK</option>
                  <option value="4BHK">4 BHK</option>
                  <option value="Villa">Villa</option>
                  <option value="Independent House">Independent House</option>
                </select>
              </div>
              <div class="sd-fg">
                <label>Property Image <span class="req">*</span></label>
                <div class="sd-file-upload-wrap">
                  <div class="sd-file-upload" id="fileDropzone">
                    <i class="fa fa-cloud-upload"></i>
                    <div class="sd-file-upload-text">Click or drag to upload image</div>
                    <div class="sd-file-upload-sub">JPG, PNG — Max 5MB</div>
                    <input type="file" id="Image" name="Image" accept="image/*" onchange="updateFileLabel(this)">
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div style="display:flex;gap:.75rem">
          <button type="submit" class="sd-submit" style="max-width:220px"><i class="fa fa-cloud-upload"></i> Upload Property</button>
          <button type="reset" class="sd-submit sd-submit-outline" style="max-width:140px"><i class="fa fa-refresh"></i> Reset</button>
        </div>
      </form>
    </div>

    <!-- Sidebar Info -->
    <div>
      <div class="sd-info-panel" style="margin-bottom:1rem">
        <div class="sd-info-panel-title"><i class="fa fa-lightbulb-o"></i> Submission Guide</div>
        <div class="sd-alert sd-a-info" style="margin-bottom:1rem">
          <i class="fa fa-info-circle"></i>
          <span>Your listing goes live only after admin approval. Ensure all details are accurate.</span>
        </div>
        <ul style="list-style:none;display:flex;flex-direction:column;gap:.6rem">
          <li style="display:flex;align-items:flex-start;gap:.5rem;font-size:.8rem;color:var(--text2)"><i class="fa fa-check-circle" style="color:var(--primary);margin-top:2px;flex-shrink:0"></i> Seller info auto-filled from your profile</li>
          <li style="display:flex;align-items:flex-start;gap:.5rem;font-size:.8rem;color:var(--text2)"><i class="fa fa-check-circle" style="color:var(--primary);margin-top:2px;flex-shrink:0"></i> Upload a clear, well-lit property photo</li>
          <li style="display:flex;align-items:flex-start;gap:.5rem;font-size:.8rem;color:var(--text2)"><i class="fa fa-check-circle" style="color:var(--primary);margin-top:2px;flex-shrink:0"></i> Enter correct area and city names</li>
          <li style="display:flex;align-items:flex-start;gap:.5rem;font-size:.8rem;color:var(--text2)"><i class="fa fa-check-circle" style="color:var(--primary);margin-top:2px;flex-shrink:0"></i> Pricing is reviewed by admin for accuracy</li>
          <li style="display:flex;align-items:flex-start;gap:.5rem;font-size:.8rem;color:var(--text2)"><i class="fa fa-check-circle" style="color:var(--primary);margin-top:2px;flex-shrink:0"></i> You'll be notified once approved</li>
        </ul>
      </div>

      <%
        DB dbStats = new DB();
        ResultSet stRs = dbStats.Select("SELECT COUNT(*) AS total, SUM(CASE WHEN sts1='Approved' THEN 1 ELSE 0 END) AS approved, SUM(CASE WHEN sts1='Pending' THEN 1 ELSE 0 END) AS pending FROM flat_house WHERE A_Name='" + A_Name + "'");
        int stTotal=0, stApproved=0, stPending=0;
        if(stRs.next()) { stTotal=stRs.getInt("total"); stApproved=stRs.getInt("approved"); stPending=stRs.getInt("pending"); }
      %>
      <div class="sd-info-panel">
        <div class="sd-info-panel-title"><i class="fa fa-bar-chart"></i> Your Flat Upload Stats</div>
        <div style="display:flex;justify-content:space-between">
          <div style="text-align:center;flex:1">
            <div style="font-family:var(--ff-display);font-size:1.6rem;font-weight:700;color:var(--primary)"><%=stTotal%></div>
            <div style="font-size:.7rem;color:var(--text3)">Flats Uploaded</div>
          </div>
          <div style="width:1px;background:var(--border)"></div>
          <div style="text-align:center;flex:1">
            <div style="font-family:var(--ff-display);font-size:1.6rem;font-weight:700;color:var(--amber)"><%=stPending%></div>
            <div style="font-size:.7rem;color:var(--text3)">Pending</div>
          </div>
          <div style="width:1px;background:var(--border)"></div>
          <div style="text-align:center;flex:1">
            <div style="font-family:var(--ff-display);font-size:1.6rem;font-weight:700;color:var(--sky)"><%=stApproved%></div>
            <div style="font-size:.7rem;color:var(--text3)">Approved</div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <% } %>
</main>

<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>
function toggleSidebar(){ document.getElementById('sidebar').classList.toggle('open'); }
function updateFileLabel(input){
  if(input.files && input.files[0]){
    document.querySelector('.sd-file-upload-text').textContent=input.files[0].name;
    document.querySelector('.sd-file-upload-sub').textContent='File selected ✓';
    document.querySelector('.sd-file-upload').style.borderColor='var(--primary2)';
    document.querySelector('.sd-file-upload').style.background='var(--primary-light)';
  }
}
function Validate_Data(){
  var area=document.getElementById("area").value.trim();
  if(!area){ alert('Area cannot be empty'); return false; }
  if(!/^[a-zA-Z ]+$/.test(area)){ alert("Area should contain only letters"); return false; }
  var rent=document.getElementById("rent").value.trim();
  if(!rent){ alert('Enter Rent amount'); return false; }
  if(!/^[0-9]+$/.test(rent)){ alert("Rent should be numbers only"); return false; }
  var adv=document.getElementById("adv").value.trim();
  if(!adv){ alert('Enter Advance amount'); return false; }
  if(!/^[0-9]+$/.test(adv)){ alert("Advance should be numbers only"); return false; }
  var fess=document.getElementById("fess").value.trim();
  if(!fess){ alert('Enter Booking Charge'); return false; }
  if(!/^[0-9]+$/.test(fess)){ alert("Booking charge should be numbers only"); return false; }
  var str=document.getElementById("str").value.trim();
  if(!str){ alert('Street cannot be empty'); return false; }
  var cit=document.getElementById("cit").value.trim();
  if(!cit){ alert('City cannot be empty'); return false; }
  if(!/^[a-zA-Z]+$/.test(cit)){ alert("City should contain only letters"); return false; }
  var H_No=document.getElementById("H_No").value.trim();
  if(!H_No){ alert('House Number cannot be empty'); return false; }
  var ge=document.getElementById("F_Type").value;
  if(ge==="Select"){ alert('Please select Flat/House Type'); return false; }
  var Image=document.getElementById("Image").value;
  if(!Image){ alert('Please select an image'); return false; }
  return true;
}
</script>
</body>
</html>
