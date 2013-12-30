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
  -- $Id: index.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<html>
<head>
<meta http-equiv="refresh" content="3;url=/esis/html/downloads/download_only_player.html" />
<title>ESIS :: Executive Security Information System</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script src="detection.js" type="text/javascript"></script>
<script type="text/javascript" src="js/swfobject.js"></script>
<style type="text/css">
<!--	
html, body{ 
	font-family:Verdana, Arial, Helvetica, sans-serif;
	font-size:10px;
	font-weight:normal;
	margin:0;
	padding:0;
	background-color:#B7C0C8;
}
-->	
</style>
</head>
<body>
<div id="flashcontent">&nbsp;</div>
<script type="text/javascript">
<!--
if (useFlashDetection) {
	//use swfobject script
	var so = new SWFObject("flash_detection.swf", "flashDetectionSwf", "80", "80", "7", "#B7C0C8");
	so.write("flashcontent");
} else {
	window.location = "module.jsp";
}
//-->
</script>
</body>
</html>