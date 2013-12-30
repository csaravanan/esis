package org.apache.jsp.html.audit;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapAudit;
import com.entelience.objects.audit.Audit;
import com.entelience.util.DateHelper;
import java.util.List;

public final class find_005faudits_jsp extends com.entelience.servlet.JspBase
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

      out.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n<html>\n<!-- the HTML header allows us to view the jsp as an html file in web browsers -->\n");
      out.write("\n\n\n\n\n\n\n");

try {
	// code
	// Check session id validity
	Integer peopleId = getSession(request);
        initTimeZone(peopleId);
	Audit resultSearch[];
	String todaysDate = formatDate(DateHelper.now());
	String searchedText = getParam(request, "searchedText");
	
	int searchType = getParamInt(request, "searchType");
	
	String statusMatchAsString = getParam(request, "statusMatch");
	String confidentialityMatchAsString = getParam(request, "confidentialityMatch");
	String originMatchAsString = getParam(request, "originMatch");
	String topicMatchAsString = getParam(request, "topicMatch");
        String standardMatchAsString = getParam(request, "standardMatch");
	String raciMatch = getParam(request, "raciMatch");

	List<Number> statusMatch = toArray(statusMatchAsString);
	List<Number> confidentialityMatch = toArray(confidentialityMatchAsString);
	List<Number> originMatch = toArray(originMatchAsString);
	List<Number> topicMatch = toArray(topicMatchAsString);
	List<Number> standardMatch = toArray(standardMatchAsString);

	
	
	Integer pageNumber = getParamInteger(request, "pageNumber");
	String order = getParam(request, "order");
	String way = getParam(request, "way");
	Boolean my = getParamBoolean(request, "my");
	
	// Now we can use webservices
	soapAudit sa = new soapAudit(peopleId);
	
	resultSearch = sa.findAudits(searchedText, searchType, statusMatch, confidentialityMatch, originMatch, topicMatch, standardMatch, raciMatch, order, way, pageNumber, my);
	// end code

      out.write("\n<head>\n<title>Search for audits - ");
      out.print( todaysDate );
      out.write("</title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<table width=\"100%\" border=\"0\" align=\"center\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t<div align=\"center\">\n\t<!-- Header //-->\n\t<table border=\"0\" align=\"center\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t<tr>\n\t\t<td width=\"20%\" rowspan=\"2\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t<td width=\"80%\" align=\"center\" class=\"title\">Search for audits</td>\n\t</tr>\n\t<tr>\n\t\t<td align=\"center\" class=\"subtitle\">");
      out.print( searchedText);
      out.write("</td>\n\t</tr>\n\t</table>\n\t<br/>\n\t<br/>\n\t<table border=\"1\" align=\"center\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr>\n\t\t<td width=\"30%\" align=\"center\">Search on</td>\n\t\t<td width=\"70%\" align=\"center\"><b>");
      out.print( searchedText );
      out.write("</b></td>\n\t</tr>\n\t</table>\n\t<br/>\n\t");

	if (resultSearch == null || resultSearch.length == 0) {
	
      out.write("\n\t<!-- no Vulns -->\n\t<br/>\n\t<table border=\"1\" align=\"center\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr>\n\t\t<td align=\"center\">No audits found.</td>\n\t</tr>\n\t</table>\n\t");

	} else {
	// results
	
      out.write("\n\t\t\t<br/>\n\t\t\t<table border=\"1\" align=\"center\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t\t<tr>\n\t\t\t\t<td align=\"center\" bgcolor=\"gainsboro\">Reference</td>\n\t\t\t\t<td align=\"center\" bgcolor=\"gainsboro\">Topic</td>\n\t\t\t\t<td align=\"center\" bgcolor=\"gainsboro\">Standard</td>\n\t\t\t\t<td align=\"center\" bgcolor=\"gainsboro\">Origin</td>\n\t\t\t\t<td align=\"center\" bgcolor=\"gainsboro\">Status</td>\n\t\t\t\t<td align=\"center\" bgcolor=\"gainsboro\">Confidentiality</td>\n\t\t\t\t<td align=\"center\" bgcolor=\"gainsboro\">Responsible</td>\n\t\t\t\t<td align=\"center\" bgcolor=\"gainsboro\">Start date</td>\n\t\t\t\t<td align=\"center\" bgcolor=\"gainsboro\">End date</td>\n\t\t\t</tr>\n\t\t\t");
	
			// now show content of each vuln
			for(int i=0; i<resultSearch.length; ++i) {
			Audit a = resultSearch[i];
			
      out.write("\n\t\t\t<tr>\n\t\t\t\t<td>");
      out.print(HTMLEncode(a.getReference()));
      out.write("</td>\n\t\t\t\t<td>");
      out.print(HTMLEncode(a.getTopic()));
      out.write("</td>\n\t\t\t\t<td>");
      out.print(HTMLEncode(a.getStandardName()));
      out.write("</td>\n\t\t\t\t<td>");
      out.print(HTMLEncode(a.getOrigin()));
      out.write("</td>\n\t\t\t\t<td>");
      out.print(HTMLEncode(a.getStatus()));
      out.write("</td>\n\t\t\t\t<td>");
      out.print(HTMLEncode(a.getConfidentiality()));
      out.write("</td>\n\t\t\t\t<td>");
      out.print(HTMLEncode(a.getOwner()));
      out.write("</td>\n\t\t\t\t<td>");
      out.print(formatDate(a.getStartDate()));
      out.write("</td>\n\t\t\t\t<td>");
      out.print(formatDate(a.getEndDate()));
      out.write("</td>\n\t\t\t</tr>\n\t\t\t");

			}//end for
			
      out.write("\n\t\t\t</table>\n\t");

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
