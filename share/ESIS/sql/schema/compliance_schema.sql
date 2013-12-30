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
-- $Id: compliance_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--

--
-- contains: ESIS compliance based information 
--
CREATE SCHEMA compliance;

--
-- Source as the publisher or authority of the standard
-- This is an ESIS reference, must be maintained via a specific ESIS probe
--
CREATE SEQUENCE compliance.e_source_serial;
CREATE TABLE compliance.e_source(
	e_source_id 	int 	DEFAULT nextval('compliance.e_source_serial'),
	source 		text	UNIQUE NOT NULL,
	PRIMARY KEY (e_source_id)
);
INSERT INTO compliance.e_source (source) VALUES ('ISO');
INSERT INTO compliance.e_source (source) VALUES ('ISACA');
INSERT INTO compliance.e_source (source) VALUES ('ISF');
INSERT INTO compliance.e_source (source) VALUES ('ISSAF');

--
-- Categories for standards
--
CREATE SEQUENCE compliance.e_standard_category_serial START 100;
CREATE TABLE compliance.e_standard_category (
	e_standard_category_id 	int 	DEFAULT nextval('compliance.e_standard_category_serial'),
	standard_category 	text 	UNIQUE NOT NULL,
	PRIMARY KEY (e_standard_category_id)
);


--
-- Norms and standards 
--
CREATE SEQUENCE compliance.e_standard_serial;
CREATE TABLE compliance.e_standard (
 	e_standard_id 		int  	DEFAULT nextval('compliance.e_standard_serial'), 
 	obj_ser			int	NOT NULL,
	obj_lm			timestamptz NOT NULL,
	db_user			text	NOT NULL,
 	reference 		text 	NOT NULL, 	-- ie 27001
 	publication_date 	timestamptz,		-- 'taking effect on December 20, 2002'
 	title 			text, 	
 	classification_index 	text,			-- ICS (ie X 30-211)
 	e_source_id 		int 	NOT NULL,
 	e_category_id		int,
 	active 			boolean 	DEFAULT true, 	-- Is this norm active (relevent) for this company
 	obsoleted 		boolean 	DEFAULT false,	-- Is this norm obsoleted
 	PRIMARY KEY(e_standard_id)
);
CREATE UNIQUE INDEX e_standard_ref ON compliance.e_standard (reference, e_source_id);



--
-- Aliases as some norms have 'common names' or refer to customer
-- specific acronyms.
--
CREATE TABLE compliance.e_standard_aliases (
	e_standard_id 	int 	NOT NULL,
	ref_alias 	text 	UNIQUE NOT NULL,
	PRIMARY KEY (e_standard_id, ref_alias)
);

--
-- Obsolescence map
--
CREATE TABLE compliance.e_standard_obsolescence (
	e_standard_id 	int 	NOT NULL,		-- the standard that is obsolete
	obsoleted_by	int 	NOT NULL,		-- the one that is more recent but could 
							-- have been obsoleted by yet another one
	obsoleted_since 	timestamptz,
 	PRIMARY KEY(e_standard_id, obsoleted_by)
);


--
-- Categories allow to semantically organize the topics
-- This can be customer specific
CREATE SEQUENCE compliance.e_topic_category_serial START 100;
CREATE TABLE compliance.e_topic_category(
	e_topic_category_id 	int 	DEFAULT nextval('compliance.e_topic_category_serial'),
	topic_category		text	UNIQUE NOT NULL,
	PRIMARY KEY (e_topic_category_id)
);


--
-- topics to topics equivalence. One topic in a standard may maps to one or many
-- topics in other standards. This is not bijective.
--
CREATE TABLE compliance.e_topic_mapping(
	main_topic_id 	int 	NOT NULL,		-- the main
	equiv_topic_id 	int 	NOT NULL,		-- the mapped one
	PRIMARY KEY (main_topic_id, equiv_topic_id)
);

--
-- Main tables, contains all the topics of the standars and norms. Following,
-- a hierarchy.
--
CREATE SEQUENCE compliance.e_topic_serial;
CREATE TABLE compliance.e_topic(
		e_topic_id 	int NOT NULL 		DEFAULT nextval('compliance.e_topic_serial'),		-- the standard ref
		obj_ser		int	NOT NULL,
		obj_lm		timestamptz NOT NULL,
		db_user		text	NOT NULL,
		e_standard_id 	int NOT NULL,		-- the id of the topic
		upper_id  	int,
		chapter 	text,			-- the chapter within the standard (chapters may be letters)
		hierarchy_level int,			-- the hierachical level within the chapter
		hierarchy_order int,		-- the order within the hierarchy
		reference 	text NOT NULL,			-- the reference as within the standard
		title 		text NOT NULL,		-- the title of the topic
		content         text,                   -- content of a topic
		e_topic_category_id 	int,
		reference_array  int[] NOT NULL , -- this is the reference splitted in an array so we can order on this field
		PRIMARY KEY(e_topic_id)
);
CREATE UNIQUE INDEX e_topic_ref ON compliance.e_topic (e_standard_id, reference);
CREATE UNIQUE INDEX e_topic_internal ON compliance.e_topic (e_standard_id, reference_array);


SELECT create_trgfn_maint_object_audit('compliance', 'e_topic', 'e_topic_id', 'e_topic_serial');
SELECT create_trgfn_maint_object_audit('compliance', 'e_standard', 'e_standard_id', 'e_standard_serial');


--
-- some axis for compliance
--
CREATE SEQUENCE compliance.e_compliance_kind_serial;
CREATE TABLE compliance.e_compliance_kind	(
	e_compliance_kind_id 	integer 	DEFAULT nextval('compliance.e_compliance_kind_serial'),
	kind 			text UNIQUE ,
	PRIMARY KEY(e_compliance_kind_id)
);

CREATE SEQUENCE compliance.e_compliance_type_serial;
CREATE TABLE compliance.e_compliance_type	(
	e_compliance_type_id 	integer 	DEFAULT nextval('compliance.e_compliance_type_serial'),
	compliance_type		text UNIQUE ,
	PRIMARY KEY(e_compliance_type_id)
);

CREATE SEQUENCE compliance.e_compliance_level_serial;
CREATE TABLE compliance.e_compliance_level (
 	e_compliance_level_id 	integer DEFAULT nextval('compliance.e_compliance_level_serial'),
 	score_text 		text,
 	score_value 		integer,
 	trend 			integer, -- +1, ., -1
 	description 		text,
 	PRIMARY KEY(e_compliance_level_id)
);
INSERT INTO compliance.e_compliance_level(score_text, score_value, trend, description) VALUES ('D-', 1, -1, 'D-');
INSERT INTO compliance.e_compliance_level(score_text, score_value, trend, description) VALUES ('D', 2, 0, 'D');
INSERT INTO compliance.e_compliance_level(score_text, score_value, trend, description) VALUES ('D+', 3, +1, 'D+');
INSERT INTO compliance.e_compliance_level(score_text, score_value, trend, description) VALUES ('C-', 4, -1, 'C-');
INSERT INTO compliance.e_compliance_level(score_text, score_value, trend, description) VALUES ('C', 5, 0, 'C');
INSERT INTO compliance.e_compliance_level(score_text, score_value, trend, description) VALUES ('C+', 6, +1, 'C+');
INSERT INTO compliance.e_compliance_level(score_text, score_value, trend, description) VALUES ('B-', 7, -1, 'B-');
INSERT INTO compliance.e_compliance_level(score_text, score_value, trend, description) VALUES ('B', 8, 0, 'B');
INSERT INTO compliance.e_compliance_level(score_text, score_value, trend, description) VALUES ('B+', 9, +1, 'B+');
INSERT INTO compliance.e_compliance_level(score_text, score_value, trend, description) VALUES ('A-', 10, -1, 'A-');
INSERT INTO compliance.e_compliance_level(score_text, score_value, trend, description) VALUES ('A', 11, 0, 'A');
INSERT INTO compliance.e_compliance_level(score_text, score_value, trend, description) VALUES ('A+', 12, +1, 'A+');




--
-- list of policy tool
-- this is updated by probes
--
CREATE SEQUENCE compliance.e_policy_tool_serial;
CREATE TABLE compliance.e_policy_tool(
        e_policy_tool_id       integer DEFAULT nextval('compliance.e_policy_tool_serial'),
        tool_name       text    UNIQUE NOT NULL,
        PRIMARY KEY(e_policy_tool_id)
);

--
-- scan results from a policy tool
--
CREATE SEQUENCE compliance.e_policy_tool_scan_serial;
CREATE TABLE compliance.e_policy_tool_scan(
        e_policy_tool_scan_id   integer DEFAULT nextval('compliance.e_policy_tool_scan_serial'),
        e_policy_tool_id        integer,
        calc_day                date,
        hostname                text,
        e_asset_id              integer, --may be null if the tool does not provide the IP
        success                 boolean,
        error_message           text, --if not success, get the error message
        PRIMARY KEY(e_policy_tool_scan_id)
);
CREATE UNIQUE INDEX e_policy_tool_scan_unik ON compliance.e_policy_tool_scan (e_policy_tool_id, calc_day, hostname, e_asset_id);

CREATE TABLE compliance.e_policy_tool_scan_elements(
        e_policy_tool_scan_id   integer,
        element           text,
        installed         text,
        PRIMARY KEY(e_policy_tool_scan_id, element)
);