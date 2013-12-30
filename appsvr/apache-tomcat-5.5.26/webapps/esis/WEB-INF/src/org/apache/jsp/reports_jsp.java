package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.List;
import com.entelience.export.DocumentHelper;
import com.entelience.objects.GeneratedDocument;
import com.entelience.sql.Db;
import com.entelience.util.DateHelper;

public final class reports_jsp extends com.entelience.servlet.JspBase
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

      out.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \n\"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">\n<html>\n<!-- the HTML header allows us to view the jsp as an html file in web browsers -->\n");
      out.write("\n\n\n\n\n\n\n\n");

//get parameters
String customer_name = getParam(request, "customer_name");
String customer_css = getParam(request, "customer_css");
String language = getParam(request, "language");

String color1 = "#efefef";
String color2 = "#cccccc";
String colorSelected = color1;
String emptyText = "No available report file.";

//use the db connexion corresponding to the company (customer_name)
Db db = getDb(customer_name);
try{
        db.enter();
        List<GeneratedDocument> docs = DocumentHelper.listGeneratedDocuments(db, null, null, null, null);

      out.write("\n<head>\n<title>Reports list</title>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\n<link rel=\"stylesheet\" media=\"screen\" type=\"text/css\" title=\"Menu\" href=\"/");
      out.print(customer_name);
      out.write("/css/");
      out.print(customer_css);
      out.write("\" />\n</head>\n<body>\n\t<table width=\"580\" cellpadding=\"3\" cellspacing=\"0\" border=\"1\">\n\t<tr>\n\t\t<th align=\"center\">");

		if("fr".equals(language)){
      out.write("\n\t\tRapports disponibles\n\t\t");
}else{
      out.write("\n\t\tAvailable reports\n\t\t");
}
      out.write("</th>\n\t\t<th align=\"center\">");

		if("fr".equals(language)){
      out.write("\n\t\tDate de generation\n\t\t");
}else{
      out.write("\n\t\tGeneration date\n\t\t");
}
      out.write("</th>\n\t\t<th align=\"center\">");

		if("fr".equals(language)){
      out.write("\n\t\tTaille\n\t\t");
}else{
      out.write("\n\t\tSize\n\t\t");
}
      out.write("</th>\n\t\t<th align=\"center\">");

		if("fr".equals(language)){
      out.write("\n\t\tType de contenu\n\t\t");
}else{
      out.write("\n\t\tContent type\n\t\t");
}
      out.write("</th>\n\t</tr>\n\t");

	for(int i=0;i<docs.size();i++){
	   GeneratedDocument doc = docs.get(i);
   	   if(i%2==0){
		colorSelected = color2;
	   }else{
		colorSelected = color1;
	   } 
	 
      out.write("\n\t <tr><td align=\"left\" bgcolor=\"");
      out.print( colorSelected );
      out.write("\">\n\t     <a href=\"html/portal/generateddocument?id=");
      out.print( doc.getDocumentId() );
      out.write("&cie=");
      out.print( customer_name );
      out.write("\">\n\t     ");
      out.print( HTMLEncode(doc.getTitle()) );
      out.write("\n\t     </a>\n\t </td>\n\t <td align=\"left\" bgcolor=\"");
      out.print( colorSelected );
      out.write("\">\n\t     ");
      out.print( DateHelper.HTMLDate(doc.getGenerationDate()) );
      out.write("\n\t </td>\n\t <td align=\"left\" bgcolor=\"");
      out.print( colorSelected );
      out.write("\">\n\t     ");
      out.print( HTMLEncode(doc.getSizeString()) );
      out.write("\n\t </td>\n\t <td align=\"left\" bgcolor=\"");
      out.print( colorSelected );
      out.write("\">\n\t     ");
      out.print( HTMLEncode(doc.getContentType()) );
      out.write("\n\t </td>\n\t </tr>\n");

        }

      out.write("\t\t\n\t\n\t</table>\n</body>\n");


} finally {
	db.exit();
}


      out.write("\n</html>\n");
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
