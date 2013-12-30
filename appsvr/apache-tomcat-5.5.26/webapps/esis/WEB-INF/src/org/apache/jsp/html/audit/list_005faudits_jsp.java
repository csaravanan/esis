package org.apache.jsp.html.audit;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.List;
import com.entelience.soap.soapAudit;
import com.entelience.objects.audit.Audit;
import com.entelience.util.DateHelper;

public final class list_005faudits_jsp extends com.entelience.servlet.JspBase
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

      out.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n<html><!-- the HTML header allows us to view the jsp as an html file in web browsers -->\n");
      out.write("\n\n\n\n\n\n");
 // code
try	{
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	// Now we can use webservices
	soapAudit au = new soapAudit(peopleId);
	
	Boolean my = getParamBoolean(request, "my");
	
	String statusMatchAsString = getParam(request, "statusMatch");
	String statusNoMatchAsString = getParam(request, "statusNoMatch");

	List<Number> statusMatch = toArray(statusMatchAsString);
	List<Number> statusNoMatch = toArray(statusNoMatchAsString);
	
	Integer origin = getParamInteger(request, "origin");
	Integer topic = getParamInteger(request, "topic");
	Boolean noReports = getParamBoolean(request, "noReports");
	String order = getParam(request, "order");
        String way = getParam(request, "way");
        Integer pageNumber = getParamInteger(request, "pageNumber");
	
	String todaysDate = formatDate(DateHelper.now());
	Audit[] audits = au.getAudits(my, statusMatch, statusNoMatch, origin, topic, noReports.booleanValue(),order, way, pageNumber);
	// end code

      out.write("\n<!-- Now begins HTML page ...-->\n<head>\n<title>List of Audits - ");
      out.print( todaysDate );
      out.write(" </title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<!-- Main table -->\n<table width=\"100%\" border=0 bgcolor=\"white\">\n<tr>\n\t<td>\n\t<div align=\"center\">\n\t<!-- Header table with title -->\n\t<table border=0 cellspacing=0 cellpadding=4 width=\"100%\">\n\t<tr>\n\t\t<td width=\"20%\" rowspan=\"2\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t<td width=\"80%\" align=center class=title>List of Audits</td>\n     </tr>\n     <tr>\n\t \t<td align=center>");
      out.print( todaysDate );
      out.write("</td>\n\t</tr>\n\t</table>\n\t<!-- end Header table with title -->\n\t<br/>\n\t");

	if (audits == null || audits.length == 0) {
	
      out.write("\n\t<br/>\n\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr>\n\t\t<td align=\"center\">No audits.</td>\n\t</tr>\n\t</table>\n\t");

	} else {
	
      out.write("\n\t<!-- Detail table -->\n\t<br/>\n\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Reference</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Topic</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Standard</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Origin</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Status</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Confidentiality</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Responsible</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Start date</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">End date</td>\n\t</tr>\n\t");

	// now show content of each vuln
	for(int i=0; i<audits.length; ++i) {
	Audit a = audits[i];
	
      out.write("\n\t<tr>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(a.getReference()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(a.getTopic()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(a.getStandardName()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(a.getOrigin()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(a.getStatus()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(a.getConfidentiality()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(a.getOwner()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(formatDate(a.getStartDate()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(formatDate(a.getEndDate()));
      out.write("</td>\n\t</tr>\n\t");

	} // end for
	
      out.write("\n\t</table>\n\t<!-- end Detail table -->\n\t");

	}
	
      out.write('\n');
      out.write('	');
      out.write("\n&nbsp;<br/>\n<table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"0\">\n<tr>\n\t<td align=\"center\" class=\"copy\">\n\t<br/>\n\t<br/>Copyright (c) 2004-2008 Entelience SARL, Copyright (c) 2008-2009 Equity SA, Copyright (c) 2009-2010 Consulare sÃ rl, Licensed under the <a href=\"http://www.gnu.org/copyleft/gpl.html\">GNU GPL, Version 3</a>.\n\t<br/>\n\t</td>\n</tr>\n</table>");
      out.write("\n\t</div>\n\t</td>\n</tr>\n</table>\n<!-- end Main table -->\n</body>\n</html>\n");

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