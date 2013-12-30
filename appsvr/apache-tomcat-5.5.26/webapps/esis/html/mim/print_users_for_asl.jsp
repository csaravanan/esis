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
  -- $Id: print_users_for_asl.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapIdentityManagement" %>
<%@ page import="com.entelience.objects.mim.UserMetrics" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
	// Class declarations
	public void initLabels(){
	   labels = new HashMap<String,String>();
	   labels.put("USERS_TITLE_en", "Users for administrator ");
	   labels.put("USER_ID_en", "User Id");
	   labels.put("ERROR_PARAMS_en", "Parameters error for JSP");
	   labels.put("DDS_en", "Out delay");
	   labels.put("DDE_en", "In delay");
	   labels.put("DDC_en", "Connection delay");
	   labels.put("DPC_en", "Administration delay");
	   labels.put("TARGETS_en", "Targets");
	   
	   labels.put("USERS_TITLE_fr", "Utilisateurs de l'administrateur ");
	   labels.put("USER_ID_fr", "Identifiant Utilisateur");
	   labels.put("ERROR_PARAMS_fr", "Erreur dans les param&egrave;tres d'appel de la JSP");
	   labels.put("DDS_fr", "D&eacute;lai de sortie");
	   labels.put("DDE_fr", "D&eacute;lai d'entr&eacute;e");
	   labels.put("DDC_fr", "D&eacute;lai de connexion");
	   labels.put("DPC_fr", "D&eacute;lai de prise en charge");
	   labels.put("ASL_ID_fr", "Identifiant");
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
      
      // Now we can use webservices
        // Read parameters.
        language = getParam(request, "lang");
        if(language == null || language.length()==0)
            language = "fr";
        initLabels();
        
        String asl_id = getParam(request, "asl_id");
        String filter = getParam(request, "filter");
        int scale = getParamInt(request, "scale");
        String geo = getParam(request, "geo");
        String org = getParam(request, "org");
        
        String unit = "";
        if (geo != null && geo.length() > 0)
        {
            unit = "("+geo+")";
        }
        if (org != null && org.length() > 0)
        {
            unit = "("+org+")";
        }
        soapIdentityManagement im = new soapIdentityManagement(peopleId);

        
        UserMetrics[] users = im.getUsersForAslForPrint(asl_id, filter, scale, org, geo);
        
        double target_dds = im.getTargetLevel("dds");
        double target_dde = im.getTargetLevel("dde");
        double target_ddc = im.getTargetLevel("ddc");
        double target_dpc = im.getTargetLevel("dpc");      
	// end code
%>
<head>
	<title><%= getLabel("USERS_TITLE")+" "+asl_id +" "+unit%></title>
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
			<td width="80%" align="center" class="title"><%= getLabel("USERS_TITLE")+" "+asl_id %></td>
		</tr>
		</table>
		<br/>
		&nbsp;<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
        	<td width="28%"><b><%= getLabel("USER_ID") %></b></td>
        	<td width="18%"><b><%= formatMetricName("dpc") %></b></td>
			<td width="18%"><b><%= formatMetricName("ddc") %></b></td>
			<td width="18%"><b><%= formatMetricName("dde") %></b></td>
			<td width="18%"><b><%= formatMetricName("dds") %></b></td>
		</tr>
		<tr>
        	<td align="center"><i><%= getLabel("TARGETS") %></i></td>
        	<td align="center"><i><%= target_dpc %></i></td>
        	<td align="center"><i><%= target_ddc %></i></td>
        	<td align="center"><i><%= target_dde %></i></td>
        	<td align="center"><i><%= target_dds %></i></td>
    	</tr>
		<%
		for(int i=0; i<users.length; i++){
		%>
		<tr>
        	<td align="center"><%= users[i].getUser_id() %></td>
        	<td align="center"><%
			if(users[i].getDpc()==null || "_".equals(users[i].getDpc())){
			%>&nbsp;<%
			} else {
			%><%= users[i].getDpc() %><%
			}
			%></td>
			<td align="center"><%
			if(users[i].getDdc()==null || "_".equals(users[i].getDdc())){
			%>&nbsp;<%
			} else {
			%><%= users[i].getDdc() %><%
			}
			%></td>
			<td align="center"><%
			if(users[i].getDde()==null || "_".equals(users[i].getDde())){
			%>&nbsp;<%
			} else {
			%><%= users[i].getDde() %><%
			}
			%></td>
			<td align="center"><%
			if(users[i].getDds()==null || "_".equals(users[i].getDds())){
			%>&nbsp;<%
			} else {
			%><%= users[i].getDds() %><%
			}
			%></td>
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