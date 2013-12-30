package org.apache.jsp.html.audit;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapAudit;
import com.entelience.soap.soapRaci;
import com.entelience.objects.audit.Report;
import com.entelience.objects.audit.Recommendation;
import com.entelience.objects.raci.RaciInfoLine;
import com.entelience.util.DateHelper;
import com.entelience.objects.audit.AuditReportId;
import com.entelience.objects.audit.AuditId;

public final class list_005frecommendations_jsp extends com.entelience.servlet.JspBase
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
      out.write("\n\n\n\n\n\n\n\n\n\n");
 // code
try {
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	// Now we can use webservices
	Recommendation rec;
	Recommendation[] recoms;
	Recommendation lr;
	soapAudit au = new soapAudit(peopleId);
	soapRaci sr = new soapRaci(peopleId); 
	String todaysDate = formatDate(DateHelper.now());
	Boolean my = getParamBoolean(request, "my");
	Boolean overdueActions = getParamBoolean(request, "overdueActions");
	Integer repId = getParamInteger(request, "report_id");
	AuditReportId report_id = null;
	if(repId != null)
		report_id = new AuditReportId(repId.intValue(), 0);
	Integer aud_id = getParamInteger(request, "audId");
	AuditId audId = null;
	if(aud_id != null)
		audId = new AuditId(aud_id.intValue(), 0);
	Integer recStatus = getParamInteger(request, "recStatus");
	Integer recPriority = getParamInteger(request, "recPriority");
	Integer recSeverity = getParamInteger(request, "recSeverity");
	Integer recPrimaryTopicId = getParamInteger(request, "recPrimaryTopicId");
	Integer recSecondaryTopicId = getParamInteger(request, "recSecondaryTopicId");
    String order = getParam(request, "order");
    String way = getParam(request, "way");
    Integer pageNumber = getParamInteger(request, "pageNumber");
	Report report = null;
	if(report_id != null)
	report = au.getReport(report_id);
	recoms = au.getListOfRecommendations(audId, report_id, recStatus, overdueActions.booleanValue(), recPriority, recSeverity, my, recPrimaryTopicId, recSecondaryTopicId, order, way, pageNumber);
	// end code

      out.write("\n<!-- Now begins HTML page ...-->\n<head>\n<title>List of recommendations - ");
      out.print( todaysDate );
      out.write(" </title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<!-- Main table -->\n<table width=\"100%\" border=\"0\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t<div align=\"center\">\n\t<!-- Header table with title -->\n\t<table border=\"0\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t<tr>\n\t\t<td width=\"20%\" rowspan=\"2\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t<td width=\"80%\" align=\"center\" class=\"title\">List of recommendations</td>\n\t</tr>\n\t<tr>\n\t\t<td align=\"center\">");
      out.print( todaysDate );
      out.write("</td>\n\t</tr>\n\t</table>\n\t<!-- end Header table with title -->\n\t<br/>\n\t");

	if(report != null){
	
      out.write("\n\t<!-- Report table -->\n\t<br/>\n\t\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\"><b>Report</b></td>\n\t\t\t\t<td colspan=\"3\" width=\"75%\" align=\"left\"><b>");
      out.print( HTMLEncode(report.getTitle()) );
      out.write("</b></td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Subtitle</td>\n\t\t\t\t<td colspan=\"3\" align=\"left\">");
      out.print( HTMLEncode(report.getSubTitle()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Executive summary</td>\n\t\t\t\t<td colspan=\"3\" align=\"left\">");
      out.print( HTMLEncode(report.getExecutiveSummary()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Source</td>\n\t\t\t\t<td colspan=\"3\" align=\"left\">");
      out.print( HTMLEncode(report.getSource()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Status</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( HTMLEncode(report.getReportStatus()) );
      out.write("&nbsp;</td>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Due date</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( formatDate(report.getDueDate()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Audit reference</td>\n\t\t\t\t<td width=\"75%\" colspan=\"3\" align=\"left\">");
      out.print( HTMLEncode(report.getReference()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Topic</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( HTMLEncode(report.getReport_topic()) );
      out.write("&nbsp;</td>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Origin</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( HTMLEncode(report.getOrigin()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Responsible</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( HTMLEncode(report.getOwner()) );
      out.write("&nbsp;</td>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Creation date</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( formatDate(report.getCreation_date()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t</table>\n\t<br/>\n\t<!-- end Report table -->\n\t");

	} //end if (report!= null)
	
      out.write('\n');
      out.write('	');

	if (recoms == null || recoms.length == 0) {
	
      out.write("\n\t<!-- No data -->\n\t<br/>\n\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr>\n\t\t<td align=\"center\">No recommendations.</td>\n\t</tr>\n\t</table>\n\t");

	} else {
	      if (recoms.length>1) { // display anchors
	
      out.write("\n\t\t<!-- List titles -->\n\t\t<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td width=\"70%\" align=\"center\" bgcolor=\"gainsboro\">Recommendation</td>\n\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">Priority</td>\n\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">Responsible</td>\n\t\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">Status</td>\n\t\t</tr>\n\t\t");

		      for(int i=0; i<recoms.length; ++i) {
		      lr = recoms[i];
		
      out.write("\n        \t\t<!-- List with internal links -->\n        \t\t<tr>\n        \t\t\t<td align=\"center\"><a href=\"#num");
      out.print( i );
      out.write('"');
      out.write('>');
      out.print( lr.getTitle() );
      out.write("</a></td>\n        \t\t\t<td align=\"center\">");
      out.print( lr.getPriority() );
      out.write("</td>\n        \t\t\t<td align=\"center\">");
      out.print( lr.getAuditor_owner_username() );
      out.write("</td>\n        \t\t\t<td align=\"center\">");
      out.print( lr.getRec_status() );
      out.write("</td>\n        \t\t</tr>\n\t\t");

		} // end for
		
      out.write("\n\t\t<!-- end List table -->\n\t\t</table>\n\t\t<br/>\n\t");

	} // end if recoms.length>1
	
      out.write("\n\t<!-- Detail table -->\n\t<br/>\n\t<table border=\"0\" cellspacing=\"10\" cellpadding=\"4\" width=\"90%\">\n\t");

	// now show content of each vuln
	for(int i=0; i<recoms.length; ++i) {
	       rec = recoms[i];
	
      out.write("\n\t\t<tr>\n\t\t\t<td>\n\t\t\t<!-- One Detail table -->\n\t\t\t<a name=\"num");
      out.print( i );
      out.write("\"></a>\n\t\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\"><b>Recommendation</b></td>\n\t\t\t\t<td width=\"75%\" colspan=\"3\" align=\"center\"><b>");
      out.print( HTMLEncode(rec.getTitle()) );
      out.write("</b></td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Reference</td>\n\t\t\t\t<td width=\"75%\" colspan=\"3\" align=\"center\">");
      out.print( HTMLEncode(rec.getReference()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t");
 if (rec.isCompliantAudit()){ 
      out.write("\n                                <tr>\n                \t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Compliance topic</td>\n                \t\t\t<td width=\"75%\" colspan=\"3\" align=\"center\">");
      out.print( HTMLEncode(rec.getComplianceTopicTitle()) );
      out.write("</td>\n                \t\t</tr>\n                        ");
 } else {
      out.write("\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Primary topic</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( HTMLEncode(rec.getRec_primary_topic()) );
      out.write("&nbsp;</td>\n\t\t\t\t<td width=\"25%\" bgcolor=\"gainsboro\" align=\"center\">Secondary topic</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( HTMLEncode(rec.getRec_secondary_topic()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t");
 }
      out.write("\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Status</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( HTMLEncode(rec.getRec_status()) );
      out.write("&nbsp;</td>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Target date</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( formatDate(rec.getTargetDate()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Creation date</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( formatDate(rec.getCreation_date()) );
      out.write("&nbsp;</td>\n\t\t\t\t<td width=\"25%\" bgcolor=\"gainsboro\" align=\"center\">Close date</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print(formatDate(rec.getClosed_date()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td height=\"30\" colspan=\"4\" align=\"center\"><b>Auditor</b></td>\n\t\t\t</tr>\n\t\t\t<!--\n\t\t\t<tr>\n\t\t\t\t<td height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Responsible auditor</td>\n\t\t\t\t<td colspan=\"3\" align=\"center\">");
//= HTMLEncode(rec.getAuditor_owner_username()) 
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t//-->\n\t\t\t<tr>\n\t\t\t\t<td colspan=\"3\" width=\"75%\" align=\"center\" bgcolor=\"gainsboro\">Auditor stakeholder(s)</td>\n\t\t\t\t<td width=\"25%\" align=\"center\" bgcolor=\"gainsboro\">RACI</td>\n\t\t\t</tr>\n\t\t\t");

			RaciInfoLine[] racis = sr.listRacis(null, rec.getE_raci_obj_auditor(), null, null, null, null);
			for(int j=0; j<racis.length; ++j) {
			
      out.write("\n\t\t\t<tr>\n\t\t\t\t<td colspan=\"3\" width=\"75%\" align=\"center\">");
      out.print( racis[j].getUserName());
      out.write("</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( racis[j].getRaci());
      out.write("</td>\n\t\t\t</tr>\n\t\t\t");

			} // end for
			
      out.write("\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Auditor recommendation</td>\n\t\t\t\t<td width=\"75%\" colspan=\"3\" align=\"center\">");
      out.print( HTMLEncode(rec.getRecommendation()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Auditor priority</td>\n\t\t\t\t<td width=\"25%\">");
      out.print( HTMLEncode(rec.getPriority()) );
      out.write("&nbsp;</td>\n\t\t\t\t<td width=\"25%\" bgcolor=\"gainsboro\" align=\"center\">Auditor severity</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( HTMLEncode(rec.getSeverity()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t        <td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Verification</td>\n\t\t\t        <td width=\"75%\" colspan=\"3\" align=\"center\"><b>\n\t\t\t        ");
 if (rec.isDocumentedVerification()){ 
      out.write("\n\t\t\t          &nbsp;Documented &nbsp;\n\t\t\t        ");
 } if(rec.isInSituVerification()) {
      out.write("\n\t\t\t          &nbsp;In Situ&nbsp;\n\t\t\t        ");
 } 
      out.write("\n\t\t\t        </b></td>\n\t\t        </tr>\n\t\t\t<tr>\n\t\t\t\t<td height=\"30\" colspan=\"4\" align=\"center\"><b>Auditee</b></td>\n\t\t\t</tr>\n\t\t\t<!--\n\t\t\t<tr>\n\t\t\t\t<td height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Responsible auditee</td>\n\t\t\t\t<td colspan=\"3\" align=\"center\">");
//= HTMLEncode(rec.getAuditee_owner_username()) 
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t//-->\n\t\t\t<tr>\n\t\t\t\t<td colspan=\"3\" width=\"75%\" align=\"center\" bgcolor=\"gainsboro\">Auditee stakeholder(s)</td>\n\t\t\t\t<td width=\"25%\" align=\"center\" bgcolor=\"gainsboro\">RACI</td>\n\t\t\t</tr>\n\t\t\t");

			RaciInfoLine[] racis2 = sr.listRacis(null, rec.getE_raci_obj_auditee(), null, null, null, null);
			for(int j=0; j<racis2.length; ++j) {
			
      out.write("\n\t\t\t<tr>\n\t\t\t\t<td width=\"75%\" colspan=\"3\" width=\"75%\" align=\"center\">");
      out.print( racis2[j].getUserName());
      out.write("</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( racis2[j].getRaci());
      out.write("</td>\n\t\t\t</tr>\n\t\t\t");

			} // end for
			
      out.write("\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Auditee answer</td>\n\t\t\t\t<td width=\"75%\" colspan=\"3\" align=\"center\">");
      out.print( HTMLEncode(rec.getAuditeeAnswer()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Auditee priority</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( HTMLEncode(rec.getAuditeePriority()) );
      out.write("&nbsp;</td>\n\t\t\t\t<td width=\"25%\" bgcolor=\"gainsboro\" align=\"center\">Auditee severity</td>\n\t\t\t\t<td width=\"25%\" align=\"center\">");
      out.print( HTMLEncode(rec.getAuditeeSeverity()) );
      out.write("&nbsp;</td>\n\t\t\t</tr>\n\t\t\t</table>\n\t\t\t<!-- end One Detail table -->\n\t\t\t</td>\n\t\t</tr>\n\t\t");

		} // end for
		
      out.write("\n\t\t</table>\n\t");

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
