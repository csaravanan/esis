package org.apache.jsp.html.audit;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapAudit;
import com.entelience.objects.audit.Audit;
import com.entelience.objects.audit.Interview;
import com.entelience.util.DateHelper;
import com.entelience.objects.audit.AuditId;

public final class list_005finterviews_jsp extends com.entelience.servlet.JspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


//Class declarations
public String getCompleted(Interview i){
	if (i.isCompleted()) {
		return "Yes";
	} else {
		return "No";
	}
}

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
      out.write('\n');
 // code
try{
	Interview interviews[] = null;
	Interview in;
	Audit audit = null;
	String todaysDate;
	
	// Check session id validity
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	// Now we can use webservices
	soapAudit au = new soapAudit(peopleId);
	todaysDate = formatDate(DateHelper.now());

	Integer audId = getParamInteger(request, "auditId");
	AuditId audit_id = null;
	if (audId != null) {
		audit_id = new AuditId(audId.intValue(), 0);
	}
	Boolean my = getParamBoolean(request, "my");

	if (null != audit_id) {
		audit = au.getAudit(audit_id);
		interviews = au.getAuditInterviews(audit_id, my);
	}
	
// end code

      out.write("\n<!-- Now begins HTML page ...-->\n<head>\n<title>List of Interviews - ");
      out.print( todaysDate );
      out.write("</title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<!-- Main table -->\n<table width=\"100%\" border=\"0\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t<div align=\"center\">\n\t<!-- Header table with title -->\n\t<table border=\"0\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t<tr>\n\t\t<td width=\"20%\" rowspan=\"2\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t<td width=\"80%\" align=\"center\" class=\"title\">List of interviews</td>\n\t</tr>\n\t<tr>\n\t\t<td align=\"center\">");
      out.print( todaysDate );
      out.write("</td>\n\t</tr>\n\t</table>\n\t<!-- end Header table with title -->\n\t<br/>\n\t");

	if (audit != null) {
	
      out.write("\n\t<!-- Audit table -->\n\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr>\n\t\t<td colspan=\"8\" align=\"center\"><b>Audit</b></td>\n\t</tr>\n\t<tr>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Reference</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Topic</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Origin</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Status</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Confidentiality</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Responsible</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">Start date</td>\n\t\t<td align=\"center\" bgcolor=\"gainsboro\">End date</td>\n\t</tr>\n\t<tr>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(audit.getReference()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(audit.getTopic()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(audit.getOrigin()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(audit.getStatus()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(audit.getConfidentiality()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(HTMLEncode(audit.getOwner()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(formatDate(audit.getStartDate()));
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print(formatDate(audit.getEndDate()));
      out.write("</td>\n\t</tr>\n\t</table>\n\t<br/>\n\t<!-- end Audit table -->\n\t");

	} // end if audit
	
      out.write("\n\t<!-- List table with internal links -->\n\t<br/>\n\t");

	if (interviews == null || interviews.length == 0) {
	
      out.write("\n\t<!-- No data -->\n\t<br/>\n\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr>\n\t\t<td align=\"center\">No interviews.</td>\n\t</tr>\n\t</table>\n\t");

	} else {
		if (interviews.length > 1) {
	
      out.write("\n\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr>\n\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">Interview date</td>\n\t\t<td width=\"20%\" align=\"center\" bgcolor=\"gainsboro\">Auditor</td>\n\t\t<td width=\"20%\" align=\"center\" bgcolor=\"gainsboro\">Auditee</td>\n\t\t<td width=\"40%\" align=\"center\" bgcolor=\"gainsboro\">Description</td>\n\t\t<td width=\"10%\" align=\"center\" bgcolor=\"gainsboro\">Completed</td>\n\t</tr>\n\t");

	for(int i=0; i < interviews.length; ++i) {
	in = interviews[i];
	
      out.write("\n\t<tr>\n\t\t<td align=\"center\">");
      out.print( formatDate(in.getItwDate()) );
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print( in.getAuditorName() );
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print( in.getAuditeeName() );
      out.write("</td>\n\t\t<td align=\"left\">");
      out.print( in.getDescription() );
      out.write("</td>\n\t\t<td align=\"center\">");
      out.print( getCompleted(in) );
      out.write("</td>\n\t</tr>\n\t");

	} // end for
	
      out.write("\n\t</table>\n\t<!-- end List table -->\n\t");

	} // end if interviews.length
	} //end if interviews
	
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
