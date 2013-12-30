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
  -- $Id: vuln_email.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<!-- The JSP used to send emails : simplified html-->
<%@ page import="com.entelience.soap.soapVulnerabilityReview" %>
<%@ page import="com.entelience.soap.soapDirectory" %>
<%@ page import="com.entelience.soap.soapRaci" %>
<%@ page import="com.entelience.objects.vuln.VulnId" %>
<%@ page import="com.entelience.objects.vrt.VulnerabilityInformation" %>
<%@ page import="com.entelience.objects.DropDown" %>
<%@ page import="com.entelience.objects.vrt.VulnerabilityInfoLine" %>
<%@ page import="com.entelience.objects.vrt.AliasInfoLine" %>
<%@ page import="com.entelience.objects.vrt.CommentInfoLine" %>
<%@ page import="com.entelience.objects.vrt.VulnerabilityAction" %>
<%@ page import="com.entelience.objects.raci.RaciInfoLine" %>
<%@ page import="com.entelience.sql.DbHelper" %>
<%@ page import="com.entelience.util.Arrays" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
	// Class declarations
    Map<Integer, String> mav_status = new HashMap<Integer, String>();
	
    protected String lookupMavStatus(Integer status_nb){
		String status = (String)mav_status.get(status_nb);
        if(status != null) return status;
        return "Unknown";
    }
    
    protected String format(String s1, String s2) throws Exception{
	if(DbHelper.nullify(s1) == null && DbHelper.nullify(s2) == null)
		return "-";
	if(DbHelper.nullify(s1) != null)
		return s1;
	if(DbHelper.nullify(s2) != null)
		return s2;
	return s1+"-"+s2;
    }
	// end class declarations
%>
<%
try{
	// code
	//TODO : add multicompany code
	
	// Now we can use webservices
	// Read parameters.
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	Integer vid = getParamInteger(request,"e_vulnerability_id");
	if(vid == null)
		throw new Exception("Null parameter for e_vulnerability_id");
	VulnId e_vulnerability_id = new VulnId(vid.intValue(), 0);
	Boolean my = getParamBoolean(request, "my");

	soapVulnerabilityReview vr = new soapVulnerabilityReview(peopleId);
	soapDirectory dir = new soapDirectory(peopleId);
	soapRaci rac = new soapRaci(peopleId);
	
	VulnerabilityInfoLine vil = vr.listOneVulnerability(e_vulnerability_id);
	VulnerabilityInformation vi = vr.getVulnerabilityInformation(e_vulnerability_id);
	VulnerabilityAction[] actions = vr.getVulnerabilityActions(e_vulnerability_id, Boolean.FALSE, my);
	RaciInfoLine[] racis = rac.listRacis(null, vil.getE_raci_obj(), null, null, null, null);
	
	AliasInfoLine[] _names = new AliasInfoLine[vi.getVuln_names().size()];
	_names = (AliasInfoLine[]) vi.getVuln_names().toArray(_names);
	String[] names = new String[_names.length];
	for(int i=0; i<names.length; i++){
		names[i] = _names[i].getName();
	}
	
	if(mav_status == null || mav_status.size() ==0){
		DropDown [] dd = vr.getListOfMAVStatus();
		for(int i=0; i< dd.length; i++){
			mav_status.put(Integer.valueOf(dd[i].getData()), dd[i].getLabel());
		}
	}
	// end code
%>
<head>
<title>Vulnerability - <%= vi.getVuln_name() %></title>
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
			<td width="20%" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
			<td width="80%" align="center" class="title">Vulnerability information</td>
		</tr>
		</table>
		<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td align="center" class="subtitle"><%= vil.getVuln_name() %></td>
		</tr>
		</table>
		<br/>
		<!-- Vuln info -->
		<a name="<%= vi.getVuln_name() %>"/>
		<!-- global table for vulnerability -->
		<br/>
		<table align="center" cellpadding="4" border="1" cellspacing="0" width="90%">
		<tr>
			<td width="25%" align="center" bgcolor="gainsboro"><b><%= vi.getVuln_name() %></b></td>
			<td width="75%" align="center"><b><%= HTMLTitle(vil.getDescription(), null) %></b></td>
		</tr>
		</table>
		<table align="center" cellpadding="4" border="1" cellspacing="0" width="90%">
		<tr>
			<td width="25%">Published date</td>
			<td width="25%"><b><%= formatDate(vi.getPublish_date()) %></b></td>
			<td width="25%">Severity</td>
			<td width="25%"><b><%= vi.getSeverity() %></b></td>
		</tr>
		</table>
		<%
		if (vi.getDescriptions() != null) {
		%>
		<table align="center" cellpadding="4" border="1" cellspacing="0" width="90%">
		<tr>
			<td  valign="top" align="left">
			<%
			for(int j=0;j<vi.getDescriptions().size();++j) {
			%>
			<%= HTMLEncode((String) vi.getDescriptions().get(j)) %>&nbsp;<br/>
			<%
			}//end for
			%>
			</td>
		</tr>
		</table>
		<%
		}// end descriptions
		%>
        <table align="center" cellpadding="4" border="1" cellspacing="0" width="90%">
		<tr>
			<td width="25%" align="center">Vendor(s)</td>
			<td width="25%" align="center"><b><%= vil.getVendor() == null ? "" : vil.getVendor().replaceAll("\\n", ", ") %></b></td>
			<td width="25%" align="center">Product(s)</td>
			<td width="25%" align="center"><b><%= vil.getProduct() == null ? "" : vil.getProduct().replaceAll("\\n", ", ") %></b></td>
		</tr>
		</table>
		<table align="center" cellpadding="4" border="1" cellspacing="0" width="90%">
		<tr>
			<td width="25%" align="center">Names</td>
			<td width="75%" align="center"><b><%= Arrays.join(names, ", ") %></b></td>
		</tr>
		</table>
		<% 
		if(racis != null && racis.length>0){
		%>
		<br/>
		<br/>
		<table align="center" cellpadding="4" border="1" cellspacing="0" width="90%">
		<tr>
			<td align="center" bgcolor="gainsboro"><b>RACI matrix</b></td>
		</tr>
		</table>
		<table align="center" cellpadding="4" border="1" cellspacing="0" width="90%">
		<%
		for(int j=0;j<racis.length;++j) {
		%>
		<tr>
			<td width="60%"><%= racis[j].getUserName() %></td>
			<td width="40%" align="left"><%= racis[j].getRaci() %></td>
		</tr>
		<%
		}//end for
		%>
		</table>
		<%
		} // end racis
		%>
		<%
		if (vi.getComments() != null) {
		%>
		<br/>
		<br/>
		<table align="center" cellpadding="4" border="1" cellspacing="0" width="90%">
		<tr>
			<td align="center" bgcolor="gainsboro"><b>Comments</b></td>
		</tr>
	    </table>
        <table align="center" cellpadding="4" border="1" cellspacing="0" width="90%">
		<%
		for(int j=0;j<vi.getComments().size();++j) {
		CommentInfoLine cil = vi.getComments().get(j);
		%>
		<tr>
			<td width="20%"><%= cil.getAuthor() %></td>
			<td width="20%"><%= formatDate(cil.getComment_date()) %></td>
			<td width="60%" valign="top" align="left"><%= cil.getComment() %></td>
		</tr>
		<%
		}//end for
		%>
		</table>
		<%
		} // end comments
		%>
		<%
		if (actions != null && actions.length > 0) {
		%>
		<br/>
		<br/>
		<table align="center" cellpadding="4" border="1" cellspacing="0" width="90%">
	    <tr>
			<td align="center" bgcolor="gainsboro"><b>Actions</b></td>
		</tr>
		</table>
		<table align="center" cellpadding="4" border="1" cellspacing="0" width="90%">
		<tr>
			<td align="center" width="15%" bgcolor="gainsboro">Status</td>
			<td align="center" width="15%" bgcolor="gainsboro">Target date</td>
			<td align="center" width="20%" bgcolor="gainsboro">Responsible</td>
			<td align="center" width="30%" bgcolor="gainsboro">Description</td>
			<td align="center" width="20%" bgcolor="gainsboro">Change ref. &amp; Workload</td>
		</tr>
		<%
		for(int j=0;j<actions.length;++j) {
		%>
		<tr>
			<td align="center"><%= lookupMavStatus(actions[j].getMav_status()) %></td>
			<td align="center"><%= formatDate(actions[j].getTarget_date()) %></td>
			<td align="center"><%= DbHelper.unnullify(actions[j].getOwnerName()) %></td>
			<td align="center"><%= DbHelper.unnullify(actions[j].getDescription()) %></td>
			<td align="center"><%= format(actions[j].getChangeref(), actions[j].getWorkload()) %></td>
		</tr>
		<%
		}
		%>
		</table>
		<%
		} // end actions
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