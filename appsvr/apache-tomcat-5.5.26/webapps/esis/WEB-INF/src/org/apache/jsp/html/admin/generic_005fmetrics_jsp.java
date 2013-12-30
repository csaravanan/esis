package org.apache.jsp.html.admin;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.entelience.soap.soapModule;
import com.entelience.objects.module.ModuleMetric;
import com.entelience.objects.module.ModuleInfoLine;
import com.entelience.util.DateHelper;
import com.entelience.sql.DbHelper;
import java.util.List;
import java.util.ArrayList;

public final class generic_005fmetrics_jsp extends com.entelience.servlet.JspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


        //Class definition : Do not put transient vars here
        public String nAifyNull(String s){
                //return "NA" instead of null
                if(s == null)
                        return "N/A";
                return s;
        }

  private static java.util.List _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList(3);
    _jspx_dependants.add("/html/admin/../style.inc.jsp");
    _jspx_dependants.add("/html/admin/../icon.inc.jsp");
    _jspx_dependants.add("/html/admin/../copyright.inc.jsp");
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
      out.write('\n');

// code
// Check session id validity
try{
        Integer peopleId = getSession(request);
        initTimeZone(peopleId);
        soapModule sm = new soapModule(peopleId);
        int moduleId= getParamInt(request, "moduleId");
        List<ModuleMetric[]> metrics = new ArrayList<ModuleMetric[]>();
        List<String> metricNames = new ArrayList<String>();
        metrics.add(sm.listMetricsForModule(moduleId, "I")); metricNames.add("Integrity");
        metrics.add(sm.listMetricsForModule(moduleId, "C")); metricNames.add("Compliance");
        metrics.add(sm.listMetricsForModule(moduleId, "A")); metricNames.add("Availability");
        metrics.add(sm.listMetricsForModule(moduleId, "Re")); metricNames.add("Reactivity");
        metrics.add(sm.listMetricsForModule(moduleId, "Ro")); metricNames.add("Robustness");
        metrics.add(sm.listMetricsForModule(moduleId, "E")); metricNames.add("Exposure");
         
        ModuleInfoLine mod = sm.getModuleInformation(moduleId);
        String todaysDate = formatDate(DateHelper.now());

      out.write("\n<!-- Now begins HTML page ...-->\n<head>\n<title>Metrics for module ");
      out.print( mod.getName());
      out.write(' ');
      out.write('-');
      out.write(' ');
      out.print( todaysDate );
      out.write(" </title>\n");
      out.write("\n<style type=\"text/css\">\n<!--\nbody {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #000000; background-color: #FFFFFF}\n.title {  font-weight: bold;  text-align: center; font-size: 20pt}\n.subtitle {  font-weight: bold;  text-align: center; font-size: 18pt}\n.copy {  color: #808099; text-align: center; font-size: 9pt}\n.vtitle{ text-align: left; font-size: 14pt; font-weight: bold}\n.vproduct { font-size: 9pt; text-align: left; color: #003366 }\n.db { font-family: \"Monaco\", \"Microsoft Sans Serif\"; font-size: 9pt; }\n-->\n</style>\n");
      out.write("\n</head>\n<body>\n<!-- Main table -->\n<table width=\"100%\" border=\"0\" bgcolor=\"white\">\n<tr>\n\t<td>\n\t<div align=\"center\">\n\t<!-- Header table with title -->\n\t<table border=\"0\" cellspacing=\"0\" cellpadding=\"4\" width=\"100%\">\n\t<tr>\n\t\t<td width=\"20%\" align=\"left\"><a href=\"http://esis.sourceforge.net/\" target=\"_blank\">");
      out.write('\n');
      out.write("  \n<img src=\"../icon.gif\" width=\"146\" height=\"51\" border=\"0\" alt=\"ESIS\">");
      out.write("</a></td>\n        <td width=\"80%\" align=\"center\" class=\"title\">Metrics for module ");
      out.print( mod.getName());
      out.write(' ');
      out.write('-');
      out.write(' ');
      out.print( todaysDate );
      out.write("</td>\n\t\t</tr>\n        </table>\n\t<!-- end Header table with title -->\n\t<br/>\n\t\n\t");

	  for(int j=0; j< metrics.size(); j++){
	       ModuleMetric[] mm =  metrics.get(j);
	       String metricName = (String) metricNames.get(j);
	
      out.write("\n\t\n\t");

	if (mm != null && mm.length>0) {
	
      out.write("\n\t\n\t<!-- Integrity -->\n\t<br/>\n\t<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\" width=\"90%\">\n\t<tr><th colspan=\"7\">");
      out.print( metricName);
      out.write("</th></tr>\n\t<tr>\n\t<th align=\"center\" bgcolor=\"gainsboro\">Metric name</th>\n\t<th align=\"center\" bgcolor=\"gainsboro\">Timescale</th>\n\t<th align=\"center\" bgcolor=\"gainsboro\">Target</th>\n\t<th align=\"center\" bgcolor=\"gainsboro\">Count</th>\n\t<th align=\"center\" bgcolor=\"gainsboro\">Min</th>\n\t<th align=\"center\" bgcolor=\"gainsboro\">Max</th>\n\t<th align=\"center\" bgcolor=\"gainsboro\">Avg</th>\n\t</tr>\n\t");

	       for(int i=0; i< mm.length; i++){
	
      out.write("\n\t<tr>\n\t<td align=\"center\">");
      out.print( mm[i].getDescription() );
      out.write("</td>\n\t<td align=\"center\">");
      out.print(nAifyNull(mm[i].getTimingName()) );
      out.write("</td>\n\t<td align=\"center\">");
      out.print(mm[i].getTarget()+" "+DbHelper.unnullify(mm[i].getUnit()));
      out.write("</td>\n\t<td align=\"center\">");
      out.print(mm[i].isSingleValue() ? mm[i].getCount()+" "+DbHelper.unnullify(mm[i].getUnit()) : "N/A");
      out.write("</td>\n\t<td align=\"center\">");
      out.print(mm[i].isSingleValue() || mm[i].getMin() == null ? "N/A" : mm[i].getMin().intValue()+" "+DbHelper.unnullify(mm[i].getUnit()));
      out.write("</td>\n\t<td align=\"center\">");
      out.print(mm[i].isSingleValue() || mm[i].getMax() == null ? "N/A" : mm[i].getMax().intValue()+" "+DbHelper.unnullify(mm[i].getUnit()));
      out.write("</td>\n\t<td align=\"center\">");
      out.print(mm[i].isSingleValue() || mm[i].getAvg() == null ? "N/A" : mm[i].getAvg().intValue()+" "+DbHelper.unnullify(mm[i].getUnit()));
      out.write("</td>\n\t</tr>\n\t");
 } //end for 
	
      out.write(" \n\t</table>\n\t");
 } //end if
	
      out.write('\n');
      out.write('	');
 } //end for
	
      out.write("\n\t\n\t\n\t");
      out.write("\n&nbsp;<br/>\n<table width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"0\">\n<tr>\n\t<td align=\"center\" class=\"copy\">\n\t<br/>\n\t<br/>Copyright (c) 2004-2008 Entelience SARL, Copyright (c) 2008-2009 Equity SA, Copyright (c) 2009-2010 Consulare sÃ rl, Licensed under the <a href=\"http://www.gnu.org/copyleft/gpl.html\">GNU GPL, Version 3</a>.\n\t<br/>\n\t</td>\n</tr>\n</table>");
      out.write("\n\t</div>\n\t</td>\n</tr>\n</table>\n<!-- end Main table -->\n</body>\n</html>\n");

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
