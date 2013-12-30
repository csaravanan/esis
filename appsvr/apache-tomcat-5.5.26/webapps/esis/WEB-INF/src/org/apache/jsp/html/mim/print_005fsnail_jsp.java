package org.apache.jsp.html.mim;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapIdentityManagement;
import com.entelience.objects.mim.SnailDataJsp;
import com.entelience.util.Config;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public final class print_005fsnail_jsp extends com.entelience.servlet.JspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


	// Class declarations
	static double percent_low;
	static double percent_medium;
	static double percent_high;
	static double percent_bad;
	static{
		try{
                  com.entelience.sql.Db db = com.entelience.sql.DbConnection.mainDbRO();
                  try {
    		    percent_low = Config.getProperty(db, "com.entelience.esis.im.snail_colors.percent_low", 75.0);
    		    percent_medium = Config.getProperty(db, "com.entelience.esis.im.snail_colors.percent_medium", 90.0);
    		    percent_high = Config.getProperty(db, "com.entelience.esis.im.snail_colors.percent_high", 110.0);
    		    percent_bad = Config.getProperty(db, "com.entelience.esis.im.snail_colors.percent_bad", 125.0);
                    percent_low = (percent_low <= 0) ? 75.0 : percent_low;
                    percent_medium = (percent_medium <= 0) ? 90.0 : percent_medium;
	            percent_high = (percent_high <= 0) ? 110.0 : percent_high;
	            percent_bad = (percent_bad <= 0) ? 125.0 : percent_bad;
                  } finally {
                    db.safeClose();
                  }
    	        } catch(Exception e){
                  percent_low=75.0;
                  percent_medium=90.0;
                  percent_high=110.0;
                  percent_bad=125.0;
                }
        } // static initialiser end
	
	public String getData(List<List<Number>> data, int i, int j) {
          String ret="";
          try{
            Number o = data.get(i).get(j);
            double tmp = o.doubleValue();
            tmp = (double)(((int)(100*tmp))/100.0); // round down to two digits of decimal precision
            return String.valueOf(tmp);
          } catch(Exception e) {
            _logger.warn("Ignored Exception ",e);
          }
          return "&nbsp;";
	}
	
	public void initLabels(){
	   labels = new HashMap<String,String>();
	   labels.put("ORG_METRICS_en", "Organization metrics");
	   labels.put("GEO_METRICS_en", "Geography metrics");
	   labels.put("UNIT_METRIC_en", "Unit \\ Metric");
	   labels.put("TARGETS_en", "Targets");
	   labels.put("DDS_en", "Out delay");
	   labels.put("DDE_en", "In delay");
	   labels.put("DDC_en", "Connection delay");
	   labels.put("DPC_en", "Administration delay");
	   labels.put("ORG_METRICS_fr", "Indicateurs par organisation");
	   labels.put("GEO_METRICS_fr", "Indicateurs par g&eacute;ographie");
	   labels.put("UNIT_METRIC_fr", "Unit&eacute; \\ Indicateur");
	   labels.put("TARGETS_fr", "Objectifs");
	   labels.put("DDS_fr", "D&eacute;lai de sortie");
	   labels.put("DDE_fr", "D&eacute;lai d'entr&eacute;e");
	   labels.put("DDC_fr", "D&eacute;lai de connexion");
	   labels.put("DPC_fr", "D&eacute;lai de prise en charge");
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
	
	public String getColor(SnailDataJsp snail, int i, int j) {
                double value=0.0f;
                double target=0.0f;
                boolean isGoodValue=true;
                List<List<Number>> data = snail.getDatas();
                List<Double> targets = snail.getTarget_levels();
                try{
                        List<Number> al = data.get(i);
                        if(al.get(j).getClass().getName().equals("java.lang.Float"))
                                value = al.get(j).doubleValue();
                        else
                                isGoodValue = false;
                        target = targets.get(j).doubleValue();
                }  catch(Exception e) {
			isGoodValue = false;
		}
                if(!isGoodValue || target == 0) return "FFFFFF";
                double percent = (value*100)/target;
                if(percent < 0) return "990000";
                else if (percent <= percent_low) return "009933";
                else if (percent <= percent_medium) return "99CC00";
                else if (percent <= percent_high) return "FFFF33";
                else if (percent <= percent_bad) return "FF9933";
                else return "FF3333";
	}
	
	Map<String,String> labels;
	String language;
	
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
      out.write("\n\n\n\n\n\n\n\n");
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

        String type = getParam(request, "type");
        String name = getParam(request, "name");
        int scale = getParamInt(request, "scale");
        int level = getParamInt(request, "level");


        soapIdentityManagement im = new soapIdentityManagement(peopleId);
	SnailDataJsp snail = null;
        if("geo".equals(type))
            snail = im.getGeoSnailForPrint(name, level, scale);
        else 
            snail = im.getOrgSnailForPrint(name, level, scale);
        initLabels();
	// end code

      out.write("\n<head>\n\t<title>");

	if("geo".equals(type)) {
	
      out.print( getLabel("GEO_METRICS") );

	} else if("org".equals(type)) {
	
      out.print( getLabel("ORG_METRICS") );

	}
	
      out.write("</title>\n\t");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<table width=\"100%\" border=\"0\"  align=\"center\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t\t<div align=\"center\">\n\t\t<table border=\"0\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t\t<tr>\n\t\t\t<td width=\"20%\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n\t\t\t<td width=\"80%\" align=\"center\" class=\"title\">");

			if("geo".equals(type)) {
			
      out.print( getLabel("GEO_METRICS") );

			} else if("org".equals(type)) {
			
      out.print( getLabel("ORG_METRICS") );

			}
			
      out.write("</td>\n\t\t</tr>\n\t\t</table>\n\t\t<table border=\"0\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t\t<tr>\n\t\t\t<td align=\"center\" class=\"subtitle\">");
      out.print( snail.getName() );
      out.write("</td>\n\t\t</tr>\n\t\t</table>\n\t\t<br/>\n\t\t&nbsp;<br/>\n\t\t");

		//compute width for rows
		int percent = (int)(70/(snail.getMetric_names().size()));
		int percentlow = (int)(percent*0.2);
		percent -= percentlow;
		
      out.write("\n\t\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t\t<tr>\n\t\t\t<td width=\"30%\"><b>");
      out.print( getLabel("UNIT_METRIC") );
      out.write("</b></td>\n\t\t\t");

			for(int i=0; i<snail.getMetric_names().size(); i++){
			
      out.write("\n\t\t\t\t<td><b>");
      out.print(formatMetricName(snail.getMetric_names().get(i).toString()) );
      out.write("</b></td>\n\t\t\t");

			}
			
      out.write("\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"center\"><i>");
      out.print( getLabel("TARGETS") );
      out.write("</i></td>\n\t\t\t");

			for(int i=0; i<snail.getTarget_levels().size(); i++){
			
      out.write("\n\t\t\t\t<td align=\"center\"><i>");
      out.print(snail.getTarget_levels().get(i) );
      out.write("</i></td>\n\t\t\t");

			}
			
      out.write("\n\t\t</tr>\n\t\t");

		for(int i=0; i<snail.getTitles().size(); i++){
		
      out.write("\n\t\t\t<tr>\n\t\t\t\t<td align=\"center\">");
      out.print(snail.getTitles().get(i) );
      out.write("</td>\n\t\t\t\t");

				for(int j=0; j<snail.getMetric_names().size(); j++){
				
      out.write("\n\t\t\t\t\t<td align=\"center\" bgcolor=\"");
      out.print(getColor(snail,i,j) );
      out.write('"');
      out.write('>');
      out.print(getData(snail.getDatas(),i,j) );
      out.write("</td>\n\t\t\t\t");

				}
				
      out.write("\n\t\t\t</tr>\n\t\t");

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
