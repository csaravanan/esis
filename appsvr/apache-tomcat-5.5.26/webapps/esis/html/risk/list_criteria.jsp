<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><!-- the HTML header allows us to view the jsp as an html file in web browsers -->
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
  -- $Id: list_criteria.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapRiskRegister" %>
<%@ page import="com.entelience.objects.risk.Criteria" %>
<%@ page import="com.entelience.util.DateHelper" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<% // code
try	{
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	// Now we can use webservices
	soapRiskRegister ri = new soapRiskRegister(peopleId);
	
	Integer categoryId = getParamInteger(request, "categoryId");
	String order = getParam(request, "order");
	String way = getParam(request, "way");
	Integer pageNumber = getParamInteger(request, "pageNumber");
	
	String todayDate = formatDate(DateHelper.now());
	Criteria[] criteria = ri.listCriteria(categoryId, order, way, pageNumber);
	// end code
%>
<!-- Now begins HTML page ...-->
<head>
<title>List of Criteria - <%= todayDate %> </title>
<%@ include file="../style.inc.jsp" %>
</head>
<body>
<!-- Main table -->
<table width="100%" border=0 bgcolor="white">
<tr>
	<td>
	<div align="center">
	<!-- Header table with title -->
	<table border=0 cellspacing=0 cellpadding=4 width="100%">
	<tr>
		<td width="20%" rowspan="2" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
		<td width="80%" align=center class=title>List of Criteria</td>
     </tr>
     <tr>
	 	<td align=center><%= todayDate %></td>
	</tr>
	</table>
	<!-- end Header table with title -->
	<br/>
	<%
	if (criteria == null || criteria.length == 0) {
	%>
	<br/>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td align="center">No criteria.</td>
	</tr>
	</table>
	<%
	} else {
	%>
	<!-- Detail table -->
	<br/>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td align="center" bgcolor="gainsboro">Reference</td>
		<td align="center" bgcolor="gainsboro">Description</td>
		<td align="center" bgcolor="gainsboro">Evaluation</td>
		<td align="center" bgcolor="gainsboro">Category</td>
		<td align="center" bgcolor="gainsboro">Answer type</td>
	</tr>
	<%
	// now show content of each vuln
	for(int i=0; i<criteria.length; ++i) {
	Criteria c = criteria[i];
	%>
	<tr>
		<td align="center"><%=HTMLEncode(c.getReference())%></td>
		<td align="center"><%=HTMLEncode(c.getDescription())%></td>
		<td align="center"><%=HTMLEncode(c.getCriteriaDescription())%></td>
		<td align="center"><%=HTMLEncode(c.getCategory())%></td>
		<td align="center"><%=HTMLEncode(c.getExpectedAnswerType())%></td>
	</tr>
	<%
	} // end for
	%>
	</table>
	<!-- end Detail table -->
	<%
	}
	%>
	<%@ include file="../copyright.inc.jsp" %>
	</div>
	</td>
</tr>
</table>
<!-- end Main table -->
</body>
</html>
<%
} catch(Exception e){
	_logger.error("Exception during JSP execution", e);
	setErrorMessage(response, e, getSessionId(request));
}
%>