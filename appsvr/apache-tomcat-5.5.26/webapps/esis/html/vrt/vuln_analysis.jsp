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
  -- $Id: vuln_analysis.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapVulnerabilityReview" %>
<%@ page import="com.entelience.soap.soapRaci" %>
<%@ page import="com.entelience.soap.soapDirectory" %>
<%@ page import="com.entelience.objects.vuln.VulnId" %>
<%@ page import="com.entelience.objects.vrt.VulnerabilityInfoLine" %>
<%@ page import="com.entelience.objects.vrt.VulnerabilityAnalysis" %>
<%@ page import="com.entelience.objects.raci.RaciInfoLine" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
	// Radio button formatter.
	public void myRadio(int val, String[] tab, String name) {
		for (int i=0; i<4; ++i) {
			if (val == i) tab[i] = "<input type=radio align=middle name=radio"+name+" checked>";
			else tab[i] = "&nbsp;";
      	}
 	}
	// Lookup tables for various text items	
	//String[] severity = {"Unrated", "Low", "Medium", "High", "Critical"}; // comes from vil as text
	String[] decision = {"New", "Repair", "Investigate", "Accept risk", "Ignore"};
	String[] status = {"N/A", "Fixed", "Planning", "In progress", "Won't fix"};
	String[] priority = {"N/A", "Low", "Medium", "High", "Immediate"};
	// end class declarations
%>
<%
// code
try{
	// Class declarations
	VulnerabilityInfoLine vil;
	VulnerabilityAnalysis va;
	RaciInfoLine[] racis;
	
	// business
	String[] brand = new String[4];
	String[] busops = new String[4];
	String[] bussup = new String[4];
	String[] intops = new String[4];
	// tech
	String[] unix = new String[4];
	String[] win = new String[4];
	String[] net = new String[4];
	String[] access = new String[4];
	String[] apps = new String[4];
	// exposure
	String[] xunix = new String[4];
	String[] xwin = new String[4];
	String[] xnet = new String[4];
	String[] xaccess = new String[4];
	String[] xapps = new String[4];
	
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	Integer vid = getParamInteger(request,"e_vulnerability_id");
	if(vid == null)
		throw new Exception("Null parameter for e_vulnerability_id");
	VulnId e_vulnerability_id = new VulnId(vid.intValue(), 0);

	soapVulnerabilityReview vr = new soapVulnerabilityReview(peopleId);
	soapDirectory dir = new soapDirectory(peopleId);
	soapRaci rac = new soapRaci(peopleId);
	
	vil = vr.listOneVulnerability(e_vulnerability_id);
	va = vr.getVulnerabilityAnalysis(e_vulnerability_id);
	racis = rac.listRacis(null, va.getE_raci_obj(), null, null, null, null);
	
	// business
	myRadio(va.getBi_brand(), brand, "brand");
	myRadio(va.getBi_busops(), busops, "busops");
	myRadio(va.getBi_bussup(), bussup, "bussup");
	myRadio(va.getBi_intops(), intops, "intops");
	//tech
	myRadio(va.getTi_unix(), unix, "unix");
	myRadio(va.getTi_windows(), win, "win");
	myRadio(va.getTi_network(), net, "net");
	myRadio(va.getTi_access(), access, "access");
	myRadio(va.getTi_apps(), apps, "apps");
	// exposure
	myRadio(va.getEx_unix(), xunix, "xunix");
	myRadio(va.getEx_windows(), xwin, "xwin");
	myRadio(va.getEx_network(), xnet, "xnet");
	myRadio(va.getEx_access(), xaccess, "xaccess");
	myRadio(va.getEx_apps(), xapps, "xapps");
	// end code
%>
<head>
<title>Vulnerability analysis - <%= vil.getVuln_name() %></title>
<%@ include file="../style.inc.jsp" %>
</head>
<body>
<table width=100% border="0" align="center" bgcolor="white">
<tr>
	<td>
		<div align="center">
		<!-- header -->
		<table border="0" cellspacing="0" cellpadding="4" width="100%">
		<tr>
			<td width="20%" rowspan="2" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
			<td width="80%" align="center" class="title">Vulnerability analysis</td>
		</tr>
		<tr>
			<td align="center" class="subtitle"><%= vil.getVuln_name() %></td>
		</tr>
		</table>
		<br/>
		<!-- Detials -->
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td width="25%" align="center"><b><%= vil.getVuln_name() %></b></td>
			<td colspan="3" align="left"><b><%= HTMLTitle(vil.getDescription(), null) %></b></td>
		</tr>
		<tr>
			<td width="25%" align="center" bgcolor="gainsboro">Published date</td>
			<td width="25%" align="center"><b><%= formatDate(vil.getPublish_date()) %></b></td>
			<td width="25%" align="center" bgcolor="gainsboro">Severity</td>
			<td width="25%" align="center"><b><%= vil.getSeverity() %></b></td>
		</tr>
		<tr>
			<td align="center" bgcolor="gainsboro">Decision</td>
			<td align="center"><b><%= decision[va.getStatus()] %></b></td>
			<td align="center" bgcolor="gainsboro">Priority</td>
			<td align="center"><b><%= priority[va.getD_priority()] %></b></td>
		</tr>
		<tr>
			<td align="center" bgcolor="gainsboro">Status</td>
			<td align="center"><b><%= status[va.getD_mav_status()] %></b></td>
			<td align="center" bgcolor="gainsboro">Target date</td>
			<td align="center"><b><%= formatDate(va.getD_mav_target()) %></b></td>
		</tr>
		</table>
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td colspan="2" align="center"><b>RACI matrix</b></td>
		</tr>
		<tr>
			<td width="75%" align="center" bgcolor="gainsboro"><b>Stakeholders</b></td>
			<td width="25%" align="center" bgcolor="gainsboro"><b>RACI</b></td>
		</tr>
		<%
		for(int i=0; i<racis.length; ++i) {	%>
		<tr>
			<td width="75%" align="center"><%= racis[i].getUserName()%></td>
			<td width="25%" align="center"><%= racis[i].getRaci()%></td>
		</tr>
		<%
		} // end for
		%>
		</table>
		<br/>
		<table border="0" cellspacing="0" cellpadding="0" width="90%">
		<tr>
			<td width="48%" valign="top">
				<table border="1" cellspacing="0" cellpadding="4" width="100%">
				<tr>
					<td width="60%" align="center" bgcolor="gainsboro"><b>Business impact</b></td>
					<td width="10%" align="center" bgcolor="gainsboro">N/A</td>
					<td width="10%" align="center" bgcolor="gainsboro">Low</td>
					<td width="10%" align="center" bgcolor="gainsboro">Med.</td>
					<td width="10%" align="center" bgcolor="gainsboro">High</td>
				</tr>
				<tr>
					<td align="center">Brand or company value</td>
					<td align="center"><%= brand[0] %></td>
					<td align="center"><%= brand[1] %></td>
					<td align="center"><%= brand[2] %></td>
					<td align="center"><%= brand[3] %></td>
				</tr>
				<tr>
					<td align="center">Business operations</td>
					<td align="center"><%= busops[0] %></td>
					<td align="center"><%= busops[1] %></td>
					<td align="center"><%= busops[2] %></td>
					<td align="center"><%= busops[3] %></td>
				</tr>
				<tr>
					<td align="center">Business support</td>
					<td align="center"><%= bussup[0] %></td>
					<td align="center"><%= bussup[1] %></td>
					<td align="center"><%= bussup[2] %></td>
					<td align="center"><%= bussup[3] %></td>
				</tr>
				<tr>
					<td align="center">International operations</td>
					<td align="center"><%= intops[0] %></td>
					<td align="center"><%= intops[1] %></td>
					<td align="center"><%= intops[2] %></td>
					<td align="center"><%= intops[3] %></td>
				</tr>
				<tr>
					<td colspan="5" align="left">Notes:<br/>
					<%= HTMLEncode(va.getBi_comment()) %></td>
				</tr>
				</table>
			</td>
			<td width="4%">&nbsp;</td>
			<td width="48%" valign="top">
				<table border="1" cellspacing="0" cellpadding="4" width="100%">
				<tr>
					<td width="60%" align="center" bgcolor="gainsboro"><b>Technical impact</b></td>
					<td width="10%" align="center" bgcolor="gainsboro">N/A</td>
					<td width="10%" align="center" bgcolor="gainsboro">Low</td>
					<td width="10%" align="center" bgcolor="gainsboro">Med.</td>
					<td width="10%" align="center" bgcolor="gainsboro">High</td>
				</tr>
				<tr>
					<td align="center">Unix</td>
					<td align="center"><%= unix[0] %></td>
					<td align="center"><%= unix[1] %></td>
					<td align="center"><%= unix[2] %></td>
					<td align="center"><%= unix[3] %></td>
				</tr>
				<tr>
					<td align="center">Windows</td>
					<td align="center"><%= win[0] %></td>
					<td align="center"><%= win[1] %></td>
					<td align="center"><%= win[2] %></td>
					<td align="center"><%= win[3] %></td>
				</tr>
				<tr>
					<td align="center">Network</td>
					<td align="center"><%= net[0] %></td>
					<td align="center"><%= net[1] %></td>
					<td align="center"><%= net[2] %></td>
					<td align="center"><%= net[3] %></td>
				</tr>
				<tr>
					<td align="center">Client devices</td>
					<td align="center"><%= access[0] %></td>
					<td align="center"><%= access[1] %></td>
					<td align="center"><%= access[2] %></td>
					<td align="center"><%= access[3] %></td>
				</tr>
				<tr>
					<td align="center">Applications</td>
					<td align="center"><%= apps[0] %></td>
					<td align="center"><%= apps[1] %></td>
					<td align="center"><%= apps[2] %></td>
					<td align="center"><%= apps[3] %></td>
				</tr>
				<tr>
					<td colspan="5" align="left">Notes:<br/>
					<%= HTMLEncode(va.getTi_comment()) %></td>
				</tr>
				</table>
			</td>
		</tr>
		</table>
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td width="50%" align="center" bgcolor="gainsboro"><b>Exposure</b></td>
			<td width="10%" align="center" bgcolor="gainsboro">#</td>
			<td width="10%" align="center" bgcolor="gainsboro">N/A</td>
			<td width="10%" align="center" bgcolor="gainsboro">Low</td>
			<td width="10%" align="center" bgcolor="gainsboro">Med.</td>
			<td width="10%" align="center" bgcolor="gainsboro">High</td>
		</tr>
		<tr>
			<td align="center">Unix</td>
			<td align="center"><%= va.getEx_unix_n() %></td> 
			<td align="center"><%= xunix[0] %></td>
			<td align="center"><%= xunix[1] %></td> 
			<td align="center"><%= xunix[2] %></td>
			<td align="center"><%= xunix[3] %></td>
		</tr>
		<tr>
			<td align="center">Windows</td>
			<td align="center"><%= va.getEx_windows_n() %></td>
			<td align="center"><%= xwin[0] %></td>
			<td align="center"><%= xwin[1] %></td> 
			<td align="center"><%= xwin[2] %></td>
			<td align="center"><%= xwin[3] %></td>
		</tr>
		<tr>
			<td align="center">Network</td>
			<td align="center"><%= va.getEx_network_n() %></td>
			<td align="center"><%= xnet[0] %></td>
			<td align="center"><%= xnet[1] %></td>
			<td align="center"><%= xnet[2] %></td>
			<td align="center"><%= xnet[3] %></td>
		</tr>
		<tr> 
			<td align="center">Client devices</td>
			<td align="center"><%= va.getEx_access_n() %></td>
			<td align="center"><%= xaccess[0] %></td>
			<td align="center"><%= xaccess[1] %></td>  
			<td align="center"><%= xaccess[2] %></td>
			<td align="center"><%= xaccess[3] %></td>
		</tr>
		<tr>
			<td align="center">Applications</td>
			<td align="center"><%= va.getEx_apps_n() %></td>
			<td align="center"><%= xapps[0] %></td>
			<td align="center"><%= xapps[1] %></td>
			<td align="center"><%= xapps[2] %></td>
			<td align="center"><%= xapps[3] %></td>
		</tr>
		<tr>
			<td colspan="6" align="left">Notes:<br/>
			<%= HTMLEncode(va.getEx_comment()) %></td>
		</tr>
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