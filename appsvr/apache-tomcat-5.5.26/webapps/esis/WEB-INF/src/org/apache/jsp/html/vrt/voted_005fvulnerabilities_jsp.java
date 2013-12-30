package org.apache.jsp.html.vrt;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapVulnerabilityReview;
import com.entelience.objects.vrt.VotedVulnerability;
import com.entelience.util.DateHelper;
import com.entelience.sql.DbHelper;

public final class voted_005fvulnerabilities_jsp extends com.entelience.servlet.JspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

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
      out.write("\n\n\n\n\n\n");

// code

try {
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	String order = getParam(request, "order");
	String way = getParam(request, "way");
	Integer pageNumber = getParamInteger(request, "page");
	Boolean my = getParamBoolean(request, "my");
	if(my == null)
		my = Boolean.FALSE;
	Boolean excludeWithDecision = getParamBoolean(request,"excludeWithDecision");
	if(excludeWithDecision == null)
		excludeWithDecision = Boolean.FALSE;
    
	// Now we can use webservices
	soapVulnerabilityReview vr = new soapVulnerabilityReview(peopleId);
	String todaysDate = formatDate(DateHelper.now());
	VotedVulnerability[] votedVulns = vr.getVotedVulnerabilities(my.booleanValue(), excludeWithDecision.booleanValue(), order, way, pageNumber); 
	// end code

      out.write("\n<!-- Now begins HTML page ...-->\n<head>\n<title>New vulnerabilities with vote - ");
      out.print( todaysDate );
      out.write("</title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<table width=\"100%\" border=\"0\" align=\"center\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t\t<div align=\"center\">\n\t\t<!-- Header //-->\n\t\t<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td width=\"20%\" rowspan=\"2\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t\t<td width=\"80%\" align=\"center\" class=\"title\">New vulnerabilities with vote(s)</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"center\">");
      out.print( todaysDate );
      out.write("</td>\n\t\t</tr>\n\t\t</table>\n\t\t<br/>\n\t\t");

		if (votedVulns == null || votedVulns.length == 0) {
		
      out.write("\n\t\t<!-- no Vulns -->\n\t\t<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td align=\"center\">No new vulnerabilities with vote.</td>\n\t\t</tr>\n\t\t</table>\n\t\t");

		} else {
		// display Vulns
		
      out.write("\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td>\n\t\t\t\t&nbsp;<br/>\n\t\t\t\t<ul>\n\t\t\t\t");

				for(int i=0; i<votedVulns.length; ++i) {
				VotedVulnerability vil = votedVulns[i];
				
      out.write("\n\t\t\t\t<li>\n\t\t\t\t\t<div align=\"left\"><b>");
      out.print( vil.getVuln_name() );
      out.write("</b> - \n\t\t\t        ");
      out.print( HTMLTitle(vil.getDescription(), null) );
      out.write("&nbsp;</div>\n\t\t\t        ");

					if(DbHelper.nullify(vil.getMy_vote()) != null){
					
      out.write("\n\t\t\t        <div align=\"left\"> - My vote: <b>");
      out.print(vil.getMy_vote());
      out.write("</b></div>\n\t\t\t        ");

					}
					if(DbHelper.nullify(vil.getDecision()) != null){
					
      out.write("\n\t\t\t        <div align=\"left\"> - Current decision: <b>");
      out.print(vil.getDecision());
      out.write("</b></div>\n\t\t\t        ");

					}
					
      out.write("\n\t\t\t        <br>\n\t\t\t\t</li>\n\t\t\t\t");

				} // end for
				
      out.write("\n\t\t\t\t</ul>\n\t\t\t</td>\n\t\t</tr>\n\t\t</table>\n\t\t");

		} // end if votedVulns
		
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
