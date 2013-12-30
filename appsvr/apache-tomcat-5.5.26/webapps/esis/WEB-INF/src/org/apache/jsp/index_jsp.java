package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class index_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("\n<html>\n<head>\n<meta http-equiv=\"refresh\" content=\"3;url=/esis/html/downloads/download_only_player.html\" />\n<title>ESIS :: Executive Security Information System</title>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\n<script src=\"detection.js\" type=\"text/javascript\"></script>\n<script type=\"text/javascript\" src=\"js/swfobject.js\"></script>\n<style type=\"text/css\">\n<!--\t\nhtml, body{ \n\tfont-family:Verdana, Arial, Helvetica, sans-serif;\n\tfont-size:10px;\n\tfont-weight:normal;\n\tmargin:0;\n\tpadding:0;\n\tbackground-color:#B7C0C8;\n}\n-->\t\n</style>\n</head>\n<body>\n<div id=\"flashcontent\">&nbsp;</div>\n<script type=\"text/javascript\">\n<!--\nif (useFlashDetection) {\n\t//use swfobject script\n\tvar so = new SWFObject(\"flash_detection.swf\", \"flashDetectionSwf\", \"80\", \"80\", \"7\", \"#B7C0C8\");\n\tso.write(\"flashcontent\");\n} else {\n\twindow.location = \"module.jsp\";\n}\n//-->\n</script>\n</body>\n</html>");
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
