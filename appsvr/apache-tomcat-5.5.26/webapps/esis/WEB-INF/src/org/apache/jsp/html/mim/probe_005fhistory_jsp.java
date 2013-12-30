package org.apache.jsp.html.mim;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapIdentityManagement;
import com.entelience.objects.FileImportHistory;
import java.util.Map;
import java.util.HashMap;

public final class probe_005fhistory_jsp extends com.entelience.servlet.JspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


	// Class declarations
	Map<String,String> labels;
	String language;
	
	public void initLabels() {
	   labels = new HashMap<String,String>();
	   labels.put("FILE_IMPORT_HISTORY_en", "File Import History");
	   labels.put("EXECUTION_DATE_en", "Execution date");
	   labels.put("FILE_NAME_en", "File name");
	   labels.put("FILE_SIZE_en", "File size");
	   labels.put("RESULT_en", "Status");
	   labels.put("SEE_ANOMALIES_en", "See anomalies from the last import");
	   labels.put("FILE_IMPORT_HISTORY_fr", "Historique d'import de fichiers");
	   labels.put("EXECUTION_DATE_fr", "Date d'ex&eacute;cution");
	   labels.put("FILE_NAME_fr", "Nom du fichier");
	   labels.put("FILE_SIZE_fr", "Taille du fichier");
	   labels.put("RESULT_fr", "Status");
	   labels.put("SEE_ANOMALIES_fr", "Voir les anomalies survenues lors du dernier import");
	}
	
	public String getLabel(String key) {
	   String langKey=key+"_"+language;
	   String res = labels.get(langKey);
	   if(res==null)
	       res=labels.get(key+"_en");
	   if(res==null)
	       res=key;
	   return res;
	   
	}
	// end class declarations

  private static java.util.List _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList(3);
    _jspx_dependants.add("/html/mim/../style.inc.jsp");
    _jspx_dependants.add("/html/mim/../icon.inc.jsp");
    _jspx_dependants.add("/html/mim/../copyright.inc.jsp");
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
      out.write("\n\n\n\n\n\n");
      out.write('\n');

try{
	// code
	// Check session id validity
       Integer peopleId = getSession(request);
	String sid = request.getHeader("Session-Id"); //used later
	
	// Now we can use webservices
	language = getParam(request, "lang");
	if(language == null || language.length()==0)
		language = "fr";
	soapIdentityManagement im = new soapIdentityManagement(peopleId);
	
	FileImportHistory[] fih = im.getFileImportStatus();
	initLabels();
	// end code

      out.write("\n<head>\n\t<title>");
      out.print( getLabel("FILE_IMPORT_HISTORY") );
      out.write("</title>\n\t");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<table width=\"100%\" border=\"0\"  align=\"center\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t\t<div align=\"center\">\n\t\t<table border=\"0\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t\t<tr>\n\t\t\t<td width=\"20%\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t\t<td width=\"80%\" align=\"center\" class=\"title\">");
      out.print( getLabel("FILE_IMPORT_HISTORY") );
      out.write("</td>\n\t\t</tr>\n\t\t</table>\n\t\t<br/>\n\t\t&nbsp;<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td width=\"25%\" align=\"center\"><b>");
      out.print( getLabel("EXECUTION_DATE") );
      out.write("</b></td>\n\t\t\t<td width=\"25%\" align=\"center\"><b>");
      out.print( getLabel("FILE_NAME") );
      out.write("</b></td>\n\t\t\t<td width=\"25%\" align=\"center\"><b>");
      out.print( getLabel("FILE_SIZE") );
      out.write("</b></td>\n\t\t\t<td width=\"25%\" align=\"center\"><b>");
      out.print( getLabel("RESULT") );
      out.write("</b></td>\n\t\t</tr>\n\t\t");

		for(int i=0; i<fih.length; i++){
		
      out.write("\n\t\t<tr>\n\t\t\t<td align=\"center\">");
      out.print( fih[i].getRun_date() );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( fih[i].getFile_name() );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( fih[i].getFile_size() );
      out.write("</td>\n\t\t\t<td align=\"center\">");
      out.print( fih[i].getStatus() );
      out.write("</td>\n\t\t</tr>\n\t\t");

		}// end for
		
      out.write("\n\t\t</table>\n\t\t<br/>\n\t\t&nbsp;<br/>\n\t\t<form action=\"anomalies_users.jsp\" method=\"POST\">\n\t\t\t<input type=\"hidden\" name=\"Session-Id\" value=\"");
      out.print(sid);
      out.write("\">\n\t\t\t<input type=\"hidden\" name=\"anomaly\" value=\"all\">\n\t\t\t<input type=\"submit\" value=\"");
      out.print( getLabel("SEE_ANOMALIES") );
      out.write("\">\n\t\t</form>\n\n\t\t</div>\n\t</td>\n</tr>\n<tr>\n\t<td>\n\t");
      out.write("\n&nbsp;<br/>\n<table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"0\">\n<tr>\n\t<td align=\"center\" class=\"copy\">\n\t<br/>\n\t<br/>Copyright (c) 2004-2008 Entelience SARL, Copyright (c) 2008-2009 Equity SA, Copyright (c) 2009-2010 Consulare sÃ rl, Licensed under the <a href=\"http://www.gnu.org/copyleft/gpl.html\">GNU GPL, Version 3</a>.\n\t<br/>\n\t</td>\n</tr>\n</table>");
      out.write("\n\t</td>\n</tr>\n</table>\n</body>\n</html>\n");

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
