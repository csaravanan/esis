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
  -- $Id: list_reports.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapAudit" %>
<%@ page import="com.entelience.objects.audit.ListReports" %>
<%@ page import="com.entelience.objects.audit.ExtReport" %>
<%@ page import="com.entelience.objects.audit.Report" %>
<%@ page import="com.entelience.util.DateHelper" %>
<%@ page import="com.entelience.objects.audit.AuditId" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<% // code
try {
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	// Now we can use webservices
	soapAudit au = new soapAudit(peopleId);
	Boolean my = getParamBoolean(request, "my");
	String todaysDate = formatDate(DateHelper.now());
	Boolean openRec = getParamBoolean(request, "openRec");
	Boolean openAct = getParamBoolean(request, "openAct");
	Boolean overdueActions = getParamBoolean(request, "overdueActions");
    String order = getParam(request, "order");
    String way = getParam(request, "way");
    Integer pageNumber = getParamInteger(request, "pageNumber");
	Integer audId = getParamInteger(request, "auditId");
	AuditId audit_id = null;
	if(audId != null)
		audit_id = new AuditId(audId.intValue(), 0);
	ListReports[] reports = au.getListOfReports(audit_id, openRec.booleanValue(), openAct.booleanValue(), overdueActions.booleanValue(), my,order, way, pageNumber);
	ListReports lr;
	ExtReport ext;
	Report rep;

// end code
%>
<!-- Now begins HTML page ...-->
<head>
<title>List of reports - <%= todaysDate %> </title>
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
		<td width="20%" rowspan="2" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
		<td width="80%" align="center" class="title">List of reports</td>
	</tr>
	<tr>
		<td align="center"><%= todaysDate %></td>
	</tr>
	</table>
	<br/>
	<!-- end Header table with title -->
	<%
	if (reports == null || reports.length == 0) {
	%>
	<!-- No data -->
	<br/>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td align="center">No reports.</td>
	</tr>
	</table>
	<%
	} else {
		if (reports.length>1) { // display anchors
		%>
		<!-- List titles -->
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td width="60%" align="center" bgcolor="gainsboro">Report</td>
			<td width="20%" align="center" bgcolor="gainsboro">Recommendations:<br/>open / close / risk accepted / total</td>
			<td width="20%" align="center" bgcolor="gainsboro">Actions:<br/>open / close / total</td>
		</tr>
		<%
		for(int i=0; i<reports.length; ++i) {
		lr = reports[i];
		ext = au.getReportExt(lr.getReport_id(), my);
		%>
		<!-- List with internal links -->
		<tr>
			<td align="center"><a href="#num<%= i %>"><%= lr.getTitle() %></a></td>
			<td align="center"><%= ext.getN_open_recs() %>&nbsp;/&nbsp;<%= ext.getN_closed_recs() %>&nbsp;/&nbsp;<%= ext.getN_risk_accepted_recs() %>&nbsp;/&nbsp;<%= lr.getN_recs() %></td>
			<td align="center"><%= ext.getN_actions_open() %>&nbsp;/&nbsp;<%= ext.getN_actions_closed() %>&nbsp;/&nbsp;<%= lr.getN_actions() %></td>
		</tr>
		<%
		} // end for
		%>
		</table>
		<!-- end List table -->
		<%
		} // end if reports.length>1
		%>
		<br/>
		<!-- Detail table -->
		<br/>
		<table border="0" cellspacing="0" cellpadding="4" width="90%">
		<%
		// now show content of each vuln
		for(int i=0; i<reports.length; ++i) {
		rep = au.getReport(reports[i].getReport_id());
		//rec = recoms[i];
		%>
		<tr>
			<td>
			<!-- One Detail table -->
			<a name="#num<%= i %>"></a>
			<table border="1" cellspacing="0" cellpadding="4" width="100%">
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center"><b>Report</b></td>
				<td colspan="3" width="75%" align="left"><b><%= HTMLEncode(rep.getTitle()) %></b></td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Subtitle</td>
				<td colspan="3" align="left"><%= HTMLEncode(rep.getSubTitle()) %>&nbsp;</td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Executive summary</td>
				<td colspan="3" align="left"><%= HTMLEncode(rep.getExecutiveSummary()) %>&nbsp;</td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Source</td>
				<td colspan="3" align="left"><%= HTMLEncode(rep.getSource()) %>&nbsp;</td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Status</td>
				<td width="25%" align="center"><%= HTMLEncode(rep.getReportStatus()) %>&nbsp;</td>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Due date</td>
				<td width="25%" align="center"><%= formatDate(rep.getDueDate()) %>&nbsp;</td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Audit reference</td>
				<td width="75%" colspan="3" align="left"><%= HTMLEncode(rep.getReference()) %>&nbsp;</td>
			</tr>
			
			<tr>
			     <% if(rep.getReport_topic() == null) {%>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Audit standard</td>
				<td width="25%" align="center"><%= HTMLEncode(rep.getAuditStandard()) %>&nbsp;</td>
	                     <% } else { %>
	                        <td width="25%" height="30" bgcolor="gainsboro" align="center">Audit topic</td>
				<td width="25%" align="center"><%= HTMLEncode(rep.getReport_topic()) %>&nbsp;</td>
	                     <% } %>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Audit origin</td>
				<td width="25%" align="center"><%= HTMLEncode(rep.getOrigin()) %>&nbsp;</td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Responsible</td>
				<td width="25%" align="center"><%= HTMLEncode(rep.getOwner()) %>&nbsp;</td>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Creation date</td>
				<td width="25%" align="center"><%= formatDate(rep.getCreation_date()) %>&nbsp;</td>
			</tr>
			</table>
			<!-- end One Detail table -->
			</td>
		</tr>
		<%
		} // end for
		%>
		</table>
		<%
	} // end if recoms
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