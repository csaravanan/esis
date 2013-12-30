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
  -- $Id: vrt_vulnerabilities.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapVulnerabilityReview" %>
<%@ page import="com.entelience.soap.soapDirectory" %>
<%@ page import="com.entelience.objects.vuln.VRTId" %>
<%@ page import="com.entelience.objects.vrt.VulnerabilityInfoLine" %>
<%@ page import="com.entelience.objects.vrt.MeetingInfoLine" %>
<%@ page import="com.entelience.objects.vrt.VRTMeetingStats" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
	// Class declarations
	String[] decision = {"New", "Repair", "Investigate", "Accept risk", "Ignore"};
	String[] priority = {"N/A", "Low", "Medium", "High", "Immediate"};
	//List titles_list = new ArrayList();
	
	public String buildParam(List<?> data) throws Exception {
	       if(data == null) return URLEncoder.encode("", "UTF-8");
		StringBuffer param = new StringBuffer(data.get(0).toString());
		for(int i=1;i<data.size();i++) {
		        param.append(',').append(data.get(i).toString());
		}
                return URLEncoder.encode(param.toString(), "UTF-8");
	}
	// end class declarations
%>
<%
try{
	//code
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	Integer vid = getParamInteger(request, "e_vulnerability_vrt_id");
	if(vid == null)
		throw new Exception("Null parameter for e_vulnerability_vrt_id");
	// Now we can use webservices
	VRTId e_vulnerability_vrt_id = new VRTId(vid.intValue(), 0);
	
	Boolean b_ignored = getParamBoolean(request, "b_ignored");
	if(b_ignored == null)
		b_ignored = Boolean.FALSE;
	String order = getParam(request, "order");
	String way = getParam(request, "way");
	Integer pageNumber = getParamInteger(request, "page");
	Boolean my = getParamBoolean(request, "my");
	

	soapVulnerabilityReview vr = new soapVulnerabilityReview(peopleId);
	soapDirectory dir = new soapDirectory(peopleId);
	
	MeetingInfoLine vrtMeeting = vr.getVRTMeeting(e_vulnerability_vrt_id);
	
	String vrtDate = formatDate(vrtMeeting.getStart_date());
	VulnerabilityInfoLine vrtVulns[];
	if (b_ignored.booleanValue()) {
		List<Number> l = new ArrayList<Number>();
		l.add(Integer.valueOf(4));
		vrtVulns = vr.listVRTVulnerabilitiesFiltered(e_vulnerability_vrt_id, l, null, order, way, pageNumber, my, null);
	} else {
		vrtVulns = vr.listVRTVulnerabilities(e_vulnerability_vrt_id, order, way, pageNumber, my, null);
	}
	// get VRT stats from ws
	VRTMeetingStats[] vrtStats = vr.getVRTMeetingStats(e_vulnerability_vrt_id, my);
	
	// build HTTP params from List
	String senames = buildParam(vrtStats[0].getNames());
	String secount = buildParam(vrtStats[0].getCount());
	
	String stnames = buildParam(vrtStats[2].getNames());
	String stcount = buildParam(vrtStats[2].getCount());
	
	String prnames = buildParam(vrtStats[1].getNames());
	String prcount = buildParam(vrtStats[1].getCount());
	
	String venames = buildParam(vrtStats[3].getNames());
	String vecount = buildParam(vrtStats[3].getCount());
	
	//titles_list.add("Status");
	//titles_list.add("Severity");
	//titles_list.add("Priority");
	//titles_list.add("Vendor");	
	//String setitles = buildParam(titles_list);
	// end code
%>
<head>
<title>VRT Meeting - <%= vrtDate %></title>
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
			<td width="80%" align="center" class="title">VRT Meeting</td>
		</tr>
		<tr>
			<td align="center" class="subtitle">Meeting date: <%= vrtDate %></td>
		</tr>
		</table>
		<br/>
		<%
		if (vrtVulns == null || vrtVulns.length == 0) {
		%>
		<!-- no Vulns -->
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td align="center">No VRT vulnerabilities.</td>
		</tr>
		</table>
		<%
		} else { // display Vulns
		%>
		<!-- vrt Vulns counts -->
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td width="16%" align="center" bgcolor="gainsboro">Total</td>
			<td width="16%" align="center" bgcolor="gainsboro">New</td>
			<td width="17%" align="center" bgcolor="gainsboro">Repair</td>
			<td width="17%" align="center" bgcolor="gainsboro">Investigate</td>
			<td width="17%" align="center" bgcolor="gainsboro">Accept Risk</td>
			<td width="17%" align="center" bgcolor="gainsboro">Ignore</td>
		</tr>
		<tr>
			<td align="center"><%= vrtMeeting.getTotal() %></td>
			<td align="center"><%= vrtMeeting.getPending() %></td>
			<td align="center"><%= vrtMeeting.getAction() %></td>
			<td align="center"><%= vrtMeeting.getInvest() %></td>
			<td align="center"><%= vrtMeeting.getArchiv() %></td>
			<td align="center"><%= vrtMeeting.getIgnored() %></td>
		</tr>
		</table>
		<br/>
		<!-- Pie Charts link -->
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="40%">
		<tr>
			<td align="center">
			<a href="PieChartServer.html?vecolors=true&vecount=<%= vecount %>&venames=<%= venames %>&vetitle=Vendor&prcount=<%= prcount %>&prnames=<%= prnames %>&prtitle=Priority&stcount=<%= stcount %>&stnames=<%= stnames %>&sttitle=Decision&secount=<%= secount %>&senames=<%= senames %>&setitle=Severity">View Pie Charts ...</a>
			</td>
		</tr>
		</table>
		<br/>
		<!-- vrtVulns list -->
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="80%">
		<tr>
			<td>
				&nbsp;<br/>
				<ul>
				<%
				for(int i=0; i<vrtVulns.length; ++i) {
				VulnerabilityInfoLine vil = vrtVulns[i];
				%>
				<li>
				<div align="left"><b><%= vil.getVuln_name() %></b> - <%= HTMLTitle(vil.getDescription(), null) %><br/>&nbsp;</div>
				</li>
				<%
				} // end for
				%>
				</ul>
			</td>
		</tr>
		</table>
		<%
		} // end if vrtVulns
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