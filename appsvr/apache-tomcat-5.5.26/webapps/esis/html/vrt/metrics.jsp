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
  -- $Id: metrics.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapVulnerabilityReview" %>
<%@ page import="com.entelience.objects.DropDown" %>
<%@ page import="com.entelience.objects.metrics.MetricDetail" %>
<%@ page import="com.entelience.util.DateHelper" %>
<%@ page import="java.lang.reflect.Array" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%
// code
// Check session id validity
try{
	String[][] groups;
	String[] names;
	int len;
	MetricDetail md;
	DropDown[] se;
	String todaysDate;
	int SECBYDAY;
	java.text.NumberFormat nf;
	
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	// Now we can use webservices
	soapVulnerabilityReview vr = new soapVulnerabilityReview(peopleId);
	
	groups = new String[3][];
	groups[0] = new String[] {"triaged", "added", "ignored", "to repair", "investigated", "risk accepted", "opened", "fixed" };
	groups[1] = new String[] {"time2vrt", "time2open"};
	groups[2] = new String[] {"time2close0", "time2close1", "time2close2", "time2close3", "time2close4"};
	
	se = vr.getListOfSeverity();
	todaysDate = formatDate(DateHelper.now());
	SECBYDAY = 3600 * 24;
	nf = java.text.NumberFormat.getInstance();
	// end code
%>
<head>
<title>VRT Metrics</title>
<%@ include file="../style.inc.jsp" %>
</head>
<body>
<table width="100%" border="0" align="center" bgcolor="white">
<tr>
	<td>
		<div align="center">
		<!-- Header -->
		<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td width="20%" rowspan="2" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
			<td width="80%" align="center" class="title">VRT Metrics</td>
		</tr>
		<tr>
			<td align="center"><%= todaysDate %></td>
		</tr>
		</table>
		<br/>
		<!-- Compliancy Metrics-->
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td colspan="5" align="center" class="subtitle"><%= HTMLTitle("Compliance", null) %></td>
		</tr>
		<tr>
			<td align="center" width="40%" bgcolor="gainsboro"><b>Vulnerability Status</b></td>
			<td width="15%" align="center" bgcolor="gainsboro"><b>Size</b></td>
			<td width="15%" align="center" bgcolor="gainsboro"><b>Rate</b></td>
			<td width="15%" align="center" bgcolor="gainsboro"><b>Target</b></td>
			<td width="15%" align="center" bgcolor="gainsboro"><b>Limit</b></td>
		</tr>
		<%
		names = groups[0];
		len = Array.getLength(names);
		if (len != 0) {
			for(int i=0;i<len;++i) {
			md = vr.getMetric(names[i], null);
			%>
			<tr>
				<td align="center"><%= HTMLEncode(md.getMetric()) %></td>
				<td align="center"><%= Math.round(md.getN()) %>&nbsp;vulns</td>
				<td align="center"><%= (md.getAverage()==Math.round(md.getAverage())) ? Math.round(md.getAverage()) : md.getAverage() %>&nbsp;%</td>
				<td align="center"><%= Math.round(md.getTarget()) %>&nbsp;vulns</td>
				<td align="center"><%= Math.round(md.getMaximum()) %>&nbsp;vulns</td>
			</tr>
			<%
			}//end for
		} // end details
		%>
		</table>
		<br/>
		<!-- Reactivity to open Metrics-->
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td colspan="5" align="center" class="subtitle"><%= HTMLTitle("Reactivity", null) %></td>
		</tr>
		<tr>
			<td width="40%" align="center" bgcolor="gainsboro"><b>Time</b></td>
			<td width="15%" align="center" bgcolor="gainsboro"><b>Longest</b></td>
			<td width="15%" align="center" bgcolor="gainsboro"><b>Average</b></td>
			<td width="15%" align="center" bgcolor="gainsboro"><b>Shortest</b></td>
			<td width="15%" align="center" bgcolor="gainsboro"><b>Target</b></td>
		</tr>
		<%
		names = groups[1];
		len = Array.getLength(names);
		if (len != 0) {
			for(int i=0;i<len;++i) {
			md = vr.getMetric(names[i], null);
			%>
			<tr>
				<td align="center"><%= HTMLEncode(md.getMetric()) %></td>
				<td align="center"><%= Math.round(md.getMaximum()/SECBYDAY) %>&nbsp;days</td>
				<td align="center"><%= Math.round(md.getAverage()/SECBYDAY) %>&nbsp;days</td>
				<td align="center"><%= Math.round(md.getMinimum()/SECBYDAY) %>&nbsp;days</td>
				<td align="center"><%= Math.round(md.getTarget()/SECBYDAY) %>&nbsp;days</td>
			</tr>
			<%
			}
		} // end details
		%>
		</table>
		<br/>
		&nbsp;<br/>
		<!-- Exposure Metrics-->
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td colspan="5" align="center" class="subtitle"><%= HTMLTitle("Exposure", null) %></td>
		</tr>
		<tr>
			<td align="center" width="40%" bgcolor="gainsboro"><b>Time to close since repair decision</b></td>
			<td align="center" width="15%" bgcolor="gainsboro"><b>Longest</b></td>
			<td align="center" width="15%" bgcolor="gainsboro"><b>Average</b></td>
			<td align="center" width="15%" bgcolor="gainsboro"><b>Shortest</b></td>
			<td align="center" width="15%" bgcolor="gainsboro"><b>Target</b></td>
		</tr>
		<%
		names = groups[2];
		len = Array.getLength(names);
		if (len != 0) {
			for(int i=0;i<len;++i) {
			md = vr.getMetric(names[i],null);
			%>
			<tr>
				<td align="center"><%= HTMLEncode(md.getMetric()) %></td>
				<td align="center"><%= Math.round(md.getMaximum()/SECBYDAY) %>&nbsp;days</td>
				<td align="center"><%= Math.round(md.getAverage()/SECBYDAY) %>&nbsp;days</td>
				<td align="center"><%= Math.round(md.getMinimum()/SECBYDAY) %>&nbsp;days</td>
				<td align="center"><%= Math.round(md.getTarget()/SECBYDAY) %>&nbsp;days</td>
			</tr>
			<%
			}
		} // end details
		%>
		</table>
		<%@ include file="../copyright.inc.jsp" %>
		</div>
	</td>
</tr>
</table>
</body>
</html>
<%
} catch(Exception e){
	_logger.error("Exception during JSP execution", e);
	setErrorMessage(response, e, getSessionId(request));
}
%>