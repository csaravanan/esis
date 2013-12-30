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
  -- $Id: vuln_comment.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapVulnerabilityReview" %>
<%@ page import="com.entelience.soap.soapDirectory" %>
<%@ page import="com.entelience.objects.vuln.VulnId" %>
<%@ page import="com.entelience.objects.vrt.VulnerabilityInformation" %>
<%@ page import="com.entelience.objects.vrt.CommentInfoLine" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%
// code
// Check session id validity
try {
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	// Now we can use webservices
	// Read parameters.
	Integer vid = getParamInteger(request, "e_vulnerability_id");
	if (vid == null) {
		throw new Exception("Null parameter for e_vulnerability_id");
	}
	Integer cid = getParamInteger(request, "e_vulnerability_comments_id");
	if (cid == null) {
		throw new Exception("Null parameter for e_vulnerability_comments_id");
	}
	int intCid = cid.intValue();
	VulnId e_vulnerability_id = new VulnId(vid.intValue(), 0);
	
	soapVulnerabilityReview vr = new soapVulnerabilityReview(peopleId);
	soapDirectory dir = new soapDirectory(peopleId);
	VulnerabilityInformation vi = vr.getVulnerabilityInformation(e_vulnerability_id);
	// end try code
%>
<head>
<title>Vulnerability <%= vi.getVuln_name() %> comment</title>
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
			<td width="80%" align="center" class="title">Vulnerability comment</td>
		</tr>
		<tr>
			<td align="center" class="subtitle"><%= vi.getVuln_name() %></td>
		</tr>
		</table>
		<br/>
		<%
		if (vi.getComments() != null) {
		%>
		<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td width="20%" align="center" bgcolor="gainsboro">Author</td>
			<td width="20%" align="center" bgcolor="gainsboro">Date</td>
			<td width="60%" align="center" bgcolor="gainsboro">Comment</td>
		</tr>
		<%
		for (int j = 0; j < vi.getComments().size(); ++j) {
			CommentInfoLine cil = (CommentInfoLine) vi.getComments().get(j);
			//show the selected comment
			if (cil.getE_vulnerability_comments_id().getId() == intCid) {
				%>
				<tr>
					<td align="center"><%= cil.getAuthor() %></td>
					<td align="center"><%= formatDate(cil.getComment_date()) %></td>
					<td valign="top" align="left"><%= cil.getComment() %></td>
				</tr>
				<%
			}
		}//end for
		%>
		</table>
		<%
		// end comments
		}
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