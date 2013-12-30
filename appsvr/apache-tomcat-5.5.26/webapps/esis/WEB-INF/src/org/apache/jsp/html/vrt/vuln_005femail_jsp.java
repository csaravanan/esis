package org.apache.jsp.html.vrt;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapVulnerabilityReview;
import com.entelience.soap.soapDirectory;
import com.entelience.soap.soapRaci;
import com.entelience.objects.vuln.VulnId;
import com.entelience.objects.vrt.VulnerabilityInformation;
import com.entelience.objects.DropDown;
import com.entelience.objects.vrt.VulnerabilityInfoLine;
import com.entelience.objects.vrt.AliasInfoLine;
import com.entelience.objects.vrt.CommentInfoLine;
import com.entelience.objects.vrt.VulnerabilityAction;
import com.entelience.objects.raci.RaciInfoLine;
import com.entelience.sql.DbHelper;
import com.entelience.util.Arrays;
import java.util.HashMap;
import java.util.Map;

public final class vuln_005femail_jsp extends com.entelience.servlet.JspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


	// Class declarations
    Map<Integer, String> mav_status = new HashMap<Integer, String>();
	
    protected String lookupMavStatus(Integer status_nb){
		String status = (String)mav_status.get(status_nb);
        if(status != null) return status;
        return "Unknown";
    }
    
    protected String format(String s1, String s2) throws Exception{
	if(DbHelper.nullify(s1) == null && DbHelper.nullify(s2) == null)
		return "-";
	if(DbHelper.nullify(s1) != null)
		return s1;
	if(DbHelper.nullify(s2) != null)
		return s2;
	return s1+"-"+s2;
    }
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

      out.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n<html>\n");
      out.write("\n<!-- The JSP used to send emails : simplified html-->\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
      out.write('\n');

try{
	// code
	//TODO : add multicompany code
	
	// Now we can use webservices
	// Read parameters.
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	Integer vid = getParamInteger(request,"e_vulnerability_id");
	if(vid == null)
		throw new Exception("Null parameter for e_vulnerability_id");
	VulnId e_vulnerability_id = new VulnId(vid.intValue(), 0);
	Boolean my = getParamBoolean(request, "my");

	soapVulnerabilityReview vr = new soapVulnerabilityReview(peopleId);
	soapDirectory dir = new soapDirectory(peopleId);
	soapRaci rac = new soapRaci(peopleId);
	
	VulnerabilityInfoLine vil = vr.listOneVulnerability(e_vulnerability_id);
	VulnerabilityInformation vi = vr.getVulnerabilityInformation(e_vulnerability_id);
	VulnerabilityAction[] actions = vr.getVulnerabilityActions(e_vulnerability_id, Boolean.FALSE, my);
	RaciInfoLine[] racis = rac.listRacis(null, vil.getE_raci_obj(), null, null, null, null);
	
	AliasInfoLine[] _names = new AliasInfoLine[vi.getVuln_names().size()];
	_names = (AliasInfoLine[]) vi.getVuln_names().toArray(_names);
	String[] names = new String[_names.length];
	for(int i=0; i<names.length; i++){
		names[i] = _names[i].getName();
	}
	
	if(mav_status == null || mav_status.size() ==0){
		DropDown [] dd = vr.getListOfMAVStatus();
		for(int i=0; i< dd.length; i++){
			mav_status.put(Integer.valueOf(dd[i].getData()), dd[i].getLabel());
		}
	}
	// end code

      out.write("\n<head>\n<title>Vulnerability - ");
      out.print( vi.getVuln_name() );
      out.write("</title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<table width=\"100%\" border=\"0\" align=\"center\" bgcolor=\"white\" cellpadding=\"0\" cellspacing=\"0\">\n<tr>\n\t<td>\n\t\t<div align=\"center\">\n\t\t<!-- Header -->\n\t\t<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td width=\"20%\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t\t<td width=\"80%\" align=\"center\" class=\"title\">Vulnerability information</td>\n\t\t</tr>\n\t\t</table>\n\t\t<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td align=\"center\" class=\"subtitle\">");
      out.print( vil.getVuln_name() );
      out.write("</td>\n\t\t</tr>\n\t\t</table>\n\t\t<br/>\n\t\t<!-- Vuln info -->\n\t\t<a name=\"");
      out.print( vi.getVuln_name() );
      out.write("\"/>\n\t\t<!-- global table for vulnerability -->\n\t\t<br/>\n\t\t<table align=\"center\" cellpadding=\"4\" border=\"1\" cellspacing=\"0\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" bgcolor=\"gainsboro\"><b>");
      out.print( vi.getVuln_name() );
      out.write("</b></td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( HTMLTitle(vil.getDescription(), null) );
      out.write("</b></td>\n\t\t</tr>\n\t\t</table>\n\t\t<table align=\"center\" cellpadding=\"4\" border=\"1\" cellspacing=\"0\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td width=\"25%\">Published date</td>\n\t\t\t<td width=\"25%\"><b>");
      out.print( formatDate(vi.getPublish_date()) );
      out.write("</b></td>\n\t\t\t<td width=\"25%\">Severity</td>\n\t\t\t<td width=\"25%\"><b>");
      out.print( vi.getSeverity() );
      out.write("</b></td>\n\t\t</tr>\n\t\t</table>\n\t\t");

		if (vi.getDescriptions() != null) {
		
      out.write("\n\t\t<table align=\"center\" cellpadding=\"4\" border=\"1\" cellspacing=\"0\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td  valign=\"top\" align=\"left\">\n\t\t\t");

			for(int j=0;j<vi.getDescriptions().size();++j) {
			
      out.write("\n\t\t\t");
      out.print( HTMLEncode((String) vi.getDescriptions().get(j)) );
      out.write("&nbsp;<br/>\n\t\t\t");

			}//end for
			
      out.write("\n\t\t\t</td>\n\t\t</tr>\n\t\t</table>\n\t\t");

		}// end descriptions
		
      out.write("\n        <table align=\"center\" cellpadding=\"4\" border=\"1\" cellspacing=\"0\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\">Vendor(s)</td>\n\t\t\t<td width=\"25%\" align=\"center\"><b>");
      out.print( vil.getVendor() == null ? "" : vil.getVendor().replaceAll("\\n", ", ") );
      out.write("</b></td>\n\t\t\t<td width=\"25%\" align=\"center\">Product(s)</td>\n\t\t\t<td width=\"25%\" align=\"center\"><b>");
      out.print( vil.getProduct() == null ? "" : vil.getProduct().replaceAll("\\n", ", ") );
      out.write("</b></td>\n\t\t</tr>\n\t\t</table>\n\t\t<table align=\"center\" cellpadding=\"4\" border=\"1\" cellspacing=\"0\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\">Names</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( Arrays.join(names, ", ") );
      out.write("</b></td>\n\t\t</tr>\n\t\t</table>\n\t\t");
 
		if(racis != null && racis.length>0){
		
      out.write("\n\t\t<br/>\n\t\t<br/>\n\t\t<table align=\"center\" cellpadding=\"4\" border=\"1\" cellspacing=\"0\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td align=\"center\" bgcolor=\"gainsboro\"><b>RACI matrix</b></td>\n\t\t</tr>\n\t\t</table>\n\t\t<table align=\"center\" cellpadding=\"4\" border=\"1\" cellspacing=\"0\" width=\"90%\">\n\t\t");

		for(int j=0;j<racis.length;++j) {
		
      out.write("\n\t\t<tr>\n\t\t\t<td width=\"60%\">");
      out.print( racis[j].getUserName() );
      out.write("</td>\n\t\t\t<td width=\"40%\" align=\"left\">");
      out.print( racis[j].getRaci() );
      out.write("</td>\n\t\t</tr>\n\t\t");

		}//end for
		
      out.write("\n\t\t</table>\n\t\t");

		} // end racis
		
      out.write('\n');
      out.write('	');
      out.write('	');

		if (vi.getComments() != null) {
		
      out.write("\n\t\t<br/>\n\t\t<br/>\n\t\t<table align=\"center\" cellpadding=\"4\" border=\"1\" cellspacing=\"0\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td align=\"center\" bgcolor=\"gainsboro\"><b>Comments</b></td>\n\t\t</tr>\n\t    </table>\n        <table align=\"center\" cellpadding=\"4\" border=\"1\" cellspacing=\"0\" width=\"90%\">\n\t\t");

		for(int j=0;j<vi.getComments().size();++j) {
		CommentInfoLine cil = vi.getComments().get(j);
		
      out.write("\n\t\t<tr>\n\t\t\t<td width=\"20%\">");
      out.print( cil.getAuthor() );
      out.write("</td>\n\t\t\t<td width=\"20%\">");
      out.print( formatDate(cil.getComment_date()) );
      out.write("</td>\n\t\t\t<td width=\"60%\" valign=\"top\" align=\"left\">");
      out.print( cil.getComment() );
      out.write("</td>\n\t\t</tr>\n\t\t");

		}//end for
		
      out.write("\n\t\t</table>\n\t\t");

		} // end comments
		
      out.write('\n');
      out.write('	');
      out.write('	');

		if (actions != null && actions.length > 0) {
		
      out.write("\n\t\t<br/>\n\t\t<br/>\n\t\t<table align=\"center\" cellpadding=\"4\" border=\"1\" cellspacing=\"0\" width=\"90%\">\n\t    <tr>\n\t\t\t<td align=\"center\" bgcolor=\"gainsboro\"><b>Actions</b></td>\n\t\t</tr>\n\t\t</table>\n\t\t<table align=\"center\" cellpadding=\"4\" border=\"1\" cellspacing=\"0\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td align=\"center\" width=\"15%\" bgcolor=\"gainsboro\">Status</td>\n\t\t\t<td align=\"center\" width=\"15%\" bgcolor=\"gainsboro\">Target date</td>\n\t\t\t<td align=\"center\" width=\"20%\" bgcolor=\"gainsboro\">Responsible</td>\n\t\t\t<td align=\"center\" width=\"30%\" bgcolor=\"gainsboro\">Description</td>\n\t\t\t<td align=\"center\" width=\"20%\" bgcolor=\"gainsboro\">Change ref. &amp; Workload</td>\n\t\t</tr>\n\t\t");

		for(int j=0;j<actions.length;++j) {
		
      out.write("\n\t\t<tr>\n\t\t\t<td align=\"center\">");
      out.print( lookupMavStatus(actions[j].getMav_status()) );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( formatDate(actions[j].getTarget_date()) );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( DbHelper.unnullify(actions[j].getOwnerName()) );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( DbHelper.unnullify(actions[j].getDescription()) );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( format(actions[j].getChangeref(), actions[j].getWorkload()) );
      out.write("</td>\n\t\t</tr>\n\t\t");

		}
		
      out.write("\n\t\t</table>\n\t\t");

		} // end actions
		
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
