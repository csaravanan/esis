<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" 
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
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
  -- $Id: portal.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
	/**
	* get parameters for WS call (they all start with p (p0, p1, p2, ...))
     * @return put them all in an array of string 
     */
	private String getParameters(HttpServletRequest request) throws Exception{
		boolean continueLoop = true;
		int i=1;
		StringBuffer params = new StringBuffer("");
		while(continueLoop){
			String param = getParam(request, "p"+i);
			if(param == null){
				//undefined parameter break
				continueLoop = false;
			}else{
				if (i > 1){
					params.append(',');
				}
				params.append(param);
			}
			i++;
		}
		return params.toString();
	}
%>
<%
try {
	String title = getParam(request, "portalTitle");
	String wsName = getParam(request, "wsName");
	String listLabelName = getParam(request, "listlabelName");
	String listlabelNumber = getParam(request, "listlabelNumber");
	String wsParams = getParameters(request);
%>
<html>
<head>
<title>ESIS - Fundamental metrics</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="publisher" content="ESIS">
<script type="text/javascript" src="/esis/js/swfobject.js"></script>
<script type="text/javascript" src="/esis/js/esisportal.js"></script>
<link rel="stylesheet" media="screen" type="text/css" title="Menu" href="css/cif.css" />
<script type="text/javascript">
<!--
//initialization of the Flash Portal
var _flashWidth = 700;
var _flashHeight = 500;
var _descriptionDefaultText = "";
var _protocol = "http";
var _host = "";
// end -->
</script>
</head>
<body>
<h2><%=title%></h2>
<hr />
<div id="portalcomponent">
<script type="text/javascript">
var so = new SWFObject("/esis/PORTAL.swf", "esisPortal", _flashWidth, _flashHeight, "8", "#EEEEEE");
so.addParam ("wmode", "transparent");
so.addVariable("portalWidth", _flashWidth);
so.addVariable("portalHeight", _flashHeight);
so.addVariable("wsParams", "<%=wsParams%>");
so.addVariable("wsName", "<%=wsName%>");
so.addVariable("portalTitle", "<%=title%>");
so.addVariable("listLabelName", "<%=listLabelName%>");
so.addVariable("listLabelNumber", "<%=listlabelNumber%>");
so.addVariable("multipleDatasTitles", "");
so.addVariable("portalProtocol", _protocol);
so.addVariable("portalHost", _host);
so.addVariable("portalSpotMetric", "");
so.addVariable("portalForceDisplay", 1);
so.addVariable("portalZoom", 0);
so.addVariable("portalRefresh", 0);
so.addVariable ("portalLanguage", "en");
so.write("portalcomponent");
</script>
</div>
<hr />
<div id="equitylogo">
<script type="text/javascript">
var so = new SWFObject("/esis/esisPoweredByLogo.swf", "equityLogo", "140", "51", "8", "#FFFFFF");
so.write("equitylogo");
</script>
</div>
</body>
</html>
<%
} catch(Exception e){
	_logger.error("Exception during JSP execution", e);
	setErrorMessage(response, e, getSessionId(request));
}
%>