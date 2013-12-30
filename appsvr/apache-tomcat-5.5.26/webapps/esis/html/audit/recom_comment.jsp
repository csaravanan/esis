<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
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
  -- $Id: recom_comment.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<!-- The JSP used to send emails : simplified html -->
<%@ page import="com.entelience.soap.soapAudit" %>
<%@ page import="com.entelience.objects.audit.AuditRecCommentId" %>
<%@ page import="com.entelience.objects.audit.AuditRecId" %>
<%@ page import="com.entelience.objects.audit.Comment" %>
<%@ page import="com.entelience.objects.audit.Recommendation" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%
try {
	// code
	// parameters
	// don't use session for emails, use parameter
	//=> getParamInteger(request, "user_id");
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	Integer rid = getParamInteger(request, "recomId");
	if (rid == null)
		throw new Exception("Null parameter for recomId");
	AuditRecId recom_id = new AuditRecId(rid.intValue(), 0);
	
	Integer cid = getParamInteger(request, "commentId");
	if (cid == null)
		throw new Exception("Null parameter for commentId");
	AuditRecCommentId comment_id = new AuditRecCommentId(cid.intValue(), 0);
	
	soapAudit au = new soapAudit(peopleId);
	
	Comment[] comments = au.getListOfComments(null, recom_id, null);
	if (comments == null || comments.length <= 0)
		throw new Exception("Specified recommendation have no comments");
	
	Comment com = null;
	for (int i = 0; i < comments.length; ++i) {
		if (comments[i].getId().getId() == comment_id.getId()) {
			com = comments[i];
		}
	}
	if (com == null)
		throw new Exception("commentId not found in the comments list of the specified recommendation");
	Recommendation rec = au.getRec(com.getForeign_id());
	// end code
%>
<head>
<title>Comment for <%= rec.getTitle() %></title>
<%@ include file="../style.inc.jsp" %>
</head>
<body>
<table width="100%" border="0" align="center" bgcolor="white" cellpadding="0" cellspacing="0">
<tr>
	<td>
		<div align="center">
		<!-- Header -->
		<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td width="20%" rowspan="2" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
			<td width="80%" align="center" class="title">Comment</td>
		</tr>
		<tr>
			<td align="center" class="subtitle">Recommendation: <%= rec.getTitle() %> (<%= rec.getReference() %>)</td>
		</tr>
		</table>
		<br/>
		<!-- Comment info -->
		<br/>
		<table width="90%" border="1" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td width="25%" height="30" bgcolor="gainsboro" align="center">Author</td>
			<td width="75%" align="center"><b><%= com.getAuthor_username() %></b></td>
		</tr>
		<tr>
			<td width="25%" height="30" bgcolor="gainsboro" align="center">Date</td>
			<td width="75%" align="center"><b><%= formatDate(com.getCreation_date()) %></b></td>
		</tr>
		<tr>
			<td width="25%" height="30" bgcolor="gainsboro" align="center">Comment</td>
			<td width="75%" align="center"><b><%= HTMLEncode(com.getComment()) %></b></td>
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
} catch(Exception e) {
	_logger.error("Exception during JSP execution", e);
	setErrorMessage(response, e, getSessionId(request));
}
%>