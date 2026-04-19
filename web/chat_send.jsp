<%@page import="Connection.DB"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%
/*
  chat_send.jsp — Insert a chat message into chat_messages
  Used by BOTH buyer_chat.jsp AND seller_chat.jsp
  Session A_Name = aadhar of the logged-in user (buyer or seller)
  POST: sender, receiver, msg
*/
String sessionUser=(String)session.getAttribute("A_Name");
if(sessionUser==null) sessionUser=(String)session.getAttribute("User");
if(sessionUser==null){ out.print("{\"ok\":false,\"error\":\"session expired\"}"); return; }
String sender  =request.getParameter("sender");
String receiver=request.getParameter("receiver");
String msg     =request.getParameter("msg");
if(sender==null||receiver==null||msg==null||msg.trim().isEmpty()){
  out.print("{\"ok\":false,\"error\":\"missing params\"}"); return;
}
if(!sender.equals(sessionUser)){ out.print("{\"ok\":false,\"error\":\"unauthorized\"}"); return; }
msg=msg.trim().replace("'","\\'");
try{
  DB db=new DB();
  db.Insert("INSERT INTO chat_messages(sender_aadhar,receiver_aadhar,message,is_read) VALUES('"+sender+"','"+receiver+"','"+msg+"',0)");
  out.print("{\"ok\":true}");
}catch(Exception e){
  out.print("{\"ok\":false,\"error\":\""+e.getMessage().replace("\"","'").replace("\n"," ")+"\"}");
}
%>
