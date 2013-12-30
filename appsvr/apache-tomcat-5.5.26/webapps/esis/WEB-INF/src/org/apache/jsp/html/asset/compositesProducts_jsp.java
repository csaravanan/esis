package org.apache.jsp.html.asset;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapAsset;
import com.entelience.soap.soapDirectory;
import com.entelience.objects.asset.CompositeProduct;
import com.entelience.objects.asset.CompositeVersion;
import com.entelience.objects.asset.CompositeProductId;
import com.entelience.objects.asset.CompositeVersionId;
import com.entelience.objects.asset.ProductVersion;
import com.entelience.objects.DropDown;
import com.entelience.sql.DbHelper;
import java.util.HashMap;
import java.util.Map;

public final class compositesProducts_jsp extends com.entelience.servlet.JspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


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

  private static java.util.List _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList(3);
    _jspx_dependants.add("/html/asset/../style.inc.jsp");
    _jspx_dependants.add("/html/asset/../icon.inc.jsp");
    _jspx_dependants.add("/html/asset/../copyright.inc.jsp");
  }

  public Object getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    JspFactory _jspxFactory = null;
    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;


    try {
      _jspxFactory = JspFactory.getDefaultFactory();
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n<html>\n<!-- the HTML header allows us to view the jsp as an html file in web browsers -->\n");
      out.write("\n\n\n\n\n\n\n\n\n\n\n\n\n");
      out.write('\n');

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

      out.write("\n<head>\n<title>");
      out.print( generateTitle(compProd, compVers));
      out.write("</title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<table width=\"100%\" border=\"0\" align=\"center\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t\t<div align=\"center\">\n\t\t<!-- Header -->\n\t\t<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td width=\"20%\" rowspan=\"2\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t\t<td width=\"80%\" align=\"center\" class=\"title\">Composite product details</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"center\" class=\"subtitle\">");
      out.print( generateTitle(compProd, compVers));
      out.write("</td>\n\t\t</tr>\n\t\t</table>\n\t\t");

		if(compProd!= null){
		//Vendor infos
		
      out.write("\n\t\t<br/>&nbsp;<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"80%\">\n\t\t<tr>\n\t\t\t<td colspan=\"4\" align=\"center\" bgcolor=\"gainsboro\"><b>");
      out.print( compProd.getVendor_name());
      out.write("</b></td>\n\t\t</tr>\n\t\t</table>\n\t\t");

		//Product infos
		
      out.write("\n\t\t<br/>\n\t\t&nbsp;<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"80%\">\n\t\t<tr>\n\t\t\t<td colspan=\"4\" align=\"center\" bgcolor=\"gainsboro\"><b>");
      out.print( compProd.getProduct_name());
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\">Status</td>\n\t\t\t<td width=\"25%\"><b>");
      out.print( getStatus(compProd));
      out.write("</b></td>\n\t\t\t<td width=\"25%\">Type</td>\n\t\t\t<td width=\"25%\"><b>");
      out.print( getType(compProd));
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\">Technology</td>\n\t\t\t<td width=\"25%\"><b>");
      out.print( getTechnology(compProd) );
      out.write("</b></td>\n\t\t\t<td width=\"25%\">Obsolescence date</td>\n\t\t\t<td width=\"25%\"><b>");
      out.print( formatDate(compProd.getObsolescence_date()));
      out.write("</b></td>\n\t\t</tr>\n\t\t");

		if(compProd.getSupported() != null || compProd.getObsoleted() != null){
		
      out.write("\n\t\t<tr>\n\t\t\t<td colspan=\"4\" align=\"center\"><b>");
      out.print( getObsolescenceAndSupport(compProd));
      out.write("</b></td>\n\t\t</tr>\n\t\t");

		}
		
      out.write("\n\t\t</table>\n\t\t");

		}
		//Version infos
		if(compVers!= null){
		
      out.write("\n\t\t<br/>\n\t\t&nbsp;<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"80%\">\n\t\t<tr>\n\t\t\t<td colspan=\"4\" align=\"center\" bgcolor=\"gainsboro\"><b>");
      out.print( compVers.getVersion());
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\">Status</td>\n\t\t\t<td width=\"25%\"><b>");
      out.print( getStatus(compVers) );
      out.write("</b></td>\n\t\t\t<td width=\"25%\">Latest version</td>\n\t\t\t<td width=\"25%\"><b>");
      out.print( compVers.isLatest() ? "Yes" : "No" );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\">Obsolescence date</td>\n\t\t\t<td width=\"25%\"><b>");
      out.print( formatDate(compVers.getObsolescence_date()));
      out.write("</b></td>\n\t\t\t");

			if(compVers.getSupported() == null && compVers.getObsoleted() == null){
			
      out.write("\n\t\t\t<td colspan=\"2\">&nbsp;</td>\n\t\t\t");

			} else {
			
      out.write("\n\t\t\t<td colspan=\"2\" align=\"center\"><b>");
      out.print( getObsolescenceAndSupport(compVers));
      out.write("</b></td>\n\t\t\t");

			}
			
      out.write("\n\t\t</tr>\n\t\t</table>\n\t\t<br/>\n\t\t&nbsp;<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"80%\">\n\t\t<tr>\n\t\t\t<td colspan=\"3\" align=\"center\" bgcolor=\"gainsboro\"><b>Products and versions linked to ");
      out.print( compProd.getVendor_name());
      out.write(' ');
      out.print( compProd.getProduct_name());
      out.write(' ');
      out.print( compVers.getVersion());
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"33%\" align=\"center\" bgcolor=\"gainsboro\"><b>Vendor</b></td>\n\t\t\t<td width=\"34%\" align=\"center\" bgcolor=\"gainsboro\"><b>Products</b></td>\n\t\t\t<td width=\"33%\" align=\"center\" bgcolor=\"gainsboro\"><b>Versions</b></td>\n\t\t</tr>\n\t\t");

		if (prodVersLinked == null || prodVersLinked.length == 0) {
		
      out.write("\n\t\t<tr>\n\t\t\t<td colspan=\"3\" align=\"center\">No product or version linked.</td>\n\t\t</tr>\n\t\t");

		} else {
			for (int i=0; i<prodVersLinked.length; ++i) {
		
      out.write("\n\t\t<tr>\n\t\t\t<td width=\"33%\" align=\"center\">");
      out.print( DbHelper.unnullify(prodVersLinked[i].getVendorName()));
      out.write("</td>\n\t\t\t<td width=\"34%\" align=\"center\">");
      out.print( DbHelper.unnullify(prodVersLinked[i].getProductName()));
      out.write("</td>\n\t\t\t<td width=\"33%\" align=\"center\">");
      out.print( DbHelper.unnullify(prodVersLinked[i].getVersionName()));
      out.write("</td>\n\t\t</tr>\n\t\t");

			}
		}
		
      out.write("\n\t\t</table>\n\t\t");

		}
		
      out.write('\n');
      out.write('	');
      out.write('	');
      out.write("\n&nbsp;<br/>\n<table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"0\">\n<tr>\n\t<td align=\"center\" class=\"copy\">\n\t<br/>\n\t<br/>Copyright (c) 2004-2008 Entelience SARL, Copyright (c) 2008-2009 Equity SA, Copyright (c) 2009-2010 Consulare sÃ rl, Licensed under the <a href=\"http://www.gnu.org/copyleft/gpl.html\">GNU GPL, Version 3</a>.\n\t<br/>\n\t</td>\n</tr>\n</table>");
      out.write("\n\t\t</div>\n\t</td>\n</tr>\n</table>\n</body>\n</html>\n");

} catch(Exception e){
	_logger.error("Exception during JSP execution", e);
	setErrorMessage(response, e, getSessionId(request));
}

    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
      }
    } finally {
      if (_jspxFactory != null) _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
