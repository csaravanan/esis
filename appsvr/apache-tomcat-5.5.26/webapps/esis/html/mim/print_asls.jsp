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
  -- $Id: print_asls.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapIdentityManagement" %>
<%@ page import="com.entelience.objects.mim.AslStatsElement" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
	// Class declarations
	public void initLabels(){
	   labels = new HashMap<String,String>();
	   labels.put("ASL_TITLE_en", "Logic Security Administrators");
	   labels.put("GEO_ASL_TITLE_en", "Logic Security Administrators for Geography ");
	   labels.put("ORG_ASL_TITLE_en", "Logic Security Administrators for Organization ");
	   labels.put("GEO_TITLE_en", "Logic Security Administrators for Geography ");
	   labels.put("ORG_TITLE_en", "Logic Security Administrators for Organization ");
	   labels.put("ERROR_PARAMS_en", "Parameters error for JSP");
	   labels.put("DDS_en", "Out delay");
	   labels.put("DDE_en", "In delay");
	   labels.put("DDC_en", "Connection delay");
	   labels.put("DPC_en", "Administration delay");
	   labels.put("ASL_ID_en", "Id");
	   labels.put("NB_USERS_en", "Users count");
	   labels.put("ORG_UNIT_en", "Organization Unit");
	   labels.put("GEO_UNIT_en", "Geographic Unit");
	   labels.put("TARGETS_en", "Targets");
	   
	   labels.put("ASL_TITLE_fr", "Administrateurs de S&eacute;curit&eacute; Logique");
	   labels.put("GEO_ASL_TITLE_fr", "Administrateurs de S&eacute;curit&eacute; Logique pour l'unit&eacute; g&eacute;ographique ");
	   labels.put("ORG_ASL_TITLE_fr", "Administrateurs de S&eacute;curit&eacute; Logique pour l'unit&eacute; organisationnelle ");
	   labels.put("GEO_TITLE_fr", "Administrateurs de S&eacute;curit&eacute; Logique <br>pour l'unit&eacute; g&eacute;ographique ");
	   labels.put("ORG_TITLE_fr", "Administrateurs de S&eacute;curit&eacute; Logique <br>pour l'unit&eacute; organisationnelle ");
	   labels.put("ERROR_PARAMS_fr", "Erreur dans les param&egrave;tres d'appel de la JSP");
	   labels.put("DDS_fr", "D&eacute;lai de sortie");
	   labels.put("DDE_fr", "D&eacute;lai d'entr&eacute;e");
	   labels.put("DDC_fr", "D&eacute;lai de connexion");
	   labels.put("DPC_fr", "D&eacute;lai de prise en charge");
	   labels.put("ASL_ID_fr", "Identifiant");
	   labels.put("NB_USERS_fr", "Nombre d'utilisateurs");
	   labels.put("ORG_UNIT_fr", "Unit&eacute; organisationnelle");
	   labels.put("GEO_UNIT_fr", "Unit&eacute; g&eacute;ographique");
	   labels.put("TARGETS_fr", "Objectifs");
	}
	
	public String formatMetricName(String metric){
	   if("dds".equals(metric))
	       return getLabel("DDS");
	   else if ("dde".equals(metric))
	       return getLabel("DDE");
	   else if ("ddc".equals(metric))
	       return getLabel("DDC");
	   else if ("dpc".equals(metric))
	       return getLabel("DPC");
	   else return metric;
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
	
	// end class declarations
%>
<%
try{
	// code
      // Check session id validity
       Integer peopleId = getSession(request);
	AslStatsElement[] asls;
      // Now we can use webservices
        // Read parameters.
        language = getParam(request, "lang");
        if(language == null || language.length()==0)
            language = "fr";
        initLabels();
        
        String type = getParam(request, "type");
        String name = getParam(request, "name");
        if(name == null) name = "";
        String filter = getParam(request, "filter");
        String order = getParam(request, "order");
        String desc = getParam(request, "desc");
        int scale = getParamInt(request, "scale");

        soapIdentityManagement im = new soapIdentityManagement(peopleId);

        
        if("geo".equals(type))
            asls = im.getAslStatsForGeoForPrint(name, order, desc, filter, scale);
        else if("org".equals(type))
            asls = im.getAslStatsForOrgForPrint(name, order, desc, filter, scale);
        else {
            %><%= getLabel("ERROR_PARAMS")%><%
            return;
        }
        
        double target_dds = im.getTargetLevel("dds");
        double target_dde = im.getTargetLevel("dde");
        double target_ddc = im.getTargetLevel("ddc");
        double target_dpc = im.getTargetLevel("dpc");
	// end code
%>
<head>
	<title><%
	if(name.length() == 0) {
	%><%= getLabel("ASL_TITLE")%><%
	} else if("geo".equals(type)) {
	%><%= getLabel("GEO_ASL_TITLE") + name %><%
	} else if("org".equals(type)) {
	%><%= getLabel("ORG_ASL_TITLE") + name %><%
	}
	%></title>
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
			<td width="80%" align="center" class="title"><%
			if(name.length() == 0) {
			%><%= getLabel("ASL_TITLE")%><%
			} else if("geo".equals(type)) {
			%><%= getLabel("GEO_TITLE") + name %><%
			} else if("org".equals(type)) {
			%><%= getLabel("ORG_TITLE") + name %><%
			}
			%></td>
		</tr>
		</table>
		<br/>
		&nbsp;<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td width="10%" align="center"><b><%= getLabel("ASL_ID") %></b></td>
			<td width="20%" align="center"><b><%= getLabel("GEO_UNIT") %></b></td>
			<td width="20%" align="center"><b><%= getLabel("ORG_UNIT") %></b></td>
			<td width="10%" align="center"><b><%= formatMetricName("dpc") %></b></td>
			<td width="10%" align="center"><b><%= formatMetricName("ddc") %></b></td>
			<td width="10%" align="center"><b><%= formatMetricName("dde") %></b></td>
			<td width="10%" align="center"><b><%= formatMetricName("dds") %></b></td>
			<td width="10%" align="center"><b><%= getLabel("NB_USERS") %></b></td>
		</tr>
		<tr>
			<td align="center"><i><%= getLabel("TARGETS") %></i></td>
			<td align="center">&nbsp;</td>
			<td align="center">&nbsp;</td>
			<td align="center"><i><%= target_dpc %></i></td>
			<td align="center"><i><%= target_ddc %></i></td>
			<td align="center"><i><%= target_dde %></i></td>
			<td align="center"><i><%= target_dds %></i></td>
			<td align="center">&nbsp;</td>
		</tr>
		<%
		for(int i=0; i<asls.length; i++){
		%>
		<tr>
			<td align="center"><%= asls[i].getAsl_id() %></td>
			<td align="center"><%
			if(asls[i].getGeography() == null || asls[i].getGeography().length()==0 || "_".equals(asls[i].getGeography())){
			%>&nbsp;<%
			} else {
			%><%= asls[i].getGeography() %><%
			}
			%></td>
			<td align="center"><%
			if(asls[i].getOrganization() == null || asls[i].getOrganization().length()==0 || "_".equals(asls[i].getOrganization())){
			%>&nbsp;<%
			} else {
			%><%= asls[i].getOrganization() %><%
			}
			%></td>
			<td align="center"><%
			if(asls[i].getDpc() == null || "_".equals(asls[i].getDpc())){
			%>&nbsp;<%
			} else {
			%><%= asls[i].getDpc() %><%
			}
			%></td><td align="center"><%
			if(asls[i].getDdc() == null || "_".equals(asls[i].getDdc())){
			%>&nbsp;<%
			} else {
			%><%= asls[i].getDdc() %><%
			}
			%></td>
			<td align="center"><%
			if(asls[i].getDde() == null || "_".equals(asls[i].getDde())){
			%>&nbsp;<%
			} else {
			%><%= asls[i].getDde() %><%
			}
			%></td>
			<td align="center"><%
			if(asls[i].getDds() == null || "_".equals(asls[i].getDds())){
			%>&nbsp;<%
			} else {
			%><%= asls[i].getDds() %><%
			}
			%></td>
			<td align="center"><%= asls[i].getNb_users() %></td>
		</tr>
		<%
		}
		%>
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