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
  -- $Id: find_reports.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapAudit" %>
<%@ page import="com.entelience.objects.audit.Report" %>
<%@ page import="com.entelience.util.DateHelper" %>
<%@ page import="com.entelience.sql.DbHelper" %>
<%@ page import="java.util.List" %>

<%@ page extends="com.entelience.servlet.JspBase" %>
<%
// code
try {
      // Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
      // Now we can use webservices
	
	String todaysDate = formatDate(DateHelper.now());
	
	String searchedText = getParam(request, "searchedText");
	
	int searchType = getParamInt(request, "searchType");
	
	String statusMatchAsString = getParam(request, "statusMatch");
	String raciMatch = getParam(request, "raciMatch");
	
	List<Number> statusMatch = toArray(statusMatchAsString);
	
	Integer pageNumber = getParamInteger(request, "pageNumber");
	String order = getParam(request, "order");
	String way = getParam(request, "way");
	Boolean my = getParamBoolean(request, "my");
	
	soapAudit au = new soapAudit(peopleId);
	Report[] resultSearch = au.findReports(searchedText, searchType, statusMatch, raciMatch, order, way, pageNumber, my);

// end code
%>
<!-- Now begins HTML page ...-->
<head>
<title>Search for reports - <%= todaysDate %> </title>
<%@ include file="../style.inc.jsp" %>
</head>
<body>
<!-- Main table -->
<table width="100%" border="0" bgcolor="white">
<tr>
	<td>
	<div align="center">
	<!-- Header table with title -->
	<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0">
	<tr>
		<td width="20%" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
		<td width="80%" align="center" class="title">List of reports</td>
	</tr>
	</table>
	<table border="0" align="center" cellspacing="0" cellpadding="4" width="100%">
	<tr>
		<td align="center" class="subtitle"><%= searchedText%></td>
	</tr>
	</table>
	<br/>
	<br/>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
    <tr>
		<td width="30%" align="center">Search on</td>
		<td width="70%" align="center"><b><%= searchedText %></b></td>
	</tr>
	</table>
	<br/>
	<%
	if (resultSearch == null || resultSearch.length == 0) {
	%>
	<!-- no Vulns -->
	<br/>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td align="center">No reports found.</td>
	</tr>
	</table>
	<%
	} else {
	// results
	%>
	<br/>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td align="center" bgcolor="gainsboro">Title</td>
		<td align="center" bgcolor="gainsboro">Source</td>
		<td align="center" bgcolor="gainsboro">Subtitle</td>
		<td align="center" bgcolor="gainsboro">Executive summary</td>
		<td align="center" bgcolor="gainsboro">Status</td>
		<td align="center" bgcolor="gainsboro">Responsible</td>
		<td align="center" bgcolor="gainsboro">Audit Topic</td>
		<td align="center" bgcolor="gainsboro">Audit Standard</td>
		<td align="center" bgcolor="gainsboro">Audit Origin</td>
		<td align="center" bgcolor="gainsboro">Creation Date</td>
		<td align="center" bgcolor="gainsboro">Due Date</td>
	</tr>
	<%	
	// now show content of each vuln
	for(int i=0; i<resultSearch.length; ++i) {
	Report r = resultSearch[i];
	%>
	<tr>
		<td><%=HTMLEncode(r.getTitle())%></td>
		<td><%=HTMLEncode(r.getSource())%></td>
		<td><%=HTMLEncode(DbHelper.unnullify(r.getSubTitle()))%></td>
		<td><%=HTMLEncode(DbHelper.unnullify(r.getExecutiveSummary()))%></td>
		<td><%=HTMLEncode(r.getReportStatus())%></td>
		<td><%=HTMLEncode(r.getOwner())%></td>
		<td><%=HTMLEncode(r.getReport_topic())%></td>
		<td><%=HTMLEncode(r.getAuditStandard())%></td>
		<td><%=HTMLEncode(r.getOrigin())%></td>
		<td><%=formatDate(r.getCreation_date())%></td>
		<td><%=formatDate(r.getDueDate())%></td>
	</tr>
	<%
	}//end for
	%>
	</table>
	<%
	}// end if
	%>
	<%@ include file="../copyright.inc.jsp" %>
	</div>
	</td>
</tr>
</table>
</body>
</html>
<%
} catch(Exception e){
	_logger.error("Exception during JSP execution", e);
	setErrorMessage(response, e, getSessionId(request));
}
%>