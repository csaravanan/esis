package org.apache.jsp.html.vrt;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapVulnerabilityReview;
import com.entelience.objects.DropDown;
import com.entelience.objects.metrics.MetricDetail;
import com.entelience.util.DateHelper;
import java.lang.reflect.Array;

public final class metrics_jsp extends com.entelience.servlet.JspBase
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

// code
// Check session id validity
try{
	String[][] groups;
	String[] names;
	int len;
	MetricDetail md;
	DropDown[] se;
	String todaysDate;
	int SECBYDAY;
	java.text.NumberFormat nf;
	
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	// Now we can use webservices
	soapVulnerabilityReview vr = new soapVulnerabilityReview(peopleId);
	
	groups = new String[3][];
	groups[0] = new String[] {"triaged", "added", "ignored", "to repair", "investigated", "risk accepted", "opened", "fixed" };
	groups[1] = new String[] {"time2vrt", "time2open"};
	groups[2] = new String[] {"time2close0", "time2close1", "time2close2", "time2close3", "time2close4"};
	
	se = vr.getListOfSeverity();
	todaysDate = formatDate(DateHelper.now());
	SECBYDAY = 3600 * 24;
	nf = java.text.NumberFormat.getInstance();
	// end code

      out.write("\n<head>\n<title>VRT Metrics</title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<table width=\"100%\" border=\"0\" align=\"center\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t\t<div align=\"center\">\n\t\t<!-- Header -->\n\t\t<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td width=\"20%\" rowspan=\"2\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t\t<td width=\"80%\" align=\"center\" class=\"title\">VRT Metrics</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"center\">");
      out.print( todaysDate );
      out.write("</td>\n\t\t</tr>\n\t\t</table>\n\t\t<br/>\n\t\t<!-- Compliancy Metrics-->\n\t\t<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td colspan=\"5\" align=\"center\" class=\"subtitle\">");
      out.print( HTMLTitle("Compliance", null) );
      out.write("</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"center\" width=\"40%\" bgcolor=\"gainsboro\"><b>Vulnerability Status</b></td>\n\t\t\t<td width=\"15%\" align=\"center\" bgcolor=\"gainsboro\"><b>Size</b></td>\n\t\t\t<td width=\"15%\" align=\"center\" bgcolor=\"gainsboro\"><b>Rate</b></td>\n\t\t\t<td width=\"15%\" align=\"center\" bgcolor=\"gainsboro\"><b>Target</b></td>\n\t\t\t<td width=\"15%\" align=\"center\" bgcolor=\"gainsboro\"><b>Limit</b></td>\n\t\t</tr>\n\t\t");

		names = groups[0];
		len = Array.getLength(names);
		if (len != 0) {
			for(int i=0;i<len;++i) {
			md = vr.getMetric(names[i], null);
			
      out.write("\n\t\t\t<tr>\n\t\t\t\t<td align=\"center\">");
      out.print( HTMLEncode(md.getMetric()) );
      out.write("</td>\n\t\t\t\t<td align=\"center\">");
      out.print( Math.round(md.getN()) );
      out.write("&nbsp;vulns</td>\n\t\t\t\t<td align=\"center\">");
      out.print( (md.getAverage()==Math.round(md.getAverage())) ? Math.round(md.getAverage()) : md.getAverage() );
      out.write("&nbsp;%</td>\n\t\t\t\t<td align=\"center\">");
      out.print( Math.round(md.getTarget()) );
      out.write("&nbsp;vulns</td>\n\t\t\t\t<td align=\"center\">");
      out.print( Math.round(md.getMaximum()) );
      out.write("&nbsp;vulns</td>\n\t\t\t</tr>\n\t\t\t");

			}//end for
		} // end details
		
      out.write("\n\t\t</table>\n\t\t<br/>\n\t\t<!-- Reactivity to open Metrics-->\n\t\t<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td colspan=\"5\" align=\"center\" class=\"subtitle\">");
      out.print( HTMLTitle("Reactivity", null) );
      out.write("</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"40%\" align=\"center\" bgcolor=\"gainsboro\"><b>Time</b></td>\n\t\t\t<td width=\"15%\" align=\"center\" bgcolor=\"gainsboro\"><b>Longest</b></td>\n\t\t\t<td width=\"15%\" align=\"center\" bgcolor=\"gainsboro\"><b>Average</b></td>\n\t\t\t<td width=\"15%\" align=\"center\" bgcolor=\"gainsboro\"><b>Shortest</b></td>\n\t\t\t<td width=\"15%\" align=\"center\" bgcolor=\"gainsboro\"><b>Target</b></td>\n\t\t</tr>\n\t\t");

		names = groups[1];
		len = Array.getLength(names);
		if (len != 0) {
			for(int i=0;i<len;++i) {
			md = vr.getMetric(names[i], null);
			
      out.write("\n\t\t\t<tr>\n\t\t\t\t<td align=\"center\">");
      out.print( HTMLEncode(md.getMetric()) );
      out.write("</td>\n\t\t\t\t<td align=\"center\">");
      out.print( Math.round(md.getMaximum()/SECBYDAY) );
      out.write("&nbsp;days</td>\n\t\t\t\t<td align=\"center\">");
      out.print( Math.round(md.getAverage()/SECBYDAY) );
      out.write("&nbsp;days</td>\n\t\t\t\t<td align=\"center\">");
      out.print( Math.round(md.getMinimum()/SECBYDAY) );
      out.write("&nbsp;days</td>\n\t\t\t\t<td align=\"center\">");
      out.print( Math.round(md.getTarget()/SECBYDAY) );
      out.write("&nbsp;days</td>\n\t\t\t</tr>\n\t\t\t");

			}
		} // end details
		
      out.write("\n\t\t</table>\n\t\t<br/>\n\t\t&nbsp;<br/>\n\t\t<!-- Exposure Metrics-->\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td colspan=\"5\" align=\"center\" class=\"subtitle\">");
      out.print( HTMLTitle("Exposure", null) );
      out.write("</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"center\" width=\"40%\" bgcolor=\"gainsboro\"><b>Time to close since repair decision</b></td>\n\t\t\t<td align=\"center\" width=\"15%\" bgcolor=\"gainsboro\"><b>Longest</b></td>\n\t\t\t<td align=\"center\" width=\"15%\" bgcolor=\"gainsboro\"><b>Average</b></td>\n\t\t\t<td align=\"center\" width=\"15%\" bgcolor=\"gainsboro\"><b>Shortest</b></td>\n\t\t\t<td align=\"center\" width=\"15%\" bgcolor=\"gainsboro\"><b>Target</b></td>\n\t\t</tr>\n\t\t");

		names = groups[2];
		len = Array.getLength(names);
		if (len != 0) {
			for(int i=0;i<len;++i) {
			md = vr.getMetric(names[i],null);
			
      out.write("\n\t\t\t<tr>\n\t\t\t\t<td align=\"center\">");
      out.print( HTMLEncode(md.getMetric()) );
      out.write("</td>\n\t\t\t\t<td align=\"center\">");
      out.print( Math.round(md.getMaximum()/SECBYDAY) );
      out.write("&nbsp;days</td>\n\t\t\t\t<td align=\"center\">");
      out.print( Math.round(md.getAverage()/SECBYDAY) );
      out.write("&nbsp;days</td>\n\t\t\t\t<td align=\"center\">");
      out.print( Math.round(md.getMinimum()/SECBYDAY) );
      out.write("&nbsp;days</td>\n\t\t\t\t<td align=\"center\">");
      out.print( Math.round(md.getTarget()/SECBYDAY) );
      out.write("&nbsp;days</td>\n\t\t\t</tr>\n\t\t\t");

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
