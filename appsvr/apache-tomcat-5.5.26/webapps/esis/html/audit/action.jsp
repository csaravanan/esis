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
  -- $Id: action.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<!-- The JSP used to send emails : simplified html -->
<%@ page import="com.entelience.soap.soapAudit" %>
<%@ page import="com.entelience.soap.soapRaci" %>
<%@ page import="com.entelience.objects.audit.AuditActionId" %>
<%@ page import="com.entelience.objects.audit.Action" %>
<%@ page import="com.entelience.objects.raci.RaciInfoLine" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%
try {
	// code
	// parameters
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	Integer aid = getParamInteger(request, "actionId");
	if (aid == null)
		throw new Exception("Null parameter for actionId");
	AuditActionId action_id = new AuditActionId(aid.intValue(), 0);
	
	soapAudit au = new soapAudit(peopleId);
	soapRaci rac = new soapRaci(peopleId);
	
	Action ac = au.getAction(action_id);
	RaciInfoLine[] racis = rac.listRacis(null, ac.getE_raci_obj(), null, null, null, null);
	// end code
%>
<head>
<title>Action - <%= ac.getTitle() %></title>
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
			<td width="80%" align="center" class="title">Action</td>
		</tr>
		</table>
		<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0">
		<tr><td align="center" class="subtitle"><%= HTMLEncode(ac.getTitle()) %></td></tr>
		<tr><td align="center" class="subtitle">linked to recommendation: <%= ac.getRecom_title() %></td></tr>
		</table>
		<br/>
		<!-- Action info -->
		<br/>
		<table width="90%" border="1" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Action title</td>
			<td width="75%" align="center"><b><%= ac.getTitle() %></b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Description</td>
			<td width="75%" align="center"><b><%= HTMLEncode(ac.getDescription()) %>&nbsp;</b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">External reference</td>
			<td width="75%" align="center"><b><%= HTMLEncode(ac.getExternalRef()) %>&nbsp;</b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Due date</td>
			<td width="75%" align="center"><b><%= formatDate(ac.getDue_date()) %></b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Status</td>
			<td width="75%" align="center"><b><%= ac.getAction_status() %></b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Responsible</td>
			<td width="75%" align="center"><b><%= ac.getOwner_username() %></b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Closed date</td>
			<td width="75%" align="center"><b><%= formatDate(ac.getClosed_date()) %>&nbsp;</b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Creation date</td>
			<td width="75%" align="center"><b><%= formatDate(ac.getCreation_date()) %></b></td>
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