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
  -- $Id: compositesProducts.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapAsset" %>
<%@ page import="com.entelience.soap.soapDirectory" %>
<%@ page import="com.entelience.objects.asset.CompositeProduct" %>
<%@ page import="com.entelience.objects.asset.CompositeVersion" %>
<%@ page import="com.entelience.objects.asset.CompositeProductId" %>
<%@ page import="com.entelience.objects.asset.CompositeVersionId" %>
<%@ page import="com.entelience.objects.asset.ProductVersion" %>
<%@ page import="com.entelience.objects.DropDown" %>
<%@ page import="com.entelience.sql.DbHelper" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
	// Class declarations
	Map<Integer, String> types;
	Map<Integer, String> technologies;
	//Generic
	public String generateTitle(CompositeProduct compProd, CompositeVersion compVers){
		StringBuffer title = new StringBuffer();
		if(compProd != null)
		{
			title.append(compProd.getVendor_name());
			title.append(' ').append(compProd.getProduct_name());
		}
		if(compVers != null)
			title.append(' ').append(compVers.getVersion());
		return title.toString();
	}
	//CompositeProduct
	public String getStatus(CompositeProduct p){
		if(p.isActive())
			return "Active";
		if(p.isEsis_hide())
			return "Hidden";
		return "N/A";
	}
	public String getType(CompositeProduct p){
		if(p.getType_id() == null) return "Unknown";
		return types.get(p.getType_id());
	}
	public String getTechnology(CompositeProduct p){
		if(p.getTechnology_id()== null) return "Unknown";
		return technologies.get(p.getTechnology_id());
	}
	public String getObsolescenceAndSupport(CompositeProduct p){
		StringBuffer res = new StringBuffer();
		boolean first = true;
		if(p.getSupported() != null){
			if(p.getSupported().booleanValue())
				res.append("Supported");
			else
				res.append("Non supported");
			first = false;
		}
		if(p.getObsoleted() != null){
			if(!first)
				res.append(", ");
			if(p.getObsoleted().booleanValue())
				res.append("Obsoleted");
			else
				res.append("Non obsoleted");
		}
		return res.toString();
	}
	//CompositeVersion
	public String getStatus(CompositeVersion v){
		if(v.isActive())
			return "Active";
		return "N/A";
	}
	public String getObsolescenceAndSupport(CompositeVersion v){
		StringBuffer res = new StringBuffer();
		boolean first = true;
		if(v.getSupported() != null){
			if(v.getSupported().booleanValue())
				res.append("Supported");
			else
				res.append("Non supported");
			first = false;
		}
		if(v.getObsoleted() != null){
			if(!first)
				res.append(", ");
			if(v.getObsoleted().booleanValue())
				res.append("Obsoleted");
			else
				res.append("Non obsoleted");
		}
		return res.toString();
	}
%>
<%
try {
	// code
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	// Now we can use webservices
	//Read parameters
	Integer compAppId = getParamInteger(request, "compAppId");
	Integer compVersId = getParamInteger(request, "compVersId");
	//convert in id objects
	CompositeProductId appId = null;
	CompositeVersionId appVersId = null;
	if(compAppId == null)
		appId = null;
	else{
		try{
			appId = new CompositeProductId(compAppId.intValue(), 0);
		} catch(Exception e){
			//null compAppId
			appId = null;
		}
	}
	if(compVersId == null)
		appVersId = null;
	else{
		try{
			appVersId = new CompositeVersionId(compVersId.intValue(), 0);
		} catch(Exception e){
			//null compVersId
			appVersId = null;
		}
	}
	//soap
	soapAsset sa = new soapAsset(peopleId);
	soapDirectory dir = new soapDirectory(peopleId);
	//set objects
	CompositeProduct compProd = null;
	CompositeVersion compVers = null;
	if(appId != null){
		compProd = sa.getCompositeProduct(appId);
	}
	ProductVersion[] prodVersLinked = null;
	if(appVersId != null){
		compVers =  sa.getCompositeVersion(appVersId);
		prodVersLinked = sa.listProductsInCompositeVersion(appVersId);
	}
	//get dropdowns
	DropDown[] dd = sa.getListTechnologies();
	technologies = new HashMap<Integer, String>();
	for(int i=0; i<dd.length; i++){
	    technologies.put(Integer.valueOf(dd[i].getData()), dd[i].getLabel());
	}
	dd = sa.getListTypes();
	types = new HashMap<Integer, String>();
	for(int i=0; i<dd.length; i++){
	    types.put(Integer.valueOf(dd[i].getData()), dd[i].getLabel());
	}
	// end code
%>
<head>
<title><%= generateTitle(compProd, compVers)%></title>
<%@ include file="../style.inc.jsp" %>
</head>
<body>
<table width="100%" border="0" align="center" bgcolor="white">
<tr>
	<td>
		<div align="center">
		<!-- Header -->
		<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0">
		<tr>
			<td width="20%" rowspan="2" align="left"><a href="http://esis.sourceforge.net/" target="_blank"><%@ include file="../icon.inc.jsp" %></a></td>
			<td width="80%" align="center" class="title">Composite product details</td>
		</tr>
		<tr>
			<td align="center" class="subtitle"><%= generateTitle(compProd, compVers)%></td>
		</tr>
		</table>
		<%
		if(compProd!= null){
		//Vendor infos
		%>
		<br/>&nbsp;<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="80%">
		<tr>
			<td colspan="4" align="center" bgcolor="gainsboro"><b><%= compProd.getVendor_name()%></b></td>
		</tr>
		</table>
		<%
		//Product infos
		%>
		<br/>
		&nbsp;<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="80%">
		<tr>
			<td colspan="4" align="center" bgcolor="gainsboro"><b><%= compProd.getProduct_name()%></b></td>
		</tr>
		<tr>
			<td width="25%">Status</td>
			<td width="25%"><b><%= getStatus(compProd)%></b></td>
			<td width="25%">Type</td>
			<td width="25%"><b><%= getType(compProd)%></b></td>
		</tr>
		<tr>
			<td width="25%">Technology</td>
			<td width="25%"><b><%= getTechnology(compProd) %></b></td>
			<td width="25%">Obsolescence date</td>
			<td width="25%"><b><%= formatDate(compProd.getObsolescence_date())%></b></td>
		</tr>
		<%
		if(compProd.getSupported() != null || compProd.getObsoleted() != null){
		%>
		<tr>
			<td colspan="4" align="center"><b><%= getObsolescenceAndSupport(compProd)%></b></td>
		</tr>
		<%
		}
		%>
		</table>
		<%
		}
		//Version infos
		if(compVers!= null){
		%>
		<br/>
		&nbsp;<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="80%">
		<tr>
			<td colspan="4" align="center" bgcolor="gainsboro"><b><%= compVers.getVersion()%></b></td>
		</tr>
		<tr>
			<td width="25%">Status</td>
			<td width="25%"><b><%= getStatus(compVers) %></b></td>
			<td width="25%">Latest version</td>
			<td width="25%"><b><%= compVers.isLatest() ? "Yes" : "No" %></b></td>
		</tr>
		<tr>
			<td width="25%">Obsolescence date</td>
			<td width="25%"><b><%= formatDate(compVers.getObsolescence_date())%></b></td>
			<%
			if(compVers.getSupported() == null && compVers.getObsoleted() == null){
			%>
			<td colspan="2">&nbsp;</td>
			<%
			} else {
			%>
			<td colspan="2" align="center"><b><%= getObsolescenceAndSupport(compVers)%></b></td>
			<%
			}
			%>
		</tr>
		</table>
		<br/>
		&nbsp;<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="80%">
		<tr>
			<td colspan="3" align="center" bgcolor="gainsboro"><b>Products and versions linked to <%= compProd.getVendor_name()%> <%= compProd.getProduct_name()%> <%= compVers.getVersion()%></b></td>
		</tr>
		<tr>
			<td width="33%" align="center" bgcolor="gainsboro"><b>Vendor</b></td>
			<td width="34%" align="center" bgcolor="gainsboro"><b>Products</b></td>
			<td width="33%" align="center" bgcolor="gainsboro"><b>Versions</b></td>
		</tr>
		<%
		if (prodVersLinked == null || prodVersLinked.length == 0) {
		%>
		<tr>
			<td colspan="3" align="center">No product or version linked.</td>
		</tr>
		<%
		} else {
			for (int i=0; i<prodVersLinked.length; ++i) {
		%>
		<tr>
			<td width="33%" align="center"><%= DbHelper.unnullify(prodVersLinked[i].getVendorName())%></td>
			<td width="34%" align="center"><%= DbHelper.unnullify(prodVersLinked[i].getProductName())%></td>
			<td width="33%" align="center"><%= DbHelper.unnullify(prodVersLinked[i].getVersionName())%></td>
		</tr>
		<%
			}
		}
		%>
		</table>
		<%
		}
		%>
		<%@ include file="../copyright.inc.jsp" %>
		</div>
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