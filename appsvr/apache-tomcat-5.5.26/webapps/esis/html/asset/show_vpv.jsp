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
  -- $Id: show_vpv.jsp 11 2009-07-07 15:02:53Z tburdairon $
  --
  --%>
<%@ page import="com.entelience.soap.soapAsset" %>
<%@ page import="com.entelience.soap.soapDirectory" %>
<%@ page import="com.entelience.objects.asset.Vendor" %>
<%@ page import="com.entelience.objects.asset.Product" %>
<%@ page import="com.entelience.objects.asset.Version" %>
<%@ page import="com.entelience.objects.asset.VendorId" %>
<%@ page import="com.entelience.objects.asset.ProductId" %>
<%@ page import="com.entelience.objects.asset.VersionId" %>
<%@ page import="com.entelience.objects.DropDown" %>
<%@ page import="com.entelience.objects.directory.PeopleInfoLine"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page extends="com.entelience.servlet.JspBase" %>
<%!
	// Class declarations
	Map<Integer, String> types;
	Map<Integer, String> relationships;
	Map<Integer, String> technologies;
	Map<Integer, String> users;

	public String generateTitle(Vendor vendor, Product product, Version version){
		StringBuffer title = new StringBuffer();
		if(vendor != null)
			title.append(vendor.getVendor_name());
		if(product != null)
			title.append(' ').append(product.getProduct_name());
		if(version != null)
			title.append(' ').append(version.getVersion());
		return title.toString();
	}

	public String getStatus(Vendor v){
		if(v.isActive())
			return "Active";
		if(v.isEsis_hide())
			return "Hidden";
		return "N/A";
	}

	public String getStatus(Product p){
		if(p.isActive())
			return "Active";
		if(p.isEsis_hide())
			return "Hidden";
		return "N/A";
	}

	public String getStatus(Version v){
		if(v.isActive())
			return "Active";
		return "N/A";
	}

	public String getType(Product p){
		if(p.getType_id() == null) return "Unknown";
		return types.get(p.getType_id());
	}

	public String getPreferredRelationship(Vendor v){
		if(v.getPreferred_relationship_id() == null) return "Unknown";
		return relationships.get(v.getPreferred_relationship_id());
	}

	public String getTechnology(Product p){
		if(p.getTechnology_id()== null) return "Unknown";
		return technologies.get(p.getTechnology_id());
	}

	public String getUser(Integer peopleId){
		if(peopleId == null) return "Unknown";
		return users.get(peopleId);
	}

	public String getObsolescenceAndSupport(Version v){
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

	public String getObsolescenceAndSupport(Product p){
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
%>
<%
try {
	// code
	// Check session id validity
	Integer peopleId = getSession(request);
        initTimeZone(peopleId);
	// Now we can use webservices
	// Read parameters.
	Integer vendorId = getParamInteger(request, "e_vendor_id");
	Integer productId = getParamInteger(request, "e_product_id");
	Integer versionId = getParamInteger(request, "e_version_id");

	VendorId vendId = null;
	ProductId prodId = null;
	VersionId versId = null;
	if(vendorId == null)
		vendId = null;
	else{
		try{
			vendId = new VendorId(vendorId.intValue(), 0);
		} catch(Exception e){
			//null vendorId
			vendId = null;
		}
	}
	if(productId == null)
		prodId = null;
	else{
		try{
			prodId = new ProductId(productId.intValue(), 0);
		} catch(Exception e){
			//null productId
			prodId = null;
		}
	}
	if(versionId == null)
		versId = null;
	else{
		try{
			versId = new VersionId(versionId.intValue(), 0);
		} catch(Exception e){
			//null versionId
			versId = null;
		}
	}


	soapAsset sa = new soapAsset(peopleId);
	soapDirectory dir = new soapDirectory(peopleId);
	
	Vendor vendor = null;
	Product product = null;
	Version version = null;
	
	if(vendId != null){
		vendor = sa.getVendor(vendId);
	}
	if(prodId != null){
		product =  sa.getProduct(prodId);
	}
	if(versId != null){
		version = sa.getVersion( versId);
	}	
	
	//get dropdowns
	DropDown[] dd = sa.getListTechnologies();
	technologies = new HashMap<Integer, String>();
	for(int i=0; i<dd.length; i++){
	    technologies.put(Integer.valueOf(dd[i].getData()), dd[i].getLabel());
	}

	dd = sa.getListRelationships();
	relationships= new HashMap<Integer, String>();
	for(int i=0; i<dd.length; i++){
	    relationships.put(Integer.valueOf(dd[i].getData()), dd[i].getLabel());
	}

	dd = sa.getListTypes();
	types = new HashMap<Integer, String>();
	for(int i=0; i<dd.length; i++){
	    types.put(Integer.valueOf(dd[i].getData()), dd[i].getLabel());
	}

	PeopleInfoLine[] pil = dir.getListPeople(Boolean.TRUE);
	users = new HashMap<Integer, String>();
	for(int i=0; i<pil.length; i++){
	    users.put(pil[i].getE_people_id(), pil[i].getDisplay_name());
	}
	// end code
%>
<head>
<title><%= generateTitle(vendor, product, version)%></title>
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
			<td width="80%" align="center" class="title">Vendor details</td>
		</tr>
		<tr>
			<td align="center" class="subtitle"><%= generateTitle(vendor, product, version)%></td>
		</tr>
		</table>
		<!-- Vendor info -->
		<%
		if(vendor!= null){
		%>
		<br/>
		&nbsp;<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="80%">
		<tr>
			<td colspan="4" align="center" bgcolor="gainsboro"><b><%= vendor.getVendor_name()%></b></td>
		</tr>
		<tr>
			<td width="25%">Preferred relationship</td>
			<td width="25%"><b><%=  getPreferredRelationship(vendor)%></b></td>
			<td width="25%">Escalation contact</td>
			<td width="25%"><b><%= getUser(vendor.getEscalation_contact_id()) %></b></td>
		</tr>
		<tr>
			<td width="25%">Security contact</td>
			<td width="25%"><b><%=  getUser(vendor.getSecurity_contact_id())%></b></td>
			<td width="25%">Status</td>
			<td width="25%"><b><%= getStatus(vendor) %></b></td>
		</tr>
		</table>
		<%
		}
		
		//Product infos
		if(product!= null){
		%>
		<br/>
		&nbsp;<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="80%">
		<tr>
			<td colspan="4" align="center" bgcolor="gainsboro"><b><%= product.getProduct_name()%></b></td>
		</tr>
		<tr>
			<td width="25%">Type</td>
			<td width="25%"><b><%=  getType(product)%></b></td>
			<td width="25%">Technology</td>
			<td width="25%"><b><%= getTechnology(product) %></b></td>
		</tr>
		<tr>
			<td width="25%">Obsolescence date</td>
			<td width="25%"><b><%=  formatDate(product.getObsolescence_date())%></b></td>
			<td width="25%">Status</td>
			<td width="25%"><b><%= getStatus(product) %></b></td>
		</tr>
		<%
		if(product.getSupported() != null || product.getObsoleted() != null){
		%>
		<tr>
			<td colspan="4" align="center"><b><%= getObsolescenceAndSupport(product)%></b></td>
		</tr>
		<%
		}
		%>
		</table>
		<%
		}
		
		//Version infos
		if(version!= null){
		%>
		<br/>
		&nbsp;<br/>
		<table border="1" cellspacing="0" cellpadding="4" width="80%">
		<tr>
			<td colspan="4" align="center" bgcolor="gainsboro"><b><%= version.getVersion()%></b></td>
		</tr>
		<tr>
			<td width="25%">Obsolescence date</td>
			<td width="25%"><b><%=  formatDate(version.getObsolescence_date())%></b></td>
			<td width="25%">Status</td>
			<td width="25%"><b><%= getStatus(version) %></b></td>
		</tr>
		<%
		if(version.getSupported() != null || version.getObsoleted() != null){
		%>
		<tr>
			<td colspan="4" align="center"><b><%= getObsolescenceAndSupport(version)%></b></td>
		</tr>
		<%
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