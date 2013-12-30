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
  -- $Id: list_riskreviews.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapRiskAssessment" %>
<%@ page import="com.entelience.objects.risk.RiskReview" %>
<%@ page import="com.entelience.objects.risk.RiskId" %>
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
	Boolean showToReview = getParamBoolean(request, "showToReview");
	RiskId riskId = null;
	try{
	    riskId =  new RiskId(getParamInteger(request, "riskId").intValue(), 0);
	} catch(Exception e){
	    riskId = null;
	}
	String order = getParam(request, "order");
	String way = getParam(request, "way");
	Integer pageNumber = getParamInteger(request, "pageNumber");
	
	String todayDate = formatDate(DateHelper.now());
	RiskReview[] riskreviews = ri.listRiskReviews(my, showToReview, riskId, order, way, pageNumber);
	// end code
%>
<!-- Now begins HTML page ...-->
<head>
<title>List of Risk Reviews - <%= todayDate %> </title>
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
		<td width="80%" align=center class=title>List of Risk Reviews</td>
     </tr>
     <tr>
	 	<td align=center><%= todayDate %></td>
	</tr>
	</table>
	<!-- end Header table with title -->
	<br/>
	<%
	if (riskreviews == null || riskreviews.length == 0) {
	%>
	<br/>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td align="center">No risk reviews.</td>
	</tr>
	</table>
	<%
	} else {
	%>
	<!-- Detail table -->
	<br/>
	<%
	// now show content of each vuln
	for(int i=0; i<riskreviews.length; ++i) {
	RiskReview r = riskreviews[i];
	%>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr>
		<td colspan="4" align="left" bgcolor="gainsboro"><b>Risk Review informations</b></td>
	</tr>
	<tr>
		<td width="25%" align="left" bgcolor="gainsboro">Reference</td>
		<td width="25%" align="left"><%=HTMLEncode(r.getReference())%></td>
		<td width="25%" align="left" bgcolor="gainsboro">Organisation</td>
		<td width="25%" align="left"><%=HTMLEncode(r.getOrganisationName())%></td>
	</tr>
	<tr>
		<td width="25" align="left" bgcolor="gainsboro">Treatment description</td>
		<td width="25%" align="left" bgcolor="gainsboro">Decision</td>
		<td width="25%" align="left" bgcolor="gainsboro">Priority</td>
		<td width="25%" align="left" bgcolor="gainsboro">Consequence level</td>
	</tr>
	<tr>
		<td align="left"><%=HTMLEncode(r.getTreatmentDescription())%></td>
		<td align="left"><%=HTMLEncode(r.getDecision())%></td>
		<td align="left"><%=HTMLEncode(r.getPriority())%></td>
		<td align="left"><%=HTMLEncode(r.getConsequenceLevel())%></td>
	</tr>
	<tr>
		<td align="left" bgcolor="gainsboro">Risk level</td>
		<td align="left" bgcolor="gainsboro">Last review</td>
		<td align="left" bgcolor="gainsboro">Adequacy of controls</td>
		<td align="left" bgcolor="gainsboro">Responsible</td>
	</tr>
	<tr>
		<td align="left"><%=HTMLEncode(r.getRiskLevel())%></td>
		<td align="left"><%=formatDate(r.getLastReview())%></td>
		<td align="left">
		<% if(r.getAdequacyOfControls() == null) {%>
		 &nbsp;
		<%} else {%>
		<%=r.getAdequacyOfControls() ? "yes" : "no"%>
		<%}%>
		</td>
		<td align="left"><%=HTMLEncode(r.getReviewResponsible())%></td>
	</tr>
	<tr>
		<td colspan="4" align="left" bgcolor="gainsboro"><b>Risk informations</b></td>
	</tr>
	<tr>
		<td align="left" bgcolor="gainsboro">Risk reference</td>
		<td align="left" bgcolor="gainsboro">Risk title</td>
		<td align="left" bgcolor="gainsboro">Risk description</td>
		<td align="left" bgcolor="gainsboro">Risk category</td>
	</tr>
	<tr>
		<td align="left"><%=HTMLEncode(r.getRiskReference())%></td>
		<td align="left"><%=HTMLEncode(r.getRiskTitle())%></td>
		<td align="left"><%=HTMLEncode(r.getRiskDescription())%></td>
		<td align="left"><%=HTMLEncode(r.getCategoryName())%></td>
	</tr>
	<tr>
		<td align="left" bgcolor="gainsboro">Risk review period</td>
		<td align="left" bgcolor="gainsboro">Risk forced review</td>
		<td align="left" bgcolor="gainsboro">Risk likelihood &amp; probability</td>
		<td align="left" bgcolor="gainsboro">Risk responsible</td>
	</tr>
	<tr>
		<td align="left"><%= r.getReviewPeriod()%> days</td>
		<td align="left"><%= r.isForcedReview() ? "yes" : "no"%></td>
		<td align="left"><%=HTMLEncode(r.getRiskLikelihood())%> (<%= r.getProbability()%>)</td>
		<td align="left"><%=HTMLEncode(r.getRiskResponsible())%></td>
	</tr>
	</table>
	<hr width="90%" />
	<%
	} // end for
	%>
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