<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%!
/* Escape single quotes for SQL safety */
private String sq(String s){ return (s==null)?"":s.replace("'","''"); }
%>
<%
String A_Name=(String)session.getAttribute("User");
if(A_Name==null){
    out.print("{\"ok\":false,\"error\":\"Session expired\"}");
    return;
}
/* PARAMETERS */
String buyerAcc     = request.getParameter("buyer_acc");
String sellerAcc    = request.getParameter("seller_acc");
String amtStr       = request.getParameter("amount");
String types        = request.getParameter("types");
String txnId        = request.getParameter("txn_id");
String propertyType = request.getParameter("prop_type");
String propertyRef  = request.getParameter("prop_ref");
/* VALIDATION */
if(buyerAcc==null || sellerAcc==null || amtStr==null){
    out.print("{\"ok\":false,\"error\":\"Missing parameters\"}");
    return;
}
double amount=0;
try{
    amount=Double.parseDouble(amtStr);
}catch(Exception e){
    out.print("{\"ok\":false,\"error\":\"Invalid amount\"}");
    return;
}
/* DEFAULT VALUES (if null) */
if(propertyType==null) propertyType="";
if(propertyRef==null) propertyRef="";
if(types==null) types="PROPERTY_PAYMENT";
if(txnId==null || txnId.equals("")) txnId="TXN"+System.currentTimeMillis();
try{
/* STEP 1: CHECK BUYER BALANCE */
DB dbBuyer=new DB();
ResultSet rsBuyer=dbBuyer.Select(
"SELECT Amount FROM buyer_account WHERE buyer_acc_id='"+buyerAcc+"' AND buyer_aadhar='"+A_Name+"' AND status='Active' LIMIT 1"
);
if(!rsBuyer.next()){
    out.print("{\"ok\":false,\"error\":\"Buyer account not found or inactive\"}");
    return;
}
double buyerBalance=0;
try{
    String bal=rsBuyer.getString("Amount");
    if(bal!=null) buyerBalance=Double.parseDouble(bal);
}catch(Exception e){}
/* STEP 2: INSUFFICIENT BALANCE CHECK */
if(buyerBalance < amount){
    out.print("{\"ok\":false,\"error\":\"Insufficient Balance\"}");
    return;
}
/* STEP 3: CALCULATE NEW BUYER BALANCE */
double newBuyerBalance = buyerBalance - amount;
/* STEP 4: UPDATE BUYER ACCOUNT */
DB dbDebit=new DB();
dbDebit.Insert(
"UPDATE buyer_account SET Amount='"+newBuyerBalance+"' WHERE buyer_acc_id='"+buyerAcc+"'"
);
/* STEP 5: GET SELLER BALANCE */
DB dbSeller=new DB();
ResultSet rsSeller=dbSeller.Select(
"SELECT Amount FROM seller_account WHERE seller_acc_id='"+sellerAcc+"' AND status='Active' LIMIT 1"
);
double sellerBalance=0;
if(rsSeller.next()){
    String sb=rsSeller.getString("Amount");
    if(sb!=null) sellerBalance=Double.parseDouble(sb);
}
/* STEP 6: CALCULATE NEW SELLER BALANCE */
double newSellerBalance = sellerBalance + amount;
/* STEP 7: UPDATE SELLER ACCOUNT */
DB dbCredit=new DB();
dbCredit.Insert(
"UPDATE seller_account SET Amount='"+newSellerBalance+"' WHERE seller_acc_id='"+sellerAcc+"'"
);

/* ═══════════════════════════════════════════════════════════════════
   STEP 7B: INSERT BOOKING RECORD INTO bookingss (flat) OR booking (land)
   Fetch property details + buyer profile, then insert the booking row
   so it appears in: My Bookings (buyer), Booked listings (seller),
   Admin booking pages, and Transactions.
   ═══════════════════════════════════════════════════════════════════ */
if(propertyRef!=null && !propertyRef.isEmpty() && propertyType!=null && !propertyType.isEmpty()){
    try{
        /* ── Buyer profile (name / email / phone) ── */
        DB dbBuyerProfile = new DB();
        ResultSet rsBuyerProfile = dbBuyerProfile.Select(
            "SELECT username,email,mobile FROM register WHERE A_Name='"+A_Name+"' LIMIT 1");
        String buyerName="", buyerEmail="", buyerPhone="";
        if(rsBuyerProfile.next()){
            if(rsBuyerProfile.getString("username")!=null) buyerName  = rsBuyerProfile.getString("username");
            if(rsBuyerProfile.getString("email")   !=null) buyerEmail = rsBuyerProfile.getString("email");
            if(rsBuyerProfile.getString("mobile")  !=null) buyerPhone = rsBuyerProfile.getString("mobile");
        }

        /* ── Buyer card number (for U_ACC column) ── */
        String buyerCardNum = "";
        DB dbBuyerCard = new DB();
        ResultSet rsBuyerCard = dbBuyerCard.Select(
            "SELECT Card_Number FROM buyer_account WHERE buyer_acc_id='"+buyerAcc+"' LIMIT 1");
        if(rsBuyerCard.next() && rsBuyerCard.getString("Card_Number")!=null)
            buyerCardNum = rsBuyerCard.getString("Card_Number");

        /* ── Seller card number (for A_ACC column) ── */
        String sellerCardNum = "";
        DB dbSellerCard = new DB();
        ResultSet rsSellerCard = dbSellerCard.Select(
            "SELECT Card_Number FROM seller_account WHERE seller_acc_id='"+sellerAcc+"' LIMIT 1");
        if(rsSellerCard.next() && rsSellerCard.getString("Card_Number")!=null)
            sellerCardNum = rsSellerCard.getString("Card_Number");

        if("flat".equalsIgnoreCase(propertyType)){
            /* ── Fetch flat_house details ── */
            DB dbFlat = new DB();
            ResultSet rsFlat = dbFlat.Select(
                "SELECT S_ID,S_Name,S_Number,S_MAIL,street,A_Name "+
                "FROM flat_house WHERE H_NO='"+propertyRef+"' LIMIT 1");

            if(rsFlat.next()){
                int    fSid    = rsFlat.getInt("S_ID");
                String fSName  = rsFlat.getString("S_Name")   !=null ? rsFlat.getString("S_Name")   : "";
                String fSMail  = rsFlat.getString("S_MAIL")   !=null ? rsFlat.getString("S_MAIL")   : "";
                String fStreet = rsFlat.getString("street")   !=null ? rsFlat.getString("street")   : "";
                String fSAadhar= rsFlat.getString("A_Name")   !=null ? rsFlat.getString("A_Name")   : "";

                /*
                  bookingss columns:
                  S_ID, S_NAME, S_MAIL, street, H_NO,
                  U_NAME, U_NUMBER, U_MAIL, STS,
                  A_ACC, C_Type, U_ACC, B_fess, key1,
                  A_NAME, SA_NAME
                */
                DB dbInsFlat = new DB();
                dbInsFlat.Insert(
                    "INSERT INTO bookingss "+
                    "(S_ID,S_NAME,S_MAIL,street,H_NO,"+
                    " U_NAME,U_NUMBER,U_MAIL,STS,"+
                    " A_ACC,C_Type,U_ACC,B_fess,key1,"+
                    " A_NAME,SA_NAME) VALUES ("+
                    "'"+fSid+"',"+
                    "'"+sq(fSName)+"',"+
                    "'"+sq(fSMail)+"',"+
                    "'"+sq(fStreet)+"',"+
                    "'"+sq(propertyRef)+"',"+
                    "'"+sq(A_Name)+"',"+           // U_NAME = buyer aadhar
                    "'"+sq(buyerPhone)+"',"+
                    "'"+sq(buyerEmail)+"',"+
                    "'Booked',"+
                    "'"+sq(sellerCardNum)+"',"+     // A_ACC = seller card no.
                    "'"+sq(types)+"',"+             // C_Type = what was paid
                    "'"+sq(buyerCardNum)+"',"+      // U_ACC = buyer card no.
                    "'"+amount+"',"+                // B_fess = amount paid
                    "'"+sq(txnId)+"',"+             // key1 = transaction ID
                    "'"+sq(fSAadhar)+"',"+          // A_NAME = seller aadhar
                    "'"+sq(fSAadhar)+"'"+           // SA_NAME = seller aadhar
                    ")"
                );
            }

        } else if("land".equalsIgnoreCase(propertyType)){
            /* ── Fetch upload (land) details ── */
            DB dbLand = new DB();
            ResultSet rsLand = dbLand.Select(
                "SELECT S_ID,S_Name,S_Number,S_MAIL,area,SUNO,A_Name "+
                "FROM upload WHERE D_NO='"+propertyRef+"' LIMIT 1");

            if(rsLand.next()){
                int    lSid    = rsLand.getInt("S_ID");
                String lSName  = rsLand.getString("S_Name") !=null ? rsLand.getString("S_Name") : "";
                String lSMail  = rsLand.getString("S_MAIL") !=null ? rsLand.getString("S_MAIL") : "";
                String lArea   = rsLand.getString("area")   !=null ? rsLand.getString("area")   : "";
                String lSuno   = rsLand.getString("SUNO")   !=null ? rsLand.getString("SUNO")   : "";
                String lSAadhar= rsLand.getString("A_Name") !=null ? rsLand.getString("A_Name") : "";

                /*
                  booking columns:
                  S_ID, S_NAME, S_MAIL, area, D_NO,
                  U_NAME, U_NUMBER, U_MAIL, STS,
                  A_ACC, C_Type, U_ACC, B_fess, key1,
                  A_NAME, SUNO, SA_Name
                */
                DB dbInsLand = new DB();
                dbInsLand.Insert(
                    "INSERT INTO booking "+
                    "(S_ID,S_NAME,S_MAIL,area,D_NO,"+
                    " U_NAME,U_NUMBER,U_MAIL,STS,"+
                    " A_ACC,C_Type,U_ACC,B_fess,key1,"+
                    " A_NAME,SUNO,SA_Name) VALUES ("+
                    "'"+lSid+"',"+
                    "'"+sq(lSName)+"',"+
                    "'"+sq(lSMail)+"',"+
                    "'"+sq(lArea)+"',"+
                    "'"+sq(propertyRef)+"',"+
                    "'"+sq(A_Name)+"',"+           // U_NAME = buyer aadhar
                    "'"+sq(buyerPhone)+"',"+
                    "'"+sq(buyerEmail)+"',"+
                    "'Booked',"+
                    "'"+sq(sellerCardNum)+"',"+     // A_ACC
                    "'"+sq(types)+"',"+             // C_Type
                    "'"+sq(buyerCardNum)+"',"+      // U_ACC
                    "'"+amount+"',"+                // B_fess
                    "'"+sq(txnId)+"',"+             // key1
                    "'"+sq(lSAadhar)+"',"+          // A_NAME
                    "'"+sq(lSuno)+"',"+             // SUNO = survey number
                    "'"+sq(lSAadhar)+"'"+           // SA_Name
                    ")"
                );
            }
        }
    }catch(Exception bookEx){
        /* Booking insert failure should NOT block the payment success response.
           Log it but continue — money transfer already succeeded above. */
    }
}
/* ═══════════════════════════════════════════════════════════════════ */

/* STEP 8: STORE TRANSACTION */
DB dbTxn=new DB();
dbTxn.Insert(
"INSERT INTO payments(txn_id,buyer_acc,seller_acc,amount,payment_type,property_type,property_ref,txn_date) VALUES('"
+txnId+"','"
+buyerAcc+"','"
+sellerAcc+"','"
+amount+"','"
+types+"','"
+propertyType+"','"
+propertyRef+"',NOW())"
);
/* SUCCESS RESPONSE */
out.print("{\"ok\":true,\"txn_id\":\""+txnId+"\",\"buyer_balance\":\""+newBuyerBalance+"\",\"seller_balance\":\""+newSellerBalance+"\"}");
}catch(Exception ex){
String err=ex.getMessage();
if(err!=null) err=err.replace("\"","'");
out.print("{\"ok\":false,\"error\":\""+err+"\"}");
}
%>
