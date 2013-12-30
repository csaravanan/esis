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
  -- $Id: list_interviews.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapAudit" %>
<%@ page import="com.entelience.objects.audit.Audit" %>
<%@ page import="com.entelience.objects.audit.Interview" %>
<%@ page import="com.entelience.util.DateHelper" %>
<%@ page import="com.entelience.objects.audit.AuditId" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
//Class declarations
public String getCompleted(Interview i){
	if (i.isCompleted()) {
		return "Yes";
	} else {
		return "No";
	}
}
%>
<% // code
try{
	Interview interviews[] = null;
	Interview in;
	Audit audit = null;
	String todaysDate;
	
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	// Now we can use webservices
	soapAudit au = new soapAudit(peopleId);
	todaysDate = formatDate(DateHelper.now());

	Integer audId = getParamInteger(request, "auditId");
	AuditId audit_id = null;
	if (audId != null) {
		audit_id = new AuditId(audId.intValue(), 0);
	}
	Boolean my = getParamBoolean(request, "my");

	if (null != audit_id) {
		audit = au.getAudit(audit_id);
		interviews = au.getAuditInterviews(audit_id, my);
	}
	
// end code
%>
<!-- Now begins HTML page ...-->
<head>
<title>List of Interviews - <%= todaysDate %></title>
<%@ include file="../style.inc.jsp" %>
</head>
<body>
<!-- Main table -->
<table width="100%" border="0" bgcolor="white">
<tr>
	<td>
	<div align="center">
	<!-- Header table with title -->
	<table border="0" cellspacing="0" cellpadding="4" width="100%">
	<tr>
		<td width="20%" rowspan="2" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
		<td width="80%" align="center" class="title">List of interviews</td>
	</tr>
	<tr>
		<td align="center"><%= todaysDate %></td>
	</tr>
	</table>
	<!-- end Header table with title -->
	<br/>
	<%
	if (audit != null) {
	%>
	<!-- Audit table -->
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td colspan="8" align="center"><b>Audit</b></td>
	</tr>
	<tr>
		<td align="center" bgcolor="gainsboro">Reference</td>
		<td align="center" bgcolor="gainsboro">Topic</td>
		<td align="center" bgcolor="gainsboro">Origin</td>
		<td align="center" bgcolor="gainsboro">Status</td>
		<td align="center" bgcolor="gainsboro">Confidentiality</td>
		<td align="center" bgcolor="gainsboro">Responsible</td>
		<td align="center" bgcolor="gainsboro">Start date</td>
		<td align="center" bgcolor="gainsboro">End date</td>
	</tr>
	<tr>
		<td align="center"><%=HTMLEncode(audit.getReference())%></td>
		<td align="center"><%=HTMLEncode(audit.getTopic())%></td>
		<td align="center"><%=HTMLEncode(audit.getOrigin())%></td>
		<td align="center"><%=HTMLEncode(audit.getStatus())%></td>
		<td align="center"><%=HTMLEncode(audit.getConfidentiality())%></td>
		<td align="center"><%=HTMLEncode(audit.getOwner())%></td>
		<td align="center"><%=formatDate(audit.getStartDate())%></td>
		<td align="center"><%=formatDate(audit.getEndDate())%></td>
	</tr>
	</table>
	<br/>
	<!-- end Audit table -->
	<%
	} // end if audit
	%>
	<!-- List table with internal links -->
	<br/>
	<%
	if (interviews == null || interviews.length == 0) {
	%>
	<!-- No data -->
	<br/>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td align="center">No interviews.</td>
	</tr>
	</table>
	<%
	} else {
		if (interviews.length > 1) {
	%>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td width="10%" align="center" bgcolor="gainsboro">Interview date</td>
		<td width="20%" align="center" bgcolor="gainsboro">Auditor</td>
		<td width="20%" align="center" bgcolor="gainsboro">Auditee</td>
		<td width="40%" align="center" bgcolor="gainsboro">Description</td>
		<td width="10%" align="center" bgcolor="gainsboro">Completed</td>
	</tr>
	<%
	for(int i=0; i < interviews.length; ++i) {
	in = interviews[i];
	%>
	<tr>
		<td align="center"><%= formatDate(in.getItwDate()) %></td>
		<td align="center"><%= in.getAuditorName() %></td>
		<td align="center"><%= in.getAuditeeName() %></td>
		<td align="left"><%= in.getDescription() %></td>
		<td align="center"><%= getCompleted(in) %></td>
	</tr>
	<%
	} // end for
	%>
	</table>
	<!-- end List table -->
	<%
	} // end if interviews.length
	} //end if interviews
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