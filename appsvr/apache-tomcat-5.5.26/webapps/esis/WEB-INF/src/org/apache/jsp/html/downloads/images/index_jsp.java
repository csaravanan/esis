package org.apache.jsp.html.downloads.images;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.util.DateHelper;

public final class index_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static java.util.List _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList(2);
    _jspx_dependants.add("/html/downloads/images/../../page_header.inc.jsp");
    _jspx_dependants.add("/html/downloads/images/../../page_footer.inc.jsp");
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

      out.write("<!--\n  -- ESIS\n  --\n  -- Copyright (c) 2004-2008 Entelience SARL,  Copyright (c) 2008-2009 Equity SA\n  --\n  -- Projects contributors : Philippe Le Berre, Thomas Burdairon, Benjamin Baudel,\n  --                         Benjamin S. Gould, Diego Patinos Ramos, Constantin Cornelie\n  -- \n  -- This file is part of ESIS.\n  --\n  -- ESIS is free software: you can redistribute it and/or modify\n  -- it under the terms of the GNU General Public License as published by\n  -- the Free Software Foundation version 3 of the License.\n  --\n  -- ESIS is distributed in the hope that it will be useful,\n  -- but WITHOUT ANY WARRANTY; without even the implied warranty of\n  -- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n  -- GNU General Public License for more details.\n  --\n  -- You should have received a copy of the GNU General Public License\n  -- along with ESIS.  If not, see <http://www.gnu.org/licenses/>.\n  --\n  -- $Id$\n  --\n  -->\n\n");
      out.write("\n<html>\n<head><title>ESIS :: Executive Security Information System</title></head>\n<body>");
      out.write("\n\t<h1>ESIS ");
      out.print( DateHelper.HTMLDateOrNull(DateHelper.now()) );
      out.write("</h1>\n");
      out.write("\n</body>\n</html>");
      out.write('\n');
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
