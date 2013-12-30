<%
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>
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
  -- $Id: module.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%
String width="1024";  // default width
String height="768"; // default height
String swfName="ESIS";
boolean isMSIE=false;
String userAgent;

// browser detection 100% if IE only ... else ... 1024x768
userAgent = request.getHeader("User-Agent");
userAgent = userAgent.toLowerCase(); //NOPMD
/*
if(userAgent != null ){
	if((userAgent.indexOf("msie") != -1)){
		width="100%";
		height="100%";
		isMSIE=true;
	}
}
*/
// check with request to find out if the user wants to try something different
//String tmp = request.getParameter("module");
//if (null != tmp && !"".equals(tmp)) { swfName = tmp; }
// page begins
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="detection.js"></script>
<script type="text/javascript" src="js/swfobject.js"></script>
<title>ESIS :: Executive Security Information System</title>
<style>
body {
	font-family:Verdana, Arial, Helvetica, sans-serif;
	font-size:10px;
	font-weight:normal;
	margin:0;
	padding:0;
	background-color:#B7C0C8;
}
</style>
</head>
<body>
<%
if (!isMSIE) {
%>
<table width="<%=width%>" height="<%=height%>" border="0" cellpadding="0" cellspacing="0" align="center">
<tr>
<td>
<%
}
%>
<!--
user agent = <%=userAgent%>
//-->
<div id="flashcontent" align="center">&nbsp;</div>
<script type="text/javascript">
<!--
var so = new SWFObject ("<%= swfName %>.swf", "<%= swfName %>Swf", <%= width %>, <%= height %>, "8.0.22", "#B7C0C8");
so.addParam("menu", true);
so.addParam("quality", "high");
//so.addParam("wmode", "transparent");
//so.addParam("salign", "t");
so.addVariable ("applicationLanguage", applicationLanguage);
so.write("flashcontent");
//-->
</script>
<%
if (!isMSIE) {
%>
</td>
</tr>
</table>
<%
}
%>
</body>
</html>