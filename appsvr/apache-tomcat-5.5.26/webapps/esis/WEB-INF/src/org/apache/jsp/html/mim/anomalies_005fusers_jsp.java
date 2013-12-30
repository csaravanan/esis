package org.apache.jsp.html.mim;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapIdentityManagement;
import com.entelience.objects.FileImportHistory;
import com.entelience.objects.mim.AnomalyStats;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public final class anomalies_005fusers_jsp extends com.entelience.servlet.JspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


	// Class declarations
	
	protected int calcNbColumns(Object[] res) {
        return (res.length>8?8:res.length);
	}
	
	protected int calcNbLines(Object[] res, int nbColumns) {
        if(nbColumns == 0) return 0;
        int result = (int)(res.length/nbColumns)+1;
        while((result-1)*nbColumns >= res.length)
            result--;
        return result;
	}
	
    Map<String,String> labels;
	String language;
	
	public void initLabels() {
	   labels = new HashMap<String,String>();
	   labels.put("USERS_NON_IMPORTED_en", "Failed import users");
	   labels.put("ANOMALY_TYPE_en", "Anomaly type");
	   labels.put("NUMBER_OF_USERS_en", "Number of Users");
	   labels.put("NO_USER_en", "No User have this anomaly");
	   labels.put("ONE_USER_en", "1 User has this anomaly");
	   labels.put("MANY_USERS_en", "Users have this anomaly");
	   labels.put("ID_en", "ID");
	   labels.put("SEE_ALL_en", "See all anomalies");
           labels.put("FILE_IMPORT_HISTORY_en", "File import history");
	   labels.put("USERS_NON_IMPORTED_fr", "Utilisateurs non import&eacute;s");
	   labels.put("ANOMALY_TYPE_fr", "Type d'anomalie");
	   labels.put("NUMBER_OF_USERS_fr", "Nombre d'utilisateurs");
	   labels.put("NO_USER_fr", "Aucun utilisateur n'a cette anomalie");
	   labels.put("ONE_USER_fr", "1 Utilisateur a cette anomalie");
	   labels.put("MANY_USERS_fr", "Utilisateurs ont cette anomalie");
	   labels.put("ID_fr", "Identifiant");
	   labels.put("SEE_ALL_fr", "Voir toutes les anomalies");
           labels.put("FILE_IMPORT_HISTORY_fr", "Historique des imports");
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
      out.write("\n\n\n\n\n\n\n\n\n");
      out.write('\n');

try{
	// code
	// Check session id validity
	//need it to pass it as parameter to link in the page
	//do it by hand, because thi page is special
	Integer peopleId = getSession(request);
	String sid = request.getHeader("Session-Id"); //used later

    int nbColumns;
	
	AnomalyStats[] resultAL =null;
	String[] resultS =null;
	List<Integer> ano_ids =null;
	// Now we can use webservices
	// Read parameters.
	String language = getParam(request, "lang");
	if(language == null || language.length()==0)
		language = "fr";
	String anomalyStr = getParam(request, "anomaly");
	_logger.debug(anomalyStr);
	int anomaly =-1;
	if(!"all".equals(anomalyStr)){
		anomaly = getParamInt(request, "anomaly");
	}
	soapIdentityManagement im = new soapIdentityManagement(peopleId);
	
	if("all".equals(anomalyStr)){
		resultAL = im.getFailedUsersStats();
		ano_ids = new ArrayList<Integer>();
		for(int i=0; i<resultAL.length; i++){
			ano_ids.add(resultAL[i].getAnomaly_id());
		}
	}else if(anomaly == -1){
		resultAL = im.getFailedUsersStats();
	}else{
		resultS = im.getFailedUsersForAnomaly(anomaly);
	}
	FileImportHistory fih = im.getImportInfosForAnomalies();
	initLabels();
	// end code

      out.write("\n<head>\n\t<title>ESIS - ");
      out.print( getLabel("USERS_NON_IMPORTED") );
      out.write("</title>\n\t");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<table width=\"100%\" border=\"0\" align=\"center\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t\t<div align=\"center\">\n\t\t<table border=\"0\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t\t<tr>\n\t\t\t<td width=\"20%\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t\t<td width=\"80%\" align=\"center\" class=\"title\">");
      out.print( getLabel("FILE_IMPORT_HISTORY") );
      out.write("</td>\n\t\t</tr>\n\t\t</table>\n\t\t<table border=\"0\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t\t<tr>\n\t\t\t<td align=\"center\" class=\"subtitle\">");
      out.print( fih.getRun_date() + " - "+ fih.getFile_name());
      out.write("\n\t\t\t<br/>");
      out.print( im.getAnomalyForAnomalyId(anomaly) );
      out.write("</td>\n\t\t</tr>\n\t\t</table>\n\t\t<br/>\n\t\t&nbsp;<br/>\n\t\t");

		if ("all".equals(anomalyStr)){
		
      out.write("\n\t\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t\t<tr>\n\t\t\t\t<td align=\"center\" width=\"50%\"><b>");
      out.print( getLabel("ANOMALY_TYPE") );
      out.write("</b></td>\n\t\t\t\t<td align=\"center\" width=\"50%\"><b>");
      out.print( getLabel("NUMBER_OF_USERS") );
      out.write("</b></td>\n\t\t\t</tr>\n\t\t\t");

			for(int i=0; resultAL!=null && i<resultAL.length; i++){
			
      out.write("\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\"><a href=\"#a");
      out.print(resultAL[i].getAnomaly_id() );
      out.write('"');
      out.write('>');
      out.print(resultAL[i].getAnomaly() );
      out.write("</a></td>\n\t\t\t\t\t<td align=\"center\">");
      out.print(resultAL[i].getNb_users() );
      out.write("</td>\n\t\t\t\t</tr>\n\t\t\t");

			}//end for
			
      out.write("\n\t\t\t</table>\n\t\t\t");

			for(int k=0; k<ano_ids.size(); k++){
			
      out.write("\n\t\t\t\t<br/>\n\t\t\t\t&nbsp;<br/>\n\t\t\t\t&nbsp;<br/>\n\t\t\t\t&nbsp;<br/>\n\t\t\t\t<a name=\"a");
      out.print( ano_ids.get(k) );
      out.write("\"></a>\n\t\t\t\t");

				resultS = im.getFailedUsersForAnomaly((ano_ids.get(k)).intValue());
				nbColumns = calcNbColumns(resultS);
				int nbLines = calcNbLines(resultS, nbColumns);
				if(resultS.length == 0){
					
      out.print( getLabel("NO_USER") );

				} else if (resultS.length == 1){
					
      out.print( getLabel("ONE_USER") );

				} else{
					
      out.print(resultS.length );
      out.write(' ');
      out.print( getLabel("MANY_USERS") );

				}
				
      out.write("\n\t\t\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t\t\t<tr>\n\t\t\t\t\t<td colspan=\"");
      out.print( nbColumns );
      out.write('"');
      out.write('>');
      out.print( im.getAnomalyForAnomalyId(((Integer)ano_ids.get(k)).intValue()) );
      out.write("</td>\n\t\t\t\t</tr>\n\t\t\t\t<tr>\n\t\t\t\t");

				//create labels
				for(int i=0; i<nbColumns; i++){
				
      out.write("\n\t\t\t\t\t<td><b>");
      out.print( getLabel("ID") );
      out.write("</b></td>\n\t\t\t\t");

				}
				
      out.write("\n\t\t\t\t</tr>\n\t\t\t\t");

				//create line of datas
				for(int i=0; i<nbLines; i++){
				
      out.write("\n\t\t\t\t\t<tr>\n\t\t\t\t\t");

					for(int j=0; j<nbColumns; j++){
						if(i+(j*nbLines)<resultS.length){
						
      out.write("\n\t\t\t\t\t\t<td align=\"center\">");
      out.print(resultS[i+(j*nbLines)] );
      out.write("</td>\n\t\t\t\t\t\t");

						}else{
						
      out.write("\n\t\t\t\t\t\t<td align=\"center\">&nbsp;</td>\n\t\t\t\t\t\t");

						}
					}
					
      out.write("\n\t\t\t\t\t</tr>\n\t\t\t\t");

				}
				
      out.write("\n\t\t\t\t</table>\n\t\t\t");

			}//end for
		} else if(anomaly == -1){
		
      out.write("\n\t\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t\t<tr>\n\t\t\t\t<td><b>");
      out.print( getLabel("ANOMALY_TYPE") );
      out.write("</b></td>\n\t\t\t\t<td><b>");
      out.print( getLabel("NUMBER_OF_USERS") );
      out.write("</b></td>\n\t\t\t\t<td><b>&nbsp;</b></td>\n\t\t\t</tr>\n\t\t\t");

			for(int i=0; i<resultAL.length; i++){
			
      out.write("\n\t\t\t\t<form action=\"anomalies_users.jsp\" method=\"POST\">\n\t\t\t\t<input type=\"hidden\" name=\"Session-Id\" value=\"");
      out.print(sid);
      out.write("\">\n\t\t\t\t<input type=\"hidden\" name=\"anomaly\" value=\"");
      out.print(resultAL[i].getAnomaly_id());
      out.write("\">\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\">");
      out.print(resultAL[i].getAnomaly() );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\">");
      out.print(resultAL[i].getNb_users() );
      out.write("</td>\n\t\t\t\t\t<td align=\"center\"><input type=\"submit\" value=\"Voir\"></td>\n\t\t\t\t</tr>\n\t\t\t\t</form>\n\t\t\t");

			}
			
      out.write("\n\t\t\t<tr>\n\t\t\t\t<form action=\"anomalies_users.jsp\" method=\"POST\">\n\t\t\t\t<input type=\"hidden\" name=\"Session-Id\" value=");
      out.print(sid);
      out.write(">\n\t\t\t\t<input type=\"hidden\" name=\"anomaly\" value=\"all\">\n\t\t\t\t<td align=\"center\" colspan=\"3\"><input type=\"submit\" value=\"Voir tous\"></td>\n\t\t\t\t</form>\n\t\t\t</tr>\n\t\t\t</table>\n\t\t");

		}else{
			nbColumns = calcNbColumns(resultS);
			int nbLines = calcNbLines(resultS, nbColumns);
			if(resultS.length == 0){
			
      out.print( getLabel("NO_USER") );

			} else if (resultS.length == 1){
			
      out.print( getLabel("ONE_USER") );

			} else{
			
      out.print(resultS.length );
      out.write(' ');
      out.print( getLabel("MANY_USERS") );

			}
			
      out.write("\n\t\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t\t<tr>\n\t\t\t\t");

				for(int i=0; i<nbColumns; i++){
				
      out.write("\n\t\t\t\t\t<td><b>");
      out.print( getLabel("ID") );
      out.write("</b></td>\n\t\t\t\t");

				}
				
      out.write("\n\t\t\t</tr>\n\t\t\t");

			for(int i=0; i<nbLines; i++){
			
      out.write("\n\t\t\t<tr>\n\t\t\t\t");

				for(int j=0; j<nbColumns; j++){
					if(i+(j*nbLines)<resultS.length){
					
      out.write("\n\t\t\t\t\t<td align=\"center\">");
      out.print(resultS[i+(j*nbLines)] );
      out.write("</td>\n\t\t\t\t\t");

					}else{
					
      out.write("\n\t\t\t\t\t<td align=center>&nbsp;</td>\n\t\t\t\t\t");

					}
				}
				
      out.write("\n\t\t\t</tr>\n\t\t\t");

			}//end for
			
      out.write("\n\t\t\t</table>\n\t\t");

		}
		
      out.write("\n\t\t</div>\n\t</td>\n</tr>\n<tr>\n\t<td>\n\t");
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
