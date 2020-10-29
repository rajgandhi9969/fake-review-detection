
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="FakeText.FakeTextFeatures" %>
<%@ page import="java.sql.*"%>

<%
    Connection conn=null;
   try{
       String asin=request.getParameter("asin");
       String reviewText=request.getParameter("reviewText").replaceAll("[(),]", "").replaceAll("'","\\\\'").replaceAll("\"\"","");
       String reviewerID=request.getParameter("reviewerID");
       Double overall=Double.parseDouble(request.getParameter("overall"));
       if(asin=="" || asin==null)
       {
           out.print("Incorrect input");
       }
       String connectionURL = "jdbc:mysql://localhost:3306/AmazonReviews\" +\n" +
               "                \"?sessionVariables=sql_mode='NO_ENGINE_SUBSTITUTION'&jdbcCompliantTruncation=false";

       Class.forName("com.mysql.jdbc.Driver").newInstance();
       conn = DriverManager.getConnection(connectionURL, "tempuser", "temp");
       FakeTextFeatures ft=new FakeTextFeatures();

       double featureSimilar=ft.Feature7_8_similar_reviews(reviewText,reviewerID,asin,conn);
       int count=1;
       String issues="";
       if(featureSimilar*100>80)
       {
           issues=issues+count+". Possible spam review due to high similarity with other reviews<br> ";
           count++;
       }
       int amazonName=ft.Feature3_seller_website(reviewText);
       if(amazonName==1)
       {
           issues=issues+count+". Seller review rather than product<br> ";
           count++;
       }

       Double outlier=ft.Feature6_outlier_review(overall,asin,conn);
       if(outlier==1)
       {
           issues=issues+count+". Huge deviation from other reviews<br> ";
           count++;
       }
       if(count==1)
       {
           out.print("True review");
       }
       else
       {
           out.print("Probably fake review due to: <br>");
           out.print(issues);
       }
   }
   catch (Exception e)
   {
       e.printStackTrace();
   }
   finally {

   }


%>
