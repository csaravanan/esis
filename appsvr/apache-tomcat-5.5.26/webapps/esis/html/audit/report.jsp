<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
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
  -- $Id: report.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<!-- The JSP used to send emails : simplified html -->
<%@ page import="com.entelience.soap.soapAudit" %>
<%@ page import="com.entelience.soap.soapRaci" %>
<%@ page import="com.entelience.objects.audit.AuditReportId" %>
<%@ page import="com.entelience.objects.audit.Report" %>
<%@ page import="com.entelience.objects.raci.RaciInfoLine" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%
try {
	// code
	// parameters
	// don't use seesion for emails, use parameter
	//=> getParamInteger(request, "user_id");
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	Integer rid = getParamInteger(request, "report_id");
	if (rid == null)
		throw new Exception("Null parameter for report_id");
	AuditReportId report_id = new AuditReportId(rid.intValue(), 0);
	
	soapAudit au = new soapAudit(peopleId);
	soapRaci rac = new soapRaci(peopleId);
	
	Report re = au.getReport(report_id);
	RaciInfoLine[] racis = rac.listRacis(null, re.getE_raci_obj(), null, null, null, null);
	// end code
%>
<head>
<title>Report - <%= re.getTitle() %></title>
<%@ include file="../style.inc.jsp" %>
</head>
<body>
<table width="100%" border="0" align="center" bgcolor="white" cellpadding="0" cellspacing="0">
<tr>
	<td>
		<div align="center">
		<!-- Header -->
		<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td width="20%" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
			<td width="80%" align="center" class="title">Report</td>
		</tr>
		</table>
		<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td align="center" class="subtitle"><%= re.getTitle() %></td>
		</tr>
		</table>
		<br/>
		<br/>
		<!-- Report info -->
			<table border="1" cellspacing="0" cellpadding="4" width="90%">
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Title</td>
				<td width="75%" align="center"><%= HTMLEncode(re.getTitle()) %></td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Subtitle</td>
				<td width="75%" align="center"><%= HTMLEncode(re.getSubTitle()) %></td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Executive summary</td>
				<td width="75%" align="center"><%= HTMLEncode(re.getExecutiveSummary()) %></td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Source</td>
				<td align="center"><%= HTMLEncode(re.getSource()) %></td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Status</td>
				<td width="75%" align="center"><%= HTMLEncode(re.getReportStatus()) %></td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Due date</td>
				<td width="75%" align="center"><%= formatDate(re.getDueDate()) %></td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Audit reference</td>
				<td width="75%" align="center"><%= HTMLEncode(re.getReference()) %></td>
			</tr>
			<% if(re.getReport_topic() == null) {%>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Audit standard</td>
				<td width="75%" align="center"><%= HTMLEncode(re.getAuditStandard()) %></td>
			</tr>
			<% } else { %>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Audit topic</td>
				<td width="75%" align="center"><%= HTMLEncode(re.getReport_topic()) %></td>
			</tr>
			<% } %>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Audit origin</td>
				<td width="75%" align="center"><%= HTMLEncode(re.getOrigin()) %></td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Responsible</td>
				<td width="75%" align="center"><%= HTMLEncode(re.getOwner()) %></td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Creation date</td>
				<td width="75%" align="center"><%= formatDate(re.getCreation_date()) %></td>
			</tr>
			</table>
		<% 
		if(racis != null && racis.length > 0){
		%>
		<br/>
		<table width="90%" border="1" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td width="60%" align="center" bgcolor="gainsboro">Stakeholder(s)</td>
			<td width="40%" align="center" bgcolor="gainsboro">RACI</td>
		</tr>
		<%
		for (int j = 0; j < racis.length; ++j) {
		%>
		<tr>
			<td width="60%" align="center"><%= racis[j].getUserName() %></td>
			<td width="40%" align="center"><b><%= racis[j].getRaci() %></b></td>
		</tr>
		<%
		}//end for
		%>
		</table>
		<%
		} // end racis
		%>
		<%@ include file="../copyright.inc.jsp" %>
		</div>
	</td>
</tr>
</table>
</body>
</html>
<%
} catch(Exception e) {
	_logger.error("Exception during JSP execution", e);
	setErrorMessage(response, e, getSessionId(request));
}
%>