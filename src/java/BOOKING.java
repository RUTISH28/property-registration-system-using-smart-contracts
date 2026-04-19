/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import Connection.DB;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.InvalidAlgorithmParameterException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import sun.misc.BASE64Encoder;

/**
 *
 * @author vinoth
 */
@WebServlet(urlPatterns = {"/BOOKING"})
public class BOOKING extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
 protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(true);
        try {
            String S_ID = request.getParameter("S_ID");
            String S_NAME = request.getParameter("S_NAME");
            String S_MAIL = request.getParameter("S_MAIL");
            String area = request.getParameter("area");
            String D_NO = request.getParameter("D_NO");
            String U_NAME = request.getParameter("U_NAME");
            String U_NUMBER = request.getParameter("U_NUMBER");
            String U_MAIL = request.getParameter("U_MAIL");
            String STS = request.getParameter("STS");
            String A_ACC = request.getParameter("A_ACC");
            String C_Type = request.getParameter("C_Type");
            String U_ACC = request.getParameter("U_ACC");
            String B_fess = request.getParameter("B_fess");
            String A_NAME = request.getParameter("A_NAME");
            String SUNO = request.getParameter("SUNO");
             String SA_Name = request.getParameter("SA_Name");
            String key = "0";
            //String apdate = request.getParameter("apdate");
            session.setAttribute("doc", D_NO);
            DB db1=new DB();
        System.out.println("insert into booking(S_ID, S_NAME, S_MAIL, area, D_NO, U_NAME, U_NUMBER, U_MAIL, STS, A_ACC, C_Type, U_ACC, B_fess, key, id,A_NAME,SUNO,SA_Name) values('" + S_ID + "','" + S_NAME + "','" + S_MAIL + "','" + area + "','" + D_NO + "','" + U_NAME + "','" + U_NUMBER + "','" + U_MAIL + "','" + STS + "','" + A_ACC + "','" + C_Type + "','" + U_ACC + "','" + B_fess + "','" + key + "','" + A_NAME + "',,'" + SUNO + "','"+SA_Name+"')");
            int i = db1.Insert("insert into booking(S_ID, S_NAME, S_MAIL, area, D_NO, U_NAME, U_NUMBER, U_MAIL, STS, A_ACC, C_Type, U_ACC, B_fess, key1,A_NAME,SUNO,SA_Name) values('" + S_ID + "','" + S_NAME + "','" + S_MAIL + "','" + area + "','" + D_NO + "','" + U_NAME + "','" + U_NUMBER + "','" + U_MAIL + "','" + STS + "','" + A_ACC + "','" + C_Type + "','" + U_ACC + "','" + B_fess + "','" + key + "','" + A_NAME + "','" + SUNO + "','"+SA_Name+"')");
           //int i = db.Insert("insert into user_phr_details(inputDate, U_Name, U_Id, Height, Weight, BB, bsugar, asugar, comp, Surgery, treat_given, treat_days, sugg, allergy, Aadhar_No, Comment, sey, id) values('" + inputDate + "','" + U_Name + "','" + U_Id + "','" + Height + "','" + Weight + "','" + BB + "','" + bsugar + "','" + asugar + "','" + comp + "','" + Surgery + "','" + treat_given + "','" + treat_days + "','" + sugg + "','" + allergy + "','" + Ano + "','" + cmnt + "','" + sey + ")");
           
           if (i > 0) {
                session.setAttribute("msg", "Inserted Successfully");
            }
            int dd = 0;
            ResultSet rs1 = db1.Select("select max(id) as dd from booking ");
            if (rs1.next()) {
                dd = rs1.getInt("dd");
            }
            String[] values = request.getParameterValues("cb");
             for (String str : values) {
                if (str.equals("1")) {
                    String plainData = S_ID, decryptedText;
                    KeyGenerator keyGen = KeyGenerator.getInstance("AES");
                    keyGen.init(128);
                    SecretKey secretKey = keyGen.generateKey();
                    Cipher aesCipher = Cipher.getInstance("AES");
                    aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
                    byte[] byteDataToEncrypt = plainData.getBytes();
                    byte[] byteCipherText = aesCipher.doFinal(byteDataToEncrypt);
                    S_ID = new BASE64Encoder().encode(byteCipherText);
                    try {
                        aesCipher.init(Cipher.DECRYPT_MODE, secretKey, aesCipher.getParameters());
                    } catch (InvalidAlgorithmParameterException ex) {
                        Logger.getLogger(User_Encrypt.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    byte[] byteDecryptedText = aesCipher.doFinal(byteCipherText);
                    decryptedText = new String(byteDecryptedText);
                    System.out.println("\n Plain Data : " + plainData + " \n Cipher Data : " + S_ID + " \n Decrypted Data : " + decryptedText);
                }
                if (str.equals("2")) {
                    String plainData = S_NAME, decryptedText;
                    KeyGenerator keyGen = KeyGenerator.getInstance("AES");
                    keyGen.init(128);
                    SecretKey secretKey = keyGen.generateKey();
                    Cipher aesCipher = Cipher.getInstance("AES");
                    aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
                    byte[] byteDataToEncrypt = plainData.getBytes();
                    byte[] byteCipherText = aesCipher.doFinal(byteDataToEncrypt);
                    S_NAME = new BASE64Encoder().encode(byteCipherText);
                    try {
                        aesCipher.init(Cipher.DECRYPT_MODE, secretKey, aesCipher.getParameters());
                    } catch (InvalidAlgorithmParameterException ex) {
                        Logger.getLogger(User_Encrypt.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    byte[] byteDecryptedText = aesCipher.doFinal(byteCipherText);
                    decryptedText = new String(byteDecryptedText);
                    System.out.println("\n Plain Data : " + plainData + " \n Cipher Data : " + S_NAME + " \n Decrypted Data : " + decryptedText);
                }
                if (str.equals("3")) {
                    String plainData = STS, decryptedText;
                    KeyGenerator keyGen = KeyGenerator.getInstance("AES");
                    keyGen.init(128);
                    SecretKey secretKey = keyGen.generateKey();
                    Cipher aesCipher = Cipher.getInstance("AES");
                    aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
                    byte[] byteDataToEncrypt = plainData.getBytes();
                    byte[] byteCipherText = aesCipher.doFinal(byteDataToEncrypt);
                    STS = new BASE64Encoder().encode(byteCipherText);
                    try {
                        aesCipher.init(Cipher.DECRYPT_MODE, secretKey, aesCipher.getParameters());
                    } catch (InvalidAlgorithmParameterException ex) {
                        Logger.getLogger(User_Encrypt.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    byte[] byteDecryptedText = aesCipher.doFinal(byteCipherText);
                    decryptedText = new String(byteDecryptedText);
                    System.out.println("\n Plain Data : " + plainData + " \n Cipher Data : " + STS + " \n Decrypted Data : " + decryptedText);
                }
                if (str.equals("4")) {
                    String plainData = B_fess, decryptedText;
                    KeyGenerator keyGen = KeyGenerator.getInstance("AES");
                    keyGen.init(128);
                    SecretKey secretKey = keyGen.generateKey();
                    Cipher aesCipher = Cipher.getInstance("AES");
                    aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
                    byte[] byteDataToEncrypt = plainData.getBytes();
                    byte[] byteCipherText = aesCipher.doFinal(byteDataToEncrypt);
                    B_fess = new BASE64Encoder().encode(byteCipherText);
                    try {
                        aesCipher.init(Cipher.DECRYPT_MODE, secretKey, aesCipher.getParameters());
                    } catch (InvalidAlgorithmParameterException ex) {
                        Logger.getLogger(User_Encrypt.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    byte[] byteDecryptedText = aesCipher.doFinal(byteCipherText);
                    decryptedText = new String(byteDecryptedText);
                    System.out.println("\n Plain Data : " + plainData + " \n Cipher Data : " + B_fess + " \n Decrypted Data : " + decryptedText);
                }
                if (str.equals("5")) {
                    String plainData = area, decryptedText;
                    KeyGenerator keyGen = KeyGenerator.getInstance("AES");
                    keyGen.init(128);
                    SecretKey secretKey = keyGen.generateKey();
                    Cipher aesCipher = Cipher.getInstance("AES");
                    aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
                    byte[] byteDataToEncrypt = plainData.getBytes();
                    byte[] byteCipherText = aesCipher.doFinal(byteDataToEncrypt);
                    area = new BASE64Encoder().encode(byteCipherText);
                    try {
                        aesCipher.init(Cipher.DECRYPT_MODE, secretKey, aesCipher.getParameters());
                    } catch (InvalidAlgorithmParameterException ex) {
                        Logger.getLogger(User_Encrypt.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    byte[] byteDecryptedText = aesCipher.doFinal(byteCipherText);
                    decryptedText = new String(byteDecryptedText);
                    System.out.println("\n Plain Data : " + plainData + " \n Cipher Data : " + area + " \n Decrypted Data : " + decryptedText);
                }
                if (str.equals("6")) {
                    String plainData = D_NO, decryptedText;
                    KeyGenerator keyGen = KeyGenerator.getInstance("AES");
                    keyGen.init(128);
                    SecretKey secretKey = keyGen.generateKey();
                    Cipher aesCipher = Cipher.getInstance("AES");
                    aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
                    byte[] byteDataToEncrypt = plainData.getBytes();
                    byte[] byteCipherText = aesCipher.doFinal(byteDataToEncrypt);
                    D_NO = new BASE64Encoder().encode(byteCipherText);
                    try {
                        aesCipher.init(Cipher.DECRYPT_MODE, secretKey, aesCipher.getParameters());
                    } catch (InvalidAlgorithmParameterException ex) {
                        Logger.getLogger(User_Encrypt.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    byte[] byteDecryptedText = aesCipher.doFinal(byteCipherText);
                    decryptedText = new String(byteDecryptedText);
                    System.out.println("\n Plain Data : " + plainData + " \n Cipher Data : " + D_NO + " \n Decrypted Data : " + decryptedText);
                }
                  if (str.equals("7")) {
                    String plainData = SUNO, decryptedText;
                    KeyGenerator keyGen = KeyGenerator.getInstance("AES");
                    keyGen.init(128);
                    SecretKey secretKey = keyGen.generateKey();
                    Cipher aesCipher = Cipher.getInstance("AES");
                    aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
                    byte[] byteDataToEncrypt = plainData.getBytes();
                    byte[] byteCipherText = aesCipher.doFinal(byteDataToEncrypt);
                    SUNO = new BASE64Encoder().encode(byteCipherText);
                    try {
                        aesCipher.init(Cipher.DECRYPT_MODE, secretKey, aesCipher.getParameters());
                    } catch (InvalidAlgorithmParameterException ex) {
                        Logger.getLogger(User_Encrypt.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    byte[] byteDecryptedText = aesCipher.doFinal(byteCipherText);
                    decryptedText = new String(byteDecryptedText);
                    System.out.println("\n Plain Data : " + plainData + " \n Cipher Data : " + SUNO + " \n Decrypted Data : " + decryptedText);
                }
                if (str.equals("8")) {
                    String plainData = U_NAME, decryptedText;
                    KeyGenerator keyGen = KeyGenerator.getInstance("AES");
                    keyGen.init(128);
                    SecretKey secretKey = keyGen.generateKey();
                    Cipher aesCipher = Cipher.getInstance("AES");
                    aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
                    byte[] byteDataToEncrypt = plainData.getBytes();
                    byte[] byteCipherText = aesCipher.doFinal(byteDataToEncrypt);
                    U_NAME = new BASE64Encoder().encode(byteCipherText);
                    try {
                        aesCipher.init(Cipher.DECRYPT_MODE, secretKey, aesCipher.getParameters());
                    } catch (InvalidAlgorithmParameterException ex) {
                        Logger.getLogger(User_Encrypt.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    byte[] byteDecryptedText = aesCipher.doFinal(byteCipherText);
                    decryptedText = new String(byteDecryptedText);
                    System.out.println("\n Plain Data : " + plainData + " \n Cipher Data : " + U_NAME + " \n Decrypted Data : " + decryptedText);
                }
                if (str.equals("9")) {
                    String plainData = U_NUMBER, decryptedText;
                    KeyGenerator keyGen = KeyGenerator.getInstance("AES");
                    keyGen.init(128);
                    SecretKey secretKey = keyGen.generateKey();
                    Cipher aesCipher = Cipher.getInstance("AES");
                    aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
                    byte[] byteDataToEncrypt = plainData.getBytes();
                    byte[] byteCipherText = aesCipher.doFinal(byteDataToEncrypt);
                    U_NUMBER = new BASE64Encoder().encode(byteCipherText);
                    try {
                        aesCipher.init(Cipher.DECRYPT_MODE, secretKey, aesCipher.getParameters());
                    } catch (InvalidAlgorithmParameterException ex) {
                        Logger.getLogger(User_Encrypt.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    byte[] byteDecryptedText = aesCipher.doFinal(byteCipherText);
                    decryptedText = new String(byteDecryptedText);
                    System.out.println("\n Plain Data : " + plainData + " \n Cipher Data : " + U_NUMBER + " \n Decrypted Data : " + decryptedText);
                }
                if (str.equals("10")) {
                    String plainData = U_MAIL, decryptedText;
                    KeyGenerator keyGen = KeyGenerator.getInstance("AES");
                    keyGen.init(128);
                    SecretKey secretKey = keyGen.generateKey();
                    Cipher aesCipher = Cipher.getInstance("AES");
                    aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
                    byte[] byteDataToEncrypt = plainData.getBytes();
                    byte[] byteCipherText = aesCipher.doFinal(byteDataToEncrypt);
                    U_MAIL = new BASE64Encoder().encode(byteCipherText);
                    try {
                        aesCipher.init(Cipher.DECRYPT_MODE, secretKey, aesCipher.getParameters());
                    } catch (InvalidAlgorithmParameterException ex) {
                        Logger.getLogger(User_Encrypt.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    byte[] byteDecryptedText = aesCipher.doFinal(byteCipherText);
                    decryptedText = new String(byteDecryptedText);
                    System.out.println("\n Plain Data : " + plainData + " \n Cipher Data : " + U_MAIL + " \n Decrypted Data : " + decryptedText);
                }
                if (str.equals("11")) {
                    String plainData = A_ACC, decryptedText;
                    KeyGenerator keyGen = KeyGenerator.getInstance("AES");
                    keyGen.init(128);
                    SecretKey secretKey = keyGen.generateKey();
                    Cipher aesCipher = Cipher.getInstance("AES");
                    aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
                    byte[] byteDataToEncrypt = plainData.getBytes();
                    byte[] byteCipherText = aesCipher.doFinal(byteDataToEncrypt);
                    A_ACC = new BASE64Encoder().encode(byteCipherText);
                    try {
                        aesCipher.init(Cipher.DECRYPT_MODE, secretKey, aesCipher.getParameters());
                    } catch (InvalidAlgorithmParameterException ex) {
                        Logger.getLogger(User_Encrypt.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    byte[] byteDecryptedText = aesCipher.doFinal(byteCipherText);
                    decryptedText = new String(byteDecryptedText);
                    System.out.println("\n Plain Data : " + plainData + " \n Cipher Data : " + A_ACC + " \n Decrypted Data : " + decryptedText);
                }
                if (str.equals("12")) {
                    String plainData = C_Type, decryptedText;
                    KeyGenerator keyGen = KeyGenerator.getInstance("AES");
                    keyGen.init(128);
                    SecretKey secretKey = keyGen.generateKey();
                    Cipher aesCipher = Cipher.getInstance("AES");
                    aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
                    byte[] byteDataToEncrypt = plainData.getBytes();
                    byte[] byteCipherText = aesCipher.doFinal(byteDataToEncrypt);
                    C_Type = new BASE64Encoder().encode(byteCipherText);
                    try {
                        aesCipher.init(Cipher.DECRYPT_MODE, secretKey, aesCipher.getParameters());
                    } catch (InvalidAlgorithmParameterException ex) {
                        Logger.getLogger(User_Encrypt.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    byte[] byteDecryptedText = aesCipher.doFinal(byteCipherText);
                    decryptedText = new String(byteDecryptedText);
                    System.out.println("\n Plain Data : " + plainData + " \n Cipher Data : " + C_Type + " \n Decrypted Data : " + decryptedText);
                }
                if (str.equals("13")) {
                    String plainData = U_ACC, decryptedText;
                    KeyGenerator keyGen = KeyGenerator.getInstance("AES");
                    keyGen.init(128);
                    SecretKey secretKey = keyGen.generateKey();
                    Cipher aesCipher = Cipher.getInstance("AES");
                    aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
                    byte[] byteDataToEncrypt = plainData.getBytes();
                    byte[] byteCipherText = aesCipher.doFinal(byteDataToEncrypt);
                    U_ACC = new BASE64Encoder().encode(byteCipherText);
                    try {
                        aesCipher.init(Cipher.DECRYPT_MODE, secretKey, aesCipher.getParameters());
                    } catch (InvalidAlgorithmParameterException ex) {
                        Logger.getLogger(User_Encrypt.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    byte[] byteDecryptedText = aesCipher.doFinal(byteCipherText);
                    decryptedText = new String(byteDecryptedText);
                    System.out.println("\n Plain Data : " + plainData + " \n Cipher Data : " + U_ACC + " \n Decrypted Data : " + decryptedText);
                }
              // if (str.equals("14")) {
                //    String plainData = apdate, decryptedText;
                  //  KeyGenerator keyGen = KeyGenerator.getInstance("AES");
                    //keyGen.init(128);
                    //SecretKey secretKey = keyGen.generateKey();
                    //Cipher aesCipher = Cipher.getInstance("AES");
                    //aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
                    //byte[] byteDataToEncrypt = plainData.getBytes();
                    //byte[] byteCipherText = aesCipher.doFinal(byteDataToEncrypt);
                    //apdate = new BASE64Encoder().encode(byteCipherText);
                    //try {
                      //  aesCipher.init(Cipher.DECRYPT_MODE, secretKey, aesCipher.getParameters());
                   // } catch (InvalidAlgorithmParameterException ex) {
                     //   Logger.getLogger(User_Encrypt.class.getName()).log(Level.SEVERE, null, ex);
                    //}
                    //byte[] byteDecryptedText = aesCipher.doFinal(byteCipherText);
                    //decryptedText = new String(byteDecryptedText);
                    //System.out.println("\n Plain Data : " + plainData + " \n Cipher Data : " + apdate + " \n Decrypted Data : " + decryptedText);
                //}
            }



            String query = "Select * from booking where S_ID='" + S_ID + "'";
            String query1 = "insert into booking1(S_ID, S_NAME, S_MAIL, area, D_NO, U_NAME, U_NUMBER, U_MAIL, STS, A_ACC, C_Type, U_ACC, B_fess, key1,A_NAME,SUNO,SA_Name) values('" + S_ID + "','" + S_NAME + "','" + S_MAIL + "','" + area + "','" + D_NO + "','" + U_NAME + "','" + U_NUMBER + "','" + U_MAIL + "','" + STS + "','" + A_ACC + "','" + C_Type + "','" + U_ACC + "','" + B_fess + "','" + key + "','"+A_NAME+"','"+SUNO+"','"+SA_Name+"')";
            System.out.println(query1);
            //String query1 = "insert into user_phr_details1(inputDate, U_Name, U_Id, Height, Weight, BB, bsugar, asugar, comp, Surgery, treat_given, treat_days, sugg, allergy, Aadhar_No, Comment, key, sey1) values('" + inputDate + "','" + U_Name + "','" + U_Id + "','" + Height + "','" + Weight + "','" + BB + "','" + bsugar + "','" + asugar + "','" + comp + "','" + Surgery + "','" + treat_given + "','" + treat_days + "','" + sugg + "','" + allergy + "','" + Ano + "','" + cmnt + "','" + sey + "','" + dd + "') ";
              System.out.println(query);
            ResultSet rs = db1.Select(query);
            if (rs.next()) {
                  System.out.println(query);
                int i1 = db1.Insert(query1);
                if (i1 > 0) {
                    session.setAttribute("msg", "Encryption details Successfully Added");
                    response.sendRedirect("house_buying.jsp");
                } else {
                    session.setAttribute("msg", "Data Base Error Can't Register");
                    response.sendRedirect("house_buying.jsp");
                }

            }
        } catch (Exception e) {
            session.setAttribute("msg", "Your data doesnot encrypted");
            response.sendRedirect("house_buying.jsp");
            out.println(e);
        } finally {
           // out.close();
        }
    }
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
