<!--
/*
 *
 * ESIS
 *
 * Copyright (c) 2004-2008 Entelience SARL,  Copyright (c) 2008-2009 Equity SA
 *
 * Projects contributors : Philippe Le Berre, Thomas Burdairon, Benjamin Baudel,
 *                         Benjamin S. Gould, Diego Patinos Ramos, Constantin Cornelie
 * 
 * 
 * This file is part of ESIS.
 * 
 * ESIS is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation version 3 of the License.
 * 
 * ESIS is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with ESIS.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $Id$
 *
 */
//-->
//browser verification
function Is() {
	agent = navigator.userAgent.toLowerCase();
	this.major = parseInt(navigator.appVersion);
	this.minor = parseFloat(navigator.appVersion);
	this.ns = ((agent.indexOf('mozilla') != -1) && (agent.indexOf('spoofer') == -1) && (agent.indexOf('compatible') == -1) && (agent.indexOf('opera') == -1) && (agent.indexOf('webtv') == -1) && (agent.indexOf('hotjava') == -1));
	this.ns2 = (this.ns && (this.major == 2));
	this.ns3 = (this.ns && (this.major == 3));
	this.ns4 = (this.ns && (this.major == 4));
	this.ns6 = (this.ns && (this.major >= 5));
	this.ie = ((agent.indexOf("msie") != -1) && (agent.indexOf("opera") == -1));
	this.ie3 = (this.ie && (this.major < 4));
	this.ie4 = (this.ie && (this.major == 4) && (agent.indexOf("msie 4") != -1));
	this.ie5 = (this.ie && (this.major == 4) && (agent.indexOf("msie 5.") != -1) && (agent.indexOf("msie 5.5") == -1) && (agent.indexOf("mac") == -1));
	this.iem5 = (this.ie && (this.major == 4) && (agent.indexOf("msie 5.") != -1) && (agent.indexOf("mac") != -1));
	this.ie55 = (this.ie && (this.major == 4) && (agent.indexOf("msie 5.5") != -1));
	this.ie6 = (this.ie && (this.major == 4) && (agent.indexOf("msie 6.") != -1));
	this.ie7 = (this.ie && (this.major == 4) && (agent.indexOf("msie 7.") != -1));
	this.ie8 = (this.ie && (this.major == 4) && (agent.indexOf("msie 8.") != -1));
	this.nsdom = (this.ns4 || this.ns6);
	this.ie5dom = (this.ie5 || this.iem5 || this.ie55);
	this.iedom = (this.ie4 || this.ie5dom || this.ie6);
	this.w3dom = (this.ns6 || this.ie6 || this.ie7 || this.ie8);
}
// return protocol + host
function setProtocolHost (host, protocol)
{
	var protocolhost = "";
	if(host != "" && host != null && host != undefined){
		if(protocol != "" && protocol != null && protocol != undefined){
			protocolhost = protocol+"://"+host;
		}else{
			protocolhost = "http://"+host; //http by default
		}
	}
	return protocolhost;
}
// return path to element in document
function thisElement (elementName)
{
	if (navigator.appName.indexOf("Microsoft") != -1)
	{
		return window [elementName];
	} else
	{
		return document [elementName];
	}
}
// to generate a portalObject data
function portalObject (wsNameValue, wsParamsValues, title, topLabelName, topLabelNumber, titleMultipleDatas, description, spotMetric, flashWidth, flashHeight, flashProtocol, flashHost)
{
	this.portalTitle = title; // graph title
	this.portalDescription = description; // description if needed
	this.wsName = wsNameValue; // webservice method name
	this.wsParams = wsParamsValues; // webservice method parameters ("," as separator)
	this.listLabelName = topLabelName; // TopList label title
	this.listLabelNumber = topLabelNumber; // Toplist number title
	this.multipleDatasTitles = titleMultipleDatas; //MultiChart, MultiBar titles
	//document values
	this.portalWidth = flashWidth;
	this.portalHeight = flashHeight;
	this.portalProtocol = flashProtocol;
	this.portalHost = flashHost;
	this.portalSpotMetric = spotMetric;
	this.portalZoom = 0;
	this.portalForceDisplay = 0;
}
// used to call ExternalInterval with a created portalObject in parameter
function callExternalInterface (wsNameValue, wsParamsValues, title, topLabelName, topLabelNumber, titleMultipleDatas, description, spotMetric, flashWidth, flashHeight, flashProtocol, flashHost)
{
	// create object with data
	var portalData = new portalObject (wsNameValue, wsParamsValues, title, topLabelName, topLabelNumber, titleMultipleDatas, description, spotMetric, flashWidth, flashHeight, flashProtocol, flashHost);
	// reload datas
	loadPortalData (portalData);
}
//call from ExternalInterface.callback to toad the AS method used by ExternalInterface with a parameter object
function loadPortalData (portalData) {
	// send portalData object to the Portal to update data
	thisElement (_esisPortalId).loadPortalData (portalData);
}
//call from ExternalInterface.call to init screen
function initPortal ()
{
	// on application first call, verify if portal is loaded
	onEsisReady ();
	return "ok";
}
//call from ExternalInterface.call to refresh description
function loadPortalDescription (theDescription)
{
	// when data are loaded, if description exists, it's inserted into form
	changeDescription (theDescription, _portalDescriptionFormId, _portalDescriptionForm);
	return "ok";
}
//to change description
function changeDescription (newDesc, portalDescriptionFormId, portalDescriptionForm)
{
	// change the description textarea
	thisElement (portalDescriptionForm) [portalDescriptionFormId].value = newDesc;
}