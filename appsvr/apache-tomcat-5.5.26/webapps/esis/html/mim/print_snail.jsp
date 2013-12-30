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
  -- $Id: print_snail.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapIdentityManagement" %>
<%@ page import="com.entelience.objects.mim.SnailDataJsp" %>
<%@ page import="com.entelience.util.Config" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
	// Class declarations
	static double percent_low;
	static double percent_medium;
	static double percent_high;
	static double percent_bad;
	static{
		try{
                  com.entelience.sql.Db db = com.entelience.sql.DbConnection.mainDbRO();
                  try {
    		    percent_low = Config.getProperty(db, "com.entelience.esis.im.snail_colors.percent_low", 75.0);
    		    percent_medium = Config.getProperty(db, "com.entelience.esis.im.snail_colors.percent_medium", 90.0);
    		    percent_high = Config.getProperty(db, "com.entelience.esis.im.snail_colors.percent_high", 110.0);
    		    percent_bad = Config.getProperty(db, "com.entelience.esis.im.snail_colors.percent_bad", 125.0);
                    percent_low = (percent_low <= 0) ? 75.0 : percent_low;
                    percent_medium = (percent_medium <= 0) ? 90.0 : percent_medium;
	            percent_high = (percent_high <= 0) ? 110.0 : percent_high;
	            percent_bad = (percent_bad <= 0) ? 125.0 : percent_bad;
                  } finally {
                    db.safeClose();
                  }
    	        } catch(Exception e){
                  percent_low=75.0;
                  percent_medium=90.0;
                  percent_high=110.0;
                  percent_bad=125.0;
                }
        } // static initialiser end
	
	public String getData(List<List<Number>> data, int i, int j) {
          String ret="";
          try{
            Number o = data.get(i).get(j);
            double tmp = o.doubleValue();
            tmp = (double)(((int)(100*tmp))/100.0); // round down to two digits of decimal precision
            return String.valueOf(tmp);
          } catch(Exception e) {
            _logger.warn("Ignored Exception ",e);
          }
          return "&nbsp;";
	}
	
	public void initLabels(){
	   labels = new HashMap<String,String>();
	   labels.put("ORG_METRICS_en", "Organization metrics");
	   labels.put("GEO_METRICS_en", "Geography metrics");
	   labels.put("UNIT_METRIC_en", "Unit \\ Metric");
	   labels.put("TARGETS_en", "Targets");
	   labels.put("DDS_en", "Out delay");
	   labels.put("DDE_en", "In delay");
	   labels.put("DDC_en", "Connection delay");
	   labels.put("DPC_en", "Administration delay");
	   labels.put("ORG_METRICS_fr", "Indicateurs par organisation");
	   labels.put("GEO_METRICS_fr", "Indicateurs par g&eacute;ographie");
	   labels.put("UNIT_METRIC_fr", "Unit&eacute; \\ Indicateur");
	   labels.put("TARGETS_fr", "Objectifs");
	   labels.put("DDS_fr", "D&eacute;lai de sortie");
	   labels.put("DDE_fr", "D&eacute;lai d'entr&eacute;e");
	   labels.put("DDC_fr", "D&eacute;lai de connexion");
	   labels.put("DPC_fr", "D&eacute;lai de prise en charge");
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
	
	public String getColor(SnailDataJsp snail, int i, int j) {
                double value=0.0f;
                double target=0.0f;
                boolean isGoodValue=true;
                List<List<Number>> data = snail.getDatas();
                List<Double> targets = snail.getTarget_levels();
                try{
                        List<Number> al = data.get(i);
                        if(al.get(j).getClass().getName().equals("java.lang.Float"))
                                value = al.get(j).doubleValue();
                        else
                                isGoodValue = false;
                        target = targets.get(j).doubleValue();
                }  catch(Exception e) {
			isGoodValue = false;
		}
                if(!isGoodValue || target == 0) return "FFFFFF";
                double percent = (value*100)/target;
                if(percent < 0) return "990000";
                else if (percent <= percent_low) return "009933";
                else if (percent <= percent_medium) return "99CC00";
                else if (percent <= percent_high) return "FFFF33";
                else if (percent <= percent_bad) return "FF9933";
                else return "FF3333";
	}
	
	Map<String,String> labels;
	String language;
	
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
	// Now we can use webservices
	// Read parameters.
        language = getParam(request, "lang");
        if(language == null || language.length()==0)
            language = "fr";

        String type = getParam(request, "type");
        String name = getParam(request, "name");
        int scale = getParamInt(request, "scale");
        int level = getParamInt(request, "level");


        soapIdentityManagement im = new soapIdentityManagement(peopleId);
	SnailDataJsp snail = null;
        if("geo".equals(type))
            snail = im.getGeoSnailForPrint(name, level, scale);
        else 
            snail = im.getOrgSnailForPrint(name, level, scale);
        initLabels();
	// end code
%>
<head>
	<title><%
	if("geo".equals(type)) {
	%><%= getLabel("GEO_METRICS") %><%
	} else if("org".equals(type)) {
	%><%= getLabel("ORG_METRICS") %><%
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
			if("geo".equals(type)) {
			%><%= getLabel("GEO_METRICS") %><%
			} else if("org".equals(type)) {
			%><%= getLabel("ORG_METRICS") %><%
			}
			%></td>
		</tr>
		</table>
		<table border="0" cellspacing="0" cellpadding="4" width="100%">
		<tr>
			<td align="center" class="subtitle"><%= snail.getName() %></td>
		</tr>
		</table>
		<br/>
		&nbsp;<br/>
		<%
		//compute width for rows
		int percent = (int)(70/(snail.getMetric_names().size()));
		int percentlow = (int)(percent*0.2);
		percent -= percentlow;
		%>
		<table border="1" cellspacing="0" cellpadding="4" width="90%">
		<tr>
			<td width="30%"><b><%= getLabel("UNIT_METRIC") %></b></td>
			<%
			for(int i=0; i<snail.getMetric_names().size(); i++){
			%>
				<td><b><%=formatMetricName(snail.getMetric_names().get(i).toString()) %></b></td>
			<%
			}
			%>
		</tr>
		<tr>
			<td align="center"><i><%= getLabel("TARGETS") %></i></td>
			<%
			for(int i=0; i<snail.getTarget_levels().size(); i++){
			%>
				<td align="center"><i><%=snail.getTarget_levels().get(i) %></i></td>
			<%
			}
			%>
		</tr>
		<%
		for(int i=0; i<snail.getTitles().size(); i++){
		%>
			<tr>
				<td align="center"><%=snail.getTitles().get(i) %></td>
				<%
				for(int j=0; j<snail.getMetric_names().size(); j++){
				%>
					<td align="center" bgcolor="<%=getColor(snail,i,j) %>"><%=getData(snail.getDatas(),i,j) %></td>
				<%
				}
				%>
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