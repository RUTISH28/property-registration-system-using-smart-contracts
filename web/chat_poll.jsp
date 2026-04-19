<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DB"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%
/* chat_poll.jsp — return new messages since offset
   Returns JSON: {"messages":[{"text":"..","out":true,"time":"HH:MM"},...]}
*/
String buyer   = request.getParameter("buyer");
String seller  = request.getParameter("seller");
String sinceStr= request.getParameter("since");
int since = 0;
try{ if(sinceStr!=null) since=Integer.parseInt(sinceStr); }catch(Exception e){}

if(buyer==null||seller==null){
  out.print("{\"messages\":[]}");
  return;
}

StringBuilder json=new StringBuilder("{\"messages\":[");
try{
  DB db=new DB();
  ResultSet rs=db.Select(
    "SELECT sender_aadhar,message,sent_at FROM chat_messages "+
    "WHERE (sender_aadhar='"+buyer+"' AND receiver_aadhar='"+seller+"') "+
    "   OR (sender_aadhar='"+seller+"' AND receiver_aadhar='"+buyer+"') "+
    "ORDER BY sent_at ASC LIMIT 200");
  int idx=0; boolean first=true;
  while(rs.next()){
    if(idx>since){
      if(!first) json.append(",");
      first=false;
      String snd=rs.getString("sender_aadhar");
      String txt=rs.getString("message"); if(txt==null)txt="";
      String ts =rs.getString("sent_at");
      String timeStr=ts!=null&&ts.length()>=16?ts.substring(11,16):"";
      boolean isOut=snd.equals(buyer);
      txt=txt.replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n");
      json.append("{\"text\":\"").append(txt).append("\",\"out\":").append(isOut).append(",\"time\":\"").append(timeStr).append("\"}");
    }
    idx++;
  }
  /* mark incoming as read */
  DB dbR=new DB();
dbR.Update("UPDATE chat_messages SET is_read=1 WHERE receiver_aadhar='"+buyer+"' AND sender_aadhar='"+seller+"' AND is_read=0");
}catch(Exception e){}
json.append("]}");
out.print(json.toString());
%>
