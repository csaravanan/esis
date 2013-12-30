package org.apache.jsp.html.mim;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapIdentityManagement;
import com.entelience.objects.mim.UserMetrics;
import java.util.Map;
import java.util.HashMap;

public final class print_005fusers_005ffor_005fasl_jsp extends com.entelience.servlet.JspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


	// Class declarations
	public void initLabels(){
	   labels = new HashMap<String,String>();
	   labels.put("USERS_TITLE_en", "Users for administrator ");
	   labels.put("USER_ID_en", "User Id");
	   labels.put("ERROR_PARAMS_en", "Parameters error for JSP");
	   labels.put("DDS_en", "Out delay");
	   labels.put("DDE_en", "In delay");
	   labels.put("DDC_en", "Connection delay");
	   labels.put("DPC_en", "Administration delay");
	   labels.put("TARGETS_en", "Targets");
	   
	   labels.put("USERS_TITLE_fr", "Utilisateurs de l'administrateur ");
	   labels.put("USER_ID_fr", "Identifiant Utilisateur");
	   labels.put("ERROR_PARAMS_fr", "Erreur dans les param&egrave;tres d'appel de la JSP");
	   labels.put("DDS_fr", "D&eacute;lai de sortie");
	   labels.put("DDE_fr", "D&eacute;lai d'entr&eacute;e");
	   labels.put("DDC_fr", "D&eacute;lai de connexion");
	   labels.put("DPC_fr", "D&eacute;lai de prise en charge");
	   labels.put("ASL_ID_fr", "Identifiant");
	   labels.put("TARGETS_fr", "Objectifs");
	}
	
	public String formatMetricName(String metric){
	   if("dds".equals(metric))
	       return getLabel("DDS");
	   else if ("dde".equals(metric))
	       return getLabel("DDE");
	   else if ("ddc".equals(metric))
	       return getLabel("DDC");
	   else if ("dpc".equals(metric))
	       return getLabel("DPC");
	   else return metric;
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
        
        String asl_id = getParam(request, "asl_id");
        String filter = getParam(request, "filter");
        int scale = getParamInt(request, "scale");
        String geo = getParam(request, "geo");
        String org = getParam(request, "org");
        
        String unit = "";
        if (geo != null && geo.length() > 0)
        {
            unit = "("+geo+")";
        }
        if (org != null && org.length() > 0)
        {
            unit = "("+org+")";
        }
        soapIdentityManagement im = new soapIdentityManagement(peopleId);

        
        UserMetrics[] users = im.getUsersForAslForPrint(asl_id, filter, scale, org, geo);
        
        double target_dds = im.getTargetLevel("dds");
        double target_dde = im.getTargetLevel("dde");
        double target_ddc = im.getTargetLevel("ddc");
        double target_dpc = im.getTargetLevel("dpc");      
	// end code

      out.write("\n<head>\n\t<title>");
      out.print( getLabel("USERS_TITLE")+" "+asl_id +" "+unit);
      out.write("</title>\n\t");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<table width=\"100%\" border=\"0\"  align=\"center\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t\t<div align=\"center\">\n\t\t<table border=\"0\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t\t<tr>\n\t\t\t<td width=\"20%\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t\t<td width=\"80%\" align=\"center\" class=\"title\">");
      out.print( getLabel("USERS_TITLE")+" "+asl_id );
      out.write("</td>\n\t\t</tr>\n\t\t</table>\n\t\t<br/>\n\t\t&nbsp;<br/>\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t<tr>\n        \t<td width=\"28%\"><b>");
      out.print( getLabel("USER_ID") );
      out.write("</b></td>\n        \t<td width=\"18%\"><b>");
      out.print( formatMetricName("dpc") );
      out.write("</b></td>\n\t\t\t<td width=\"18%\"><b>");
      out.print( formatMetricName("ddc") );
      out.write("</b></td>\n\t\t\t<td width=\"18%\"><b>");
      out.print( formatMetricName("dde") );
      out.write("</b></td>\n\t\t\t<td width=\"18%\"><b>");
      out.print( formatMetricName("dds") );
      out.write("</b></td>\n\t\t</tr>\n\t\t<tr>\n        \t<td align=\"center\"><i>");
      out.print( getLabel("TARGETS") );
      out.write("</i></td>\n        \t<td align=\"center\"><i>");
      out.print( target_dpc );
      out.write("</i></td>\n        \t<td align=\"center\"><i>");
      out.print( target_ddc );
      out.write("</i></td>\n        \t<td align=\"center\"><i>");
      out.print( target_dde );
      out.write("</i></td>\n        \t<td align=\"center\"><i>");
      out.print( target_dds );
      out.write("</i></td>\n    \t</tr>\n\t\t");

		for(int i=0; i<users.length; i++){
		
      out.write("\n\t\t<tr>\n        \t<td align=\"center\">");
      out.print( users[i].getUser_id() );
      out.write("</td>\n        \t<td align=\"center\">");

			if(users[i].getDpc()==null || "_".equals(users[i].getDpc())){
			
      out.write("&nbsp;");

			} else {
			
      out.print( users[i].getDpc() );

			}
			
      out.write("</td>\n\t\t\t<td align=\"center\">");

			if(users[i].getDdc()==null || "_".equals(users[i].getDdc())){
			
      out.write("&nbsp;");

			} else {
			
      out.print( users[i].getDdc() );

			}
			
      out.write("</td>\n\t\t\t<td align=\"center\">");

			if(users[i].getDde()==null || "_".equals(users[i].getDde())){
			
      out.write("&nbsp;");

			} else {
			
      out.print( users[i].getDde() );

			}
			
      out.write("</td>\n\t\t\t<td align=\"center\">");

			if(users[i].getDds()==null || "_".equals(users[i].getDds())){
			
      out.write("&nbsp;");

			} else {
			
      out.print( users[i].getDds() );

			}
			
      out.write("</td>\n\t\t</tr>\n\t\t");

		}
		
      out.write("\n\t\t</table>\n\t\t</div>\n\t</td>\n</tr>\n<tr>\n\t<td>\n\t");
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
