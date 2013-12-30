<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
  -- $Id: find_audits.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapAudit" %>
<%@ page import="com.entelience.objects.audit.Audit" %>
<%@ page import="com.entelience.util.DateHelper" %>
<%@ page import="java.util.List" %>

<%@ page extends="com.entelience.servlet.JspBase" %>
<%
try {
	// code
	// Check session id validity
	Integer peopleId = getSession(request);
        initTimeZone(peopleId);
	Audit resultSearch[];
	String todaysDate = formatDate(DateHelper.now());
	String searchedText = getParam(request, "searchedText");
	
	int searchType = getParamInt(request, "searchType");
	
	String statusMatchAsString = getParam(request, "statusMatch");
	String confidentialityMatchAsString = getParam(request, "confidentialityMatch");
	String originMatchAsString = getParam(request, "originMatch");
	String topicMatchAsString = getParam(request, "topicMatch");
        String standardMatchAsString = getParam(request, "standardMatch");
	String raciMatch = getParam(request, "raciMatch");

	List<Number> statusMatch = toArray(statusMatchAsString);
	List<Number> confidentialityMatch = toArray(confidentialityMatchAsString);
	List<Number> originMatch = toArray(originMatchAsString);
	List<Number> topicMatch = toArray(topicMatchAsString);
	List<Number> standardMatch = toArray(standardMatchAsString);

	
	
	Integer pageNumber = getParamInteger(request, "pageNumber");
	String order = getParam(request, "order");
	String way = getParam(request, "way");
	Boolean my = getParamBoolean(request, "my");
	
	// Now we can use webservices
	soapAudit sa = new soapAudit(peopleId);
	
	resultSearch = sa.findAudits(searchedText, searchType, statusMatch, confidentialityMatch, originMatch, topicMatch, standardMatch, raciMatch, order, way, pageNumber, my);
	// end code
%>
<head>
<title>Search for audits - <%= todaysDate %></title>
<%@ include file="../style.inc.jsp" %>
</head>
<body>
<table width="100%" border="0" align="center" bgcolor="white">
<tr>
	<td>
	<div align="center">
	<!-- Header //-->
	<table border="0" align="center" cellspacing="0" cellpadding="4" width="100%">
	<tr>
		<td width="20%" rowspan="2" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
		<td width="80%" align="center" class="title">Search for audits</td>
	</tr>
	<tr>
		<td align="center" class="subtitle"><%= searchedText%></td>
	</tr>
	</table>
	<br/>
	<br/>
	<table border="1" align="center" cellspacing="0" cellpadding="4" width="90%">
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
	<table border="1" align="center" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td align="center">No audits found.</td>
	</tr>
	</table>
	<%
	} else {
	// results
	%>
			<br/>
			<table border="1" align="center" cellspacing="0" cellpadding="4" width="90%">
			<tr>
				<td align="center" bgcolor="gainsboro">Reference</td>
				<td align="center" bgcolor="gainsboro">Topic</td>
				<td align="center" bgcolor="gainsboro">Standard</td>
				<td align="center" bgcolor="gainsboro">Origin</td>
				<td align="center" bgcolor="gainsboro">Status</td>
				<td align="center" bgcolor="gainsboro">Confidentiality</td>
				<td align="center" bgcolor="gainsboro">Responsible</td>
				<td align="center" bgcolor="gainsboro">Start date</td>
				<td align="center" bgcolor="gainsboro">End date</td>
			</tr>
			<%	
			// now show content of each vuln
			for(int i=0; i<resultSearch.length; ++i) {
			Audit a = resultSearch[i];
			%>
			<tr>
				<td><%=HTMLEncode(a.getReference())%></td>
				<td><%=HTMLEncode(a.getTopic())%></td>
				<td><%=HTMLEncode(a.getStandardName())%></td>
				<td><%=HTMLEncode(a.getOrigin())%></td>
				<td><%=HTMLEncode(a.getStatus())%></td>
				<td><%=HTMLEncode(a.getConfidentiality())%></td>
				<td><%=HTMLEncode(a.getOwner())%></td>
				<td><%=formatDate(a.getStartDate())%></td>
				<td><%=formatDate(a.getEndDate())%></td>
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