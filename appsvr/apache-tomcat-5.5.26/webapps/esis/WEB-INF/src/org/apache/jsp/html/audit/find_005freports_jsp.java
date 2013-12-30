package org.apache.jsp.html.audit;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapAudit;
import com.entelience.objects.audit.Report;
import com.entelience.util.DateHelper;
import com.entelience.sql.DbHelper;
import java.util.List;

public final class find_005freports_jsp extends com.entelience.servlet.JspBase
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
      out.write("\n\n\n\n\n\n\n\n");

// code
try {
      // Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
      // Now we can use webservices
	
	String todaysDate = formatDate(DateHelper.now());
	
	String searchedText = getParam(request, "searchedText");
	
	int searchType = getParamInt(request, "searchType");
	
	String statusMatchAsString = getParam(request, "statusMatch");
	String raciMatch = getParam(request, "raciMatch");
	
	List<Number> statusMatch = toArray(statusMatchAsString);
	
	Integer pageNumber = getParamInteger(request, "pageNumber");
	String order = getParam(request, "order");
	String way = getParam(request, "way");
	Boolean my = getParamBoolean(request, "my");
	
	soapAudit au = new soapAudit(peopleId);
	Report[] resultSearch = au.findReports(searchedText, searchType, statusMatch, raciMatch, order, way, pageNumber, my);

// end code

      out.write("\n<!-- Now begins HTML page ...-->\n<head>\n<title>Search for reports - ");
      out.print( todaysDate );
      out.write(" </title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<!-- Main table -->\n<table width=\"100%\" border=\"0\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t<div align=\"center\">\n\t<!-- Header table with title -->\n\t<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t<tr>\n\t\t<td width=\"20%\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t<td width=\"80%\" align=\"center\" class=\"title\">List of reports</td>\n\t</tr>\n\t</table>\n\t<table border=\"0\" align=\"center\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t<tr>\n\t\t<td align=\"center\" class=\"subtitle\">");
      out.print( searchedText);
      out.write("</td>\n\t</tr>\n\t</table>\n\t<br/>\n\t<br/>\n\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n    <tr>\n\t\t<td width=\"30%\" align=\"center\">Search on</td>\n\t\t<td width=\"70%\" align=\"center\"><b>");
      out.print( searchedText );
      out.write("</b></td>\n\t</tr>\n\t</table>\n\t<br/>\n\t");

	if (resultSearch == null || resultSearch.length == 0) {
	
      out.write("\n\t<!-- no Vulns -->\n\t<br/>\n\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr>\n\t\t<td align=\"center\">No reports found.</td>\n\t</tr>\n\t</table>\n\t");

	} else {
	// results
	
      out.write("\n\t<br/>\n\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Title</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Source</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Subtitle</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Executive summary</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Status</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Responsible</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Audit Topic</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Audit Standard</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Audit Origin</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Creation Date</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Due Date</td>\n\t</tr>\n\t");
	
	// now show content of each vuln
	for(int i=0; i<resultSearch.length; ++i) {
	Report r = resultSearch[i];
	
      out.write("\n\t<tr>\n\t\t<td>");
      out.print(HTMLEncode(r.getTitle()));
      out.write("</td>\n\t\t<td>");
      out.print(HTMLEncode(r.getSource()));
      out.write("</td>\n\t\t<td>");
      out.print(HTMLEncode(DbHelper.unnullify(r.getSubTitle())));
      out.write("</td>\n\t\t<td>");
      out.print(HTMLEncode(DbHelper.unnullify(r.getExecutiveSummary())));
      out.write("</td>\n\t\t<td>");
      out.print(HTMLEncode(r.getReportStatus()));
      out.write("</td>\n\t\t<td>");
      out.print(HTMLEncode(r.getOwner()));
      out.write("</td>\n\t\t<td>");
      out.print(HTMLEncode(r.getReport_topic()));
      out.write("</td>\n\t\t<td>");
      out.print(HTMLEncode(r.getAuditStandard()));
      out.write("</td>\n\t\t<td>");
      out.print(HTMLEncode(r.getOrigin()));
      out.write("</td>\n\t\t<td>");
      out.print(formatDate(r.getCreation_date()));
      out.write("</td>\n\t\t<td>");
      out.print(formatDate(r.getDueDate()));
      out.write("</td>\n\t</tr>\n\t");

	}//end for
	
      out.write("\n\t</table>\n\t");

	}// end if
	
      out.write('\n');
      out.write('	');
      out.write("\n&nbsp;<br/>\n<table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"0\">\n<tr>\n\t<td align=\"center\" class=\"copy\">\n\t<br/>\n\t<br/>Copyright (c) 2004-2008 Entelience SARL, Copyright (c) 2008-2009 Equity SA, Copyright (c) 2009-2010 Consulare sÃ rl, Licensed under the <a href=\"http://www.gnu.org/copyleft/gpl.html\">GNU GPL, Version 3</a>.\n\t<br/>\n\t</td>\n</tr>\n</table>");
      out.write("\n\t</div>\n\t</td>\n</tr>\n</table>\n</body>\n</html>\n");

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
