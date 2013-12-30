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
-- $Id: probe_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


-- ESIS Security DataWarehouse schema
--
-- contains: probe management schema

-- create tables


--
-- status for probe run
--
CREATE TABLE e_probe_run_status
(
        e_probe_run_status_id      int,
        status_name             text    UNIQUE NOT NULL,
        PRIMARY KEY(e_probe_run_status_id)
);
-- see sql/lang/probe_strings.sqltemplate
--
-- keep it sync with ProbeHistoryDb

CREATE TABLE e_probe_category
(
        e_probe_category_id     int,
        package_name    text    UNIQUE NOT NULL,
        name            text    UNIQUE NOT NULL,
        PRIMARY KEY(e_probe_category_id)
);
--
-- real values for name are in sql lang
--
INSERT INTO e_probe_category(e_probe_category_id, package_name, name) VALUES (1, 'apps', 'apps');
INSERT INTO e_probe_category(e_probe_category_id, package_name, name) VALUES (2, 'asset', 'asset');
INSERT INTO e_probe_category(e_probe_category_id, package_name, name) VALUES (3, 'audit', 'audit');
INSERT INTO e_probe_category(e_probe_category_id, package_name, name) VALUES (4, 'compliance', 'compliance');
INSERT INTO e_probe_category(e_probe_category_id, package_name, name) VALUES (5, 'httplog', 'httplog');
INSERT INTO e_probe_category(e_probe_category_id, package_name, name) VALUES (6, 'itops', 'itops');
INSERT INTO e_probe_category(e_probe_category_id, package_name, name) VALUES (7, 'itsm', 'itsm');
INSERT INTO e_probe_category(e_probe_category_id, package_name, name) VALUES (8, 'mail', 'mail');
INSERT INTO e_probe_category(e_probe_category_id, package_name, name) VALUES (9, 'mim', 'mim');
INSERT INTO e_probe_category(e_probe_category_id, package_name, name) VALUES (10, 'net', 'net');
INSERT INTO e_probe_category(e_probe_category_id, package_name, name) VALUES (11, 'patch', 'patch');
INSERT INTO e_probe_category(e_probe_category_id, package_name, name) VALUES (12, 'usertools', 'usertools');
INSERT INTO e_probe_category(e_probe_category_id, package_name, name) VALUES (13, 'virus', 'virus');
INSERT INTO e_probe_category(e_probe_category_id, package_name, name) VALUES (14, 'chat', 'chat');


-- table to store probe run history
CREATE SEQUENCE e_probe_history_serial;
CREATE TABLE e_probe_history
(
	e_probe_history_id	int		DEFAULT nextval('e_probe_history_serial'),
	probe_name		text 		NOT NULL,					-- the probe's class name
	run_date		timestamptz default current_timestamp,	-- date that the probe was run
	end_date		timestamptz,	    			-- when the probe finished
	success			boolean		NOT NULL DEFAULT false,		-- worked or failed
	error			boolean		NOT NULL DEFAULT false,		-- success = false, error = true -> "ERROR", false -> "FAILURE"
	abort			boolean		NOT NULL DEFAULT false,		-- success = false, abort = true -> "ABORTED" ^C (+ error -> ABORTED after partialCommit)
	no_data                 boolean         NOT NULL DEFAULT false,        --no data was imported by this probe
	e_probe_run_status_id  int             NOT NULL,       --e_probe_run_status
	error_message	text,    		-- is there an error message to display
	exception_stacktrace   text,            --is there ay stacktrace available
	PRIMARY KEY(e_probe_history_id)
);

-- table to store files infos
CREATE TABLE e_probe_file_history
(
       e_probe_history_id int          NOT NULL,        -- see e_probe_history
       file_name           text NOT NULL,       -- the file name (full path to file)
       file_size           bigint NOT NULL,     -- the file size
       file_hash                       text,                             -- the file hash/crc
       count_elts       bigint NOT NULL DEFAULT 0,
       count_elts_valid       bigint NOT NULL DEFAULT 0
);

-- table to store probes
CREATE TABLE e_probes
(
	e_probe_class	text NOT NULL,		-- class name
	active			boolean DEFAULT true,-- is this probe active (can be run)
	license         text,              --the license number for the probe
	PRIMARY KEY (e_probe_class)
);

--
-- origin of the parameter values (db, xml, default)
--
CREATE TABLE e_probe_parameter_origin
(
        e_probe_parameter_origin_id     int,
        origin                          text    UNIQUE NOT NULL,
        PRIMARY KEY(e_probe_parameter_origin_id)
);
--
-- keep these values synchronized with com.entelience.objects.probe.ProbeParameter
--
-- see sql/lang/probe_strings.sqltemplate

--
-- normalized parameters
--
CREATE SEQUENCE e_probe_parameter_serial;
CREATE TABLE e_probe_parameter
(
        e_probe_parameter_id    int     DEFAULT  nextval('e_probe_parameter_serial'),
        parameter_name          text    NOT NULL
);

CREATE TABLE e_probe_parameter_history
(
        e_probe_history_id int NOT NULL, 	--see e_probe_history
        e_probe_parameter_id int NOT NULL,      --see e_probe_parameter
        e_probe_parameter_origin_id int NOT NULL,       -- e_probe_parameter_origin
        parameter_value           text
);

-- table to store 'todo' information about probes and perhaps other things.
CREATE TABLE e_todo (
	todo_name 	text 	NOT NULL,
	todo_date 	date 		--used if the todo is a report
);

-- table to store history of DbProbes

CREATE TABLE e_probe_db_history(
	e_probe_history_id int NOT NULL, 	--see e_probe_history
	jdbc_url        text,
	tablename	text,			--name of the table of the external db
	last_inserted_id    bigint,		--marker for the last inserted id of the main table of the external database, no special constraints since we can use either the id or the date
	last_inserted_date  timestamptz		--marker for the last inserted date of the main table of the external database
);

-- table to store running probes
-- THIS IS A TRANSIENT TABLE!
CREATE TABLE e_probe_pid(
	probe_name		text,							-- the probe class name
	run_date		timestamptz DEFAULT current_timestamp,	-- when was it launched
	pid				int 							-- process PID
,	PRIMARY KEY (probe_name)
);

-- File mirroring and management
CREATE SEQUENCE e_remote_file_state_serial;
CREATE TABLE e_remote_file_state (
	remote_file_state_id		integer 	NOT NULL DEFAULT nextval('e_remote_file_state_serial'),
	local_id	integer,
	remote_state	integer		NOT NULL DEFAULT 0,
	filename	text		NOT NULL,
	orig_filename	text		NOT NULL,
	url		text		NOT NULL,
	retry_count	integer		NOT NULL DEFAULT 0,
	last_modified	bigint,		-- for http only
	message		text,
	PRIMARY KEY (remote_file_state_id)
);
CREATE UNIQUE INDEX e_remote_file_state_filename_url ON e_remote_file_state (filename, url);

CREATE SEQUENCE e_local_file_state_serial;
CREATE TABLE e_local_file_state (
	local_file_state_id		integer		NOT NULL DEFAULT nextval('e_local_file_state_serial'),
	local_state	integer		NOT NULL DEFAULT 0,
	filename	text		NOT NULL,
	orig_filename	text		NOT NULL,
	root_dir	text		NOT NULL,
	sub_dir		text		NOT NULL DEFAULT '.',
	retry_count	integer		NOT NULL DEFAULT 0,
	probe		text,		-- only stored if file has 'run' for this probe (real success / error / failure)
	probe_history_id int,		-- stored at 'run' time so that we know what this file probe is running on...
	message		text,
	PRIMARY KEY (local_file_state_id)
);
CREATE UNIQUE INDEX e_local_file_state_filename_dir ON e_local_file_state (filename, root_dir, sub_dir);

CREATE TABLE e_metadata(
        remote_file_state_id    int,
        local_file_state_id     int,
        name                    text    NOT NULL,
        text_value              text,
        int_value               bigint,
        double_value            double precision,
        date_value              timestamptz,
        CHECK(remote_file_state_id IS NOT NULL OR local_file_state_id IS NOT NULL),
        CHECK(text_value IS NOT NULL OR int_value IS NOT NULL OR double_value IS NOT NULL OR date_value IS NOT NULL)
);
CREATE UNIQUE INDEX e_metadata_unik ON e_metadata (name, remote_file_state_id, local_file_state_id);


CREATE TABLE e_file_states (
	id		integer	NOT NULL,
	state_name	text	NOT NULL
);
--
-- keep these values synchronized with com.entelience.probe.FileStates
--
-- see sql/lang/probe_strings.sqltemplate


--
-- history for probes that import files from an asset 
--
CREATE TABLE e_probe_asset_history(
        e_asset_id              int,
        e_probe_history_id      int,
        last_imported_ts        timestamptz     NOT NULL,
        PRIMARY KEY(e_asset_id,e_probe_history_id)
);




--
-- probe patterns
--
CREATE TABLE e_probe_pattern(
        probe_name      text,
        pattern         text,
        meaning         text    NOT NULL,
        last_modified   timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(probe_name, pattern)
);

--
-- Patterns for BO Magnitude
--
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'logon required.*', 'logon required');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'logon succeeded.*', 'logon succeeded');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'session ended.*', 'session ended');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'logon failed.*', 'logon failed');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Killing processes dependent.*', 'Killing processes dependent');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Connection expiration.*', 'Connection expiration');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Cannot insert duplicate key.*', 'Cannot insert duplicate key');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Initializing Process manager.*', 'Initializing Process manager');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Ping from.*', 'Ping from');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'interactive task submission.*', 'interactive task submission');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Executed sub consolidation.*', 'Executed sub consolidation');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Execute Document package.*', 'Execute Document package');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Integrate package collection.*', 'Integrate package collection');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'End of incoming media inspection.*', 'End of incoming media inspection');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Generating receive task\\(s\\).*', 'Generating receive task(s)');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Starting incoming media inspection.*', 'Starting incoming media inspection');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Failed to run database query.*', 'Failed to run database query');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Custom index creation.*', 'Custom index creation');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Run rule.*', 'Run rule');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Update the scope.*', 'Update the scope');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Apply carry-over flow.*', 'Apply carry-over flow');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Apply consolidation rate.*', 'Apply consolidation rate');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Zeroize consolidated amount.*', 'Zeroize consolidated amount');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Calculate consolidation rate.*', 'Calculate consolidation rate');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Apply conversion rates.*', 'Apply conversion rates');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Load data.*', 'Load data');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Load preconsolidated data.*', 'Load preconsolidated data');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', '-> trigger condition for unchecked opening balance.*', '-> trigger condition for unchecked opening balance');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Apply dimensional analyses.*', 'Apply dimensional analyses');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Generate consolidated rows.*', 'Generate consolidated rows');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Processing successful.*', 'Processing successful');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Save consolidation.*', 'Save consolidation');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Prepare data.*', 'Prepare data');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Create conversion tables.*', 'Create conversion tables');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Create Scope.*', 'Create Scope');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Read Category Scenario.*', 'Read Category Scenario');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Start of processing.*', 'Start of processing');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Read Scope.*', 'Read Scope');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Executing reception task.*', 'Executing reception task');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'End of reception task.*', 'End of reception task');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Start execution of hook for pack integration.*', 'Start execution of hook for pack integration');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Run set of rules.*', 'Run set of rules');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Executing sending task.*', 'Executing sending task');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'End of sending task.*', 'End of sending task');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Your user profile does not authorize you to create or change objects.*', 'Your user profile does not authorize you to create or change objects');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'The user name or password is incorrect.*', 'The user name or password is incorrect');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Registering root node.*', 'Registering root node');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Registered root node.*', 'Registered root node');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Initializing the transaction manager.*', 'Initializing the transaction manager');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Initializing application server.*', 'Initializing application server');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Initializing cache cleaning.*', 'Initializing cache cleaning');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Beginning internal uninitialize.*', 'Beginning internal uninitialize');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Uninitializing application server.*', 'Uninitializing application server');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Starting memory monitoring.*', 'Starting memory monitoring');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'application server initialized.*', 'application server initialized');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Registered consumer.*', 'Registered consumer');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'schemes initialization end.*', 'schemes initialization end');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'The application server uninitialized.*', 'The application server uninitialized');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Revoking node ended.*', 'Revoking node ended');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Revoking node.*', 'Revoking node');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Internal uninitialize ended.*', 'Internal uninitialize ended');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Datasource factory deleted.*', 'Datasource factory deleted');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'unloading schemes.*', 'unloading schemes');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Revoked consumer.*', 'Revoked consumer');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Ending memory monitoring.*', 'Ending memory monitoring');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Revoked node.*', 'Revoked node');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Syntax error.*', 'Syntax error');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) 
VALUES ('com.entelience.probe.apps.BOMagnitude', 'The certificate of session \\{.*\\} is invalid.', 'Invalid certificate');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) 
VALUES ('com.entelience.probe.apps.BOMagnitude', 'user \\S* logout successful', 'logout successfull');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) 
VALUES ('com.entelience.probe.apps.BOMagnitude', 'user \\S* StopPrinting successful for printer .*', 'StopPrinting successfull');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) 
VALUES ('com.entelience.probe.apps.BOMagnitude', 'The object \'.*\' of type \'.*\' has already been locked by user \\S*', 'Object already locked');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) 
VALUES ('com.entelience.probe.apps.BOMagnitude', 'user \\S* connection to .* : success', 'Connection success');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) 
VALUES ('com.entelience.probe.apps.BOMagnitude', 'user \\S* connection to .* : failure.*', 'Connection failure');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) 
VALUES ('com.entelience.probe.apps.BOMagnitude', '\\S* not responding', 'Not responding');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) 
VALUES ('com.entelience.probe.apps.BOMagnitude', 'ctwebapp on \\S* initialized', 'Webapp initialized');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) 
VALUES ('com.entelience.probe.apps.BOMagnitude', 'Session \\{.*\\} has already been locked in data source \'.*\' by user \'.*\'.', 'Session blocked');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) 
VALUES ('com.entelience.probe.apps.BOMagnitude', 'scheme \'\\S*\' initialized', 'scheme initialized');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) 
VALUES ('com.entelience.probe.apps.BOMagnitude', 'ctwebapp on \\S* shutdown', 'Webapp shutdown');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) 
VALUES ('com.entelience.probe.apps.BOMagnitude', 'parent .* not found for .*', 'Parent not found');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) 
VALUES ('com.entelience.probe.apps.BOMagnitude', '\\S* schemas unloaded', 'Schemas unloaded');

INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'DROP TABLE .*', 'DROP TABLE');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'CREATE TABLE .*', 'CREATE TABLE');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Exception raised while selecting expired servers with date .*', 'Exception raised while selecting expired servers');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', E'Exception raised while updating server with certificate \\S+ and expiration date .*', 'Exception raised while updating server');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Timeout calculation failed', 'Timeout calculation failed');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Invalid scheduler instance certificate : .*', 'Invalid scheduler instance certificate');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Expired server finalization failed', 'Expired server finalization failed');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Exception raised while selecting server informations from .*', 'Exception raised while selecting server informations');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', E'Server lease with certificate \\S+ and lease time \\S+ renew failed', 'Server lease renew failed');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', E'Internal load of user \\S+ failed. User unknown by system.', 'Internal load of user failed. User unknown by system');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Application is stopping because server lease expiration date update failed', 'Application is stopping because server lease expiration date update failed');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'ORA-03113: .*', 'fin de fichier sur canal de communication');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'ORA-01033: .*', E'initialisation ou fermeture d\'ORACLE en cours');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Active server requester failed', 'Active server requester failed');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', E'Server registration renewal with certificate \\S+ failed', 'Server registration renewal failed');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Publish package : Publish package .*', 'Publish package');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', E'Opening package \\{.*\\} : getting pack opening lock mode.', 'Opening package');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', 'Set share lock mode for package .*', 'Set share lock mode for package');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', E'\\(\\d+\\) An exception occured in CCtWebProcessPackManager::OpenPackage, errorinfos:', 'An exception occured in CCtWebProcessPackManager::OpenPackage');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', E'Exception raised while deleting servers \\S+ from ct_active_server', 'Exception raised while deleting servers from ct_active_server');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', E'SSO ID \\S+ connection to \\S+ via SSO : success', 'SSO connection success');
INSERT INTO e_probe_pattern(probe_name, pattern, meaning) VALUES ('com.entelience.probe.apps.BOMagnitude', E'SSO ID \\S+ connection to \\S+ via SSO : failure:', 'SSO connection failure');




--
-- source table
--
-- if the probe is a db probe, jdbc_url and table_name must be filled
-- else only probe name is required
CREATE SEQUENCE t_source_serial;
CREATE TABLE t_source(
        t_source_id     integer DEFAULT nextval('t_source_serial'),
        probe_name      text    NOT NULL,
        jdbc_url        text,
        table_name      text,
        PRIMARY KEY(t_source_id)
);
CREATE UNIQUE INDEX t_source_unik ON t_source(probe_name, jdbc_url, table_name);


--
-- products and versions supported by probes
--
CREATE TABLE e_probe_supported_products(
        probe_name      text,
        e_product_id    integer, --asset.e_product
        e_version_id    integer, --asset.e_version
        supported       boolean NOT NULL, -- globally supported
        supported_since_version_id      integer, --e_application_version_id, null if not glabally supported
        locally_supported       boolean NOT NULL DEFAULT false, -- supported on an installation
        locally_supported_since timestamptz, --if locally supported, date where it was supported first
        PRIMARY KEY(probe_name, e_product_id, e_version_id)
);