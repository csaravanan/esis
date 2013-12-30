package org.apache.jsp.html.audit;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapAudit;
import com.entelience.objects.audit.ListReports;
import com.entelience.objects.audit.ExtReport;
import com.entelience.objects.audit.Report;
import com.entelience.util.DateHelper;
import com.entelience.objects.audit.AuditId;

public final class list_005freports_jsp extends com.entelience.servlet.JspBase
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
	soapAudit au = new soapAudit(peopleId);
	Boolean my = getParamBoolean(request, "my");
	String todaysDate = formatDate(DateHelper.now());
	Boolean openRec = getParamBoolean(request, "openRec");
	Boolean openAct = getParamBoolean(request, "openAct");
	Boolean overdueActions = getParamBoolean(request, "overdueActions");
    String order = getParam(request, "order");
    String way = getParam(request, "way");
    Integer pageNumber = getParamInteger(request, "pageNumber");
	Integer audId = getParamInteger(request, "auditId");
	AuditId audit_id = null;
	if(audId != null)
		audit_id = new AuditId(audId.intValue(), 0);
	ListReports[] reports = au.getListOfReports(audit_id, openRec.booleanValue(), openAct.booleanValue(), overdueActions.booleanValue(), my,order, way, pageNumber);
	ListReports lr;
	ExtReport ext;
	Report rep;

// end code

      out.write("\n<!-- Now begins HTML page ...-->\n<head>\n<title>List of reports - ");
      out.print( todaysDate );
      out.write(" </title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<!-- Main table -->\n<table width=\"100%\" border=\"0\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t<div align=\"center\">\n\t<!-- Header table with title -->\n\t<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t<tr>\n\t\t<td width=\"20%\" rowspan=\"2\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t<td width=\"80%\" align=\"center\" class=\"title\">List of reports</td>\n\t</tr>\n\t<tr>\n\t\t<td align=\"center\">");
      out.print( todaysDate );
      out.write("</td>\n\t</tr>\n\t</table>\n\t<br/>\n\t<!-- end Header table with title -->\n\t");

	if (reports == null || reports.length == 0) {
	
      out.write("\n\t<!-- No data -->\n\t<br/>\n\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr>\n\t\t<td align=\"center\">No reports.</td>\n\t</tr>\n\t</table>\n\t");

	} else {
		if (reports.length>1) { // display anchors
		
      out.write("\n\t\t<!-- List titles -->\n\t\t<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td width=\"60%\" align=\"center\" bgcolor=\"gainsboro\">Report</td>\n\t\t\t<td width=\"20%\" align=\"center\" bgcolor=\"gainsboro\">Recommendations:<br/>open / close / risk accepted / total</td>\n\t\t\t<td width=\"20%\" align=\"center\" bgcolor=\"gainsboro\">Actions:<br/>open / close / total</td>\n\t\t</tr>\n\t\t");

		for(int i=0; i<reports.length; ++i) {
		lr = reports[i];
		ext = au.getReportExt(lr.getReport_id(), my);
		
      out.write("\n\t\t<!-- List with internal links -->\n\t\t<tr>\n\t\t\t<td align=\"center\"><a href=\"#num");
      out.print( i );
      out.write('"');
      out.write('>');
      out.print( lr.getTitle() );
      out.write("</a></td>\n\t\t\t<td align=\"center\">");
      out.print( ext.getN_open_recs() );
      out.write("&nbsp;/&nbsp;");
      out.print( ext.getN_closed_recs() );
      out.write("&nbsp;/&nbsp;");
      out.print( ext.getN_risk_accepted_recs() );
      out.write("&nbsp;/&nbsp;");
      out.print( lr.getN_recs() );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( ext.getN_actions_open() );
      out.write("&nbsp;/&nbsp;");
      out.print( ext.getN_actions_closed() );
      out.write("&nbsp;/&nbsp;");
      out.print( lr.getN_actions() );
      out.write("</td>\n\t\t</tr>\n\t\t");

		} // end for
		
      out.write("\n\t\t</table>\n\t\t<!-- end List table -->\n\t\t");

		} // end if reports.length>1
		
      out.write("\n\t\t<br/>\n\t\t<!-- Detail table -->\n\t\t<br/>\n\t\t<table border=\"0\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t");

		// now show content of each vuln
		for(int i=0; i<reports.length; ++i) {
		rep = au.getReport(reports[i].getReport_id());
		//rec = recoms[i];
		
      out.write("\n\t\t<tr>\n\t\t\t<td>\n\t\t\t<!-- One Detail table -->\n\t\t\t<a name=\"#num");
      out.print( i );
      out.write("\"></a>\n\t\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\"><b>Report</b></td>\n\t\t\t\t<td colspan=\"3\" width=\"75%\" align=\"left\"><b>");
      out.print( HTMLEncode(rep.getTitle()) );
      out.write("</b></td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Subtitle</td>\n\t\t\t\t<td colspan=\"3\" align=\"left\">");
      out.print( HTMLEncode(rep.getSubTitle()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Executive summary</td>\n\t\t\t\t<td colspan=\"3\" align=\"left\">");
      out.print( HTMLEncode(rep.getExecutiveSummary()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Source</td>\n\t\t\t\t<td colspan=\"3\" align=\"left\">");
      out.print( HTMLEncode(rep.getSource()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Status</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( HTMLEncode(rep.getReportStatus()) );
      out.write("&nbsp;</td>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Due date</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( formatDate(rep.getDueDate()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Audit reference</td>\n\t\t\t\t<td width=\"75%\" colspan=\"3\" align=\"left\">");
      out.print( HTMLEncode(rep.getReference()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t\n\t\t\t<tr>\n\t\t\t     ");
 if(rep.getReport_topic() == null) {
      out.write("\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Audit standard</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( HTMLEncode(rep.getAuditStandard()) );
      out.write("&nbsp;</td>\n\t                     ");
 } else { 
      out.write("\n\t                        <td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Audit topic</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( HTMLEncode(rep.getReport_topic()) );
      out.write("&nbsp;</td>\n\t                     ");
 } 
      out.write("\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Audit origin</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( HTMLEncode(rep.getOrigin()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Responsible</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( HTMLEncode(rep.getOwner()) );
      out.write("&nbsp;</td>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Creation date</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( formatDate(rep.getCreation_date()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t</table>\n\t\t\t<!-- end One Detail table -->\n\t\t\t</td>\n\t\t</tr>\n\t\t");

		} // end for
		
      out.write("\n\t\t</table>\n\t\t");

	} // end if recoms
	
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
