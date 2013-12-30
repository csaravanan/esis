package org.apache.jsp.html.portal;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class portal_jsp extends com.entelience.servlet.JspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


	/**
	* get parameters for WS call (they all start with p (p0, p1, p2, ...))
     * @return put them all in an array of string 
     */
	private String getParameters(HttpServletRequest request) throws Exception{
		boolean continueLoop = true;
		int i=1;
		StringBuffer params = new StringBuffer("");
		while(continueLoop){
			String param = getParam(request, "p"+i);
			if(param == null){
				//undefined parameter break
				continueLoop = false;
			}else{
				if (i > 1){
					params.append(',');
				}
				params.append(param);
			}
			i++;
		}
		return params.toString();
	}

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

      out.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \n\"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">\n");
      out.write('\n');
      out.write('\n');
      out.write('\n');

try {
	String title = getParam(request, "portalTitle");
	String wsName = getParam(request, "wsName");
	String listLabelName = getParam(request, "listlabelName");
	String listlabelNumber = getParam(request, "listlabelNumber");
	String wsParams = getParameters(request);

      out.write("\n<html>\n<head>\n<title>ESIS - Fundamental metrics</title>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\n<meta name=\"publisher\" content=\"ESIS\">\n<script type=\"text/javascript\" src=\"/esis/js/swfobject.js\"></script>\n<script type=\"text/javascript\" src=\"/esis/js/esisportal.js\"></script>\n<link rel=\"stylesheet\" media=\"screen\" type=\"text/css\" title=\"Menu\" href=\"css/cif.css\" />\n<script type=\"text/javascript\">\n<!--\n//initialization of the Flash Portal\nvar _flashWidth = 700;\nvar _flashHeight = 500;\nvar _descriptionDefaultText = \"\";\nvar _protocol = \"http\";\nvar _host = \"\";\n// end -->\n</script>\n</head>\n<body>\n<h2>");
      out.print(title);
      out.write("</h2>\n<hr />\n<div id=\"portalcomponent\">\n<script type=\"text/javascript\">\nvar so = new SWFObject(\"/esis/PORTAL.swf\", \"esisPortal\", _flashWidth, _flashHeight, \"8\", \"#EEEEEE\");\nso.addParam (\"wmode\", \"transparent\");\nso.addVariable(\"portalWidth\", _flashWidth);\nso.addVariable(\"portalHeight\", _flashHeight);\nso.addVariable(\"wsParams\", \"");
      out.print(wsParams);
      out.write("\");\nso.addVariable(\"wsName\", \"");
      out.print(wsName);
      out.write("\");\nso.addVariable(\"portalTitle\", \"");
      out.print(title);
      out.write("\");\nso.addVariable(\"listLabelName\", \"");
      out.print(listLabelName);
      out.write("\");\nso.addVariable(\"listLabelNumber\", \"");
      out.print(listlabelNumber);
      out.write("\");\nso.addVariable(\"multipleDatasTitles\", \"\");\nso.addVariable(\"portalProtocol\", _protocol);\nso.addVariable(\"portalHost\", _host);\nso.addVariable(\"portalSpotMetric\", \"\");\nso.addVariable(\"portalForceDisplay\", 1);\nso.addVariable(\"portalZoom\", 0);\nso.addVariable(\"portalRefresh\", 0);\nso.addVariable (\"portalLanguage\", \"en\");\nso.write(\"portalcomponent\");\n</script>\n</div>\n<hr />\n<div id=\"equitylogo\">\n<script type=\"text/javascript\">\nvar so = new SWFObject(\"/esis/esisPoweredByLogo.swf\", \"equityLogo\", \"140\", \"51\", \"8\", \"#FFFFFF\");\nso.write(\"equitylogo\");\n</script>\n</div>\n</body>\n</html>\n");

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
