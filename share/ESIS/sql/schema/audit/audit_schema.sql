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
-- $Id: audit_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--

--
-- contains: audit management schema

--
-- Audit Reports
--
CREATE SCHEMA audit;


CREATE SEQUENCE audit.e_audit_serial;
CREATE TABLE audit.e_audit(
	e_audit_id		integer 	DEFAULT nextval('audit.e_audit_serial'),
	-- for object audit
	obj_ser			integer		NOT NULL,
	obj_lm			timestamptz	NOT NULL,
	db_user			text		NOT NULL,
	--
	audit_origin		integer		NOT NULL,	--e_audit_origin
	audit_topic		integer	,	--e_audit_topic
	creation_date		timestamptz 	DEFAULT current_timestamp,
	closed_date 		timestamptz,
	start_date		timestamptz,
	end_date		timestamptz,
	reference		text,
	e_raci_obj      integer     NOT NULL,   --e_raci
	objectives		text,
	context			text,
	deliverables		text,
	audit_scope		text,
	compliance 		boolean 	NOT NULL 	DEFAULT false,  --are we in compliance mode ?
	e_standard_id 		integer, 	-- compliance.e_standard if we are in compliance mode
	e_audit_status_id		integer		NOT NULL,	--e_audit_status
	e_audit_confidentiality_id	integer		NOT NULL,	--e_audit_confidentiality
	deleted			boolean		DEFAULT false,
	PRIMARY KEY(e_audit_id)
);

CREATE SEQUENCE audit.e_audit_interview_serial;
CREATE TABLE audit.e_audit_interview(
	e_audit_interview_id	integer		DEFAULT nextval('audit.e_audit_interview_serial'),
	-- for object audit
	obj_ser			integer		NOT NULL,
	obj_lm			timestamptz	NOT NULL,
	db_user			text		NOT NULL,
	--
	e_audit_id		integer		NOT NULL,	--e_audit
	creation_date		timestamptz	DEFAULT current_timestamp,
	auditee			text		NOT NULL,
	e_raci_obj      integer     NOT NULL,   --e_raci
	description		text,
	interview_date		timestamptz		NOT NULL,
	completed		boolean		NOT NULL,
	deleted			boolean		DEFAULT FALSE,
	PRIMARY KEY(e_audit_interview_id)
);

CREATE SEQUENCE audit.e_audit_document_serial;
CREATE TABLE audit.e_audit_document(
	e_audit_document_id	integer		DEFAULT nextval('audit.e_audit_document_serial'),
	-- for object audit
	obj_ser			integer		NOT NULL,
	obj_lm			timestamptz	NOT NULL,
	db_user			text		NOT NULL,
	--
	e_audit_id		integer		NOT NULL,	--e_audit
	e_audit_rec_id          integer,        --e_audit_rec, can be null
	creation_date		timestamptz	DEFAULT current_timestamp,
	title			text,
	description		text,
	e_raci_obj      integer     NOT NULL,   --e_raci
	reference		text,
	deleted			boolean		DEFAULT FALSE,
	e_confidentiality_id    integer         NOT NULL,
	verified                boolean        NOT NULL,
	e_audit_document_type_id       integer NOT NULL, --e_audit_document_type
	PRIMARY KEY(e_audit_document_id)
);

CREATE SEQUENCE audit.e_audit_document_content_serial;
CREATE TABLE audit.e_audit_document_content(
        e_audit_document_content_id     integer DEFAULT nextval('audit.e_audit_document_content_serial'),
	e_audit_document_id	integer		NOT NULL,	--e_audit_document
	checksum                text           NOT NULL,
	file_name               text,
	mime_type               text           NOT NULL,
	change_date             timestamptz    NOT NULL DEFAULT current_timestamp,
	content			bytea,
	PRIMARY KEY (e_audit_document_content_id)
);

CREATE SEQUENCE audit.e_audit_document_type_serial	START 100;
CREATE TABLE	audit.e_audit_document_type	(
	e_audit_document_type_id	integer	DEFAULT nextval('audit.e_audit_document_type_serial'),
	document_type			        text UNIQUE NOT NULL,
	PRIMARY KEY(e_audit_document_type_id)
); --cf sql/lang/audit/audit_strings.sqltemplate

CREATE TABLE audit.e_audit_document_history(
        change_date             timestamptz     NOT NULL        DEFAULT current_timestamp,
        modifier                integer         NOT NULL,  --e_people
        e_audit_document_id     integer         NOT NULL,  --audit.e_audit_document
        responsible             integer         NOT NULL,  --e_people
        title                   text,
        e_audit_document_content_id     integer,  --audit.e_audit_document_content
        revision_number         integer   -- # of revision of the document
);

CREATE TABLE audit.e_audit_history(
	e_audit_id		integer		NOT NULL,	--e_audit
	change_date		timestamptz	NOT NULL,
	modifier		integer		NOT NULL,	--e_people_id
	start_date		timestamptz,
	end_date		timestamptz,
	audit_owner		integer 	NOT NULL,			--e_people
	e_audit_status_id		integer NOT NULL,			--e_audit_status
	e_audit_confidentiality_id	integer NOT NULL,
	e_audit_topic_id 		integer,
	e_audit_origin_id 		integer NOT NULL,
	content_change		boolean 	NOT NULL,
	other_change		boolean 	NOT NULL
);

CREATE TABLE audit.e_audit_organisation(
 	e_audit_id 		integer,  --e_audit
 	PRIMARY KEY(e_audit_id, e_organisation_id)
) INHERITS (e_organisation_to_elements);


CREATE TABLE audit.e_audit_confidentiality(
	e_audit_confidentiality_id	integer	NOT NULL,
	confidentiality			text	UNIQUE NOT NULL,
	PRIMARY KEY(e_audit_confidentiality_id)
);
-- see sql/lang/audit/audit_strings.sqltemplate


CREATE TABLE audit.e_audit_status(
	e_audit_status_id	integer	NOT NULL,
	status			text	UNIQUE NOT NULL,
	PRIMARY KEY(e_audit_status_id)
);
-- see sql/lang/audit/audit_strings.sqltemplate



CREATE SEQUENCE	audit.e_audit_report_serial;
CREATE TABLE	audit.e_audit_report	(
	e_audit_report_id	integer		DEFAULT nextval('audit.e_audit_report_serial'),
	-- for object audit
	obj_ser			integer		NOT NULL,
	obj_lm			timestamptz	NOT NULL,
	db_user			text		NOT NULL,
	--
	creation_date		timestamptz	DEFAULT current_timestamp,
	e_audit_id 		integer		NOT NULL, --e_audit
	due_date		timestamptz,
	title			text 		NOT NULL,
	sub_title 		text,
	executive_summary 	text,
	source			text,
	e_status_id 		integer 	NOT NULL, --e_audit_report_status
	deleted			boolean		DEFAULT false, -- deleted ?
	e_raci_obj		integer		NOT NULL,	-- see e_raci
	PRIMARY KEY(e_audit_report_id)
);

CREATE TABLE audit.e_audit_report_history (
	e_audit_report_id 	integer 	NOT NULL,
	change_date 		timestamptz 	DEFAULT current_timestamp,
	modifier 		int 	 	NOT NULL,
	due_date 		timestamptz,
	current_value 		boolean 	NOT NULL DEFAULT true,
	e_status_id 		int
);

--
-- Audit Reports' Recommendations
--
CREATE SEQUENCE	audit.e_audit_rec_serial;
CREATE TABLE	audit.e_audit_rec	(
	e_audit_rec_id		integer		DEFAULT nextval('audit.e_audit_rec_serial'),
	-- for object audit
	obj_ser			integer		NOT NULL,
	obj_lm			timestamptz	NOT NULL,
	db_user			text		NOT NULL,
	--
	audit_report_id		integer		NOT NULL,	-- see e_audit_report
	creation_date		timestamptz	DEFAULT current_timestamp,
	reference		text,		-- external reference
	title			text,		-- recommendation title
	recommendation		text,		-- recommendation body
	rec_status		integer		NOT NULL,	-- see e_audit_rec_status, e_audit_rec_history
	severity		integer		NOT NULL,	-- see e_audit_severity
	priority		integer		NOT NULL,	-- see e_audit_priority, e_audit_rec_history
	e_raci_obj		integer		NOT NULL,	-- see e_raci
	closed_date		timestamptz,	-- when closed (status == closed)
	primary_topic		integer,	-- see e_audit_rec_topic
	secondary_topic		integer,
	compliance_topic_id 	integer, 	-- see compliance.e_topic : only if the audit is a compliance audit
	deleted			boolean		DEFAULT false,	-- deleted 
	PRIMARY KEY(e_audit_rec_id)
);
CREATE INDEX e_report_rec_reference_n ON audit.e_audit_rec(reference);

CREATE TABLE audit.e_audit_rec_organisation(
 	e_audit_rec_id 		integer,  --e_audit_rec
 	PRIMARY KEY(e_audit_rec_id, e_organisation_id)
) INHERITS (e_organisation_to_elements);

CREATE TABLE audit.e_audit_rec_verification(
 	e_audit_rec_id 		integer 	NOT NULL, --e_audit_rec
 	documented 		boolean 	NOT NULL,
 	on_site 		boolean 	NOT NULL,
 	e_audit_rec_follow_up_id 	integer
);




CREATE SEQUENCE audit.e_audit_rec_compliance_serial;
CREATE TABLE audit.e_audit_rec_compliance(
	e_audit_rec_compliance_id 	integer 	DEFAULT nextval('audit.e_audit_rec_compliance_serial'),
 	e_audit_rec_id 		integer  	NOT NULL,
 	e_organisation_id 	integer,   	--can be null
 	-- for object audit
	obj_ser  		integer 	NOT NULL,
	obj_lm 			timestamptz 	NOT NULL,
	db_user  		text 		NOT NULL,
	--
	creation_date 		timestamptz 	NOT NULL,
	e_compliance_level_id 	integer, 	--e_compliance_level
	compliance_level_target integer, 	--e_compliance_level
	e_compliance_type_id 	integer 	NOT NULL, 	--e_compliance_type
	e_compliance_kind_id 	integer 	NOT NULL,
	description 		text
);
CREATE UNIQUE INDEX e_audit_rec_compliance_unik_idx ON audit.e_audit_rec_compliance(e_audit_rec_id, e_organisation_id);
SELECT create_trgfn_maint_object_audit('audit', 'e_audit_rec_compliance', 'e_audit_rec_compliance_id', 'e_audit_rec_compliance_serial');

CREATE TABLE audit.e_audit_rec_compliance_history(
 	e_audit_rec_compliance_id  	integer  	NOT NULL,
 	compliance_level   		integer,
 	compliance_target  		integer,
 	modifier  			integer   	NOT NULL,
 	modification_date   		timestamptz  	DEFAULT current_timestamp
);


CREATE SEQUENCE	audit.e_audit_rec_auditee_serial;
CREATE TABLE audit.e_audit_rec_auditee (
	e_audit_rec_auditee_id	integer DEFAULT nextval('audit.e_audit_rec_auditee_serial'),
	-- for object audit
	obj_ser			integer		NOT NULL,
	obj_lm			timestamptz	NOT NULL,
	db_user			text		NOT NULL,
	--
    e_audit_rec_id  integer		NOT NULL,  --from e_audit_rec
    e_raci_obj		integer		NOT NULL,	-- see e_raci
    auditee_answer		text,
	auditee_priority	integer		NOT NULL,
	auditee_severity	integer		NOT NULL,
	target_date            timestamptz,            --can be null
        escalade                boolean         NOT NULL DEFAULT false,
	PRIMARY KEY(e_audit_rec_auditee_id)
);
CREATE UNIQUE INDEX e_audit_rec_auditee_audit_rec_id ON audit.e_audit_rec_auditee (e_audit_rec_id);


--
-- recommendations can be duplicate
--
CREATE TABLE audit.e_audit_rec_duplicate (
 	main_rec_id 		integer 	NOT NULL, --the 'main' recommendation
 	dup_rec_id 		integer 	NOT NULL  --the duplicate recommendation
);
CREATE UNIQUE INDEX e_audit_rec_duplicate_idx ON audit.e_audit_rec_duplicate (main_rec_id, dup_rec_id);

--
-- dependencies between recommendations
--
CREATE TABLE audit.e_audit_rec_dependencies (
 	blocks_rec_id 		integer 	NOT NULL,  --this rec blocks the other rec
 	dependson_rec_id 	integer 	NOT NULL   --this rec depends on the other rec
);
CREATE UNIQUE INDEX e_audit_rec_dependencies_idx ON audit.e_audit_rec_dependencies (blocks_rec_id, dependson_rec_id);

--
-- links between recommendations and other stuff 
--
CREATE TABLE audit.e_audit_rec_external_dependencies (
 	e_rec_id 			integer 	NOT NULL,  --e_audit_rec
 	e_vulnerability_id 		integer 	 --vuln.e_vulnerability
)
WITH OIDS; -- e_vulnerability_id
--
--
-- Recommendations' Actions
--
CREATE SEQUENCE	audit.e_audit_action_serial;
CREATE TABLE	audit.e_audit_action	(
	e_audit_action_id	integer		DEFAULT nextval('audit.e_audit_action_serial'),
	-- for object audit
	obj_ser			integer		NOT NULL,
	obj_lm			timestamptz	NOT NULL,
	db_user			text		NOT NULL,
	--
	rec_id			integer			NOT NULL,	-- see e_audit_rec
	creation_date		timestamptz	DEFAULT current_timestamp,
	due_date		timestamptz		NOT NULL,	-- due date
	closed_date		timestamptz,
	escalade 		boolean 	NOT NULL DEFAULT false,
	e_raci_obj      integer     NOT NULL,   --e_raci
	title			text,		-- action title
	external_ref 		text,
	description		text,		-- action description
	action_status		integer		NOT NULL,	-- see e_audit_action_status, e_audit_action_status_history
	deleted			boolean		DEFAULT false,	-- deleted
	PRIMARY KEY (e_audit_action_id)
);


CREATE TABLE audit.e_audit_action_organisation(
 	e_audit_action_id 		integer,  --e_audit_rec
 	PRIMARY KEY(e_audit_action_id, e_organisation_id)
) INHERITS (e_organisation_to_elements);


--
-- Recommendations' Comments
--
CREATE SEQUENCE	audit.e_audit_rec_comment_serial;
CREATE TABLE	audit.e_audit_rec_comment	(
	e_audit_rec_comment_id	integer	DEFAULT nextval('audit.e_audit_rec_comment_serial'),
	-- for object audit
	obj_ser			integer		NOT NULL,
	obj_lm			timestamptz	NOT NULL,
	db_user			text		NOT NULL,
	--
	rec_id			integer		NOT NULL,
	creation_date	timestamptz	DEFAULT current_timestamp,
	author			integer		NOT NULL, 	-- see e_people
	comment			text,		-- comment body
	deleted			boolean,
	PRIMARY KEY (e_audit_rec_comment_id)
);

CREATE TABLE audit.e_audit_rec_comment_history (
 	e_audit_rec_comment_id	integer 	NOT NULL,
 	change_date 		timestamptz 	NOT NULL DEFAULT current_timestamp,
 	modifier 		integer 	NOT NULL,
 	comment 		text
);

--
-- Recommendations changes
--
CREATE TABLE audit.e_audit_rec_history	(
	rec_id			integer		NOT NULL,	-- see e_audit_rec
	rec_status		integer		NOT NULL,	-- see e_audit_rec_status
	auditor_owner		integer		NOT NULL,	-- see e_people
	priority		integer		NOT NULL,	-- see e_audit_priority
	auditee_owner		integer		NOT NULL, 	-- see e_people
	auditee_priority	integer		NOT NULL,
	severity 		integer 	NOT NULL,
	auditee_severity 	integer 	NOT NULL,
	change_date		timestamptz	DEFAULT current_timestamp,
	modifier		integer		NOT NULL,	-- see e_people (logged in user)
	target_date             timestamptz
);

--
-- Actions changes
--
CREATE TABLE audit.e_audit_action_history	(
	action_id		integer		NOT NULL,	-- see e_audit_action
	action_status		integer		NOT NULL,	-- see e_audit_action_status
	owner			integer		NOT NULL,	-- see e_people
	due_date		timestamptz, -- may be null
	change_date		timestamptz	DEFAULT current_timestamp,
	modifier		integer		NOT NULL	-- see e_people (logged in user)
);

--
-- Search history
--
CREATE TABLE audit.e_audit_search_history(
	search_date 	timestamptz 	DEFAULT current_timestamp NOT NULL,
	e_people_id 	integer 	NOT NULL, --e_people
	object_searched 	text 	NOT NULL, -- audit/report/recommendation/action
	searched 	text 		NOT NULL
);


--
-- Report Status
--
CREATE TABLE audit.e_audit_report_status	(
	e_audit_report_status_id 	integer NOT NULL,
	report_status 			text 	UNIQUE NOT NULL,
	PRIMARY KEY (e_audit_report_status_id)
);
-- see sql/lang/audit/audit_strings.sqltemplate

--
-- Recommendation Status
--
CREATE TABLE audit.e_audit_rec_status	(
	e_audit_rec_status_id	integer	NOT NULL,
	rec_status		text	UNIQUE NOT NULL,
	PRIMARY KEY (e_audit_rec_status_id)
);
-- see sql/lang/audit/audit_strings.sqltemplate

--
-- Recommendation Severity
--
CREATE TABLE	audit.e_audit_severity	(
	e_audit_severity_id	integer		NOT NULL,
	severity		text      UNIQUE NOT NULL,
	PRIMARY KEY (e_audit_severity_id)
);
-- see sql/lang/audit/audit_strings.sqltemplate

--
-- Audit Report Topics
--
CREATE SEQUENCE audit.e_audit_topic_serial	START 100;
CREATE TABLE	audit.e_audit_topic	(
	e_audit_topic_id	integer	DEFAULT nextval('audit.e_audit_topic_serial'),
	topic			text UNIQUE NOT NULL,
	PRIMARY KEY(e_audit_topic_id)
);
-- see sql/lang/audit/audit_strings.sqltemplate

--
-- Audit report origins
--
CREATE SEQUENCE audit.e_audit_origin_serial	START 100;
CREATE TABLE	audit.e_audit_origin	(
	e_audit_origin_id	integer	DEFAULT nextval('audit.e_audit_origin_serial'),
	origin			text	 UNIQUE	NOT NULL,
	PRIMARY KEY(e_audit_origin_id)
);
-- see sql/lang/audit/audit_strings.sqltemplate

--
-- Action Status
--
CREATE TABLE	audit.e_audit_action_status	(
	e_audit_action_status_id	integer	NOT NULL,
	action_status			text	UNIQUE  NOT NULL,
	PRIMARY KEY(e_audit_action_status_id)
);
-- see sql/lang/audit/audit_strings.sqltemplate

-- 
-- Recommendation Priority
--
CREATE TABLE	audit.e_audit_priority	(
	e_audit_priority_id		integer,
	priority			text UNIQUE NOT NULL,
	PRIMARY KEY(e_audit_priority_id)
);
-- see sql/lang/audit/audit_strings.sqltemplate


--
-- Recommendation Topics
--
CREATE SEQUENCE audit.e_audit_rec_topic_serial START 100;
CREATE TABLE	audit.e_audit_rec_topic	(
	e_audit_rec_topic_id		integer	DEFAULT nextval('audit.e_audit_rec_topic_serial'),
	topic				text	UNIQUE NOT NULL,
	PRIMARY KEY (e_audit_rec_topic_id)
);
-- see sql/lang/audit/audit_strings.sqltemplate




SELECT create_trgfn_maint_object_audit('audit', 'e_audit_report', 'e_audit_report_id', 'e_audit_report_serial');
SELECT create_trgfn_maint_object_audit('audit', 'e_audit_rec', 'e_audit_rec_id', 'e_audit_rec_serial');
SELECT create_trgfn_maint_object_audit('audit', 'e_audit_rec_auditee', 'e_audit_rec_auditee_id', 'e_audit_rec_auditee_serial');
SELECT create_trgfn_maint_object_audit('audit', 'e_audit_action', 'e_audit_action_id', 'e_audit_action_serial');
SELECT create_trgfn_maint_object_audit('audit', 'e_audit_rec_comment', 'e_audit_rec_comment_id', 'e_audit_rec_comment_serial');
SELECT create_trgfn_maint_object_audit('audit', 'e_audit', 'e_audit_id', 'e_audit_serial');
SELECT create_trgfn_maint_object_audit('audit', 'e_audit_interview', 'e_audit_interview_id', 'e_audit_interview_serial');
SELECT create_trgfn_maint_object_audit('audit', 'e_audit_document', 'e_audit_document_id', 'e_audit_document_serial');

SELECT create_trgfn_maint_raci('audit', 'e_audit_rec');
SELECT create_trgfn_maint_raci('audit', 'e_audit_rec_auditee');
SELECT create_trgfn_maint_raci('audit', 'e_audit');
SELECT create_trgfn_maint_raci('audit', 'e_audit_interview');
SELECT create_trgfn_maint_raci('audit', 'e_audit_document');
SELECT create_trgfn_maint_raci('audit', 'e_audit_action');
SELECT create_trgfn_maint_raci('audit', 'e_audit_report');



--
-- Metric tables
--
CREATE TABLE audit.e_audit_daily(
 	calc_day 	date 	NOT NULL,
 	count_past_due_audits 	integer NOT NULL,
 	count_past_due_reports 	integer NOT NULL,
 	count_audits_closed_that_day 	integer NOT NULL,
 	count_audits_created_that_day 	integer NOT NULL,
 	PRIMARY KEY(calc_day)
);

CREATE TABLE audit.e_audit_status_daily(
 	calc_day 	date 	NOT NULL,
 	status 		integer NOT NULL,
 	count_audits 	integer NOT NULL,
 	count_audits_changed_that_day 	integer NOT NULL,
 	PRIMARY KEY(calc_day, status)
);
CREATE TABLE audit.e_audit_topic_daily(
 	calc_day 	date 	NOT NULL,
 	topic 		integer NOT NULL,
 	count_audits 	integer NOT NULL,
 	count_audits_changed_that_day 	integer NOT NULL,
 	PRIMARY KEY(calc_day, topic)
);
CREATE TABLE audit.e_audit_origin_daily(
 	calc_day 	date 	NOT NULL,
 	origin 		integer NOT NULL,
 	count_audits 	integer NOT NULL,
 	count_audits_changed_that_day 	integer NOT NULL,
 	PRIMARY KEY(calc_day, origin)
);
CREATE TABLE audit.e_audit_confidentiality_daily(
 	calc_day 	date 	NOT NULL,
 	confidentiality 	integer NOT NULL,
 	count_audits 	integer NOT NULL,
 	count_audits_changed_that_day 	integer NOT NULL,
 	PRIMARY KEY(calc_day, confidentiality)
);

CREATE TABLE audit.e_audit_rec_daily(
 	calc_day 	date 	NOT NULL,
 	e_audit_id 	integer NOT NULL,
 	count_recs_with_past_due_date 	integer NOT NULL,
 	count_recs_closed_that_day 	integer NOT NULL,
 	count_recs_delayed 		integer NOT NULL,
 	PRIMARY KEY(calc_day, e_audit_id)
);
CREATE TABLE audit.e_audit_rec_status_daily(
 	calc_day 	date 	NOT NULL,
 	status 		integer NOT NULL,
 	e_audit_id 	integer NOT NULL,
 	count_recs 	integer NOT NULL,
 	count_recs_changed_that_day 	integer NOT NULL,
 	PRIMARY KEY(calc_day, status, e_audit_id)
);

CREATE TABLE audit.e_audit_action_daily(
	calc_day 	date 	NOT NULL,
	e_audit_rec_id 	integer NOT NULL,
	count_actions_with_past_due_date 	integer NOT NULL,
	count_actions_delayed_that_day 	integer NOT NULL,
	count_actions_closed_that_day 	integer NOT NULL,
	PRIMARY KEY(calc_day, e_audit_rec_id)
);
CREATE TABLE audit.e_audit_action_status_daily(
 	calc_day 	date 	NOT NULL,
 	status 		integer NOT NULL,
 	e_audit_rec_id 	integer NOT NULL,
 	count_actions 	integer NOT NULL,
 	count_actions_changed_that_day 	integer NOT NULL,
 	PRIMARY KEY(calc_day, status, e_audit_rec_id)
);


CREATE TABLE audit.e_audit_compliance_daily(
        calc_day        date    NOT NULL,
        e_audit_id      integer NOT NULL,
        count_comp_with_insufficient_level      integer         NOT NULL,  -- # of compliances with level < target
        count_comp_with_sufficient_level        integer         NOT NULL,  -- # of compliances with level >= target
        count_compliant_rec                     integer         NOT NULL,  -- # of recs having at least 1 compliance with level < target
        count_non_compliant_rec                 integer         NOT NULL,  -- # of recs having all compliances level>= target
        count_comp_level_ok_that_day            integer         NOT NULL,  -- # of compliances that changed this day to a good level
        count_compliant_recs_that_day           integer         NOT NULL,  -- # of recs that became compliant ( all levels >= target) that day
        PRIMARY KEY(calc_day, e_audit_id)
);

CREATE TABLE audit.e_audit_compliance_level_daily(
        calc_day        date    NOT NULL,
        e_audit_id      integer NOT NULL,
        e_level_id      integer NOT NULL,
        count_compliances       integer         NOT NULL,       -- # of compliance with this level
        count_recs              integer         NOT NULL,       -- # of recs with this level
        count_compliances_ok    integer         NOT NULL,       -- # of compliance with this level that have level >= target
        count_compliances_nok   integer         NOT NULL,       -- # of compliance with this level that have level < target
        PRIMARY KEY(calc_day, e_audit_id, e_level_id)
);

CREATE TABLE audit.e_audit_compliance_target_daily(
        calc_day        date    NOT NULL,
        e_audit_id      integer NOT NULL,
        e_target_id      integer NOT NULL,
        count_compliances       integer         NOT NULL,       -- # of compliance with this target
        count_recs              integer         NOT NULL,       -- # of recs with this target
        count_compliances_ok    integer         NOT NULL,       -- # of compliance with this target that have level >= target
        count_compliances_nok   integer         NOT NULL,       -- # of compliance with this target that have level < target
        PRIMARY KEY(calc_day, e_audit_id, e_target_id)
);


CREATE TABLE audit.e_audit_raci_daily(
	calc_day 	date 		NOT NULL,
	e_people_id 	integer 	NOT NULL,
	r 		boolean 	NOT NULL,
	a 		boolean 	NOT NULL,
	c 		boolean 	NOT NULL,
	i 		boolean 	NOT NULL,
	count_actions 	integer 	NOT NULL DEFAULT 0,
	count_recs_auditor 	integer 	NOT NULL DEFAULT 0,
	count_recs_auditee 	integer 	NOT NULL DEFAULT 0,
	count_reports 	integer 	NOT NULL DEFAULT 0,
	count_audits 	integer 	NOT NULL DEFAULT 0,
	count_past_due_actions 	integer 	NOT NULL DEFAULT 0,
	count_past_due_recs_auditor 	integer 	NOT NULL DEFAULT 0,
	count_past_due_recs_auditee 	integer 	NOT NULL DEFAULT 0,
	count_past_due_reports 	integer 	NOT NULL DEFAULT 0,
	count_past_due_audits 	integer 	NOT NULL DEFAULT 0,
	count_delayed_actions 	integer 	NOT NULL DEFAULT 0,
	count_delayed_recs_auditor 	integer 	NOT NULL DEFAULT 0,
	count_delayed_recs_auditee 	integer 	NOT NULL DEFAULT 0,
	count_delayed_reports 	integer 	NOT NULL DEFAULT 0,
	count_delayed_audits 	integer 	NOT NULL DEFAULT 0,
	PRIMARY KEY (calc_day, e_people_id, r,a,c,i)
);

CREATE TABLE audit.e_audit_raci_confidentiality_daily(
	calc_day 	date 		NOT NULL,
	e_people_id 	integer 	NOT NULL,
	r 		boolean 	NOT NULL,
	a 		boolean 	NOT NULL,
	c 		boolean 	NOT NULL,
	i 		boolean 	NOT NULL,
	confidentiality 	integer 	NOT NULL,
	count_audits 	integer 	NOT NULL DEFAULT 0,
	PRIMARY KEY (calc_day, e_people_id, r,a,c,i, confidentiality)
);

CREATE TABLE audit.e_audit_rec_severity_raci_daily(
	calc_day 	date 		NOT NULL,
	e_people_id 	integer 	NOT NULL,
	r 		boolean 	NOT NULL,
	a 		boolean 	NOT NULL,
	c 		boolean 	NOT NULL,
	i 		boolean 	NOT NULL,
	severity 	integer 	NOT NULL,
	count_recs_as_auditor 	integer 	NOT NULL DEFAULT 0,
	count_recs_as_auditee 	integer 	NOT NULL DEFAULT 0,
	PRIMARY KEY (calc_day, e_people_id, r,a,c,i, severity)
);
CREATE TABLE audit.e_audit_rec_priority_raci_daily(
	calc_day 	date 		NOT NULL,
	e_people_id 	integer 	NOT NULL,
	r 		boolean 	NOT NULL,
	a 		boolean 	NOT NULL,
	c 		boolean 	NOT NULL,
	i 		boolean 	NOT NULL,
	priority 	integer 	NOT NULL,
	count_recs_as_auditor 	integer 	NOT NULL DEFAULT 0,
	count_recs_as_auditee 	integer 	NOT NULL DEFAULT 0,
	PRIMARY KEY (calc_day, e_people_id, r,a,c,i, priority)
);


CREATE TABLE audit.e_audit_report_status_daily(
 	calc_day 	date 	NOT NULL,
 	e_audit_id      integer NOT NULL,
 	status 		integer NOT NULL,
 	count_reports 	integer NOT NULL,
 	count_reports_changed_that_day 	integer NOT NULL,
 	PRIMARY KEY(calc_day, e_audit_id, status)
);

