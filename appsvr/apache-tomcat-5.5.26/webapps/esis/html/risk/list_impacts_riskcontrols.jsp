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
  -- $Id: list_impacts_riskcontrols.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapRiskAssessment" %>
<%@ page import="com.entelience.objects.risk.RiskControl" %>
<%@ page import="com.entelience.objects.risk.Impact" %>
<%@ page import="com.entelience.objects.risk.RiskId" %>
<%@ page import="com.entelience.objects.risk.RiskReviewId" %>
<%@ page import="com.entelience.util.DateHelper" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<% // code
try	{
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	// Now we can use webservices
	soapRiskAssessment ri = new soapRiskAssessment(peopleId);
	
	Boolean my = getParamBoolean(request, "my");
	Integer risk_id = getParamInteger(request, "riskId");
	RiskId riskId = null;
	if(risk_id != null){
		riskId = new RiskId(risk_id.intValue(), 0);
	}
	Integer review_id = getParamInteger(request, "reviewId");
	RiskReviewId reviewId = null;
	if(review_id != null){
		reviewId = new RiskReviewId(review_id.intValue(), 0);
	}
	Boolean showDeletedImpacts = getParamBoolean(request, "showDeletedImpacts");
	String orderImpacts = getParam(request, "orderImpacts");
	String wayImpacts = getParam(request, "wayImpacts");
	Integer pageNumberImpacts = getParamInteger(request, "pageNumberImpacts");
	Boolean showDeletedRiskControls = getParamBoolean(request, "showDeletedRiskControls");
	String orderRiskControls = getParam(request, "orderRiskControls");
	String wayRiskControls = getParam(request, "wayRiskControls");
	Integer pageNumberRiskControls = getParamInteger(request, "pageNumberRiskControls");
	
	String todayDate = formatDate(DateHelper.now());
	Impact[] impacts = ri.listImpacts(my, riskId, reviewId, showDeletedImpacts, orderImpacts, wayImpacts, pageNumberImpacts);
	RiskControl[] riskcontrols = ri.listRiskControls(my, riskId, reviewId, showDeletedRiskControls, orderRiskControls, wayRiskControls, pageNumberRiskControls);
	// end code
%>
<!-- Now begins HTML page ...-->
<head>
<title>List of Impacts &amp; Risk Controls - <%= todayDate %> </title>
<%@ include file="../style.inc.jsp" %>
</head>
<body>
<!-- Main table -->
<table width="100%" border=0 bgcolor="white">
<tr>
	<td>
	<div align="center">
	<!-- Header table with title -->
	<table border=0 cellspacing=0 cellpadding=4 width="100%">
	<tr>
		<td width="20%" rowspan="2" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
		<td width="80%" align=center class=title>List of Impacts &amp; Risk Controls</td>
     </tr>
     <tr>
	 	<td align=center><%= todayDate %></td>
	</tr>
	</table>
	<!-- end Header table with title -->
	<br/>
	<%
	if (impacts == null || impacts.length == 0) {
	%>
	<br/>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td align="center">No impacts.</td>
	</tr>
	</table>
	<%
	} else {
	%>
	<!-- Detail table -->
	<br/>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td colspan="5" align="center" bgcolor="gainsboro"><b>IMPACTS</b></td>
	</tr>
	<tr>
		<td align="center" bgcolor="gainsboro">Title</td>
		<td align="center" bgcolor="gainsboro">Description</td>
		<td align="center" bgcolor="gainsboro">Negative Consequence</td>
		<td align="center" bgcolor="gainsboro">Benefic Consequence</td>
		<td align="center" bgcolor="gainsboro">Deleted</td>
	</tr>
	<%
	// now show content of each vuln
	for(int i=0; i<impacts.length; ++i) {
	Impact im = impacts[i];
	%>
	<tr>
		<td align="center"><%=HTMLEncode(im.getTitle())%></td>
		<td align="center"><%=HTMLEncode(im.getDescription())%></td>
		<td align="center"><%= im.getBenefic() ? "-" : HTMLEncode(im.getConsequenceLevel())%></td>
		<td align="center"><%= im.getBenefic() ? HTMLEncode(im.getConsequenceLevel()) : "-"%></td>
		<td align="center"><%= im.isDeleted() ? "yes" : "no"%></td>
	</tr>
	<%
	} // end for
	%>
	</table>
	<!-- end Detail table -->
	<%
	}
	%>
	<br/>
	<%
	if (riskcontrols == null || riskcontrols.length == 0) {
	%>
	<br/>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td align="center">No risk controls.</td>
	</tr>
	</table>
	<%
	} else {
	%>
	<!-- Detail table -->
	<br/>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td colspan="5" align="center" bgcolor="gainsboro"><b>RISK CONTROLS</b></td>
	</tr>
	<tr>
		<td align="center" bgcolor="gainsboro">Resource requirement</td>
		<td align="center" bgcolor="gainsboro">Description</td>
		<td align="center" bgcolor="gainsboro">Responsible</td>
		<td align="center" bgcolor="gainsboro">Deleted</td>
	</tr>
	<%
	// now show content of each vuln
	for(int i=0; i<riskcontrols.length; ++i) {
	RiskControl rc = riskcontrols[i];
	%>
	<tr>
		<td align="center"><%=HTMLEncode(rc.getResourceRequirement())%></td>
		<td align="center"><%=HTMLEncode(rc.getDescription())%></td>
		<td align="center"><%=HTMLEncode(rc.getResponsible())%></td>
		<td align="center"><%= rc.isDeleted() ? "yes" : "no"%></td>
	</tr>
	<%
	} // end for
	%>
	</table>
	<!-- end Detail table -->
	<%
	}
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