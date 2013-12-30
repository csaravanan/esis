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
  -- $Id: audit.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<!-- The JSP used to send emails : simplified html -->
<%@ page import="com.entelience.soap.soapAudit" %>
<%@ page import="com.entelience.soap.soapRaci" %>
<%@ page import="com.entelience.objects.audit.AuditId" %>
<%@ page import="com.entelience.objects.audit.Audit" %>
<%@ page import="com.entelience.objects.audit.Interview" %>
<%@ page import="com.entelience.objects.raci.RaciInfoLine" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
// Class declarations
public String getCompleted(Interview i) {
	if (i.isCompleted()) {
		return "Yes";
	} else {
		return "No";
	}
}
// end Class declarations
%>
<%
try {
	// code
	// parameters
	// don't use seesion for emails, use parameter
	//=> getParamInteger(request, "user_id");
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	Boolean my = getParamBoolean(request, "my");
	Integer aid = getParamInteger(request, "auditId");
	if (aid == null)
		throw new Exception("Null parameter for auditId");
	AuditId audit_id = new AuditId(aid.intValue(), 0);
	
	soapAudit au = new soapAudit(peopleId);
	soapRaci rac = new soapRaci(peopleId);
	
	Audit ai = au.getAudit(audit_id);
	RaciInfoLine[] racis = rac.listRacis(null, ai.getE_raci_obj(), null, null, null, null);
	Interview[] interviews = au.getAuditInterviews(audit_id, my);
	// end code
%>
<head>
<title>Audit - <%= ai.getReference() %></title>
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
			<td width="80%" align="center" class="title">Audit</td>
		</tr>
		</table>
		<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td align="center" class="subtitle">reference : <%= HTMLEncode(ai.getReference()) %></td>
		</tr>
		</table>
		<br/>
		<br/>
		<!-- Audit info -->
		<!-- global table for audit -->
		<table width="90%" border="1" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td width="25%" height="30" bgcolor="gainsboro" align="center">Status</td>
			<td width="25%" align="center"><b><%= HTMLEncode(ai.getStatus()) %></b></td>
			<td width="25%" height="30" bgcolor="gainsboro" align="center">Confidentiality</td>
			<td width="25%" align="center"><b><%= HTMLEncode(ai.getConfidentiality()) %></b></td>
		</tr>
		<tr>
			<td width="25%" height="30" bgcolor="gainsboro" align="center">Start date</td>
			<td width="25%" align="center"><b><%= formatDate(ai.getStartDate()) %></b></td>
			<td width="25%" height="30" bgcolor="gainsboro" align="center">End date</td>
			<td width="25%" align="center"><b><%= formatDate(ai.getEndDate()) %></b></td>
		</tr>
		<tr>
			<td width="25%" height="30" bgcolor="gainsboro" align="center">Origin</td>
			<td width="25%" align="center"><b><%= HTMLEncode(ai.getOrigin()) %></b></td>
			<% if(ai.isCompliant()) {%>
			<td width="25%" height="30" bgcolor="gainsboro" align="center">Standard</td>
			<td width="25%" align="center"><b><%= HTMLEncode(ai.getStandardName()) %></b></td>
			<% } else {%>
			<td width="25%" height="30" bgcolor="gainsboro" align="center">Topic</td>
			<td width="25%" align="center"><b><%= HTMLEncode(ai.getTopic()) %></b></td>
			<% }%>
		</tr>
		<tr>
			<td width="25%" height="30" bgcolor="gainsboro" align="center">Responsible</td>
			<td width="25%" align="center"><b><%= HTMLEncode(ai.getOwner()) %></b></td>
			<td width="25%" height="30" bgcolor="gainsboro" align="center">Creation date</td>
			<td width="25%" align="center"><b><%= formatDate(ai.getCreationDate()) %></b></td>
		</tr>
		</table>
		<br/>
		<table width="90%" border="1" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Objectives</td>
			<td width="75%" align="left"><b><%= HTMLEncode(ai.getObjectives()) %>&nbsp;</b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Context</td>
			<td width="75%" align="left"><b><%= HTMLEncode(ai.getContext()) %></b>&nbsp;</td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Deliverables</td>
			<td width="75%" align="left"><b><%= HTMLEncode(ai.getDeliverables()) %>&nbsp;</b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Scope</td>
			<td width="75%" align="left"><b><%= HTMLEncode(ai.getScope()) %>&nbsp;</b></td>
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
		<%
		if (interviews != null && interviews.length > 0) {
		%>
		<br/>
		<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td align="center" class="subtitle">Interviews</td>
		</tr>
		</table>
		<table width="90%" border="1" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<th align="center" width="15%" bgcolor="gainsboro">Interview date</th>
			<th align="center" width="15%" bgcolor="gainsboro">Auditor</th>
			<th align="center" width="15%" bgcolor="gainsboro">Auditee</th>
			<th align="center" width="40%" bgcolor="gainsboro">Description</th>
			<th align="center" width="15%" bgcolor="gainsboro">Completed</th>
		</tr>
		<%
		for(int k = 0; k < interviews.length; ++k) {
		%>
		<tr>
			<td align="center"><%= formatDate(interviews[k].getItwDate()) %></td>
			<td align="center"><%= interviews[k].getAuditorName() %></td>
			<td align="center"><%= interviews[k].getAuditeeName() %></td>
			<td align="center"><%= interviews[k].getDescription() %></td>
			<td align="center"><%= getCompleted(interviews[k]) %></td>
		</tr>
		<%
		} //end for
		%>
		</table>
		<%
		} // end interviews
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