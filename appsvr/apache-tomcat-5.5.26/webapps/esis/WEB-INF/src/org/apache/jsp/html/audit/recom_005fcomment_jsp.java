package org.apache.jsp.html.audit;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapAudit;
import com.entelience.objects.audit.AuditRecCommentId;
import com.entelience.objects.audit.AuditRecId;
import com.entelience.objects.audit.Comment;
import com.entelience.objects.audit.Recommendation;

public final class recom_005fcomment_jsp extends com.entelience.servlet.JspBase
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
	// don't use session for emails, use parameter
	//=> getParamInteger(request, "user_id");
	Integer peopleId = getSession(request);
	initTimeZone(peopleId);
	Integer rid = getParamInteger(request, "recomId");
	if (rid == null)
		throw new Exception("Null parameter for recomId");
	AuditRecId recom_id = new AuditRecId(rid.intValue(), 0);
	
	Integer cid = getParamInteger(request, "commentId");
	if (cid == null)
		throw new Exception("Null parameter for commentId");
	AuditRecCommentId comment_id = new AuditRecCommentId(cid.intValue(), 0);
	
	soapAudit au = new soapAudit(peopleId);
	
	Comment[] comments = au.getListOfComments(null, recom_id, null);
	if (comments == null || comments.length <= 0)
		throw new Exception("Specified recommendation have no comments");
	
	Comment com = null;
	for (int i = 0; i < comments.length; ++i) {
		if (comments[i].getId().getId() == comment_id.getId()) {
			com = comments[i];
		}
	}
	if (com == null)
		throw new Exception("commentId not found in the comments list of the specified recommendation");
	Recommendation rec = au.getRec(com.getForeign_id());
	// end code

      out.write("\n<head>\n<title>Comment for ");
      out.print( rec.getTitle() );
      out.write("</title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<table width=\"100%\" border=\"0\" align=\"center\" bgcolor=\"white\" cellpadding=\"0\" cellspacing=\"0\">\n<tr>\n\t<td>\n\t\t<div align=\"center\">\n\t\t<!-- Header -->\n\t\t<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td width=\"20%\" rowspan=\"2\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t\t<td width=\"80%\" align=\"center\" class=\"title\">Comment</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"center\" class=\"subtitle\">Recommendation: ");
      out.print( rec.getTitle() );
      out.write(' ');
      out.write('(');
      out.print( rec.getReference() );
      out.write(")</td>\n\t\t</tr>\n\t\t</table>\n\t\t<br/>\n\t\t<!-- Comment info -->\n\t\t<br/>\n\t\t<table width=\"90%\" border=\"1\" align=\"center\" cellpadding=\"4\" cellspacing=\"0\">\n\t\t<tr>\n\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Author</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( com.getAuthor_username() );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Date</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( formatDate(com.getCreation_date()) );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td width=\"25%\" height=\"30\" bgcolor=\"gainsboro\" align=\"center\">Comment</td>\n\t\t\t<td width=\"75%\" align=\"center\"><b>");
      out.print( HTMLEncode(com.getComment()) );
      out.write("</b></td>\n\t\t</tr>\n\t\t</table>\n\t\t");
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
