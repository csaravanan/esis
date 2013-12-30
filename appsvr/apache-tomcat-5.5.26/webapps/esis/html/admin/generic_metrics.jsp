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
  -- $Id: generic_metrics.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapModule" %>
<%@ page import="com.entelience.objects.module.ModuleMetric" %>
<%@ page import="com.entelience.objects.module.ModuleInfoLine" %>
<%@ page import="com.entelience.util.DateHelper" %>
<%@ page import="com.entelience.sql.DbHelper" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
        //Class definition : Do not put transient vars here
        public String nAifyNull(String s){
                //return "NA" instead of null
                if(s == null)
                        return "N/A";
                return s;
        }
%>

<%
// code
// Check session id validity
try{
        Integer peopleId = getSession(request);
        initTimeZone(peopleId);
        soapModule sm = new soapModule(peopleId);
        int moduleId= getParamInt(request, "moduleId");
        List<ModuleMetric[]> metrics = new ArrayList<ModuleMetric[]>();
        List<String> metricNames = new ArrayList<String>();
        metrics.add(sm.listMetricsForModule(moduleId, "I")); metricNames.add("Integrity");
        metrics.add(sm.listMetricsForModule(moduleId, "C")); metricNames.add("Compliance");
        metrics.add(sm.listMetricsForModule(moduleId, "A")); metricNames.add("Availability");
        metrics.add(sm.listMetricsForModule(moduleId, "Re")); metricNames.add("Reactivity");
        metrics.add(sm.listMetricsForModule(moduleId, "Ro")); metricNames.add("Robustness");
        metrics.add(sm.listMetricsForModule(moduleId, "E")); metricNames.add("Exposure");
         
        ModuleInfoLine mod = sm.getModuleInformation(moduleId);
        String todaysDate = formatDate(DateHelper.now());
%>
<!-- Now begins HTML page ...-->
<head>
<title>Metrics for module <%= mod.getName()%> - <%= todaysDate %> </title>
<%@ include file="../style.inc.jsp" %>
</head>
<body>
<!-- Main table -->
<table width="100%" border="0" bgcolor="white">
<tr>
	<td>
	<div align="center">
	<!-- Header table with title -->
	<table border="0" cellspacing="0" cellpadding="4" width="100%">
	<tr>
		<td width="20%" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
        <td width="80%" align="center" class="title">Metrics for module <%= mod.getName()%> - <%= todaysDate %></td>
		</tr>
        </table>
	<!-- end Header table with title -->
	<br/>
	
	<%
	  for(int j=0; j< metrics.size(); j++){
	       ModuleMetric[] mm =  metrics.get(j);
	       String metricName = (String) metricNames.get(j);
	%>
	
	<%
	if (mm != null && mm.length>0) {
	%>
	
	<!-- Integrity -->
	<br/>
	<table border="1" cellspacing="0" cellpadding="4" width="90%">
	<tr><th colspan="7"><%= metricName%></th></tr>
	<tr>
	<th align="center" bgcolor="gainsboro">Metric name</th>
	<th align="center" bgcolor="gainsboro">Timescale</th>
	<th align="center" bgcolor="gainsboro">Target</th>
	<th align="center" bgcolor="gainsboro">Count</th>
	<th align="center" bgcolor="gainsboro">Min</th>
	<th align="center" bgcolor="gainsboro">Max</th>
	<th align="center" bgcolor="gainsboro">Avg</th>
	</tr>
	<%
	       for(int i=0; i< mm.length; i++){
	%>
	<tr>
	<td align="center"><%= mm[i].getDescription() %></td>
	<td align="center"><%=nAifyNull(mm[i].getTimingName()) %></td>
	<td align="center"><%=mm[i].getTarget()+" "+DbHelper.unnullify(mm[i].getUnit())%></td>
	<td align="center"><%=mm[i].isSingleValue() ? mm[i].getCount()+" "+DbHelper.unnullify(mm[i].getUnit()) : "N/A"%></td>
	<td align="center"><%=mm[i].isSingleValue() || mm[i].getMin() == null ? "N/A" : mm[i].getMin().intValue()+" "+DbHelper.unnullify(mm[i].getUnit())%></td>
	<td align="center"><%=mm[i].isSingleValue() || mm[i].getMax() == null ? "N/A" : mm[i].getMax().intValue()+" "+DbHelper.unnullify(mm[i].getUnit())%></td>
	<td align="center"><%=mm[i].isSingleValue() || mm[i].getAvg() == null ? "N/A" : mm[i].getAvg().intValue()+" "+DbHelper.unnullify(mm[i].getUnit())%></td>
	</tr>
	<% } //end for 
	%> 
	</table>
	<% } //end if
	%>
	<% } //end for
	%>
	
	
	<%@ include file="../copyright.inc.jsp" %>
	</div>
	</td>
</tr>
</table>
<!-- end Main table -->
</body>
</html>
<%
} catch(Exception e){
	_logger.error("Exception during JSP execution", e);
	setErrorMessage(response, e, getSessionId(request));
}
%>