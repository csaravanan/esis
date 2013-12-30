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
-- $Id: modules_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


--
-- contains: modules management schema


--
-- This table is intended to reflect all available modules
--

CREATE SEQUENCE	e_module_serial;
CREATE TABLE	e_module (
	e_module_id	integer	DEFAULT nextval('e_module_serial'),
	-- for object audit
	obj_ser			integer		NOT NULL,
	obj_lm			timestamptz	NOT NULL,
	db_user			text		NOT NULL,
	-- for raci
	e_raci_obj		integer		NOT NULL,
	--
	shortname	text	NOT NULL,	-- A TLA/FLA name that is used internally (i.e. SARM)
	fqn		text	NOT NULL,	-- The fully qualified module name (i.e. Security Auditors Report Management)
	module_name	text	NOT NULL,	-- A common name (i.e. Audit)
	class_name	text	NOT NULL,	-- The class name (com.entelience.module.AuditModule)
	e_module_version_id	integer,	-- the currently installed version : if null means no version is installed
	license			text,		-- the license information
	active		boolean DEFAULT FALSE,
	PRIMARY KEY(e_module_id)
);
CREATE UNIQUE INDEX e_module_class_name ON e_module (class_name);

SELECT create_trgfn_maint_object_audit('public', 'e_module', 'e_module_id', 'e_module_serial');
-- create Raci for anonymous user for each module
SELECT create_trgfn_maint_raci('public', 'e_module');

-- NO SAMPLES : it's filled from java --


CREATE SEQUENCE e_application_version_serial;
CREATE TABLE e_application_version (
        e_application_version_id	integer		DEFAULT nextval('e_application_version_serial'),
	revision		text		NOT NULL,	-- A revision number/ string.  eg.  ESIS-0.1-M8-Bug999
	installation_date	timestamptz	DEFAULT current_timestamp,
	release_date            date            NOT NULL,
	support_end_date	timestamptz,	-- Support contract expires when? null = never ?
	current_version		boolean	DEFAULT TRUE,
	PRIMARY KEY(e_application_version_id)
);

CREATE SEQUENCE	e_module_report_serial;
CREATE TABLE e_module_report (
	e_module_report_id 	integer 	DEFAULT nextval('e_module_report_serial'),
	e_module_id 		integer,  --can be null for subreports
	name 			text 		NOT NULL,
	description 		text,
	class_name 		text,  --can be null for subreports
	report_data 		bytea       	DEFAULT NULL
);
CREATE UNIQUE INDEX e_module_report_name ON e_module_report (name);
CREATE UNIQUE INDEX e_module_report_class_name ON e_module_report (class_name);

--
-- parameters for reports.
--
CREATE SEQUENCE e_module_report_parameter_serial;
CREATE TABLE e_module_report_parameter (
	e_module_report_parameter_id 	integer 	DEFAULT nextval('e_module_report_parameter_serial'),
	e_module_report_id 		integer 	NOT NULL,  
	description 		text 	NOT NULL,
	value 			text 	NOT NULL
);



CREATE TABLE e_module_indicator (
        e_module_indicator_id           integer,
        short_name                      text            NOT NULL,
        name                            text            NOT NULL,
        PRIMARY KEY(e_module_indicator_id)
);
CREATE UNIQUE INDEX e_module_indicator_short_name ON e_module_indicator (short_name);
CREATE UNIQUE INDEX e_module_indicator_name ON e_module_indicator (name);
INSERT INTO e_module_indicator (e_module_indicator_id, short_name, name) VALUES (1, 'I', 'Integrity');
INSERT INTO e_module_indicator (e_module_indicator_id, short_name, name) VALUES (2, 'C', 'Compliance');
INSERT INTO e_module_indicator (e_module_indicator_id, short_name, name) VALUES (3, 'A', 'Availability');
INSERT INTO e_module_indicator (e_module_indicator_id, short_name, name) VALUES (4, 'Re', 'Reactivity');
INSERT INTO e_module_indicator (e_module_indicator_id, short_name, name) VALUES (5, 'Ro', 'Robustness');
INSERT INTO e_module_indicator (e_module_indicator_id, short_name, name) VALUES (6, 'E', 'Exposure');

CREATE SEQUENCE e_module_metric_serial;
CREATE TABLE e_module_metric (
        e_module_metric_id              integer         DEFAULT nextval('e_module_metric_serial'),
        e_module_id                     integer         NOT NULL,
        e_module_indicator_id           integer         NOT NULL,
        internal_name                   text            NOT NULL,
        unit                            text,
        e_module_metric_timing_id       integer,        --could be null
        description                     text,
        target_value                    integer,
        PRIMARY KEY(e_module_metric_id)
);
CREATE UNIQUE INDEX e_module_metric_unik_idx ON e_module_metric (e_module_id, internal_name);

CREATE SEQUENCE e_module_metric_timing_serial;
CREATE TABLE e_module_metric_timing(
        e_module_metric_timing_id       integer         DEFAULT nextval('e_module_metric_timing_serial'),
        count_time_unit                 integer         NOT NULL,
        time_unit                       text            NOT NULL,
        name                            text            NOT NULL
);
INSERT INTO e_module_metric_timing(count_time_unit, time_unit, name) VALUES (1, 'week', '1 week');
INSERT INTO e_module_metric_timing(count_time_unit, time_unit, name) VALUES (1, 'month', '1 month');
INSERT INTO e_module_metric_timing(count_time_unit, time_unit, name) VALUES (3, 'month', '3 months');
INSERT INTO e_module_metric_timing(count_time_unit, time_unit, name) VALUES (6, 'month', '6 months');

CREATE TABLE e_module_metric_target_history(
        e_module_metric_id              integer         NOT NULL,
        modifier                        integer         NOT NULL,
        change_date                     timestamptz     DEFAULT current_timestamp,
        e_timing_id                     integer,        --can be null
        target_value                    integer
);


CREATE SEQUENCE e_generated_reports_serial;
CREATE TABLE e_generated_reports(
        e_generated_reports_id          integer DEFAULT nextval('e_generated_reports_serial'),
        generation_date                 timestamptz NOT NULL DEFAULT current_timestamp,
        e_module_report_id              int,
        title                           text    NOT NULL,
        report_data                     bytea   NOT NULL,
        content_type                    text    NOT NULL,
        filename                        text    NOT NULL,
        PRIMARY KEY(e_generated_reports_id)
);