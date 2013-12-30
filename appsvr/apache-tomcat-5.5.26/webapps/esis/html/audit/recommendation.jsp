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
  -- $Id: recommendation.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<!-- The JSP used to send emails : simplified html -->
<%@ page import="com.entelience.soap.soapAudit" %>
<%@ page import="com.entelience.soap.soapRaci" %>
<%@ page import="com.entelience.objects.audit.AuditRecId" %>
<%@ page import="com.entelience.objects.audit.Recommendation" %>
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
	Boolean my = getParamBoolean(request, "my");
	Integer rid = getParamInteger(request, "recomId");
	if (rid == null)
		throw new Exception("Null parameter for recomId");
	AuditRecId recom_id = new AuditRecId(rid.intValue(), 0);
	
	soapAudit au = new soapAudit(peopleId);
	soapRaci rac = new soapRaci(peopleId);
	
	Recommendation rec = au.getRec(recom_id);
	RaciInfoLine[] racis_auditor = rac.listRacis(null, rec.getE_raci_obj_auditor(), null, null, null, null);
	RaciInfoLine[] racis_auditee = rac.listRacis(null, rec.getE_raci_obj_auditee(), null, null, null, null);
	// end code
%>
<head>
<title>Recommendation - <%= rec.getTitle() %></title>
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
			<td width="80%" align="center" class="title">Recommendation</td>
		</tr>
		</table>
		<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td align="center" class="subtitle"><%= rec.getTitle() %> (<%= rec.getReference() %>)</td>
		</tr>
		</table>
		<br/>
		<!-- Recommendations info -->
		<br/>
		<table width="90%" border="1" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Title</td>
			<td width="75%" align="center"><b><%= rec.getTitle() %></b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Reference</td>
			<td width="75%" align="center"><b><%= rec.getReference() %></b></td>
		</tr>
                <% if (rec.isCompliantAudit()){ %>
                <tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Compliance topic</td>
			<td width="75%" align="center"><b><%= rec.getComplianceTopicTitle() %></b></td>
		</tr>
                <% } else {%>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Primary topic</td>
			<td width="75%" align="center"><b><%= rec.getRec_primary_topic() %></b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Secondary topic</td>
			<td width="75%" align="center"><b><%= rec.getRec_secondary_topic() %></b></td>
		</tr>
		<% }%>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Target date</td>
			<td width="75%" align="center"><b><%= formatDate(rec.getTargetDate()) %></b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Status</td>
			<td width="75%" align="center"><b><%= rec.getRec_status() %></b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Closed date</td>
			<td width="75%" align="center"><b><%= formatDate(rec.getClosed_date()) %>&nbsp;</b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Creation date</td>
			<td width="75%" align="center"><b><%= formatDate(rec.getCreation_date()) %></b></td>
		</tr>
		<tr>
			<td colspan="2" align="center" height="30"><b>Auditor part</b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Recommendation</td>
			<td width="75%" align="center"><b><%= HTMLEncode(rec.getRecommendation()) %>&nbsp;</b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Severity</td>
			<td width="75%" align="center"><b><%= rec.getSeverity() %></b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Priority</td>
			<td width="75%" align="center"><b><%= rec.getPriority() %></b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Responsible</td>
			<td width="75%" align="center"><b><%= rec.getAuditor_owner_username() %></b></td>
		</tr>
                <tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Verification</td>
			<td width="75%" align="center"><b>
			<% if (rec.isDocumentedVerification()){ %>
			     &nbsp;Documented &nbsp;
			<% } if(rec.isInSituVerification()) {%>
			     &nbsp;In Situ&nbsp;
			<% } %>
			</b></td>
		</tr>
		<tr>
			<td colspan="2" align="center" height="30"><b>Auditee part</b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Auditee answer</td>
			<td width="75%" align="center"><b><%= HTMLEncode(rec.getAuditeeAnswer()) %>&nbsp;</b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Severity</td>
			<td width="75%" align="center"><b><%= rec.getAuditeeSeverity() %></b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Priority</td>
			<td width="75%" align="center"><b><%= rec.getAuditeePriority() %></b></td>
		</tr>
		<tr>
			<td width="25%" align="center" height="30" bgcolor="gainsboro">Responsible</td>
			<td width="75%" align="center"><b><%= rec.getAuditee_owner_username() %></b></td>
		</tr>
		</table>
		<%
		//DEPENDENCY datas
		//is dependent
		if (rec.isDependent()) {
		%>
		<br/>
		<table width="90%" border="1" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td align="center" height="30" bgcolor="gainsboro"><b>Blocking recommendations</b></td>
		</tr>
		<%
		Recommendation[] recBlocking = au.listBlockingRecommendations(recom_id, my);
		for (int l = 0; l < recBlocking.length; ++l) {
		%>
		<tr>
			<td align="left"><%= recBlocking[l].getTitle() %> (<%= recBlocking[l].getReference() %>)</td>
		</tr>
		<%
		}//end for
		%>
		</table>
		<%
		} //end is dependent
		//has dependent(s)
		if (rec.isHasDependent()) {
		%>
		<br/>
		<table width="90%" border="1" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td align="center" height="30" bgcolor="gainsboro"><b>Dependents recommendations</b></td>
		</tr>
		<%
		Recommendation[] recDependent = au.listDependentRecommendations(recom_id, my);
		for (int l = 0; l < recDependent.length; ++l) {
		%>
		<tr>
			<td align="left"><%= recDependent[l].getTitle() %> (<%= recDependent[l].getReference() %>)</td>
		</tr>
		<%
		}//end for
		%>
		</table>
		<%
		} //end has dependent(s)
		//is duplicate
		if (rec.isDuplicate()) {
		%>
		<br/>
		<table width="90%" border="1" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td align="center" height="30" bgcolor="gainsboro"><b>References recommendations</b></td>
		</tr>
		<%
		Recommendation[] recReference = au.listReferenceRecommendations(recom_id, my);
		for (int l = 0; l < recReference.length; ++l) {
		%>
		<tr>
			<td align="left"><%= recReference[l].getTitle() %> (<%= recReference[l].getReference() %>)</td>
		</tr>
		<%
		}//end for
		%>
		</table>
		<%
		} //end is duplcate
		//has duplicate(s)
		if (rec.isHasDuplicate()) {
		%>
		<br/>
		<table width="90%" border="1" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td align="center" height="30" bgcolor="gainsboro"><b>Duplicates recommendations</b></td>
		</tr>
		<%
		Recommendation[] recDuplicate = au.listDuplicateRecommendations(recom_id, my);
		for (int l = 0; l < recDuplicate.length; ++l) {
		%>
		<tr>
			<td align="left"><%= recDuplicate[l].getTitle() %> (<%= recDuplicate[l].getReference() %>)</td>
		</tr>
		<%
		}//end for
		%>
		</table>
		<%
		} //end has duplicate(s)
		%>
		<%
		//RACIS
		//raci auditor
		if(racis_auditor != null && racis_auditor.length > 0){
		%>
		<br/>
		<table width="90%" border="1" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td width="60%" align="center" bgcolor="gainsboro">Auditor stakeholder(s)</td>
			<td width="40%" align="center" bgcolor="gainsboro">RACI</td>
		</tr>
		<%
		for (int j = 0; j < racis_auditor.length; ++j) {
		%>
		<tr>
			<td width="60%" align="center"><%= racis_auditor[j].getUserName() %></td>
			<td width="40%" align="center"><b><%= racis_auditor[j].getRaci() %></b></td>
		</tr>
		<%
		}//end for
		%>
		</table>
		<%
		} // end racis auditor
		%>
		<%
		//raci auditee
		if (racis_auditee != null && racis_auditee.length > 0){
		%>
		<br/>
		<table width="90%" border="1" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td width="60%" align="center" bgcolor="gainsboro">Auditee stakeholder(s)</td>
			<td width="40%" align="center" bgcolor="gainsboro">RACI</td>
		</tr>
		<%
		for (int k = 0; k < racis_auditee.length; ++k) {
		%>
		<tr>
			<td width="60%" align="center"><%= racis_auditee[k].getUserName() %></td>
			<td width="40%" align="center"><b><%= racis_auditee[k].getRaci() %></b></td>
		</tr>
		<%
		}//end for
		%>
		</table>
		<%
		} // end racis auditee
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