<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" 
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
<!-- the HTML header allows us to view the jsp as an html file in web browsers -->
<%--
  -- ESIS
  --
  -- Copyright (c) 2004-2008 Entelience SARL,  Copyright (c) 2008-2009 Equity SA
  --
  -- Projects contributors : Philippe Le Berre, Thomas Burdairon, Benjamin Baudel,
  --                         Benjamin S. Gould, Diego Patinos Ramos, Constantin Cornelie
  -- 
  -- This file is part of ESIS.
  --
  -- ESIS is free software: you can redistribute it and/or modify
  -- it under the terms of the GNU General Public License as published by
  -- the Free Software Foundation version 3 of the License.
  --
  -- ESIS is distributed in the hope that it will be useful,
  -- but WITHOUT ANY WARRANTY; without even the implied warranty of
  -- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  -- GNU General Public License for more details.
  --
  -- You should have received a copy of the GNU General Public License
  -- along with ESIS.  If not, see <http://www.gnu.org/licenses/>.
  --
  -- $Id: reports.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="java.util.List"%>
<%@ page import="com.entelience.export.DocumentHelper"%>
<%@ page import="com.entelience.objects.GeneratedDocument"%>
<%@ page import="com.entelience.sql.Db"%>
<%@ page import="com.entelience.util.DateHelper"%>
<%@ page extends="com.entelience.servlet.JspBase" %>

<%
//get parameters
String customer_name = getParam(request, "customer_name");
String customer_css = getParam(request, "customer_css");
String language = getParam(request, "language");

String color1 = "#efefef";
String color2 = "#cccccc";
String colorSelected = color1;
String emptyText = "No available report file.";

//use the db connexion corresponding to the company (customer_name)
Db db = getDb(customer_name);
try{
        db.enter();
        List<GeneratedDocument> docs = DocumentHelper.listGeneratedDocuments(db, null, null, null, null);
%>
<head>
<title>Reports list</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" media="screen" type="text/css" title="Menu" href="/<%=customer_name%>/css/<%=customer_css%>" />
</head>
<body>
	<table width="580" cellpadding="3" cellspacing="0" border="1">
	<tr>
		<th align="center"><%
		if("fr".equals(language)){%>
		Rapports disponibles
		<%}else{%>
		Available reports
		<%}%></th>
		<th align="center"><%
		if("fr".equals(language)){%>
		Date de generation
		<%}else{%>
		Generation date
		<%}%></th>
		<th align="center"><%
		if("fr".equals(language)){%>
		Taille
		<%}else{%>
		Size
		<%}%></th>
		<th align="center"><%
		if("fr".equals(language)){%>
		Type de contenu
		<%}else{%>
		Content type
		<%}%></th>
	</tr>
	<%
	for(int i=0;i<docs.size();i++){
	   GeneratedDocument doc = docs.get(i);
   	   if(i%2==0){
		colorSelected = color2;
	   }else{
		colorSelected = color1;
	   } 
	 %>
	 <tr><td align="left" bgcolor="<%= colorSelected %>">
	     <a href="html/portal/generateddocument?id=<%= doc.getDocumentId() %>&cie=<%= customer_name %>">
	     <%= HTMLEncode(doc.getTitle()) %>
	     </a>
	 </td>
	 <td align="left" bgcolor="<%= colorSelected %>">
	     <%= DateHelper.HTMLDate(doc.getGenerationDate()) %>
	 </td>
	 <td align="left" bgcolor="<%= colorSelected %>">
	     <%= HTMLEncode(doc.getSizeString()) %>
	 </td>
	 <td align="left" bgcolor="<%= colorSelected %>">
	     <%= HTMLEncode(doc.getContentType()) %>
	 </td>
	 </tr>
<%
        }
%>		
	
	</table>
</body>
<%

} finally {
	db.exit();
}

%>
</html>
