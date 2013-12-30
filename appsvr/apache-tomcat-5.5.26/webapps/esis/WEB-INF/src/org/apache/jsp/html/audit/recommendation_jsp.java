package org.apache.jsp.html.audit;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapAudit;
import com.entelience.soap.soapRaci;
import com.entelience.objects.audit.AuditRecId;
import com.entelience.objects.audit.Recommendation;
import com.entelience.objects.raci.RaciInfoLine;

public final class recommendation_jsp extends com.entelience.servlet.JspBase
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
	// don't use seesion for emails, use parameter
	//=> getParamInteger(request, "user_id");
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	Boolean my = getParamBoolean(request, "my");
	Integer rid = getParamInteger(request, "recomId");
	if (rid == null)
		throw new Exception("Null parameter for recomId");
	AuditRecId recom_id = new AuditRecId(rid.intValue(), 0);
	
	soapAudit au = new soapAudit(peopleId);
	soapRaci rac = new soapRaci(peopleId);
	
	Recommendation rec = au.getRec(recom_id);
	RaciInfoLine[] racis_auditor = rac.listRacis(null, rec.getE_raci_obj_auditor(), null, null, null, null);
	RaciInfoLine[] racis_auditee = rac.listRacis(null, rec.getE_raci_obj_auditee(), null, null, null, null);
	// end code

      out.write("\n<head>\n<title>Recommendation - ");
      out.print( rec.getTitle() );
      out.write("</title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<table width=\"100%\" border=\"0\" align=\"center\" bgcolor=\"white\" cellpadding=\"0\" cellspacing=\"0\">\n<tr>\n\t<td>\n\t\t<div align=\"center\">\n\t\t<!-- Header -->\n\t\t<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td width=\"20%\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t\t<td width=\"80%\" align=\"center\" class=\"title\">Recommendation</td>\n\t\t</tr>\n\t\t</table>\n\t\t<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td align=\"center\" class=\"subtitle\">");
      out.print( rec.getTitle() );
      out.write(' ');
      out.write('(');
      out.print( rec.getReference() );
      out.write(")</td>\n\t\t</tr>\n\t\t</table>\n\t\t<br/>\n\t\t<!-- Recommendations info -->\n\t\t<br/>\n\t\t<table width=\"90%\" border=\"1\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Title</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( rec.getTitle() );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Reference</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( rec.getReference() );
      out.write("</b></td>\n\t\t</tr>\n                ");
 if (rec.isCompliantAudit()){ 
      out.write("\n                <tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Compliance topic</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( rec.getComplianceTopicTitle() );
      out.write("</b></td>\n\t\t</tr>\n                ");
 } else {
      out.write("\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Primary topic</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( rec.getRec_primary_topic() );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Secondary topic</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( rec.getRec_secondary_topic() );
      out.write("</b></td>\n\t\t</tr>\n\t\t");
 }
      out.write("\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Target date</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( formatDate(rec.getTargetDate()) );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Status</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( rec.getRec_status() );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Closed date</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( formatDate(rec.getClosed_date()) );
      out.write("&nbsp;</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Creation date</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( formatDate(rec.getCreation_date()) );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td colspan=\"2\" align=\"center\" height=\"30\"><b>Auditor part</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Recommendation</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( HTMLEncode(rec.getRecommendation()) );
      out.write("&nbsp;</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Severity</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( rec.getSeverity() );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Priority</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( rec.getPriority() );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Responsible</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( rec.getAuditor_owner_username() );
      out.write("</b></td>\n\t\t</tr>\n                <tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Verification</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>\n\t\t\t");
 if (rec.isDocumentedVerification()){ 
      out.write("\n\t\t\t     &nbsp;Documented &nbsp;\n\t\t\t");
 } if(rec.isInSituVerification()) {
      out.write("\n\t\t\t     &nbsp;In Situ&nbsp;\n\t\t\t");
 } 
      out.write("\n\t\t\t</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td colspan=\"2\" align=\"center\" height=\"30\"><b>Auditee part</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Auditee answer</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( HTMLEncode(rec.getAuditeeAnswer()) );
      out.write("&nbsp;</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Severity</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( rec.getAuditeeSeverity() );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Priority</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( rec.getAuditeePriority() );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\" height=\"30\" bgcolor=\"gainsboro\">Responsible</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( rec.getAuditee_owner_username() );
      out.write("</b></td>\n\t\t</tr>\n\t\t</table>\n\t\t");

		//DEPENDENCY datas
		//is dependent
		if (rec.isDependent()) {
		
      out.write("\n\t\t<br/>\n\t\t<table width=\"90%\" border=\"1\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td align=\"center\" height=\"30\" bgcolor=\"gainsboro\"><b>Blocking recommendations</b></td>\n\t\t</tr>\n\t\t");

		Recommendation[] recBlocking = au.listBlockingRecommendations(recom_id, my);
		for (int l = 0; l < recBlocking.length; ++l) {
		
      out.write("\n\t\t<tr>\n\t\t\t<td align=\"left\">");
      out.print( recBlocking[l].getTitle() );
      out.write(' ');
      out.write('(');
      out.print( recBlocking[l].getReference() );
      out.write(")</td>\n\t\t</tr>\n\t\t");

		}//end for
		
      out.write("\n\t\t</table>\n\t\t");

		} //end is dependent
		//has dependent(s)
		if (rec.isHasDependent()) {
		
      out.write("\n\t\t<br/>\n\t\t<table width=\"90%\" border=\"1\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td align=\"center\" height=\"30\" bgcolor=\"gainsboro\"><b>Dependents recommendations</b></td>\n\t\t</tr>\n\t\t");

		Recommendation[] recDependent = au.listDependentRecommendations(recom_id, my);
		for (int l = 0; l < recDependent.length; ++l) {
		
      out.write("\n\t\t<tr>\n\t\t\t<td align=\"left\">");
      out.print( recDependent[l].getTitle() );
      out.write(' ');
      out.write('(');
      out.print( recDependent[l].getReference() );
      out.write(")</td>\n\t\t</tr>\n\t\t");

		}//end for
		
      out.write("\n\t\t</table>\n\t\t");

		} //end has dependent(s)
		//is duplicate
		if (rec.isDuplicate()) {
		
      out.write("\n\t\t<br/>\n\t\t<table width=\"90%\" border=\"1\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td align=\"center\" height=\"30\" bgcolor=\"gainsboro\"><b>References recommendations</b></td>\n\t\t</tr>\n\t\t");

		Recommendation[] recReference = au.listReferenceRecommendations(recom_id, my);
		for (int l = 0; l < recReference.length; ++l) {
		
      out.write("\n\t\t<tr>\n\t\t\t<td align=\"left\">");
      out.print( recReference[l].getTitle() );
      out.write(' ');
      out.write('(');
      out.print( recReference[l].getReference() );
      out.write(")</td>\n\t\t</tr>\n\t\t");

		}//end for
		
      out.write("\n\t\t</table>\n\t\t");

		} //end is duplcate
		//has duplicate(s)
		if (rec.isHasDuplicate()) {
		
      out.write("\n\t\t<br/>\n\t\t<table width=\"90%\" border=\"1\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td align=\"center\" height=\"30\" bgcolor=\"gainsboro\"><b>Duplicates recommendations</b></td>\n\t\t</tr>\n\t\t");

		Recommendation[] recDuplicate = au.listDuplicateRecommendations(recom_id, my);
		for (int l = 0; l < recDuplicate.length; ++l) {
		
      out.write("\n\t\t<tr>\n\t\t\t<td align=\"left\">");
      out.print( recDuplicate[l].getTitle() );
      out.write(' ');
      out.write('(');
      out.print( recDuplicate[l].getReference() );
      out.write(")</td>\n\t\t</tr>\n\t\t");

		}//end for
		
      out.write("\n\t\t</table>\n\t\t");

		} //end has duplicate(s)
		
      out.write('\n');
      out.write('	');
      out.write('	');

		//RACIS
		//raci auditor
		if(racis_auditor != null && racis_auditor.length > 0){
		
      out.write("\n\t\t<br/>\n\t\t<table width=\"90%\" border=\"1\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td width=\"60%\" align=\"center\" bgcolor=\"gainsboro\">Auditor stakeholder(s)</td>\n\t\t\t<td width=\"40%\" align=\"center\" bgcolor=\"gainsboro\">RACI</td>\n\t\t</tr>\n\t\t");

		for (int j = 0; j < racis_auditor.length; ++j) {
		
      out.write("\n\t\t<tr>\n\t\t\t<td width=\"60%\" align=\"center\">");
      out.print( racis_auditor[j].getUserName() );
      out.write("</td>\n\t\t\t<td width=\"40%\" align=\"center\"><b>");
      out.print( racis_auditor[j].getRaci() );
      out.write("</b></td>\n\t\t</tr>\n\t\t");

		}//end for
		
      out.write("\n\t\t</table>\n\t\t");

		} // end racis auditor
		
      out.write('\n');
      out.write('	');
      out.write('	');

		//raci auditee
		if (racis_auditee != null && racis_auditee.length > 0){
		
      out.write("\n\t\t<br/>\n\t\t<table width=\"90%\" border=\"1\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td width=\"60%\" align=\"center\" bgcolor=\"gainsboro\">Auditee stakeholder(s)</td>\n\t\t\t<td width=\"40%\" align=\"center\" bgcolor=\"gainsboro\">RACI</td>\n\t\t</tr>\n\t\t");

		for (int k = 0; k < racis_auditee.length; ++k) {
		
      out.write("\n\t\t<tr>\n\t\t\t<td width=\"60%\" align=\"center\">");
      out.print( racis_auditee[k].getUserName() );
      out.write("</td>\n\t\t\t<td width=\"40%\" align=\"center\"><b>");
      out.print( racis_auditee[k].getRaci() );
      out.write("</b></td>\n\t\t</tr>\n\t\t");

		}//end for
		
      out.write("\n\t\t</table>\n\t\t");

		} // end racis auditee
		
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
