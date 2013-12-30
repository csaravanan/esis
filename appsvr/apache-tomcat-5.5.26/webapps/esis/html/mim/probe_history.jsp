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
  -- $Id: probe_history.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapIdentityManagement" %>
<%@ page import="com.entelience.objects.FileImportHistory" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
	// Class declarations
	Map<String,String> labels;
	String language;
	
	public void initLabels() {
	   labels = new HashMap<String,String>();
	   labels.put("FILE_IMPORT_HISTORY_en", "File Import History");
	   labels.put("EXECUTION_DATE_en", "Execution date");
	   labels.put("FILE_NAME_en", "File name");
	   labels.put("FILE_SIZE_en", "File size");
	   labels.put("RESULT_en", "Status");
	   labels.put("SEE_ANOMALIES_en", "See anomalies from the last import");
	   labels.put("FILE_IMPORT_HISTORY_fr", "Historique d'import de fichiers");
	   labels.put("EXECUTION_DATE_fr", "Date d'ex&eacute;cution");
	   labels.put("FILE_NAME_fr", "Nom du fichier");
	   labels.put("FILE_SIZE_fr", "Taille du fichier");
	   labels.put("RESULT_fr", "Status");
	   labels.put("SEE_ANOMALIES_fr", "Voir les anomalies survenues lors du dernier import");
	}
	
	public String getLabel(String key) {
	   String langKey=key+"_"+language;
	   String res = labels.get(langKey);
	   if(res==null)
	       res=labels.get(key+"_en");
	   if(res==null)
	       res=key;
	   return res;
	   
	}
	// end class declarations
%>
<%
try{
	// code
	// Check session id validity
       Integer peopleId = getSession(request);
	String sid = request.getHeader("Session-Id"); //used later
	
	// Now we can use webservices
	language = getParam(request, "lang");
	if(language == null || language.length()==0)
		language = "fr";
	soapIdentityManagement im = new soapIdentityManagement(peopleId);
	
	FileImportHistory[] fih = im.getFileImportStatus();
	initLabels();
	// end code
%>
<head>
	<title><%= getLabel("FILE_IMPORT_HISTORY") %></title>
	<%@ include file="../style.inc.jsp" %>
</head>
<body>
<table width="100%" border="0"  align="center" bgcolor="white">
<tr>
	<td>
		<div align="center">
		<table border="0" cellspacing="0" cellpadding="4" width="100%">
		<tr>
			<td width="20%" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
			<td width="80%" align="center" class="title"><%= getLabel("FILE_IMPORT_HISTORY") %></td>
		</tr>
		</table>
		<br/>
		&nbsp;<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td width="25%" align="center"><b><%= getLabel("EXECUTION_DATE") %></b></td>
			<td width="25%" align="center"><b><%= getLabel("FILE_NAME") %></b></td>
			<td width="25%" align="center"><b><%= getLabel("FILE_SIZE") %></b></td>
			<td width="25%" align="center"><b><%= getLabel("RESULT") %></b></td>
		</tr>
		<%
		for(int i=0; i<fih.length; i++){
		%>
		<tr>
			<td align="center"><%= fih[i].getRun_date() %></td>
			<td align="center"><%= fih[i].getFile_name() %></td>
			<td align="center"><%= fih[i].getFile_size() %></td>
			<td align="center"><%= fih[i].getStatus() %></td>
		</tr>
		<%
		}// end for
		%>
		</table>
		<br/>
		&nbsp;<br/>
		<form action="anomalies_users.jsp" method="POST">
			<input type="hidden" name="Session-Id" value="<%=sid%>">
			<input type="hidden" name="anomaly" value="all">
			<input type="submit" value="<%= getLabel("SEE_ANOMALIES") %>">
		</form>

		</div>
	</td>
</tr>
<tr>
	<td>
	<%@ include file="../copyright.inc.jsp" %>
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