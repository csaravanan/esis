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
  -- $Id: mav_vulnerabilities.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapVulnerabilityReview" %>
<%@ page import="com.entelience.soap.soapDirectory" %>
<%@ page import="com.entelience.objects.vrt.MAVInfoLine" %>
<%@ page import="com.entelience.objects.vrt.OpenVulnStats" %>
<%@ page import="com.entelience.util.DateHelper" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
	// Class declarations
	String[] decision = {"New", "Repair", "Investigate", "Accept risk", "Ignore"};
	String[] priority = {"N/A", "Low", "Medium", "High", "Immediate"};
	String[] status = {"N/A", "Fixed", "Planning", "In progress"};
	//List titles_list = new ArrayList();
	
	public String buildParam(List<?> data) throws Exception{
	        StringBuffer param = new StringBuffer(data.get(0).toString());
		for(int i=1;i<data.size();i++) {
			param.append(',').append(data.get(i).toString());
		}
		return URLEncoder.encode(param.toString(), "UTF-8");
	}
	// end class declarations
%>
<%
// code
try {
	boolean valid =false;
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	String order = getParam(request, "order");
	String way = getParam(request, "way");
	Integer pageNumber = getParamInteger(request, "page");
	Boolean my = getParamBoolean(request, "my");
	
	// Now we can use webservices
	soapVulnerabilityReview vr = new soapVulnerabilityReview(peopleId);
	soapDirectory dir = new soapDirectory(peopleId);
	
	String todaysDate = formatDate(DateHelper.now());
	MAVInfoLine[] mavVulns = vr.listOpenVulnerabilities(order, way, pageNumber, my, null);
	// get OpenVuln stats from ws
	OpenVulnStats[] mavStats = vr.getOpenVulnStats(my, null);
	
	// build HTTP params from List
	String senames = buildParam(mavStats[0].getNames());
	String secount = buildParam(mavStats[0].getCount());

	String stnames = buildParam(mavStats[2].getNames());
	String stcount = buildParam(mavStats[2].getCount());

	String prnames = buildParam(mavStats[1].getNames());
	String prcount = buildParam(mavStats[1].getCount());

	String venames = buildParam(mavStats[3].getNames());
	String vecount = buildParam(mavStats[3].getCount());
%>
<head>
<title>Vulnerabilities in action plan - <%= todaysDate %></title>
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
			<td width="80%" align="center" class="title">Vulnerabilities in action plan</td>
		</tr>
		<tr>
			<td align="center"><%= todaysDate %></td>
		</tr>
		</table>
		<br/>
		<%
		if (mavVulns == null || mavVulns.length == 0) {
		%>
		<!-- no Vulns -->
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td align="center">No vulnerabilities.</td>
		</tr>
		</table>
		<%
		} else {
		// display Vulns
		%>
		<!-- Pie Charts link -->
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="40%">
		<tr>
			<td align="center">
			<a href="PieChartServer.html?senames=<%= senames %>&secount=<%= secount %>&setitle=Severity&stnames=<%= stnames %>&stcount=<%= stcount %>&sttitle=Status&prnames=<%= prnames %>&prcount=<%= prcount %>&prtitle=Priority&vecolors=true&venames=<%= venames %>&vecount=<%= vecount %>&vetitle=Vendor">View Pie Charts ...</a>
			</td>
		</tr>
		</table>
		<br/>
		<!-- mavVulns list -->
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td>
				&nbsp;<br/>
				<ul>
				<%
				for(int i=0; i<mavVulns.length; ++i) {
				%>
				<li>
				<div align="left"><b><%= mavVulns[i].getVuln_name() %></b> - <%= HTMLTitle(mavVulns[i].getDescription(), null) %><br/>&nbsp;</div>
				</li>
				<%
				} // end for
				%>
				</ul>
			</td>
		</tr>
		</table>
		<%
		} // end if mavVulns
		%>
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