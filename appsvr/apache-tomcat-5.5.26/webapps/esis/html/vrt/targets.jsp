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
  -- $Id: targets.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapVulnerabilityReview" %>
<%@ page import="com.entelience.objects.DropDown" %>
<%@ page import="com.entelience.objects.metrics.TargetDetail" %>
<%@ page import="com.entelience.util.DateHelper" %>
<%@ page import="java.lang.reflect.Array" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%
try{
	// code
	// Check session id validity
	Integer peopleId = getSession(request);
        initTimeZone(peopleId);
	// Now we can use webservices
	soapVulnerabilityReview vr = new soapVulnerabilityReview(peopleId);
	
	TargetDetail[] tds = vr.getMetricTargets();
	int len = Array.getLength(tds);
	DropDown[] se;
	se = vr.getListOfSeverity();
	String todaysDate = formatDate(DateHelper.now());
	// end code
%>
<head>
<title>VRT Targets</title>
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
			<td width="80%" align="center" class="title">VRT Targets</td>
		</tr>
		<tr>
			<td align="center"><%= todaysDate %></td>
		</tr>
		</table>
		<br/>
		<!-- Target Details-->
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<!--
		<tr>
			<td colspan="2" align="center"><h2>< %= HTMLTitle("Targets", null) % ></h2></td>
		</tr>
		-->
		<tr>
			<td align="center" width="50%" bgcolor="gainsboro"><b>Name</b></td>
			<td align="center" width="50%" bgcolor="gainsboro"><b>Value</b></td>
		</tr>
		<%
		if (len != 0) {
			for(int i=0;i<len;++i) {
			%>
			<tr>
				<td align="center"><%= HTMLEncode(tds[i].getName().replace('_',' ')) %>&nbsp;
				<%
				if ("close_time".equals(tds[i].getName())) {
				%>for severity &quot;<%= se[tds[i].getKey_id().intValue()].getLabel() %>&quot;<%
				}%>
				</td>
				<td align="center"><%= tds[i].getValue() %>
				<%
				if (tds[i].getName().endsWith("size")) {
				%>&nbsp;vulns<%
				}%>
				<%
				if (tds[i].getName().endsWith("time")) {
				%>&nbsp;days<%
				}%>
				<%
				if (tds[i].getName().endsWith("rate")) {
				%>&nbsp;%<%
				}%>
				</td>
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