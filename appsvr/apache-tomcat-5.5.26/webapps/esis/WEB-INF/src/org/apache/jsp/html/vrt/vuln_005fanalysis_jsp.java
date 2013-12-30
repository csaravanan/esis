package org.apache.jsp.html.vrt;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapVulnerabilityReview;
import com.entelience.soap.soapRaci;
import com.entelience.soap.soapDirectory;
import com.entelience.objects.vuln.VulnId;
import com.entelience.objects.vrt.VulnerabilityInfoLine;
import com.entelience.objects.vrt.VulnerabilityAnalysis;
import com.entelience.objects.raci.RaciInfoLine;

public final class vuln_005fanalysis_jsp extends com.entelience.servlet.JspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


	// Radio button formatter.
	public void myRadio(int val, String[] tab, String name) {
		for (int i=0; i<4; ++i) {
			if (val == i) tab[i] = "<input type=radio align=middle name=radio"+name+" checked>";
			else tab[i] = "&nbsp;";
      	}
 	}
	// Lookup tables for various text items	
	//String[] severity = {"Unrated", "Low", "Medium", "High", "Critical"}; // comes from vil as text
	String[] decision = {"New", "Repair", "Investigate", "Accept risk", "Ignore"};
	String[] status = {"N/A", "Fixed", "Planning", "In progress", "Won't fix"};
	String[] priority = {"N/A", "Low", "Medium", "High", "Immediate"};
	// end class declarations

  private static java.util.List _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList(3);
    _jspx_dependants.add("/html/vrt/../style.inc.jsp");
    _jspx_dependants.add("/html/vrt/../icon.inc.jsp");
    _jspx_dependants.add("/html/vrt/../copyright.inc.jsp");
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
      out.write("\n\n\n\n\n\n\n\n\n");
      out.write('\n');

// code
try{
	// Class declarations
	VulnerabilityInfoLine vil;
	VulnerabilityAnalysis va;
	RaciInfoLine[] racis;
	
	// business
	String[] brand = new String[4];
	String[] busops = new String[4];
	String[] bussup = new String[4];
	String[] intops = new String[4];
	// tech
	String[] unix = new String[4];
	String[] win = new String[4];
	String[] net = new String[4];
	String[] access = new String[4];
	String[] apps = new String[4];
	// exposure
	String[] xunix = new String[4];
	String[] xwin = new String[4];
	String[] xnet = new String[4];
	String[] xaccess = new String[4];
	String[] xapps = new String[4];
	
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	Integer vid = getParamInteger(request,"e_vulnerability_id");
	if(vid == null)
		throw new Exception("Null parameter for e_vulnerability_id");
	VulnId e_vulnerability_id = new VulnId(vid.intValue(), 0);

	soapVulnerabilityReview vr = new soapVulnerabilityReview(peopleId);
	soapDirectory dir = new soapDirectory(peopleId);
	soapRaci rac = new soapRaci(peopleId);
	
	vil = vr.listOneVulnerability(e_vulnerability_id);
	va = vr.getVulnerabilityAnalysis(e_vulnerability_id);
	racis = rac.listRacis(null, va.getE_raci_obj(), null, null, null, null);
	
	// business
	myRadio(va.getBi_brand(), brand, "brand");
	myRadio(va.getBi_busops(), busops, "busops");
	myRadio(va.getBi_bussup(), bussup, "bussup");
	myRadio(va.getBi_intops(), intops, "intops");
	//tech
	myRadio(va.getTi_unix(), unix, "unix");
	myRadio(va.getTi_windows(), win, "win");
	myRadio(va.getTi_network(), net, "net");
	myRadio(va.getTi_access(), access, "access");
	myRadio(va.getTi_apps(), apps, "apps");
	// exposure
	myRadio(va.getEx_unix(), xunix, "xunix");
	myRadio(va.getEx_windows(), xwin, "xwin");
	myRadio(va.getEx_network(), xnet, "xnet");
	myRadio(va.getEx_access(), xaccess, "xaccess");
	myRadio(va.getEx_apps(), xapps, "xapps");
	// end code

      out.write("\n<head>\n<title>Vulnerability analysis - ");
      out.print( vil.getVuln_name() );
      out.write("</title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<table width=100% border=\"0\" align=\"center\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t\t<div align=\"center\">\n\t\t<!-- header -->\n\t\t<table border=\"0\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t\t<tr>\n\t\t\t<td width=\"20%\" rowspan=\"2\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t\t<td width=\"80%\" align=\"center\" class=\"title\">Vulnerability analysis</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"center\" class=\"subtitle\">");
      out.print( vil.getVuln_name() );
      out.write("</td>\n\t\t</tr>\n\t\t</table>\n\t\t<br/>\n\t\t<!-- Detials -->\n\t\t<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\"><b>");
      out.print( vil.getVuln_name() );
      out.write("</b></td>\n\t\t\t<td colspan=\"3\" align=\"left\"><b>");
      out.print( HTMLTitle(vil.getDescription(), null) );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" bgcolor=\"gainsboro\">Published date</td>\n\t\t\t<td width=\"25%\" align=\"center\"><b>");
      out.print( formatDate(vil.getPublish_date()) );
      out.write("</b></td>\n\t\t\t<td width=\"25%\" align=\"center\" bgcolor=\"gainsboro\">Severity</td>\n\t\t\t<td width=\"25%\" align=\"center\"><b>");
      out.print( vil.getSeverity() );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"center\" bgcolor=\"gainsboro\">Decision</td>\n\t\t\t<td align=\"center\"><b>");
      out.print( decision[va.getStatus()] );
      out.write("</b></td>\n\t\t\t<td align=\"center\" bgcolor=\"gainsboro\">Priority</td>\n\t\t\t<td align=\"center\"><b>");
      out.print( priority[va.getD_priority()] );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"center\" bgcolor=\"gainsboro\">Status</td>\n\t\t\t<td align=\"center\"><b>");
      out.print( status[va.getD_mav_status()] );
      out.write("</b></td>\n\t\t\t<td align=\"center\" bgcolor=\"gainsboro\">Target date</td>\n\t\t\t<td align=\"center\"><b>");
      out.print( formatDate(va.getD_mav_target()) );
      out.write("</b></td>\n\t\t</tr>\n\t\t</table>\n\t\t<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td colspan=\"2\" align=\"center\"><b>RACI matrix</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"75%\" align=\"center\" bgcolor=\"gainsboro\"><b>Stakeholders</b></td>\n\t\t\t<td width=\"25%\" align=\"center\" bgcolor=\"gainsboro\"><b>RACI</b></td>\n\t\t</tr>\n\t\t");

		for(int i=0; i<racis.length; ++i) {	
      out.write("\n\t\t<tr>\n\t\t\t<td width=\"75%\" align=\"center\">");
      out.print( racis[i].getUserName());
      out.write("</td>\n\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( racis[i].getRaci());
      out.write("</td>\n\t\t</tr>\n\t\t");

		} // end for
		
      out.write("\n\t\t</table>\n\t\t<br/>\n\t\t<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td width=\"48%\" valign=\"top\">\n\t\t\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t\t\t\t<tr>\n\t\t\t\t\t<td width=\"60%\" align=\"center\" bgcolor=\"gainsboro\"><b>Business impact</b></td>\n\t\t\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">N/A</td>\n\t\t\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">Low</td>\n\t\t\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">Med.</td>\n\t\t\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">High</td>\n\t\t\t\t</tr>\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\">Brand or company value</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( brand[0] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( brand[1] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( brand[2] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( brand[3] );
      out.write("</td>\n\t\t\t\t</tr>\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\">Business operations</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( busops[0] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( busops[1] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( busops[2] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( busops[3] );
      out.write("</td>\n\t\t\t\t</tr>\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\">Business support</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( bussup[0] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( bussup[1] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( bussup[2] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( bussup[3] );
      out.write("</td>\n\t\t\t\t</tr>\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\">International operations</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( intops[0] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( intops[1] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( intops[2] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( intops[3] );
      out.write("</td>\n\t\t\t\t</tr>\n\t\t\t\t<tr>\n\t\t\t\t\t<td colspan=\"5\" align=\"left\">Notes:<br/>\n\t\t\t\t\t");
      out.print( HTMLEncode(va.getBi_comment()) );
      out.write("</td>\n\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</td>\n\t\t\t<td width=\"4%\">&nbsp;</td>\n\t\t\t<td width=\"48%\" valign=\"top\">\n\t\t\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t\t\t\t<tr>\n\t\t\t\t\t<td width=\"60%\" align=\"center\" bgcolor=\"gainsboro\"><b>Technical impact</b></td>\n\t\t\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">N/A</td>\n\t\t\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">Low</td>\n\t\t\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">Med.</td>\n\t\t\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">High</td>\n\t\t\t\t</tr>\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\">Unix</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( unix[0] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( unix[1] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( unix[2] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( unix[3] );
      out.write("</td>\n\t\t\t\t</tr>\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\">Windows</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( win[0] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( win[1] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( win[2] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( win[3] );
      out.write("</td>\n\t\t\t\t</tr>\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\">Network</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( net[0] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( net[1] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( net[2] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( net[3] );
      out.write("</td>\n\t\t\t\t</tr>\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\">Client devices</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( access[0] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( access[1] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( access[2] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( access[3] );
      out.write("</td>\n\t\t\t\t</tr>\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\">Applications</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( apps[0] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( apps[1] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( apps[2] );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print( apps[3] );
      out.write("</td>\n\t\t\t\t</tr>\n\t\t\t\t<tr>\n\t\t\t\t\t<td colspan=\"5\" align=\"left\">Notes:<br/>\n\t\t\t\t\t");
      out.print( HTMLEncode(va.getTi_comment()) );
      out.write("</td>\n\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</td>\n\t\t</tr>\n\t\t</table>\n\t\t<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td width=\"50%\" align=\"center\" bgcolor=\"gainsboro\"><b>Exposure</b></td>\n\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">#</td>\n\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">N/A</td>\n\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">Low</td>\n\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">Med.</td>\n\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">High</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"center\">Unix</td>\n\t\t\t<td align=\"center\">");
      out.print( va.getEx_unix_n() );
      out.write("</td> \n\t\t\t<td align=\"center\">");
      out.print( xunix[0] );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xunix[1] );
      out.write("</td> \n\t\t\t<td align=\"center\">");
      out.print( xunix[2] );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xunix[3] );
      out.write("</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"center\">Windows</td>\n\t\t\t<td align=\"center\">");
      out.print( va.getEx_windows_n() );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xwin[0] );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xwin[1] );
      out.write("</td> \n\t\t\t<td align=\"center\">");
      out.print( xwin[2] );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xwin[3] );
      out.write("</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"center\">Network</td>\n\t\t\t<td align=\"center\">");
      out.print( va.getEx_network_n() );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xnet[0] );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xnet[1] );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xnet[2] );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xnet[3] );
      out.write("</td>\n\t\t</tr>\n\t\t<tr> \n\t\t\t<td align=\"center\">Client devices</td>\n\t\t\t<td align=\"center\">");
      out.print( va.getEx_access_n() );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xaccess[0] );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xaccess[1] );
      out.write("</td>  \n\t\t\t<td align=\"center\">");
      out.print( xaccess[2] );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xaccess[3] );
      out.write("</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"center\">Applications</td>\n\t\t\t<td align=\"center\">");
      out.print( va.getEx_apps_n() );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xapps[0] );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xapps[1] );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xapps[2] );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( xapps[3] );
      out.write("</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td colspan=\"6\" align=\"left\">Notes:<br/>\n\t\t\t");
      out.print( HTMLEncode(va.getEx_comment()) );
      out.write("</td>\n\t\t</tr>\n\t\t</table>\n\t\t");
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
