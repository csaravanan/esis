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
  -- $Id: print_user_details.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapIdentityManagement" %>
<%@ page import="com.entelience.objects.mim.UserDetail" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
	// Class declarations
	public void initLabels(){
	   labels = new HashMap<String,String>();
	   labels.put("USER_TITLE_en", "User detail ");
	   labels.put("USER_ID_en", "User Id");
	   labels.put("ERROR_PARAMS_en", "Parameters error for JSP");
	   labels.put("DATE_HIRE_en", "Hire date");
	   labels.put("DATE_END_CONTRACT_en", "End contract date");
	   labels.put("AD_en", "AD System");
	   labels.put("TSS_en", "TSS System");
	   labels.put("WHENCREATED_en", "creation date");
	   labels.put("WHENCHANGED_en", "account change date");
	   labels.put("LOGONCOUNT_en", "logon count");
	   labels.put("LASTLOGON_en", "last logon date");
	   labels.put("PWDLASTSET_en", "password last set");
	   labels.put("PWDEXPIRES_en", "password expire date");
	   
	   labels.put("USER_TITLE_fr", "D&eacute;tails de l'utilisateur ");
	   labels.put("USER_ID_fr", "Identifiant utilisateur");
	   labels.put("ERROR_PARAMS_fr", "Erreur dans les param&egrave;tres d'appel de la JSP");
	   labels.put("DATE_HIRE_fr", "Date d'embauche");
	   labels.put("DATE_END_CONTRACT_fr", "Date de fin de contrat");
	   labels.put("AD_fr", "Syst&egrave;me AD");
	   labels.put("TSS_fr", "Syst&egrave;me TSS");
	   labels.put("WHENCREATED_fr", "Cr&eacute;ation du compte");
	   labels.put("WHENCHANGED_fr", "Dernier changement du compte");
	   labels.put("LOGONCOUNT_fr", "Nombre d'identifications");
	   labels.put("LASTLOGON_fr", "Derni&egrave;re identification");
	   labels.put("PWDLASTSET_fr", "Dernier changement de mot de passe");
	   labels.put("PWDEXPIRES_fr", "Expiration du mot de passe");
	}
	
	Map<String,String> labels;
	String language;
	
	public String getLabel(String key){
	   String langKey=key+"_"+language;
	   String res = labels.get(langKey);
	   if(res==null)
	       res=labels.get(key+"_en");
	   if(res==null)
	       res=key;
	   return res;

	}
	
	public String format(Object o){
	   if(o == null) return "&nbsp;";
	   return o.toString();
	}

	// end class declarations
%>
<%
try{
	// code
	// Check session id validity
       Integer peopleId = getSession(request);
	
	// Now we can use webservices
	// Read parameters.
	language = getParam(request, "lang");
	if(language == null || language.length()==0)
		language = "fr";
	initLabels();
	
	String user_id = getParam(request, "user_id");
	if(user_id == null || user_id.length() == 0){
		%><%= getLabel("ERROR_PARAMS")%><%
		return;
	}
	
	soapIdentityManagement im = new soapIdentityManagement(peopleId);
	
	UserDetail details = im.getUserDetail(user_id);
	// end code
%>
<head>
	<title><%= getLabel("USER_TITLE")+" "+user_id %></title>
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
			<td width="80%" align="center" class="title"><%= getLabel("USER_TITLE")+" "+user_id %></td>
		</tr>
		</table>
		<br/>
		&nbsp;<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
        <tr>
            <td colspan="2" align="center"><b><%= user_id %></b></td>
        </tr>
		<tr>
            <td align="center" width="50%"><%= getLabel("DATE_HIRE")%></td>
            <td align="center" width="50%"><%= format(details.getDate_hire())%></td>
        </tr>
        <tr>
            <td align="center"><%= getLabel("DATE_END_CONTRACT")%></td>
            <td align="center"><%= format(details.getDate_end_contract())%></td>
        </tr>
		</table>
		<br/>
		&nbsp;<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
            <td colspan="2" align="center"><b><%= getLabel("AD")%></b></td>
            <td colspan="2" align="center"><b><%= getLabel("TSS")%></b></td>
        </tr>
        <tr>
            <td align="center" width="25%"><%= getLabel("WHENCREATED")%></td>
            <td align="center" width="25%"><%= format(details.getAd_whencreated())%></td>
            <td align="center" width="25%"><%= getLabel("WHENCREATED")%></td>
            <td align="center" width="25%"><%= format(details.getTss_whencreated())%></td>
        </tr>
        <tr>
            <td align="center"><%= getLabel("WHENCHANGED")%></td>
            <td align="center"><%= format(details.getAd_whenchanged())%></td>
            <td align="center"><%= getLabel("WHENCHANGED")%></td>
            <td align="center"><%= format(details.getTss_whenchanged())%></td>
        </tr>
        <tr>
            <td align="center"><%= getLabel("LOGONCOUNT")%></td>
            <td align="center"><%= details.getAd_logoncount()%></td>
            <td align="center"><%= getLabel("LOGONCOUNT")%></td>
            <td align="center"><%= details.getTss_logoncount()%></td>
        </tr>
        <tr>
            <td align="center"><%= getLabel("LASTLOGON")%></td>
            <td align="center"><%= format(details.getAd_lastlogon())%></td>
            <td align="center"><%= getLabel("LASTLOGON")%></td>
            <td align="center"><%= format(details.getTss_lastlogon())%></td>
        </tr>
        <tr>
            <td align="center"><%= getLabel("PWDLASTSET")%></td>
            <td align="center"><%= format(details.getAd_pwdlastset())%></td>
            <td align="center"><%= getLabel("PWDLASTSET")%></td>
            <td align="center"><%= format(details.getTss_pwdlastset())%></td>
        </tr>
        <tr>
            <td align="center">&nbsp;</td>
            <td align="center">&nbsp;</td>
            <td align="center"><%= getLabel("PWDEXPIRES")%></td>
            <td align="center"><%= format(details.getTss_pwdexpires())%></td>
        </tr>
		</table>
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