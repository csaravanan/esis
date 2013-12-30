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
-- $Id: raci_views.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


-- Please access raci objects and people information only through these views.
-- Any query on any of the base tables should translate easily.
-- Don't forget to also add all fields to the query.  If the same field appears
-- with different names to add both.

-- First: RACI with directory information or NULLs,,,
DROP VIEW v_raci_people CASCADE;
CREATE OR REPLACE VIEW v_raci_people
(
  e_raci_obj,
  e_people_id,
  e_raci_object_type_id,
  r, a, c, i,
--
  user_name,
  passwd,
  first_name,
  last_name,
  display_name,
  phone,
  email,
  e_location_id,
  creation_date,
  last_mod_date,
  e_company_id,
  disabled,
  is_admin
) AS SELECT 
 r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i, 
 p.user_name, p.passwd, p.first_name, p.last_name, p.display_name, p.phone, p.email, p.e_location_id, p.creation_date, p.last_mod_date, p.e_company_id, p.disabled, p.is_admin
FROM e_raci r LEFT OUTER JOIN e_people p ON (r.e_people_id = p.e_people_id);

-- We need a function that returns owner information
CREATE OR REPLACE  FUNCTION raci_to_owner(e_raci_obj IN integer) RETURNS integer 
AS $fn$
	DECLARE
		result integer;
	BEGIN
		result := 0; -- anonymous by default
		IF (EXISTS (SELECT r.e_people_id FROM e_raci r WHERE r.e_raci_obj = e_raci_obj AND r.r)) THEN
			SELECT INTO result r.e_people_id FROM e_raci r WHERE r.e_raci_obj = e_raci_obj AND r.r ORDER BY 1 DESC LIMIT 1;
		ELSIF (EXISTS (SELECT r.e_people_id FROM e_raci r WHERE r.e_raci_obj = e_raci_obj AND r.a)) THEN
			SELECT INTO result r.e_people_id FROM e_raci r WHERE r.e_raci_obj = e_raci_obj AND r.a ORDER BY 1 DESC LIMIT 1;
		END IF;
		RETURN result;
	END;
$fn$
LANGUAGE plpgsql STABLE STRICT;

-- Second: One view per type of object being handled by RACI,
-- here we 'roll up' the people information into five arrays (all people id, r_s, a_s, c_s, i_s, ra_s, ci_s)
-- so we only have one row per real object.
--
-- These becomes efficient when querying by foreign object key and/or various raci
-- rules restrictions by joining with these views.  For example:
--
-- SELECT e_vulnerability_id, obj_ser FROM v_raci_vulnerability raci
-- WHERE 4 = ANY(i_s) AND is_new_published = false AND is_new_scanned = false
-- AND ignored = false AND closed_date IS NULL;
--
-- (find all open vulnerabilities where person #4 is informed)
--
-- SELECT e_vulnerability_id, obj_ser, i_s FROM v_raci_vulnerability WHERE array_upper(i_s, 1) >= 15;
--
-- (find all vulnerabilities with more than 15 informed people)
--
DROP VIEW v_raci_vulnerability CASCADE;
CREATE OR REPLACE  VIEW v_raci_vulnerability
(
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_vulnerability_id, obj_ser, obj_lm, db_user, e_vuln_id_primary, is_new_published, is_new_scanned, severity, receive_date, triage_date, bi_brand, bi_busops, bi_bussup, bi_intops, bi_comment, ti_unix, ti_windows, ti_network, ti_access, ti_apps, ti_comment, ex_unix, ex_unix_n, ex_windows, ex_windows_n, ex_network, ex_network_n, ex_access, ex_access_n, ex_apps, ex_apps_n, ex_comment, status, ignored, d_priority, d_mav_status, d_mav_target, start_investigate, end_investigate, start_action, end_action, closed_date
)
AS SELECT 
  	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_vulnerability_id, o.obj_ser, o.obj_lm, o.db_user, o.e_vuln_id_primary, o.is_new_published, o.is_new_scanned, o.severity, o.receive_date, o.triage_date, o.bi_brand, o.bi_busops, o.bi_bussup, o.bi_intops, o.bi_comment, o.ti_unix, o.ti_windows, o.ti_network, o.ti_access, o.ti_apps, o.ti_comment, o.ex_unix, o.ex_unix_n, o.ex_windows, o.ex_windows_n, o.ex_network, o.ex_network_n, o.ex_access, o.ex_access_n, o.ex_apps, o.ex_apps_n, o.ex_comment, o.status, o.ignored, o.d_priority, o.d_mav_status, o.d_mav_target, o.start_investigate, o.end_investigate, o.start_action, o.end_action, o.closed_date
FROM e_raci_objects d INNER JOIN vuln.e_vulnerability o ON (d.e_raci_object_type_id = 1  AND d.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_vulnerability_action;
CREATE OR REPLACE  VIEW v_raci_vulnerability_action (
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_vulnerability_action_id, obj_ser, obj_lm, db_user, 
	e_vulnerability_id, changeref, workload, description, priority, 
	mav_status, target_date, hidden, creation_date, closed_date
) 
AS 
SELECT
	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_vulnerability_action_id, o.obj_ser, o.obj_lm, o.db_user, 
	o.e_vulnerability_id, o.changeref, o.workload, o.description, o.priority, 
	o.mav_status, o.target_date, o.hidden, o.creation_date, o.closed_date
FROM e_raci_objects d INNER JOIN vuln.e_vulnerability_action o ON (d.e_raci_object_type_id = 2  AND d.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_vulnerability_vrt;
CREATE  OR REPLACE VIEW v_raci_vulnerability_vrt (
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_vulnerability_vrt_id, obj_ser, obj_lm, db_user,
	start_date, end_date, paused, closed, creation_date
)
AS
SELECT
	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_vulnerability_vrt_id, o.obj_ser, o.obj_lm, o.db_user,
	o.start_date, o.end_date, o.paused, o.closed, o.creation_date
FROM e_raci_objects d INNER JOIN vuln.e_vulnerability_vrt o ON (d.e_raci_object_type_id = 3  AND d.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_module;
CREATE OR REPLACE VIEW v_raci_module (
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_module_id, obj_ser, obj_lm, db_user, 
	shortname, fqn, module_name, class_name, e_module_version_id, 
	license, active
)
AS
SELECT
	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_module_id, o.obj_ser, o.obj_lm, o.db_user,
	o.shortname, o.fqn, o.module_name, o.class_name, o.e_module_version_id, 
	o.license, o.active
FROM e_raci_objects d INNER JOIN public.e_module o ON (d.e_raci_object_type_id = 4  AND d.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_audit;
CREATE OR REPLACE VIEW v_raci_audit (
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_audit_id, obj_ser, obj_lm, db_user,
	audit_origin, audit_topic, 
	creation_date, start_date, end_date, reference, 
	objectives, context, deliverables, audit_scope, 
	e_audit_status_id, e_audit_confidentiality_id, deleted, compliance, e_standard_id
)
AS
SELECT
	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_audit_id, o.obj_ser, o.obj_lm, o.db_user,
	o.audit_origin, o.audit_topic, 
	o.creation_date, o.start_date, o.end_date, o.reference, 
	o.objectives, o.context, o.deliverables, o.audit_scope, 
	o.e_audit_status_id, o.e_audit_confidentiality_id, o.deleted,
	o.compliance, o.e_standard_id
FROM e_raci_objects d INNER JOIN audit.e_audit o ON (d.e_raci_object_type_id = 5  AND d.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_audit_interview;
CREATE OR REPLACE VIEW v_raci_audit_interview (
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_audit_interview_id, obj_ser, obj_lm, db_user,
	e_audit_id, creation_date, auditee, description, interview_date,
	completed, deleted
)
AS
SELECT
	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_audit_interview_id, o.obj_ser, o.obj_lm, o.db_user,
	o.e_audit_id, o.creation_date, o.auditee, o.description, o.interview_date,
	o.completed, o.deleted
FROM e_raci_objects d INNER JOIN audit.e_audit_interview o ON (d.e_raci_object_type_id = 6  AND d.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_audit_document;
CREATE OR REPLACE VIEW v_raci_audit_document (
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_audit_document_id, obj_ser, obj_lm, db_user, 
	e_audit_id, e_audit_rec_id, creation_date, title, description, reference, deleted,
	e_confidentiality_id, verified, e_audit_document_type_id
)
AS
SELECT
	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_audit_document_id, o.obj_ser, o.obj_lm, o.db_user,
	o.e_audit_id, o.e_audit_rec_id, o.creation_date, o.title, o.description, o.reference, o.deleted,
	o.e_confidentiality_id, o.verified, o.e_audit_document_type_id
FROM e_raci_objects d INNER JOIN audit.e_audit_document o ON (d.e_raci_object_type_id = 7  AND d.e_raci_obj = o.e_raci_obj);	

DROP VIEW v_raci_audit_rec;
CREATE OR REPLACE VIEW v_raci_audit_rec (
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_audit_rec_id, obj_ser, obj_lm, db_user,
	audit_report_id, creation_date, reference, title,
	recommendation, rec_status, severity, priority, closed_date,
	primary_topic, secondary_topic, compliance_topic_id, deleted
)
AS
SELECT
	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_audit_rec_id, o.obj_ser, o.obj_lm, o.db_user,
	o.audit_report_id, o.creation_date, o.reference, o.title,
	o.recommendation, o.rec_status, o.severity, o.priority, o.closed_date,
	o.primary_topic, o.secondary_topic, o.compliance_topic_id, o.deleted
FROM e_raci_objects d INNER JOIN audit.e_audit_rec o ON (d.e_raci_object_type_id = 8  AND d.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_audit_rec_auditee;
CREATE OR REPLACE VIEW v_raci_audit_rec_auditee (
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_audit_rec_auditee_id, obj_ser, obj_lm, db_user,
	e_audit_rec_id, auditee_answer, auditee_priority, auditee_severity, target_date, escalade
)
AS
SELECT
	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_audit_rec_auditee_id, o.obj_ser, o.obj_lm, o.db_user,
	o.e_audit_rec_id, o.auditee_answer, o.auditee_priority, o.auditee_severity, o.target_date, o.escalade
FROM e_raci_objects d INNER JOIN audit.e_audit_rec_auditee o ON (d.e_raci_object_type_id = 9  AND d.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_audit_action;
CREATE OR REPLACE VIEW v_raci_audit_action (
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_audit_action_id, obj_ser, obj_lm, db_user,
	rec_id, creation_date, due_date, closed_date, title,
	description, action_status, external_ref, escalade, deleted
)
AS
SELECT
	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_audit_action_id, o.obj_ser, o.obj_lm, o.db_user,
	o.rec_id, o.creation_date, o.due_date, o.closed_date, o.title,
	o.description, o.action_status, o.external_ref, o.escalade, o.deleted
FROM e_raci_objects d INNER JOIN audit.e_audit_action o ON (d.e_raci_object_type_id = 10 AND d.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_audit_report;
CREATE OR REPLACE VIEW v_raci_audit_report (
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_audit_report_id, obj_ser, obj_lm, db_user,
	creation_date, e_audit_id, due_date, title, source, e_status_id,
	sub_title, executive_summary,
	deleted
)
AS
SELECT
	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_audit_report_id, o.obj_ser, o.obj_lm, o.db_user,
	o.creation_date, o.e_audit_id, o.due_date, o.title, o.source, o.e_status_id, o.sub_title, o.executive_summary, o.deleted
FROM e_raci_objects d INNER JOIN audit.e_audit_report o ON (d.e_raci_object_type_id = 11 AND d.e_raci_obj = o.e_raci_obj);


DROP VIEW v_raci_composite_product;
CREATE OR REPLACE VIEW v_raci_composite_product (
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_composite_product_id, obj_ser, obj_lm, db_user, e_product_id
)
AS
SELECT
	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_composite_product_id, o.obj_ser, o.obj_lm, o.db_user, o.e_product_id
FROM e_raci_objects d INNER JOIN asset.e_composite_product o ON (d.e_raci_object_type_id = 12  AND d.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_risk CASCADE;
CREATE OR REPLACE  VIEW v_raci_risk
(
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_risk_id, obj_ser, obj_lm, db_user, creation_date, reference, title, description, expires_by, review_period, forced_review, e_category_id, e_likelihood_id, e_compliance_standard_id
)
AS SELECT 
  	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_risk_id, o.obj_ser, o.obj_lm, o.db_user, o.creation_date, o.reference, o.title, o.description, o.expires_by, o.review_period, o.forced_review, o.e_category_id, o.e_likelihood_id, o.e_compliance_standard_id
FROM e_raci_objects d INNER JOIN risk.e_risk o ON (d.e_raci_object_type_id = 13  AND d.e_raci_obj = o.e_raci_obj);


DROP VIEW v_raci_risk_review CASCADE;
CREATE OR REPLACE  VIEW v_raci_risk_review
(
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_risk_review_id, obj_ser, obj_lm, db_user, e_risk_id, e_organisation_id, reference, treatment_description, e_decision_id, e_priority_id, adequacy_of_controls, e_consequence_level_id, review_date, deleted
)
AS SELECT 
  	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_risk_review_id, o.obj_ser, o.obj_lm, o.db_user, o.e_risk_id, o.e_organisation_id, o.reference, o.treatment_description, o.e_decision_id, o.e_priority_id, o.adequacy_of_controls, o.e_consequence_level_id, o.review_date, o.deleted
FROM e_raci_objects d INNER JOIN risk.e_risk_review o ON (d.e_raci_object_type_id = 14  AND d.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_risk_control CASCADE;
CREATE OR REPLACE  VIEW v_raci_risk_control
(
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_risk_control_id, obj_ser, obj_lm, db_user, e_risk_id, e_risk_review_id, e_impact_id, resource_requirement, deleted, creation_date, description
)
AS SELECT 
  	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_risk_control_id, o.obj_ser, o.obj_lm, o.db_user, o.e_risk_id, o.e_risk_review_id, o.e_impact_id, o.resource_requirement, o.deleted, o.creation_date, o.description
FROM e_raci_objects d INNER JOIN risk.e_risk_control o ON (d.e_raci_object_type_id = 15  AND d.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_risk_action CASCADE;
CREATE OR REPLACE  VIEW v_raci_risk_action
(
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	e_action_id, obj_ser, obj_lm, db_user, e_risk_control_id, e_consequence_id, reference, title, description, target_date, e_status_id, creation_date
)
AS SELECT 
  	d.e_raci_obj, d.e_raci_object_type_id, 
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
	ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
	raci_to_owner(d.e_raci_obj),
	--
	o.e_action_id, o.obj_ser, o.obj_lm, o.db_user, o.e_risk_control_id, o.e_consequence_id, o.reference, o.title, o.description, o.target_date, o.e_status_id, o.creation_date
FROM e_raci_objects d INNER JOIN risk.e_action o ON (d.e_raci_object_type_id = 16  AND d.e_raci_obj = o.e_raci_obj);

-- Third: Get distinct objects managed by raci, their type, sets of people (all, r,a,c,i)
-- ids and all the 'real' object ids, serial#, last modified time and last db_user
--
DROP VIEW v_raci_objects;
CREATE OR REPLACE VIEW v_raci_objects (
	e_raci_obj, e_raci_object_type_id, people, r_s, a_s, c_s, i_s, ra_s, ci_s, owner,
	object_id, obj_ser, obj_lm, db_user
)
AS
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_vulnerability_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN vuln.e_vulnerability o 
		ON (d.e_raci_object_type_id = 1  AND d.e_raci_obj=o.e_raci_obj)	
UNION
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_vulnerability_action_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN vuln.e_vulnerability_action o 
		ON (d.e_raci_object_type_id = 2  AND d.e_raci_obj=o.e_raci_obj)
UNION
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_vulnerability_vrt_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN vuln.e_vulnerability_vrt o 
		ON (d.e_raci_object_type_id = 3  AND d.e_raci_obj=o.e_raci_obj)
UNION
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_module_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN public.e_module o 
		ON (d.e_raci_object_type_id = 4  AND d.e_raci_obj=o.e_raci_obj)
UNION
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_audit_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN audit.e_audit o 
		ON (d.e_raci_object_type_id = 5  AND d.e_raci_obj=o.e_raci_obj)
UNION
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_audit_interview_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN audit.e_audit_interview o 
		ON (d.e_raci_object_type_id = 6  AND d.e_raci_obj=o.e_raci_obj)
UNION
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_audit_document_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN audit.e_audit_document o 
		ON (d.e_raci_object_type_id = 7  AND d.e_raci_obj=o.e_raci_obj)
UNION
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_audit_rec_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN audit.e_audit_rec o 
		ON (d.e_raci_object_type_id = 8  AND d.e_raci_obj=o.e_raci_obj)
UNION
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_audit_rec_auditee_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN audit.e_audit_rec_auditee o 
		ON (d.e_raci_object_type_id = 9  AND d.e_raci_obj=o.e_raci_obj)
UNION
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_audit_action_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN audit.e_audit_action o 
		ON (d.e_raci_object_type_id = 10 AND d.e_raci_obj=o.e_raci_obj)
UNION
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_audit_report_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN audit.e_audit_report o 
		ON (d.e_raci_object_type_id = 11  AND d.e_raci_obj=o.e_raci_obj)
UNION
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_composite_product_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN asset.e_composite_product o 
		ON (d.e_raci_object_type_id = 12  AND d.e_raci_obj=o.e_raci_obj)
UNION
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_risk_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN risk.e_risk o 
		ON (d.e_raci_object_type_id = 13  AND d.e_raci_obj=o.e_raci_obj)
UNION
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_risk_review_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN risk.e_risk_review o 
		ON (d.e_raci_object_type_id = 14  AND d.e_raci_obj=o.e_raci_obj)
UNION
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_risk_review_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN risk.e_risk_control o 
		ON (d.e_raci_object_type_id = 15  AND d.e_raci_obj=o.e_raci_obj)
UNION
	SELECT
		d.e_raci_obj, d.e_raci_object_type_id, 
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.r),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.a),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.c),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND r.i),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.r OR r.a)),
		ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=d.e_raci_obj AND r.e_raci_object_type_id=d.e_raci_object_type_id AND r.e_people_id <> 0 AND (r.c OR r.i)),
		raci_to_owner(d.e_raci_obj),
		--
		o.e_action_id, o.obj_ser, o.obj_lm, o.db_user
	FROM e_raci_objects d 
		INNER JOIN risk.e_action o 
		ON (d.e_raci_object_type_id = 16  AND d.e_raci_obj=o.e_raci_obj)
;	

-- Fourth: for each object *and* each person get individual and full raci
-- along with directory and object details.  Objects will be repeated...
DROP VIEW v_raci_people_objects;
CREATE OR REPLACE VIEW v_raci_people_objects (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s, object_id, obj_ser, obj_lm, db_user
)
AS
SELECT  
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	v.people, v.r_s, v.a_s, v.c_s, v.i_s, v.ra_s, v.ci_s, v.object_id, v.obj_ser, v.obj_lm, v.db_user
FROM v_raci_people r LEFT OUTER JOIN v_raci_objects v ON (r.e_raci_obj = v.e_raci_obj AND r.e_raci_object_type_id = v.e_raci_object_type_id);

-- And again, for each type of object
DROP VIEW v_raci_people_vulnerability;
CREATE OR REPLACE VIEW v_raci_people_vulnerability (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_vulnerability_id, obj_ser, obj_lm, db_user, e_vuln_id_primary, is_new_published, is_new_scanned, severity, receive_date, triage_date, bi_brand, bi_busops, bi_bussup, bi_intops, bi_comment, ti_unix, ti_windows, ti_network, ti_access, ti_apps, ti_comment, ex_unix, ex_unix_n, ex_windows, ex_windows_n, ex_network, ex_network_n, ex_access, ex_access_n, ex_apps, ex_apps_n, ex_comment, status, ignored, d_priority, d_mav_status, d_mav_target, start_investigate, end_investigate, start_action, end_action, closed_date
) AS SELECT 
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_vulnerability_id, o.obj_ser, o.obj_lm, o.db_user, o.e_vuln_id_primary, o.is_new_published, o.is_new_scanned, o.severity, o.receive_date, o.triage_date, o.bi_brand, o.bi_busops, o.bi_bussup, o.bi_intops, o.bi_comment, o.ti_unix, o.ti_windows, o.ti_network, o.ti_access, o.ti_apps, o.ti_comment, o.ex_unix, o.ex_unix_n, o.ex_windows, o.ex_windows_n, o.ex_network, o.ex_network_n, o.ex_access, o.ex_access_n, o.ex_apps, o.ex_apps_n, o.ex_comment, o.status, o.ignored, o.d_priority, o.d_mav_status, o.d_mav_target, o.start_investigate, o.end_investigate, o.start_action, o.end_action, o.closed_date
FROM v_raci_people r INNER JOIN v_raci_vulnerability o ON (1  = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_people_vulnerability_action;
CREATE OR REPLACE VIEW v_raci_people_vulnerability_action (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_vulnerability_action_id, obj_ser, obj_lm, db_user, 
	e_vulnerability_id, changeref, workload, description, priority, 
	mav_status, target_date, hidden, creation_date, closed_date
) AS SELECT
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_vulnerability_action_id, o.obj_ser, o.obj_lm, o.db_user, 
	o.e_vulnerability_id, o.changeref, o.workload, o.description, o.priority, 
	o.mav_status, o.target_date, o.hidden, o.creation_date, o.closed_date
FROM v_raci_people r INNER JOIN v_raci_vulnerability_action o ON (2  = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_people_vulnerability_vrt;
CREATE OR REPLACE VIEW v_raci_people_vulnerability_vrt (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_vulnerability_vrt_id, obj_ser, obj_lm, db_user,
	start_date, end_date, paused, closed, creation_date
) AS SELECT
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_vulnerability_vrt_id, o.obj_ser, o.obj_lm, o.db_user,
	o.start_date, o.end_date, o.paused, o.closed, o.creation_date
FROM v_raci_people r INNER JOIN v_raci_vulnerability_vrt o ON (3  = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_people_module;
CREATE OR REPLACE VIEW v_raci_people_module (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_module_id, obj_ser, obj_lm, db_user, 
	shortname, fqn, module_name, class_name, e_module_version_id, 
	license, active
) AS SELECT
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_module_id, o.obj_ser, o.obj_lm, o.db_user,
	o.shortname, o.fqn, o.module_name, o.class_name, o.e_module_version_id, 
	o.license, o.active
FROM v_raci_people r INNER JOIN v_raci_module o ON (4  = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_people_audit;
CREATE OR REPLACE VIEW v_raci_people_audit (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_audit_id, obj_ser, obj_lm, db_user,
	audit_origin, audit_topic, 
	creation_date, start_date, end_date, reference, 
	objectives, context, deliverables, audit_scope, 
	e_audit_status_id, e_audit_confidentiality_id, deleted,
	compliance, e_standard_id
) AS SELECT
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_audit_id, o.obj_ser, o.obj_lm, o.db_user,
	o.audit_origin, o.audit_topic, 
	o.creation_date, o.start_date, o.end_date, o.reference, 
	o.objectives, o.context, o.deliverables, o.audit_scope, 
	o.e_audit_status_id, o.e_audit_confidentiality_id, o.deleted,
	o.compliance, o.e_standard_id
FROM v_raci_people r INNER JOIN v_raci_audit o ON (5  = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_people_audit_interview;
CREATE OR REPLACE VIEW v_raci_people_audit_interview (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_audit_interview_id, obj_ser, obj_lm, db_user,
	e_audit_id, creation_date, auditee, description, interview_date,
	completed, deleted
) AS SELECT
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_audit_interview_id, o.obj_ser, o.obj_lm, o.db_user,
	o.e_audit_id, o.creation_date, o.auditee, o.description, o.interview_date,
	o.completed, o.deleted
FROM v_raci_people r INNER JOIN v_raci_audit_interview o ON (6  = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_people_audit_document;
CREATE OR REPLACE VIEW v_raci_people_audit_document (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_audit_document_id, obj_ser, obj_lm, db_user,
	e_audit_id, e_audit_rec_id, creation_date, title, description, reference, deleted,
	e_confidentiality_id, verified, e_audit_document_type_id
) AS SELECT
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_audit_document_id, o.obj_ser, o.obj_lm, o.db_user,
	o.e_audit_id, o.e_audit_rec_id, o.creation_date, o.title, o.description, o.reference, o.deleted,
	o.e_confidentiality_id, o.verified, o.e_audit_document_type_id
FROM v_raci_people r INNER JOIN v_raci_audit_document o ON (7  = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_people_audit_rec;
CREATE OR REPLACE VIEW v_raci_people_audit_rec (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_audit_rec_id, obj_ser, obj_lm, db_user,
	audit_report_id, creation_date, reference, title,
	recommendation, rec_status, severity, priority, closed_date,
	primary_topic, secondary_topic, deleted, compliance_topic_id
) AS SELECT
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_audit_rec_id, o.obj_ser, o.obj_lm, o.db_user,
	o.audit_report_id, o.creation_date, o.reference, o.title,
	o.recommendation, o.rec_status, o.severity, o.priority, o.closed_date,
	o.primary_topic, o.secondary_topic, o.deleted, o.compliance_topic_id
FROM v_raci_people r INNER JOIN v_raci_audit_rec o ON (8  = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_people_audit_rec_auditee;
CREATE OR REPLACE VIEW v_raci_people_audit_rec_auditee (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_audit_rec_auditee_id, obj_ser, obj_lm, db_user,
	e_audit_rec_id, auditee_answer, auditee_priority, auditee_severity, target_date, escalade
) AS SELECT
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_audit_rec_auditee_id, o.obj_ser, o.obj_lm, o.db_user,
	o.e_audit_rec_id, o.auditee_answer, o.auditee_priority, o.auditee_severity, o.target_date, o.escalade
FROM v_raci_people r INNER JOIN v_raci_audit_rec_auditee o ON (9  = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_people_audit_action;
CREATE OR REPLACE VIEW v_raci_people_audit_action (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_audit_action_id, obj_ser, obj_lm, db_user,
	rec_id, creation_date, due_date, closed_date, title,
	description, action_status, external_ref, deleted, escalade
) AS SELECT
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_audit_action_id, o.obj_ser, o.obj_lm, o.db_user,
	o.rec_id, o.creation_date, o.due_date, o.closed_date, o.title,
	o.description, o.action_status, o.external_ref, o.deleted, o.escalade
FROM v_raci_people r INNER JOIN v_raci_audit_action o ON (10 = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_people_audit_report;
CREATE OR REPLACE VIEW v_raci_people_audit_report (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_audit_report_id, obj_ser, obj_lm, db_user,
	creation_date, e_audit_id, due_date, title, source, e_status_id,
	sub_title, executive_summary,
	deleted
) AS SELECT
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_audit_report_id, o.obj_ser, o.obj_lm, o.db_user,
	o.creation_date, o.e_audit_id, o.due_date, o.title, o.source, o.e_status_id, o.sub_title, o.executive_summary, o.deleted
FROM v_raci_people r INNER JOIN v_raci_audit_report o ON (11 = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_people_composite_product;
CREATE OR REPLACE VIEW v_raci_people_composite_product (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_composite_product_id, obj_ser, obj_lm, db_user, e_product_id
) AS SELECT
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_composite_product_id, o.obj_ser, o.obj_lm, o.db_user, o.e_product_id
FROM v_raci_people r INNER JOIN v_raci_composite_product o ON (12  = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_people_risk;
CREATE OR REPLACE VIEW v_raci_people_risk (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_risk_id, obj_ser, obj_lm, db_user, creation_date, reference, title, description, expires_by, review_period, forced_review, e_category_id, e_likelihood_id, e_compliance_standard_id
) AS SELECT
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_risk_id, o.obj_ser, o.obj_lm, o.db_user, o.creation_date, o.reference, o.title, o.description, o.expires_by, o.review_period, o.forced_review, o.e_category_id, o.e_likelihood_id, o.e_compliance_standard_id
FROM v_raci_people r INNER JOIN v_raci_risk o ON (13  = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);


DROP VIEW v_raci_people_risk_review CASCADE;
CREATE OR REPLACE  VIEW v_raci_people_risk_review (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_risk_review_id, obj_ser, obj_lm, db_user, e_risk_id, e_organisation_id, reference, treatment_description, e_decision_id, e_priority_id, adequacy_of_controls, e_consequence_level_id, review_date, deleted
) AS SELECT
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_risk_review_id, o.obj_ser, o.obj_lm, o.db_user, o.e_risk_id, o.e_organisation_id, o.reference, o.treatment_description, o.e_decision_id, o.e_priority_id, o.adequacy_of_controls, o.e_consequence_level_id, o.review_date, o.deleted
FROM v_raci_people r INNER JOIN v_raci_risk_review o ON (14 = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_people_risk_control CASCADE;
CREATE OR REPLACE  VIEW v_raci_people_risk_control (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_risk_control_id, obj_ser, obj_lm, db_user, e_risk_id, e_risk_review_id, e_impact_id, resource_requirement, deleted, creation_date, description
) AS SELECT
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_risk_control_id, o.obj_ser, o.obj_lm, o.db_user, o.e_risk_id, o.e_risk_review_id, o.e_impact_id, o.resource_requirement, o.deleted, o.creation_date, o.description
FROM v_raci_people r INNER JOIN v_raci_risk_control o ON (15 = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);

DROP VIEW v_raci_people_risk_action CASCADE;
CREATE OR REPLACE  VIEW v_raci_people_risk_action (
	e_raci_obj, e_people_id, e_raci_object_type_id, r, a, c, i,
	user_name, passwd, first_name, last_name, display_name, phone, email, e_location_id, ppl_creation_date, last_mod_date, e_company_id, disabled, is_admin,
	people, r_s, a_s, c_s, i_s, ra_s, ci_s,
	e_action_id, obj_ser, obj_lm, db_user, e_risk_control_id, e_consequence_id, reference, title, description, target_date, e_status_id, creation_date
) AS SELECT
	r.e_raci_obj, r.e_people_id, r.e_raci_object_type_id, r.r, r.a, r.c, r.i,
	r.user_name, r.passwd, r.first_name, r.last_name, r.display_name, r.phone, r.email, r.e_location_id, r.creation_date, r.last_mod_date, r.e_company_id, r.disabled, r.is_admin,
	o.people, o.r_s, o.a_s, o.c_s, o.i_s, o.ra_s, o.ci_s,
	o.e_action_id, o.obj_ser, o.obj_lm, o.db_user, o.e_risk_control_id, o.e_consequence_id, o.reference, o.title, o.description, o.target_date, o.e_status_id, o.creation_date
FROM v_raci_people r INNER JOIN v_raci_risk_action o ON (16 = r.e_raci_object_type_id AND r.e_raci_obj = o.e_raci_obj);


CREATE OR REPLACE FUNCTION raci_en_name_vulnerability(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result (evr.vuln_name) 
			FROM vuln.e_vulnerability ev INNER JOIN vuln.e_vulnerability_reports evr ON ev.e_vuln_id_primary = evr.e_vuln_id
			WHERE ev.e_raci_obj = e_raci_obj LIMIT 1;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

CREATE OR REPLACE FUNCTION raci_en_name_vulnerability_action(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result ('action ' || coalesce('ref: ' || eva.changeref, '# ' || e_vulnerability_action_id ) ||' for vulnerability ' || evr.vuln_name) 
			FROM vuln.e_vulnerability_action eva INNER JOIN vuln.e_vulnerability ev ON (eva.e_vulnerability_id = ev.e_vulnerability_id)
				INNER JOIN vuln.e_vulnerability_reports evr ON (ev.e_vuln_id_primary = evr.e_vuln_id)
			WHERE eva.e_raci_obj = e_raci_obj;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

CREATE OR REPLACE FUNCTION raci_en_name_vulnerability_vrt(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result ('VRT Meeting ' || coalesce(('started on ' || date(vrt.start_date)), 'not yet started'))
			FROM vuln.e_vulnerability_vrt vrt
			WHERE vrt.e_raci_obj = e_raci_obj;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

CREATE OR REPLACE FUNCTION raci_en_name_module(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result (m.fqn)
			FROM e_module m
			WHERE m.e_raci_obj = e_raci_obj;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

CREATE OR REPLACE FUNCTION raci_en_name_audit(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result ('Audit (ref :' || aud.reference || ')')
			FROM audit.e_audit aud
			WHERE aud.e_raci_obj = e_raci_obj;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

CREATE OR REPLACE FUNCTION raci_en_name_audit_report(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result ('Audit report ' || coalesce('title: ' || rep.title, '# ' || rep.e_audit_report_id ))
			FROM audit.e_audit_report rep
			WHERE rep.e_raci_obj = e_raci_obj;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

CREATE OR REPLACE FUNCTION raci_en_name_audit_interview(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result ('Interview for audit ' || aud.reference)
			FROM audit.e_audit_interview itw INNER JOIN audit.e_audit aud ON (itw.e_audit_id = aud.e_audit_id)
			WHERE itw.e_raci_obj = e_raci_obj;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

CREATE OR REPLACE FUNCTION raci_en_name_audit_document(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result ('Document '|| doc.reference || ' for audit ' || aud.reference)
			FROM audit.e_audit_document doc INNER JOIN audit.e_audit aud ON (doc.e_audit_id = aud.e_audit_id)
			WHERE doc.e_raci_obj = e_raci_obj;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

CREATE OR REPLACE FUNCTION raci_en_name_audit_rec(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result ('Recommendation auditor (ref :' || rec.reference || ')')
			FROM audit.e_audit_rec rec
			WHERE rec.e_raci_obj = e_raci_obj;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

CREATE OR REPLACE FUNCTION raci_en_name_audit_rec_auditee(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result ('Recommendation auditee (ref :' || rec.reference || ')')
			FROM audit.e_audit_rec_auditee recaud INNER JOIN audit.e_audit_rec rec ON (recaud.e_audit_rec_id = rec.e_audit_rec_id)
			WHERE recaud.e_raci_obj = e_raci_obj;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

CREATE OR REPLACE FUNCTION raci_en_name_audit_action(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result ('Action for recommendation ' || rec.reference)
			FROM audit.e_audit_action act INNER JOIN audit.e_audit_rec rec ON (act.rec_id = rec.e_audit_rec_id)
			WHERE act.e_raci_obj = e_raci_obj;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

CREATE OR REPLACE FUNCTION raci_en_name_asset_composite_product(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result ('Composite product ' || p.name)
			FROM asset.e_composite_product c INNER JOIN asset.e_product p ON (p.e_product_id = c.e_product_id)
			WHERE c.e_raci_obj = e_raci_obj;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

CREATE OR REPLACE FUNCTION raci_en_name_risk(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result ('Risk ' || r.title)
			FROM risk.e_risk r
			WHERE r.e_raci_obj = e_raci_obj;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

CREATE OR REPLACE FUNCTION raci_en_name_risk_review(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result ('Risk Review for risk ' || r.title || coalesce((' reviewed on ' || date(rr.review_date)), ' not yet reviewed'))
			FROM risk.e_risk_review rr INNER JOIN risk.e_risk r ON r.e_risk_id = rr.e_risk_id
			WHERE rr.e_raci_obj = e_raci_obj;
	        return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

CREATE OR REPLACE FUNCTION raci_en_name_risk_control(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result ('Risk Control for risk ' || r.title)
			FROM risk.e_risk_control rc INNER JOIN risk.e_risk r ON r.e_risk_id = rc.e_risk_id
			WHERE rc.e_raci_obj = e_raci_obj;
	        return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

CREATE OR REPLACE FUNCTION raci_en_name_risk_action(e_raci_obj IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		SELECT INTO result ('Action ' || r.title)
			FROM risk.e_action r
			WHERE r.e_raci_obj = e_raci_obj;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

-- get the name of the module from looking at e_raci_object_type_id
CREATE OR REPLACE FUNCTION module_en_name(e_raci_object_type_id IN integer) RETURNS text AS $fn$
	DECLARE result text;
	BEGIN
		IF (e_raci_object_type_id = 4) THEN
			return 'Modules'; -- not in database
		ELSE
			SELECT INTO result m.module_name
				FROM e_raci_object_type ty LEFT OUTER JOIN e_module m ON (ty.module_class = m.class_name)
				WHERE ty.e_raci_object_type_id = e_raci_object_type_id
				LIMIT 1
			;
			return result;
		END IF;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

-- view to get the module + name out of the sql.
DROP VIEW v_raci_names;
CREATE OR REPLACE VIEW v_raci_names(
	r,a,c,i, e_people_id, e_raci_obj, user_name, first_name, last_name, display_name, email, description, e_raci_object_type_id, module_name, name
) AS (
	SELECT r, a, c, i, e_people_id, e_raci_obj, user_name, first_name, last_name, display_name, email, ty.description, v.e_raci_object_type_id, 
		module_en_name(v.e_raci_object_type_id), 
		CASE
			WHEN v.e_raci_object_type_id = 1  THEN
				raci_en_name_vulnerability(e_raci_obj)
			WHEN v.e_raci_object_type_id = 2  THEN
				raci_en_name_vulnerability_action(e_raci_obj)
			WHEN v.e_raci_object_type_id = 3  THEN
				raci_en_name_vulnerability_vrt(e_raci_obj)
			WHEN v.e_raci_object_type_id = 4  THEN
				raci_en_name_module(e_raci_obj)
			WHEN v.e_raci_object_type_id = 5  THEN
				raci_en_name_audit(e_raci_obj)
			WHEN v.e_raci_object_type_id = 6  THEN
				raci_en_name_audit_interview(e_raci_obj)
			WHEN v.e_raci_object_type_id = 7  THEN
				raci_en_name_audit_document(e_raci_obj)
			WHEN v.e_raci_object_type_id = 8  THEN
				raci_en_name_audit_rec(e_raci_obj)
			WHEN v.e_raci_object_type_id = 9  THEN
				raci_en_name_audit_rec_auditee(e_raci_obj)
			WHEN v.e_raci_object_type_id = 10 THEN
				raci_en_name_audit_action(e_raci_obj)
			WHEN v.e_raci_object_type_id = 11 THEN
				raci_en_name_audit_report(e_raci_obj)
			WHEN v.e_raci_object_type_id = 12 THEN
				raci_en_name_asset_composite_product(e_raci_obj)
			WHEN v.e_raci_object_type_id = 13 THEN
				raci_en_name_risk(e_raci_obj)
			WHEN v.e_raci_object_type_id = 14 THEN
				raci_en_name_risk_review(e_raci_obj)
			WHEN v.e_raci_object_type_id = 15 THEN
				raci_en_name_risk_control(e_raci_obj)
			WHEN v.e_raci_object_type_id = 16 THEN
				raci_en_name_risk_action(e_raci_obj)
			ELSE
				NULL
		END
	FROM
		v_raci_people_objects v LEFT OUTER JOIN e_raci_object_type ty ON (v.e_raci_object_type_id = ty.e_raci_object_type_id)
	WHERE
		e_people_id <> 0 -- disallow anonymous
);


-- view to get raci elements with a target date
DROP VIEW v_raci_target CASCADE;
CREATE OR REPLACE VIEW v_raci_target(
        e_raci_obj, target_date, name, obj_id, obj_ser
) AS (
        SELECT e_raci_obj, d_mav_target, raci_en_name_vulnerability(e_raci_obj), e_vulnerability_id, obj_ser
        FROM vuln.e_vulnerability
        WHERE d_mav_target IS NOT NULL
        UNION
        SELECT e_raci_obj, target_date, raci_en_name_vulnerability_action(e_raci_obj), e_vulnerability_action_id, obj_ser
        FROM vuln.e_vulnerability_action
        WHERE target_date IS NOT NULL
        UNION
        SELECT e_raci_obj, end_date, raci_en_name_audit(e_raci_obj), e_audit_id, obj_ser
        FROM audit.e_audit
        WHERE NOT deleted AND end_date IS NOT NULL
        UNION
        SELECT e_raci_obj, interview_date, raci_en_name_audit_interview(e_raci_obj), e_audit_interview_id, obj_ser
        FROM audit.e_audit_interview
        WHERE NOT deleted AND interview_date IS NOT NULL
        UNION
        SELECT e_raci_obj, due_date, raci_en_name_audit_report(e_raci_obj), e_audit_report_id, obj_ser
        FROM audit.e_audit_report
        WHERE NOT deleted AND due_date IS NOT NULL
        UNION
        SELECT ree.e_raci_obj, target_date, raci_en_name_audit_rec_auditee(ree.e_raci_obj), ree.e_audit_rec_id, ree.obj_ser
        FROM audit.e_audit_rec_auditee ree
        INNER JOIN audit.e_audit_rec ror ON ror.e_audit_rec_id = ree.e_audit_rec_id
        WHERE NOT ror.deleted AND target_date IS NOT NULL
        UNION
        SELECT e_raci_obj, due_date, raci_en_name_audit_action(e_raci_obj), e_audit_action_id, obj_ser
        FROM audit.e_audit_action
        WHERE NOT deleted AND due_date IS NOT NULL
        UNION
        SELECT e_raci_obj, target_date, raci_en_name_risk_action(e_raci_obj), e_action_id, obj_ser
        FROM risk.e_action
        WHERE target_date IS NOT NULL
);

-- view to get raci elements with a target date and their raci matrix
DROP VIEW v_raci_people_target CASCADE;
CREATE OR REPLACE VIEW v_raci_people_target(
        e_raci_obj, target_date, name, obj_id, obj_ser, people, r_s, a_s, c_s, i_s, ra_s, ci_s
) AS (
        SELECT t.e_raci_obj, t.target_date, t.name, t.obj_id, t.obj_ser,
        ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=t.e_raci_obj AND r.e_people_id <> 0),
        ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=t.e_raci_obj AND r.e_people_id <> 0 AND r.r),
        ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=t.e_raci_obj AND r.e_people_id <> 0 AND r.a),
        ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=t.e_raci_obj AND r.e_people_id <> 0 AND r.c),
        ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=t.e_raci_obj AND r.e_people_id <> 0 AND r.i),
        ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=t.e_raci_obj AND r.e_people_id <> 0 AND (r.r OR r.a)),
        ARRAY(SELECT e_people_id FROM e_raci r WHERE r.e_raci_obj=t.e_raci_obj AND r.e_people_id <> 0 AND (r.c OR r.i))
        FROM v_raci_target AS t 
);