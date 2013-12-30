package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class module_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static java.util.List _jspx_dependants;

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


response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server

      out.write('\n');
      out.write('\n');

String width="1024";  // default width
String height="768"; // default height
String swfName="ESIS";
boolean isMSIE=false;
String userAgent;

// browser detection 100% if IE only ... else ... 1024x768
userAgent = request.getHeader("User-Agent");
userAgent = userAgent.toLowerCase(); //NOPMD
/*
if(userAgent != null ){
	if((userAgent.indexOf("msie") != -1)){
		width="100%";
		height="100%";
		isMSIE=true;
	}
}
*/
// check with request to find out if the user wants to try something different
//String tmp = request.getParameter("module");
//if (null != tmp && !"".equals(tmp)) { swfName = tmp; }
// page begins

      out.write("\n<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">\n<head>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />\n<script type=\"text/javascript\" src=\"detection.js\"></script>\n<script type=\"text/javascript\" src=\"js/swfobject.js\"></script>\n<title>ESIS :: Executive Security Information System</title>\n<style>\nbody {\n\tfont-family:Verdana, Arial, Helvetica, sans-serif;\n\tfont-size:10px;\n\tfont-weight:normal;\n\tmargin:0;\n\tpadding:0;\n\tbackground-color:#B7C0C8;\n}\n</style>\n</head>\n<body>\n");

if (!isMSIE) {

      out.write("\n<table width=\"");
      out.print(width);
      out.write("\" height=\"");
      out.print(height);
      out.write("\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" align=\"center\">\n<tr>\n<td>\n");

}

      out.write("\n<!--\nuser agent = ");
      out.print(userAgent);
      out.write("\n//-->\n<div id=\"flashcontent\" align=\"center\">&nbsp;</div>\n<script type=\"text/javascript\">\n<!--\nvar so = new SWFObject (\"");
      out.print( swfName );
      out.write(".swf\", \"");
      out.print( swfName );
      out.write("Swf\", ");
      out.print( width );
      out.write(',');
      out.write(' ');
      out.print( height );
      out.write(", \"8.0.22\", \"#B7C0C8\");\nso.addParam(\"menu\", true);\nso.addParam(\"quality\", \"high\");\n//so.addParam(\"wmode\", \"transparent\");\n//so.addParam(\"salign\", \"t\");\nso.addVariable (\"applicationLanguage\", applicationLanguage);\nso.write(\"flashcontent\");\n//-->\n</script>\n");

if (!isMSIE) {

      out.write("\n</td>\n</tr>\n</table>\n");

}

      out.write("\n</body>\n</html>");
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
