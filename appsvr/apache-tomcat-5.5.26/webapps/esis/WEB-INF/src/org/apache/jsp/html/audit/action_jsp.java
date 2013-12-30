package org.apache.jsp.html.audit;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapAudit;
import com.entelience.soap.soapRaci;
import com.entelience.objects.audit.AuditActionId;
import com.entelience.objects.audit.Action;
import com.entelience.objects.raci.RaciInfoLine;

public final class action_jsp extends com.entelience.servlet.JspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static java.util.List _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList(3);
    _jspx_dependants.add("/html/audit/../style.inc.jsp");
    _jspx_dependants.add("/html/audit/../icon.inc.jsp");
    _jspx_dependants.add("/html/audit/../copyright.inc.jsp");
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
      out.write("\n<!-- The JSP used to send emails : simplified html -->\n\n\n\n\n\n\n");

try {
	// code
	// parameters
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	Integer aid = getParamInteger(request, "actionId");
	if (aid == null)
		throw new Exception("Null parameter for actionId");
	AuditActionId action_id = new AuditActionId(aid.intValue(), 0);
	
	soapAudit au = new soapAudit(peopleId);
	soapRaci rac = new soapRaci(peopleId);
	
	Action ac = au.getAction(action_id);
	RaciInfoLine[] racis = rac.listRacis(null, ac.getE_raci_obj(), null, null, null, null);
	// end code

      out.write("\n<head>\n<title>Action - ");
      out.print( ac.getTitle() );
      out.write("</title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<table width=\"100%\" border=\"0\" align=\"center\" bgcolor=\"white\" cellpadding=\"0\" cellspacing=\"0\">\n<tr>\n\t<td>\n\t\t<div align=\"center\">\n\t\t<!-- Header -->\n\t\t<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td width=\"20%\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t\t<td width=\"80%\" align=\"center\" class=\"title\">Action</td>\n\t\t</tr>\n\t\t</table>\n\t\t<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr><td align=\"center\" class=\"subtitle\">");
      out.print( HTMLEncode(ac.getTitle()) );
      out.write("</td></tr>\n\t\t<tr><td align=\"center\" class=\"subtitle\">linked to recommendation: ");
      out.print( ac.getRecom_title() );
      out.write("</td></tr>\n\t\t</table>\n\t\t<br/>\n\t\t<!-- Action info -->\n\t\t<br/>\n\t\t<table width=\"90%\" border=\"1\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Action title</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( ac.getTitle() );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Description</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( HTMLEncode(ac.getDescription()) );
      out.write("&nbsp;</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">External reference</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( HTMLEncode(ac.getExternalRef()) );
      out.write("&nbsp;</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Due date</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( formatDate(ac.getDue_date()) );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Status</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( ac.getAction_status() );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Responsible</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( ac.getOwner_username() );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Closed date</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( formatDate(ac.getClosed_date()) );
      out.write("&nbsp;</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Creation date</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( formatDate(ac.getCreation_date()) );
      out.write("</b></td>\n\t\t</tr>\n\t\t</table>\n\t\t");
 
		if(racis != null && racis.length > 0){
		
      out.write("\n\t\t<br/>\n\t\t<table width=\"90%\" border=\"1\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td width=\"60%\" align=\"center\" bgcolor=\"gainsboro\">Stakeholder(s)</td>\n\t\t\t<td width=\"40%\" align=\"center\" bgcolor=\"gainsboro\">RACI</td>\n\t\t</tr>\n\t\t");

		for (int j = 0; j < racis.length; ++j) {
		
      out.write("\n\t\t<tr>\n\t\t\t<td width=\"60%\" align=\"center\">");
      out.print( racis[j].getUserName() );
      out.write("</td>\n\t\t\t<td width=\"40%\" align=\"center\"><b>");
      out.print( racis[j].getRaci() );
      out.write("</b></td>\n\t\t</tr>\n\t\t");

		}//end for
		
      out.write("\n\t\t</table>\n\t\t");

		} // end racis
		
      out.write('\n');
      out.write('	');
      out.write('	');
      out.write("\n&nbsp;<br/>\n<table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"0\">\n<tr>\n\t<td align=\"center\" class=\"copy\">\n\t<br/>\n\t<br/>Copyright (c) 2004-2008 Entelience SARL, Copyright (c) 2008-2009 Equity SA, Copyright (c) 2009-2010 Consulare sÃ rl, Licensed under the <a href=\"http://www.gnu.org/copyleft/gpl.html\">GNU GPL, Version 3</a>.\n\t<br/>\n\t</td>\n</tr>\n</table>");
      out.write("\n\t\t</div>\n\t</td>\n</tr>\n</table>\n</body>\n</html>\n");

} catch(Exception e) {
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
