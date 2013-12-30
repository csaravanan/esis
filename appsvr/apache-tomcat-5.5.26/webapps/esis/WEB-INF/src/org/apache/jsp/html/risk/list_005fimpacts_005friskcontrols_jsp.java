package org.apache.jsp.html.risk;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapRiskAssessment;
import com.entelience.objects.risk.RiskControl;
import com.entelience.objects.risk.Impact;
import com.entelience.objects.risk.RiskId;
import com.entelience.objects.risk.RiskReviewId;
import com.entelience.util.DateHelper;

public final class list_005fimpacts_005friskcontrols_jsp extends com.entelience.servlet.JspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static java.util.List _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList(3);
    _jspx_dependants.add("/html/risk/../style.inc.jsp");
    _jspx_dependants.add("/html/risk/../icon.inc.jsp");
    _jspx_dependants.add("/html/risk/../copyright.inc.jsp");
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
try	{
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	// Now we can use webservices
	soapRiskAssessment ri = new soapRiskAssessment(peopleId);
	
	Boolean my = getParamBoolean(request, "my");
	Integer risk_id = getParamInteger(request, "riskId");
	RiskId riskId = null;
	if(risk_id != null){
		riskId = new RiskId(risk_id.intValue(), 0);
	}
	Integer review_id = getParamInteger(request, "reviewId");
	RiskReviewId reviewId = null;
	if(review_id != null){
		reviewId = new RiskReviewId(review_id.intValue(), 0);
	}
	Boolean showDeletedImpacts = getParamBoolean(request, "showDeletedImpacts");
	String orderImpacts = getParam(request, "orderImpacts");
	String wayImpacts = getParam(request, "wayImpacts");
	Integer pageNumberImpacts = getParamInteger(request, "pageNumberImpacts");
	Boolean showDeletedRiskControls = getParamBoolean(request, "showDeletedRiskControls");
	String orderRiskControls = getParam(request, "orderRiskControls");
	String wayRiskControls = getParam(request, "wayRiskControls");
	Integer pageNumberRiskControls = getParamInteger(request, "pageNumberRiskControls");
	
	String todayDate = formatDate(DateHelper.now());
	Impact[] impacts = ri.listImpacts(my, riskId, reviewId, showDeletedImpacts, orderImpacts, wayImpacts, pageNumberImpacts);
	RiskControl[] riskcontrols = ri.listRiskControls(my, riskId, reviewId, showDeletedRiskControls, orderRiskControls, wayRiskControls, pageNumberRiskControls);
	// end code

      out.write("\n<!-- Now begins HTML page ...-->\n<head>\n<title>List of Impacts &amp; Risk Controls - ");
      out.print( todayDate );
      out.write(" </title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<!-- Main table -->\n<table width=\"100%\" border=0 bgcolor=\"white\">\n<tr>\n\t<td>\n\t<div align=\"center\">\n\t<!-- Header table with title -->\n\t<table border=0 cellspacing=0 cellpadding=4 width=\"100%\">\n\t<tr>\n\t\t<td width=\"20%\" rowspan=\"2\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t<td width=\"80%\" align=center class=title>List of Impacts &amp; Risk Controls</td>\n     </tr>\n     <tr>\n\t \t<td align=center>");
      out.print( todayDate );
      out.write("</td>\n\t</tr>\n\t</table>\n\t<!-- end Header table with title -->\n\t<br/>\n\t");

	if (impacts == null || impacts.length == 0) {
	
      out.write("\n\t<br/>\n\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr>\n\t\t<td align=\"center\">No impacts.</td>\n\t</tr>\n\t</table>\n\t");

	} else {
	
      out.write("\n\t<!-- Detail table -->\n\t<br/>\n\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr>\n\t\t<td colspan=\"5\" align=\"center\" bgcolor=\"gainsboro\"><b>IMPACTS</b></td>\n\t</tr>\n\t<tr>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Title</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Description</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Negative Consequence</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Benefic Consequence</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Deleted</td>\n\t</tr>\n\t");

	// now show content of each vuln
	for(int i=0; i<impacts.length; ++i) {
	Impact im = impacts[i];
	
      out.write("\n\t<tr>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(im.getTitle()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(im.getDescription()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print( im.getBenefic() ? "-" : HTMLEncode(im.getConsequenceLevel()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print( im.getBenefic() ? HTMLEncode(im.getConsequenceLevel()) : "-");
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print( im.isDeleted() ? "yes" : "no");
      out.write("</td>\n\t</tr>\n\t");

	} // end for
	
      out.write("\n\t</table>\n\t<!-- end Detail table -->\n\t");

	}
	
      out.write("\n\t<br/>\n\t");

	if (riskcontrols == null || riskcontrols.length == 0) {
	
      out.write("\n\t<br/>\n\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr>\n\t\t<td align=\"center\">No risk controls.</td>\n\t</tr>\n\t</table>\n\t");

	} else {
	
      out.write("\n\t<!-- Detail table -->\n\t<br/>\n\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr>\n\t\t<td colspan=\"5\" align=\"center\" bgcolor=\"gainsboro\"><b>RISK CONTROLS</b></td>\n\t</tr>\n\t<tr>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Resource requirement</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Description</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Responsible</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Deleted</td>\n\t</tr>\n\t");

	// now show content of each vuln
	for(int i=0; i<riskcontrols.length; ++i) {
	RiskControl rc = riskcontrols[i];
	
      out.write("\n\t<tr>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(rc.getResourceRequirement()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(rc.getDescription()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(rc.getResponsible()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print( rc.isDeleted() ? "yes" : "no");
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
