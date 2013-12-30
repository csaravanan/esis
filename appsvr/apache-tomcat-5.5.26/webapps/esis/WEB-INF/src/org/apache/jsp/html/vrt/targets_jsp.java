package org.apache.jsp.html.vrt;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapVulnerabilityReview;
import com.entelience.objects.DropDown;
import com.entelience.objects.metrics.TargetDetail;
import com.entelience.util.DateHelper;
import java.lang.reflect.Array;

public final class targets_jsp extends com.entelience.servlet.JspBase
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
      out.write("\n\n\n\n\n\n\n");

try{
	// code
	// Check session id validity
	Integer peopleId = getSession(request);
        initTimeZone(peopleId);
	// Now we can use webservices
	soapVulnerabilityReview vr = new soapVulnerabilityReview(peopleId);
	
	TargetDetail[] tds = vr.getMetricTargets();
	int len = Array.getLength(tds);
	DropDown[] se;
	se = vr.getListOfSeverity();
	String todaysDate = formatDate(DateHelper.now());
	// end code

      out.write("\n<head>\n<title>VRT Targets</title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<table width=\"100%\" border=\"0\" align=\"center\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t\t<div align=\"center\">\n\t\t<!-- Header -->\n\t\t<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td width=\"20%\" rowspan=\"2\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t\t<td width=\"80%\" align=\"center\" class=\"title\">VRT Targets</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"center\">");
      out.print( todaysDate );
      out.write("</td>\n\t\t</tr>\n\t\t</table>\n\t\t<br/>\n\t\t<!-- Target Details-->\n\t\t<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t<!--\n\t\t<tr>\n\t\t\t<td colspan=\"2\" align=\"center\"><h2>< %= HTMLTitle(\"Targets\", null) % ></h2></td>\n\t\t</tr>\n\t\t-->\n\t\t<tr>\n\t\t\t<td align=\"center\" width=\"50%\" bgcolor=\"gainsboro\"><b>Name</b></td>\n\t\t\t<td align=\"center\" width=\"50%\" bgcolor=\"gainsboro\"><b>Value</b></td>\n\t\t</tr>\n\t\t");

		if (len != 0) {
			for(int i=0;i<len;++i) {
			
      out.write("\n\t\t\t<tr>\n\t\t\t\t<td align=\"center\">");
      out.print( HTMLEncode(tds[i].getName().replace('_',' ')) );
      out.write("&nbsp;\n\t\t\t\t");

				if ("close_time".equals(tds[i].getName())) {
				
      out.write("for severity &quot;");
      out.print( se[tds[i].getKey_id().intValue()].getLabel() );
      out.write("&quot;");

				}
      out.write("\n\t\t\t\t</td>\n\t\t\t\t<td align=\"center\">");
      out.print( tds[i].getValue() );
      out.write("\n\t\t\t\t");

				if (tds[i].getName().endsWith("size")) {
				
      out.write("&nbsp;vulns");

				}
      out.write("\n\t\t\t\t");

				if (tds[i].getName().endsWith("time")) {
				
      out.write("&nbsp;days");

				}
      out.write("\n\t\t\t\t");

				if (tds[i].getName().endsWith("rate")) {
				
      out.write("&nbsp;%");

				}
      out.write("\n\t\t\t\t</td>\n\t\t\t</tr>\n\t\t\t");

			}
		} // end details
		
      out.write("\n\t\t</table>\n\t\t");
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
