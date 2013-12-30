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
  -- $Id: list_recommendations.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapAudit" %>
<%@ page import="com.entelience.soap.soapRaci" %>
<%@ page import="com.entelience.objects.audit.Report" %>
<%@ page import="com.entelience.objects.audit.Recommendation" %>
<%@ page import="com.entelience.objects.raci.RaciInfoLine" %>
<%@ page import="com.entelience.util.DateHelper" %>
<%@ page import="com.entelience.objects.audit.AuditReportId" %>
<%@ page import="com.entelience.objects.audit.AuditId" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<% // code
try {
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	// Now we can use webservices
	Recommendation rec;
	Recommendation[] recoms;
	Recommendation lr;
	soapAudit au = new soapAudit(peopleId);
	soapRaci sr = new soapRaci(peopleId); 
	String todaysDate = formatDate(DateHelper.now());
	Boolean my = getParamBoolean(request, "my");
	Boolean overdueActions = getParamBoolean(request, "overdueActions");
	Integer repId = getParamInteger(request, "report_id");
	AuditReportId report_id = null;
	if(repId != null)
		report_id = new AuditReportId(repId.intValue(), 0);
	Integer aud_id = getParamInteger(request, "audId");
	AuditId audId = null;
	if(aud_id != null)
		audId = new AuditId(aud_id.intValue(), 0);
	Integer recStatus = getParamInteger(request, "recStatus");
	Integer recPriority = getParamInteger(request, "recPriority");
	Integer recSeverity = getParamInteger(request, "recSeverity");
	Integer recPrimaryTopicId = getParamInteger(request, "recPrimaryTopicId");
	Integer recSecondaryTopicId = getParamInteger(request, "recSecondaryTopicId");
    String order = getParam(request, "order");
    String way = getParam(request, "way");
    Integer pageNumber = getParamInteger(request, "pageNumber");
	Report report = null;
	if(report_id != null)
	report = au.getReport(report_id);
	recoms = au.getListOfRecommendations(audId, report_id, recStatus, overdueActions.booleanValue(), recPriority, recSeverity, my, recPrimaryTopicId, recSecondaryTopicId, order, way, pageNumber);
	// end code
%>
<!-- Now begins HTML page ...-->
<head>
<title>List of recommendations - <%= todaysDate %> </title>
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
		<td width="80%" align="center" class="title">List of recommendations</td>
	</tr>
	<tr>
		<td align="center"><%= todaysDate %></td>
	</tr>
	</table>
	<!-- end Header table with title -->
	<br/>
	<%
	if(report != null){
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
	<br/>
	<!-- end Report table -->
	<%
	} //end if (report!= null)
	%>
	<%
	if (recoms == null || recoms.length == 0) {
	%>
	<!-- No data -->
	<br/>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td align="center">No recommendations.</td>
	</tr>
	</table>
	<%
	} else {
	      if (recoms.length>1) { // display anchors
	%>
		<!-- List titles -->
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td width="70%" align="center" bgcolor="gainsboro">Recommendation</td>
			<td width="10%" align="center" bgcolor="gainsboro">Priority</td>
			<td width="10%" align="center" bgcolor="gainsboro">Responsible</td>
			<td width="10%" align="center" bgcolor="gainsboro">Status</td>
		</tr>
		<%
		      for(int i=0; i<recoms.length; ++i) {
		      lr = recoms[i];
		%>
        		<!-- List with internal links -->
        		<tr>
        			<td align="center"><a href="#num<%= i %>"><%= lr.getTitle() %></a></td>
        			<td align="center"><%= lr.getPriority() %></td>
        			<td align="center"><%= lr.getAuditor_owner_username() %></td>
        			<td align="center"><%= lr.getRec_status() %></td>
        		</tr>
		<%
		} // end for
		%>
		<!-- end List table -->
		</table>
		<br/>
	<%
	} // end if recoms.length>1
	%>
	<!-- Detail table -->
	<br/>
	<table border="0" cellspacing="10" cellpadding="4" width="90%">
	<%
	// now show content of each vuln
	for(int i=0; i<recoms.length; ++i) {
	       rec = recoms[i];
	%>
		<tr>
			<td>
			<!-- One Detail table -->
			<a name="num<%= i %>"></a>
			<table border="1" cellspacing="0" cellpadding="4" width="100%">
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center"><b>Recommendation</b></td>
				<td width="75%" colspan="3" align="center"><b><%= HTMLEncode(rec.getTitle()) %></b></td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Reference</td>
				<td width="75%" colspan="3" align="center"><%= HTMLEncode(rec.getReference()) %>&nbsp;</td>
			</tr>
			<% if (rec.isCompliantAudit()){ %>
                                <tr>
                			<td width="25%" align="center" height="30" bgcolor="gainsboro">Compliance topic</td>
                			<td width="75%" colspan="3" align="center"><%= HTMLEncode(rec.getComplianceTopicTitle()) %></td>
                		</tr>
                        <% } else {%>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Primary topic</td>
				<td width="25%" align="center"><%= HTMLEncode(rec.getRec_primary_topic()) %>&nbsp;</td>
				<td width="25%" bgcolor="gainsboro" align="center">Secondary topic</td>
				<td width="25%" align="center"><%= HTMLEncode(rec.getRec_secondary_topic()) %>&nbsp;</td>
			</tr>
			<% }%>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Status</td>
				<td width="25%" align="center"><%= HTMLEncode(rec.getRec_status()) %>&nbsp;</td>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Target date</td>
				<td width="25%" align="center"><%= formatDate(rec.getTargetDate()) %>&nbsp;</td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Creation date</td>
				<td width="25%" align="center"><%= formatDate(rec.getCreation_date()) %>&nbsp;</td>
				<td width="25%" bgcolor="gainsboro" align="center">Close date</td>
				<td width="25%" align="center"><%=formatDate(rec.getClosed_date()) %>&nbsp;</td>
			</tr>
			<tr>
				<td height="30" colspan="4" align="center"><b>Auditor</b></td>
			</tr>
			<!--
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Responsible auditor</td>
				<td colspan="3" align="center"><%//= HTMLEncode(rec.getAuditor_owner_username()) %>&nbsp;</td>
			</tr>
			//-->
			<tr>
				<td colspan="3" width="75%" align="center" bgcolor="gainsboro">Auditor stakeholder(s)</td>
				<td width="25%" align="center" bgcolor="gainsboro">RACI</td>
			</tr>
			<%
			RaciInfoLine[] racis = sr.listRacis(null, rec.getE_raci_obj_auditor(), null, null, null, null);
			for(int j=0; j<racis.length; ++j) {
			%>
			<tr>
				<td colspan="3" width="75%" align="center"><%= racis[j].getUserName()%></td>
				<td width="25%" align="center"><%= racis[j].getRaci()%></td>
			</tr>
			<%
			} // end for
			%>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Auditor recommendation</td>
				<td width="75%" colspan="3" align="center"><%= HTMLEncode(rec.getRecommendation()) %>&nbsp;</td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Auditor priority</td>
				<td width="25%"><%= HTMLEncode(rec.getPriority()) %>&nbsp;</td>
				<td width="25%" bgcolor="gainsboro" align="center">Auditor severity</td>
				<td width="25%" align="center"><%= HTMLEncode(rec.getSeverity()) %>&nbsp;</td>
			</tr>
			<tr>
			        <td width="25%" align="center" height="30" bgcolor="gainsboro">Verification</td>
			        <td width="75%" colspan="3" align="center"><b>
			        <% if (rec.isDocumentedVerification()){ %>
			          &nbsp;Documented &nbsp;
			        <% } if(rec.isInSituVerification()) {%>
			          &nbsp;In Situ&nbsp;
			        <% } %>
			        </b></td>
		        </tr>
			<tr>
				<td height="30" colspan="4" align="center"><b>Auditee</b></td>
			</tr>
			<!--
			<tr>
				<td height="30" bgcolor="gainsboro" align="center">Responsible auditee</td>
				<td colspan="3" align="center"><%//= HTMLEncode(rec.getAuditee_owner_username()) %>&nbsp;</td>
			</tr>
			//-->
			<tr>
				<td colspan="3" width="75%" align="center" bgcolor="gainsboro">Auditee stakeholder(s)</td>
				<td width="25%" align="center" bgcolor="gainsboro">RACI</td>
			</tr>
			<%
			RaciInfoLine[] racis2 = sr.listRacis(null, rec.getE_raci_obj_auditee(), null, null, null, null);
			for(int j=0; j<racis2.length; ++j) {
			%>
			<tr>
				<td width="75%" colspan="3" width="75%" align="center"><%= racis2[j].getUserName()%></td>
				<td width="25%" align="center"><%= racis2[j].getRaci()%></td>
			</tr>
			<%
			} // end for
			%>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Auditee answer</td>
				<td width="75%" colspan="3" align="center"><%= HTMLEncode(rec.getAuditeeAnswer()) %>&nbsp;</td>
			</tr>
			<tr>
				<td width="25%" height="30" bgcolor="gainsboro" align="center">Auditee priority</td>
				<td width="25%" align="center"><%= HTMLEncode(rec.getAuditeePriority()) %>&nbsp;</td>
				<td width="25%" bgcolor="gainsboro" align="center">Auditee severity</td>
				<td width="25%" align="center"><%= HTMLEncode(rec.getAuditeeSeverity()) %>&nbsp;</td>
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