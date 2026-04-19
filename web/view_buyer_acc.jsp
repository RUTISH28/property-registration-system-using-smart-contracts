
<!DOCTYPE html>
<html>
<%@ page import="java.sql.*,Connection.DB" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>




<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Waste Management - User Registration</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f0f3f4;
            color: #333;
            font-family: 'Arial', sans-serif;
        }
        /* Navbar */
        .navbar {
            background-color: #333;
        }
        .navbar-nav .nav-item {
    margin: 0 15px; /* More spacing between items */
}
        .navbar-brand img {
            height: 50px;
        }
        .navbar-nav .nav-item .nav-link.active {
            background-color: #f0c14b;
            color: white; 
            font-weight: bold;
            border-radius: 5px;
        }
         .navbar-dark .navbar-nav .nav-link{
    color:#fff;
}
        .navbar-nav .nav-item .nav-link {
            font-size: 1.1em;
        }
        /* Hero Section */
        .hero-section {
            text-align: center;
            padding: 80px 20px;
            background: rgba(0, 0, 0, 0.6);
            color: #fff;
            margin-top: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }
        .hero-section h1 {
            font-size: 3.5em;
            font-weight: bold;
            text-transform: uppercase;
        }
        .cta-button {
            font-size: 1.3em;
            padding: 12px 35px;
            background-color: #f0c14b;
            color: #333;
            border: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .cta-button:hover {
            background-color: #e68a00;
            cursor: pointer;
        }
        /* Registration Form */
        .registration-form {
            margin-top: 50px;
            padding: 30px;
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 8%;
        }
        .registration-form h2 {
            color: #4CAF50;
            font-weight: bold;
            margin-bottom: 30px;
        }
        /* Donation Process Section */
        .donation-process {
            padding: 50px 20px;
            background-color: #ffffff;
            margin-top: 50px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .donation-process h2 {
            color: #4CAF50;
            font-weight: bold;
            margin-bottom: 30px;
        }
        .donation-process img {
            max-width: 100%;
            border-radius: 8px;
            margin-bottom: 20px;
            transition: transform 0.3s ease-in-out;
        }
        .donation-process img:hover {
            transform: scale(1.05);
        }
        .donation-process .col-md-6 {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        .donation-process ul {
            list-style-type: none;
            padding: 0;
            text-align: left;
            margin-top: 30px;
        }
        .donation-process ul li {
            padding: 10px 0;
            border-bottom: 1px solid #ddd;
            font-size: 1.1em;
        }
        /* FAQ Section */
        .faq-section {
            padding: 50px 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
            margin-top: 50px;
        }
        .faq-section h2 {
            color: #4CAF50;
            font-weight: bold;
            margin-bottom: 30px;
        }
        .faq-section ul {
            list-style-type: none;
            padding: 0;
        }
        .faq-section ul li {
            padding: 10px 0;
            border-bottom: 1px solid #ddd;
        }
        /* Footer */
        .footer {
            background-color: #2c3e50;
            color: white;
            padding: 10px;
            text-align: center;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
        
    
    .name {
        width: 60%;
        margin: 40px auto;
        background-color: #fff;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }

    .name h2 {
        text-align: center;
        color: #333;
        margin-bottom: 30px;
    }

    form {
        display: flex;
        flex-direction: column;
    }

    label {
        font-weight: bold;
        margin: 10px 0 5px;
    }

    input, select, textarea {
        padding: 10px;
        border-radius: 5px;
        border: 1px solid #ccc;
        width: 100%;
        box-sizing: border-box;
    }

    textarea {
        resize: vertical;
    }

    input[type="submit"] {
        margin-top: 20px;
        padding: 12px;
        border: none;
        border-radius: 5px;
        background-color: #28a745;
        color: white;
        font-size: 16px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    input[type="submit"]:hover {
        background-color: #218838;
    }

    p {
        font-size: 16px;
        margin-bottom: 15px;
    }

    /* Optional: smaller padding for file input */
    input[type="file"] {
        padding: 3px;
    }

    </style>

   
    
    <style>
       
        
        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }
        .atm-card {
            width: 350px;
            height: 200px;
            border-radius: 15px;
            color: white;
            padding: 20px;
            margin: 15px auto;
            position: relative;
            box-shadow: 0 8px 20px rgba(0,0,0,0.3);
            font-family: 'Courier New', Courier, monospace;
        }
        .card-number {
            font-size: 1.3em;
            letter-spacing: 2px;
            margin: 20px 0;
        }
        .cardholder {
            text-transform: uppercase;
            font-weight: bold;
        }
        .expire-date {
            position: absolute;
            bottom: 20px;
            right: 20px;
        }
        .card-type {
            position: absolute;
            top: 20px;
            right: 20px;
            font-weight: bold;
        }
        .card-brand {
            position: absolute;
            
            left: 20px;
            font-weight: bold;
            text-transform: uppercase;
        }
        /* Example colors for card types */
        .credit { background: linear-gradient(135deg, #667eea, #764ba2); }
        .debit { background: linear-gradient(135deg, #43cea2, #185a9d); }
    </style>
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
        
    
    <div class="container">
        <h2><u>Your Accounts</u></h2>

        <%
            Integer buyer_id = (Integer) session.getAttribute("U_Id");
            if(buyer_id == null){
                response.sendRedirect("index.jsp"); // redirect if not logged in
            }

            try {
                DB db = new DB();
                ResultSet rs = db.Select("SELECT * FROM buyer_account WHERE buyer_id=" + buyer_id);

                if(!rs.isBeforeFirst()){ // No rows
        %>
                    <div class="alert alert-info">No accounts found. <a href="buyer_account.jsp">Add an account</a></div>
        <%
                } else {
                    while(rs.next()){
                        String acc_id=rs.getString("buyer_acc_id");
                        String cardType = rs.getString("Card_Type");
                        String cardClass = cardType.equalsIgnoreCase("Credit") ? "credit" : "debit";
        %>
                        <div class="atm-card <%=cardClass%>">
                            <div class="card-type"><%= rs.getString("Card_Type") %></div>
                            <div class="card-number">
                                <%= rs.getString("Card_Number") %>
                            </div>
                            <div class="cardholder">Name:<%= rs.getString("Cardholder_Name") %></div>
                            <div class="expire-date">Exp: <%= rs.getString("Expire_Date") %></div>
                            <div class="card-brand">Brand:<%= rs.getString("Card_Brand") %></div>
                      
                             <br>
                             <br>   
                             <a href="default_1.jsp?id=<%=acc_id%>"><button class="book-button">Default</button></a>
                             <a href="remove.jsp?id=<%=acc_id%>"><button class="book-button">Remove</button></a>
                        </div>
        <%
                    }
                }
            } catch(Exception e){
                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                e.printStackTrace();
            }
        %>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
