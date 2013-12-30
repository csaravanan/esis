--
--
-- ESIS
--
-- Copyright (c) 2004-2008 Entelience SARL,  Copyright (c) 2008-2009 Equity SA
--
-- Projects contributors : Philippe Le Berre, Thomas Burdairon, Benjamin Baudel,
--                         Benjamin S. Gould, Diego Patinos Ramos, Constantin Cornelie
-- 
-- 
-- This file is part of ESIS.
-- 
-- ESIS is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation version 3 of the License.
-- 
-- ESIS is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with ESIS.  If not, see <http://www.gnu.org/licenses/>.
--
-- $Id: properties_schema.sql 387 2010-04-12 16:21:37Z pleberre $
--
--


--
-- ESIS database version
--
CREATE TABLE e_esisdbversion (
	revision_tag		text NOT NULL,		-- revision level (ie. STABLE-20091111)	
	last_update_file 	text,
	last_updated		timestamptz NOT NULL DEFAULT current_timestamp,
	PRIMARY KEY (revision_tag)
);

--
-- ESIS cmd history
--
CREATE TABLE e_esiscmd_history (
	run_date	timestamptz DEFAULT current_timestamp,	-- when the command was run
	cmd			text,									-- the command
	args		text,									-- the args
	PRIMARY KEY(run_date, cmd, args)
	);
	
--
-- contains: Properties schema

--
-- Table with all the dynamic properties. See also the esis.properties file
--
CREATE TABLE e_esisconfig
(
    parameter 		text,
    value 		text,
    hidden 		boolean NOT NULL DEFAULT false,
    lm_user             int, --e_people
    lm_timestamp        timestamptz     DEFAULT current_timestamp,
    default_value	text,
    PRIMARY KEY (parameter)
);


CREATE TABLE e_esisconfig_history(
        change_date     timestamptz     NOT NULL DEFAULT current_timestamp,
        modifier        int, --e_people
        parameter       text    NOT NULL,
        operation       char(1)		NOT NULL, -- 'I', 'U', 'D'
        old_value       text,
        new_value       text
);

--
-- Cannot add delete trigger, this must be done manually because we can't get the modifier from the e_esisconfig table
--
CREATE OR REPLACE FUNCTION trgfn_preference_history() RETURNS TRIGGER AS $trig$
	DECLARE
    BEGIN
        IF (TG_OP = 'INSERT') THEN
                INSERT INTO e_esisconfig_history (modifier, parameter, operation, old_value, new_value) 
                        VALUES (NEW.lm_user, NEW.parameter, 'I', null, NEW.value);
        ELSIF (TG_OP = 'UPDATE') THEN
                INSERT INTO e_esisconfig_history (modifier, parameter, operation, old_value, new_value) 
                        VALUES (NEW.lm_user, NEW.parameter, 'U', OLD.value, NEW.value);
	END IF;
	RETURN NEW;
	END;
$trig$ LANGUAGE plpgsql;

CREATE TRIGGER trg_maint_pref_history AFTER INSERT OR UPDATE ON e_esisconfig
	FOR EACH ROW EXECUTE PROCEDURE trgfn_preference_history();

--
-- Main configuration:
--
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.rootDir', '/opt/ESIS', '/opt/ESIS', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.errorsDir', '/opt/ESIS/errors', '/opt/ESIS/errors', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.errorsSize', '512 mb', '512 mb', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.reportsDir', '/opt/ESIS/reports', '/opt/ESIS/reports', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.defaultCompany', 'Entelience', 'Entelience', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.poweredByLogo', '/opt/ESIS/share/ESIS/poweredBy.png', '/opt/ESIS/share/ESIS/poweredBy.png', 0);
--
-- Web server configuration:
--
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.web.localServerPort', '8080', '8080', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.web.localServerAddress', '127.0.0.1', '127.0.0.1', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.web.remoteServerProtocol', 'http', 'http', 0);


--
-- SMTP Properties
--
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.mail.MailHelper.hostName', 'localhost', 'localhost', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.mail.MailHelper.hostPort', '25', '25', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.mail.MailHelper.useTls', 'false', 'false', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.mail.MailHelper.useAuth', 'false', 'false', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.mail.MailHelper.smtpUser', 'user', 'user', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.feature.attachCalendarFile', 'false', 'false', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, hidden, lm_user) VALUES ('com.entelience.mail.MailHelper.smtpPassword', 'passwd', 'passwd', true, 0);

INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.mail.MailHelper.maxTries', '5', '5', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.mail.MailHelper.maxEmailSentAtOnce', '25', '25', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.mail.MailHelper.iconLocation', '/opt/ESIS/share/ESIS/icon.gif', '/opt/ESIS/share/ESIS/icon.gif', 0);
--
-- Probes Properties
--
-- This should NOT be there but within their probes and inserted when activated
--


--
-- WebServices authentication
--
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.soap.SessionHandler.timeoutMinutes', '20', '20', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.soap.soapBase.authMethod', 'com.entelience.soap.auth.Database', 'com.entelience.soap.auth.Database', 0);

--
-- Webservice datagrid configuration
--
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.maxReturnedRows', '50', '50', 0);

--
-- LDAP Configuration
--
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.soap.auth.LDAP.base', 'dc=my-domain,dc=com', 'dc=my-domain,dc=com', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.soap.auth.LDAP.baseFilterString', 'objectclass=person', 'objectclass=person', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.soap.auth.LDAP.userNameField', 'uid', 'uid', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.soap.auth.LDAP.url', 'ldap://localhost:389/', 'ldap://localhost:389/', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.soap.auth.LDAP.searchUserName', 'cn=Manager,dc=my-domain,dc=com', 'cn=Manager,dc=my-domain,dc=com', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, hidden, lm_user) VALUES ('com.entelience.soap.auth.LDAP.searchPassword', 'secret', 'secret', true, 0);

--
-- HTTP Proxy configuration
--
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpHelper.userAgent', 'esis', 'esis', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpHelper.useProxy', 'false', 'false', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpHelper.proxyHost', 'localhost', 'localhost', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpHelper.proxyPort', '3128', '3128', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpHelper.useProxyAuth', 'false', 'false', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpHelper.proxyRealm', 'Customer-realm', 'Customer-realm', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpHelper.proxyScheme', null, null, 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpHelper.proxyUserName', 'user', 'user', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, hidden, lm_user) VALUES ('com.entelience.util.HttpHelper.proxyPassword', 'passwd', 'passwd', true, 0);
--
-- HTTPS proxy configuration for HttpTransport: 
--
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpSslHelper.userAgent', 'esis', 'esis', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpSslHelper.useProxy', 'false', 'false', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpSslHelper.proxyHost', 'localhost', 'localhost', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpSslHelper.proxyPort', '3128', '3128', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpSslHelper.useProxyAuth', 'false', 'false', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpSslHelper.proxyRealm', 'Customer-realm', 'Customer-realm', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpSslHelper.proxyScheme', null, null, 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpSslHelper.proxyUserName', 'user', 'user', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, hidden, lm_user) VALUES ('com.entelience.util.HttpSslHelper.proxyPassword', 'passwd', 'passwd', true, 0);
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.util.HttpSslHelper.keyStore', 'file:///opt/ESIS/.keyStore', 'file:///opt/ESIS/.keyStore', 0);
INSERT INTO e_esisconfig (parameter, value, default_value, hidden, lm_user) VALUES ('com.entelience.util.HttpSslHelper.keyStorePassword', 'password', 'password', true, 0);

--
-- RACI preferences
--
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.raci.strict_RACI', 'true', 'true', 0);

--
-- CNIL level
-- No user info collected by the probes by default
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.cnilLevel', '2', '2', 0);

--
-- Logs
--
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.logDirectory', '/opt/ESIS/var/log', '/opt/ESIS/var/log', 0);
-- cmd history size
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.cmdHistorySize', '5000', '5000', 0);

--
-- Probes xml
--
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.probeXmlFile', '/opt/ESIS/share/ESIS/probes.xml', '/opt/ESIS/share/ESIS/probes.xml', 0);


CREATE TABLE e_preference_descriptions(
    parameter 		text,
    description		text,
    PRIMARY KEY (parameter)
);
--
-- filled by sql lang scripts
--
