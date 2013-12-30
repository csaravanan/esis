<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<!-- the HTML header allows us to view the jsp as an html file in web browsers -->
<%--
  -- ESIS
  --
  -- Copyright (c) 2004-2008 Entelience SARL,  Copyright (c) 2008-2009 Equity SA
  -- Copyright (c) 2010 Consulare sàrl
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
  -- $Id: anomalies_users.jsp 373 2010-04-09 18:46:30Z pleberre $
  --
  --%>
<%@ page import="com.entelience.soap.soapIdentityManagement" %>
<%@ page import="com.entelience.objects.FileImportHistory" %>
<%@ page import="com.entelience.objects.mim.AnomalyStats" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
	// Class declarations
	
	protected int calcNbColumns(Object[] res) {
        return (res.length>8?8:res.length);
	}
	
	protected int calcNbLines(Object[] res, int nbColumns) {
        if(nbColumns == 0) return 0;
        int result = (int)(res.length/nbColumns)+1;
        while((result-1)*nbColumns >= res.length)
            result--;
        return result;
	}
	
    Map<String,String> labels;
	String language;
	
	public void initLabels() {
	   labels = new HashMap<String,String>();
	   labels.put("USERS_NON_IMPORTED_en", "Failed import users");
	   labels.put("ANOMALY_TYPE_en", "Anomaly type");
	   labels.put("NUMBER_OF_USERS_en", "Number of Users");
	   labels.put("NO_USER_en", "No User have this anomaly");
	   labels.put("ONE_USER_en", "1 User has this anomaly");
	   labels.put("MANY_USERS_en", "Users have this anomaly");
	   labels.put("ID_en", "ID");
	   labels.put("SEE_ALL_en", "See all anomalies");
           labels.put("FILE_IMPORT_HISTORY_en", "File import history");
	   labels.put("USERS_NON_IMPORTED_fr", "Utilisateurs non import&eacute;s");
	   labels.put("ANOMALY_TYPE_fr", "Type d'anomalie");
	   labels.put("NUMBER_OF_USERS_fr", "Nombre d'utilisateurs");
	   labels.put("NO_USER_fr", "Aucun utilisateur n'a cette anomalie");
	   labels.put("ONE_USER_fr", "1 Utilisateur a cette anomalie");
	   labels.put("MANY_USERS_fr", "Utilisateurs ont cette anomalie");
	   labels.put("ID_fr", "Identifiant");
	   labels.put("SEE_ALL_fr", "Voir toutes les anomalies");
           labels.put("FILE_IMPORT_HISTORY_fr", "Historique des imports");
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
	//need it to pass it as parameter to link in the page
	//do it by hand, because thi page is special
	Integer peopleId = getSession(request);
	String sid = request.getHeader("Session-Id"); //used later

    int nbColumns;
	
	AnomalyStats[] resultAL =null;
	String[] resultS =null;
	List<Integer> ano_ids =null;
	// Now we can use webservices
	// Read parameters.
	String language = getParam(request, "lang");
	if(language == null || language.length()==0)
		language = "fr";
	String anomalyStr = getParam(request, "anomaly");
	_logger.debug(anomalyStr);
	int anomaly =-1;
	if(!"all".equals(anomalyStr)){
		anomaly = getParamInt(request, "anomaly");
	}
	soapIdentityManagement im = new soapIdentityManagement(peopleId);
	
	if("all".equals(anomalyStr)){
		resultAL = im.getFailedUsersStats();
		ano_ids = new ArrayList<Integer>();
		for(int i=0; i<resultAL.length; i++){
			ano_ids.add(resultAL[i].getAnomaly_id());
		}
	}else if(anomaly == -1){
		resultAL = im.getFailedUsersStats();
	}else{
		resultS = im.getFailedUsersForAnomaly(anomaly);
	}
	FileImportHistory fih = im.getImportInfosForAnomalies();
	initLabels();
	// end code
%>
<head>
	<title>ESIS - <%= getLabel("USERS_NON_IMPORTED") %></title>
	<%@ include file="../style.inc.jsp" %>
</head>
<body>
<table width="100%" border="0" align="center" bgcolor="white">
<tr>
	<td>
		<div align="center">
		<table border="0" cellspacing="0" cellpadding="4" width="100%">
		<tr>
			<td width="20%" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
			<td width="80%" align="center" class="title"><%= getLabel("FILE_IMPORT_HISTORY") %></td>
		</tr>
		</table>
		<table border="0" cellspacing="0" cellpadding="4" width="100%">
		<tr>
			<td align="center" class="subtitle"><%= fih.getRun_date() + " - "+ fih.getFile_name()%>
			<br/><%= im.getAnomalyForAnomalyId(anomaly) %></td>
		</tr>
		</table>
		<br/>
		&nbsp;<br/>
		<%
		if ("all".equals(anomalyStr)){
		%>
			<table border="1" cellspacing="0" cellpadding="4" width="90%">
			<tr>
				<td align="center" width="50%"><b><%= getLabel("ANOMALY_TYPE") %></b></td>
				<td align="center" width="50%"><b><%= getLabel("NUMBER_OF_USERS") %></b></td>
			</tr>
			<%
			for(int i=0; resultAL!=null && i<resultAL.length; i++){
			%>
				<tr>
					<td align="center"><a href="#a<%=resultAL[i].getAnomaly_id() %>"><%=resultAL[i].getAnomaly() %></a></td>
					<td align="center"><%=resultAL[i].getNb_users() %></td>
				</tr>
			<%
			}//end for
			%>
			</table>
			<%
			for(int k=0; k<ano_ids.size(); k++){
			%>
				<br/>
				&nbsp;<br/>
				&nbsp;<br/>
				&nbsp;<br/>
				<a name="a<%= ano_ids.get(k) %>"></a>
				<%
				resultS = im.getFailedUsersForAnomaly((ano_ids.get(k)).intValue());
				nbColumns = calcNbColumns(resultS);
				int nbLines = calcNbLines(resultS, nbColumns);
				if(resultS.length == 0){
					%><%= getLabel("NO_USER") %><%
				} else if (resultS.length == 1){
					%><%= getLabel("ONE_USER") %><%
				} else{
					%><%=resultS.length %> <%= getLabel("MANY_USERS") %><%
				}
				%>
				<table border="1" cellspacing="0" cellpadding="4" width="90%">
				<tr>
					<td colspan="<%= nbColumns %>"><%= im.getAnomalyForAnomalyId(((Integer)ano_ids.get(k)).intValue()) %></td>
				</tr>
				<tr>
				<%
				//create labels
				for(int i=0; i<nbColumns; i++){
				%>
					<td><b><%= getLabel("ID") %></b></td>
				<%
				}
				%>
				</tr>
				<%
				//create line of datas
				for(int i=0; i<nbLines; i++){
				%>
					<tr>
					<%
					for(int j=0; j<nbColumns; j++){
						if(i+(j*nbLines)<resultS.length){
						%>
						<td align="center"><%=resultS[i+(j*nbLines)] %></td>
						<%
						}else{
						%>
						<td align="center">&nbsp;</td>
						<%
						}
					}
					%>
					</tr>
				<%
				}
				%>
				</table>
			<%
			}//end for
		} else if(anomaly == -1){
		%>
			<table border="1" cellspacing="0" cellpadding="4" width="90%">
			<tr>
				<td><b><%= getLabel("ANOMALY_TYPE") %></b></td>
				<td><b><%= getLabel("NUMBER_OF_USERS") %></b></td>
				<td><b>&nbsp;</b></td>
			</tr>
			<%
			for(int i=0; i<resultAL.length; i++){
			%>
				<form action="anomalies_users.jsp" method="POST">
				<input type="hidden" name="Session-Id" value="<%=sid%>">
				<input type="hidden" name="anomaly" value="<%=resultAL[i].getAnomaly_id()%>">
				<tr>
					<td align="center"><%=resultAL[i].getAnomaly() %></td>
					<td align="center"><%=resultAL[i].getNb_users() %></td>
					<td align="center"><input type="submit" value="Voir"></td>
				</tr>
				</form>
			<%
			}
			%>
			<tr>
				<form action="anomalies_users.jsp" method="POST">
				<input type="hidden" name="Session-Id" value=<%=sid%>>
				<input type="hidden" name="anomaly" value="all">
				<td align="center" colspan="3"><input type="submit" value="Voir tous"></td>
				</form>
			</tr>
			</table>
		<%
		}else{
			nbColumns = calcNbColumns(resultS);
			int nbLines = calcNbLines(resultS, nbColumns);
			if(resultS.length == 0){
			%><%= getLabel("NO_USER") %><%
			} else if (resultS.length == 1){
			%><%= getLabel("ONE_USER") %><%
			} else{
			%><%=resultS.length %> <%= getLabel("MANY_USERS") %><%
			}
			%>
			<table border="1" cellspacing="0" cellpadding="4" width="90%">
			<tr>
				<%
				for(int i=0; i<nbColumns; i++){
				%>
					<td><b><%= getLabel("ID") %></b></td>
				<%
				}
				%>
			</tr>
			<%
			for(int i=0; i<nbLines; i++){
			%>
			<tr>
				<%
				for(int j=0; j<nbColumns; j++){
					if(i+(j*nbLines)<resultS.length){
					%>
					<td align="center"><%=resultS[i+(j*nbLines)] %></td>
					<%
					}else{
					%>
					<td align=center>&nbsp;</td>
					<%
					}
				}
				%>
			</tr>
			<%
			}//end for
			%>
			</table>
		<%
		}
		%>
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