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
  -- $Id: list_actions.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapAudit" %>
<%@ page import="com.entelience.soap.soapRaci" %>
<%@ page import="com.entelience.objects.audit.Action" %>
<%@ page import="com.entelience.objects.audit.Report" %>
<%@ page import="com.entelience.objects.audit.Recommendation" %>
<%@ page import="com.entelience.objects.raci.RaciInfoLine" %>
<%@ page import="com.entelience.util.DateHelper" %>
<%@ page import="com.entelience.objects.audit.AuditReportId" %>
<%@ page import="com.entelience.objects.audit.AuditRecId" %>
<%@ page import="com.entelience.objects.audit.AuditId" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<% // code
try {
	Action actions[];
	Action la;
	Report report = null;
	Recommendation recom = null;
	Action act;

	String todaysDate;
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	// Now we can use webservices
	soapAudit au = new soapAudit(peopleId);
	soapRaci sr = new soapRaci(peopleId); 
	todaysDate = formatDate(DateHelper.now());

	Integer repId = getParamInteger(request, "report_id");
	AuditReportId report_id = null;
	if(repId != null)
		report_id = new AuditReportId(repId.intValue(), 0);

	Integer recId = getParamInteger(request, "recom_id");
	AuditRecId recom_id= null;
	if(recId != null){
		recom_id = new AuditRecId(recId.intValue(), 0);
	}
	Integer aud_id = getParamInteger(request, "audId");
	AuditId audId = null;
	if(aud_id != null)
		audId = new AuditId(aud_id.intValue(), 0);
	Boolean my = getParamBoolean(request, "my");
	Integer status_id = getParamInteger(request, "actionStatusId");
	Boolean open = getParamBoolean(request, "openAct");
    String order = getParam(request, "order");
    String way = getParam(request, "way");
    Integer pageNumber = getParamInteger(request, "pageNumber");

	if (null != report_id) {
        	report = au.getReport(report_id);
	} 

	if(null != recom_id){
		recom = au.getRec(recom_id);
	}
	actions = au.getListOfActions(audId, report_id, recom_id, my, status_id, open.booleanValue(), order, way, pageNumber);
	// end code
%>
<!-- Now begins HTML page ...-->
<head>
<title>List of actions - <%= todaysDate %></title>
<%@ include file="../style.inc.jsp" %>
</head>
<body>
<!-- Main table -->
<table width="100%" border="0" bgcolor="white">
<tr>
	<td>
	<div align="center">
	<!-- Header table with title -->
	<table border=0 cellspacing=0 cellpadding=4 width="100%">
	<tr>
		<td width="20%" rowspan="2" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
		<td width="80%" align="center" class="title">List of actions</td>
     </tr>
	 <tr>
	 	<td align="center"><%= todaysDate %></td>
	</tr>
	</table>
	<!-- end Header table with title -->
	<br/>
	<%
	if (report != null) {
	%>
	<!-- Report table -->
	<br/>
			<table border="1" cellspacing="0" cellpadding="4" width="90%">
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center"><b>Report</b></td>
				<td colspan="3" width="75%" align="left"><b><%= HTMLEncode(report.getTitle()) %></b></td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Subtitle</td>
				<td colspan="3" align="left"><%= HTMLEncode(report.getSubTitle()) %>&nbsp;</td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Executive summary</td>
				<td colspan="3" align="left"><%= HTMLEncode(report.getExecutiveSummary()) %>&nbsp;</td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Source</td>
				<td colspan="3" align="left"><%= HTMLEncode(report.getSource()) %>&nbsp;</td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Status</td>
				<td width="25%" align="center"><%= HTMLEncode(report.getReportStatus()) %>&nbsp;</td>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Due date</td>
				<td width="25%" align="center"><%= formatDate(report.getDueDate()) %>&nbsp;</td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Audit reference</td>
				<td width="75%" colspan="3" align="left"><%= HTMLEncode(report.getReference()) %>&nbsp;</td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Topic</td>
				<td width="25%" align="center"><%= HTMLEncode(report.getReport_topic()) %>&nbsp;</td>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Origin</td>
				<td width="25%" align="center"><%= HTMLEncode(report.getOrigin()) %>&nbsp;</td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Responsible</td>
				<td width="25%" align="center"><%= HTMLEncode(report.getOwner()) %>&nbsp;</td>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Creation date</td>
				<td width="25%" align="center"><%= formatDate(report.getCreation_date()) %>&nbsp;</td>
			</tr>
			</table>
	<!-- end Report table -->
	<br/>
	<%
	} // end if report
	%>
	<%
	if (recom != null) {
	%>
	<!-- Recommendation table -->
			<br/>
			<table border="1" cellspacing="0" cellpadding="4" width="90%">
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center"><b>Recommendation</b></td>
				<td width="75%" colspan="3" align="center"><b><%= HTMLEncode(recom.getTitle()) %></b></td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Reference</td>
				<td colspan="3" align="center"><%= HTMLEncode(recom.getReference()) %>&nbsp;</td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Primary topic</td>
				<td width="25%" align="center"><%= HTMLEncode(recom.getRec_primary_topic()) %>&nbsp;</td>
				<td width="25%" bgcolor="gainsboro" align="center">Secondary topic</td>
				<td width="25%" align="center"><%= HTMLEncode(recom.getRec_secondary_topic()) %>&nbsp;</td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Status</td>
				<td colspan="3" align="center"><%= HTMLEncode(recom.getRec_status()) %>&nbsp;</td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Creation date</td>
				<td width="25%" align="center"><%= formatDate(recom.getCreation_date()) %>&nbsp;</td>
				<td width="25%" bgcolor="gainsboro" align="center">Close date</td>
				<td width="25%" align="center"><%=formatDate(recom.getClosed_date()) %>&nbsp;</td>
			</tr>
			<tr>
				<td height="30" colspan="4" align="center"><b>Auditor</b></td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Responsible auditor</td>
				<td colspan="3" align="center"><%= HTMLEncode(recom.getAuditor_owner_username()) %>&nbsp;</td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Auditor recommendation</td>
				<td colspan="3" align="center"><%= HTMLEncode(recom.getRecommendation()) %>&nbsp;</td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Auditor priority</td>
				<td width="25%"><%= HTMLEncode(recom.getPriority()) %>&nbsp;</td>
				<td width="25%" bgcolor="gainsboro" align="center">Auditor severity</td>
				<td width="25%" align="center"><%= HTMLEncode(recom.getSeverity()) %>&nbsp;</td>
			</tr>
			<tr>
				<td height="30" colspan="4" align="center"><b>Auditee</b></td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Responsible auditee</td>
				<td colspan="3" align="center"><%= HTMLEncode(recom.getAuditee_owner_username()) %>&nbsp;</td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Auditee answer</td>
				<td colspan="3" align="center"><%= HTMLEncode(recom.getAuditeeAnswer()) %>&nbsp;</td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Auditee priority</td>
				<td width="25%" align="center"><%= HTMLEncode(recom.getAuditeePriority()) %>&nbsp;</td>
				<td width="25%" bgcolor="gainsboro" align="center">Auditee severity</td>
				<td width="25%" align="center"><%= HTMLEncode(recom.getAuditeeSeverity()) %>&nbsp;</td>
			</tr>
			</table>
			<br/>
	<!-- end Recommendation table -->
	<%
	} // end if recom
	%>
	<!-- List table with internal links -->
	<%
	if (actions == null || actions.length == 0) {
	%>
	<!-- No data -->
	<br/>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td align="center">No actions.</td>
	</tr>
	</table>
	<%
	} else {
		if (actions.length>1) { // display anchors
		%>
		<!-- List titles -->
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td width="70%" align="center" bgcolor="gainsboro">Action</td>
			<td width="10%" align="center" bgcolor="gainsboro">Status</td>
			<td width="10%" align="center" bgcolor="gainsboro">Responsible</td>
			<td width="10%" align="center" bgcolor="gainsboro">Due date</td>
		</tr>
		<%
		for(int i=0; i<actions.length; ++i) {
		la = actions[i];
		%>
		<!-- List with internal links -->
		<tr>     
			<td align="center"><a href="#num<%= i %>"><%= la.getTitle() %></a></td>
			<td align="center"><%= la.getAction_status() %></td>
			<td align="center"><%= la.getOwner_username() %></td>
			<td align="center"><%= formatDate(la.getDue_date()) %></td>
		</tr>
		<%
		} // end for
		%>
		<!-- end List table -->
		</table>
		<br/>
		<%
		} // end if actions.length>1
		%>
		<!-- Detail table -->
		<br/>
		<table border="0" cellspacing="0" cellpadding="0" width="90%">
		<%	
		// now show content of each vuln
		for(int i=0; i<actions.length; ++i) {
		act = actions[i];
		//au.getAction(actions[i].action_id);
		%>
		<tr>
			<td>
			<!-- One Detail table -->
			<a name="#num<%= i %>"></a>
			<table border="1" cellspacing="0" cellpadding="4" width="100%">
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center"><b>Title</b></td>
				<td width="75%" colspan="3" align="center"><b><%= HTMLEncode(act.getTitle()) %></b></td>
			</tr>
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Action</td>
				<td colspan="3" align="center"><%= HTMLEncode(act.getDescription()) %>&nbsp;</td>
			</tr>
			<tr>
				<td width="25%" align="center" height="30" bgcolor="gainsboro">Creation date</td>
				<td width="25%" align="center"><%= formatDate(act.getCreation_date()) %>&nbsp;</td>
				<td width="25%" align="center" height="30" bgcolor="gainsboro">Due date</td>
				<td width="25%" align="center"><%=formatDate(act.getDue_date()) %>&nbsp;</td>
			</tr>
			<tr>
				<td align="center" height="30" bgcolor="gainsboro">Status</td>
				<td colspan="3" align="center"><%= act.getAction_status() %>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3" align="center" height="30" bgcolor="gainsboro">Stakeholder(s)</td>
				<td align="center" bgcolor="gainsboro">RACI</td>
			</tr>
			<%
			RaciInfoLine[] racis2 = sr.listRacis(null, act.getE_raci_obj(), null, null, null, null);
			for(int j=0; j<racis2.length; ++j) {
			%>
			<tr>
				<td colspan="3" align="center"><%= racis2[j].getUserName()%></td>
				<td align="center"><%= racis2[j].getRaci()%></td>
			</tr>
			<%
			} // end for
			%>
			</table>
			<!-- end One Detail table -->
			</td>
		</tr>
		<%
		} // end for
		%>
		</table>
		<!-- end Detail table -->
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