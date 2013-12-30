package org.apache.jsp.html.mim;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapIdentityManagement;
import com.entelience.objects.mim.UserDetail;
import java.util.Map;
import java.util.HashMap;

public final class print_005fuser_005fdetails_jsp extends com.entelience.servlet.JspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


	// Class declarations
	public void initLabels(){
	   labels = new HashMap<String,String>();
	   labels.put("USER_TITLE_en", "User detail ");
	   labels.put("USER_ID_en", "User Id");
	   labels.put("ERROR_PARAMS_en", "Parameters error for JSP");
	   labels.put("DATE_HIRE_en", "Hire date");
	   labels.put("DATE_END_CONTRACT_en", "End contract date");
	   labels.put("AD_en", "AD System");
	   labels.put("TSS_en", "TSS System");
	   labels.put("WHENCREATED_en", "creation date");
	   labels.put("WHENCHANGED_en", "account change date");
	   labels.put("LOGONCOUNT_en", "logon count");
	   labels.put("LASTLOGON_en", "last logon date");
	   labels.put("PWDLASTSET_en", "password last set");
	   labels.put("PWDEXPIRES_en", "password expire date");
	   
	   labels.put("USER_TITLE_fr", "D&eacute;tails de l'utilisateur ");
	   labels.put("USER_ID_fr", "Identifiant utilisateur");
	   labels.put("ERROR_PARAMS_fr", "Erreur dans les param&egrave;tres d'appel de la JSP");
	   labels.put("DATE_HIRE_fr", "Date d'embauche");
	   labels.put("DATE_END_CONTRACT_fr", "Date de fin de contrat");
	   labels.put("AD_fr", "Syst&egrave;me AD");
	   labels.put("TSS_fr", "Syst&egrave;me TSS");
	   labels.put("WHENCREATED_fr", "Cr&eacute;ation du compte");
	   labels.put("WHENCHANGED_fr", "Dernier changement du compte");
	   labels.put("LOGONCOUNT_fr", "Nombre d'identifications");
	   labels.put("LASTLOGON_fr", "Derni&egrave;re identification");
	   labels.put("PWDLASTSET_fr", "Dernier changement de mot de passe");
	   labels.put("PWDEXPIRES_fr", "Expiration du mot de passe");
	}
	
	Map<String,String> labels;
	String language;
	
	public String getLabel(String key){
	   String langKey=key+"_"+language;
	   String res = labels.get(langKey);
	   if(res==null)
	       res=labels.get(key+"_en");
	   if(res==null)
	       res=key;
	   return res;

	}
	
	public String format(Object o){
	   if(o == null) return "&nbsp;";
	   return o.toString();
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
	
	// Now we can use webservices
	// Read parameters.
	language = getParam(request, "lang");
	if(language == null || language.length()==0)
		language = "fr";
	initLabels();
	
	String user_id = getParam(request, "user_id");
	if(user_id == null || user_id.length() == 0){
		
      out.print( getLabel("ERROR_PARAMS"));

		return;
	}
	
	soapIdentityManagement im = new soapIdentityManagement(peopleId);
	
	UserDetail details = im.getUserDetail(user_id);
	// end code

      out.write("\n<head>\n\t<title>");
      out.print( getLabel("USER_TITLE")+" "+user_id );
      out.write("</title>\n\t");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<table width=\"100%\" border=\"0\"  align=\"center\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t\t<div align=\"center\">\n\t\t<table border=\"0\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t\t<tr>\n\t\t\t<td width=\"20%\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t\t<td width=\"80%\" align=\"center\" class=\"title\">");
      out.print( getLabel("USER_TITLE")+" "+user_id );
      out.write("</td>\n\t\t</tr>\n\t\t</table>\n\t\t<br/>\n\t\t&nbsp;<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n        <tr>\n            <td colspan=\"2\" align=\"center\"><b>");
      out.print( user_id );
      out.write("</b></td>\n        </tr>\n\t\t<tr>\n            <td align=\"center\" width=\"50%\">");
      out.print( getLabel("DATE_HIRE"));
      out.write("</td>\n            <td align=\"center\" width=\"50%\">");
      out.print( format(details.getDate_hire()));
      out.write("</td>\n        </tr>\n        <tr>\n            <td align=\"center\">");
      out.print( getLabel("DATE_END_CONTRACT"));
      out.write("</td>\n            <td align=\"center\">");
      out.print( format(details.getDate_end_contract()));
      out.write("</td>\n        </tr>\n\t\t</table>\n\t\t<br/>\n\t\t&nbsp;<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t<tr>\n            <td colspan=\"2\" align=\"center\"><b>");
      out.print( getLabel("AD"));
      out.write("</b></td>\n            <td colspan=\"2\" align=\"center\"><b>");
      out.print( getLabel("TSS"));
      out.write("</b></td>\n        </tr>\n        <tr>\n            <td align=\"center\" width=\"25%\">");
      out.print( getLabel("WHENCREATED"));
      out.write("</td>\n            <td align=\"center\" width=\"25%\">");
      out.print( format(details.getAd_whencreated()));
      out.write("</td>\n            <td align=\"center\" width=\"25%\">");
      out.print( getLabel("WHENCREATED"));
      out.write("</td>\n            <td align=\"center\" width=\"25%\">");
      out.print( format(details.getTss_whencreated()));
      out.write("</td>\n        </tr>\n        <tr>\n            <td align=\"center\">");
      out.print( getLabel("WHENCHANGED"));
      out.write("</td>\n            <td align=\"center\">");
      out.print( format(details.getAd_whenchanged()));
      out.write("</td>\n            <td align=\"center\">");
      out.print( getLabel("WHENCHANGED"));
      out.write("</td>\n            <td align=\"center\">");
      out.print( format(details.getTss_whenchanged()));
      out.write("</td>\n        </tr>\n        <tr>\n            <td align=\"center\">");
      out.print( getLabel("LOGONCOUNT"));
      out.write("</td>\n            <td align=\"center\">");
      out.print( details.getAd_logoncount());
      out.write("</td>\n            <td align=\"center\">");
      out.print( getLabel("LOGONCOUNT"));
      out.write("</td>\n            <td align=\"center\">");
      out.print( details.getTss_logoncount());
      out.write("</td>\n        </tr>\n        <tr>\n            <td align=\"center\">");
      out.print( getLabel("LASTLOGON"));
      out.write("</td>\n            <td align=\"center\">");
      out.print( format(details.getAd_lastlogon()));
      out.write("</td>\n            <td align=\"center\">");
      out.print( getLabel("LASTLOGON"));
      out.write("</td>\n            <td align=\"center\">");
      out.print( format(details.getTss_lastlogon()));
      out.write("</td>\n        </tr>\n        <tr>\n            <td align=\"center\">");
      out.print( getLabel("PWDLASTSET"));
      out.write("</td>\n            <td align=\"center\">");
      out.print( format(details.getAd_pwdlastset()));
      out.write("</td>\n            <td align=\"center\">");
      out.print( getLabel("PWDLASTSET"));
      out.write("</td>\n            <td align=\"center\">");
      out.print( format(details.getTss_pwdlastset()));
      out.write("</td>\n        </tr>\n        <tr>\n            <td align=\"center\">&nbsp;</td>\n            <td align=\"center\">&nbsp;</td>\n            <td align=\"center\">");
      out.print( getLabel("PWDEXPIRES"));
      out.write("</td>\n            <td align=\"center\">");
      out.print( format(details.getTss_pwdexpires()));
      out.write("</td>\n        </tr>\n\t\t</table>\n\t\t</div>\n\t</td>\n</tr>\n<tr>\n\t<td>\n\t");
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
