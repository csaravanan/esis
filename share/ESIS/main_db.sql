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
-- $Id: multi_tables.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--

--
-- bug2531
--
-- make triggers and 'index' tables possible for having many tables share a unique contraint
--


CREATE OR REPLACE FUNCTION  create_trgfn_maint_mkey(
		schema		text,	-- eg 'vuln'
		main_table	text,	-- eg 'i_vuln'
		keycheck_table	text,	-- eg 't_vuln_keycheck'
		variable_names	text[]	-- eg ARRAY['e_vuln_id', 'vuln_name']
) RETURNS void AS $create_trgfn_maint_mkey$
	DECLARE
		i		integer;
		del_stmt	text;
		ins_stmt	text;
		upd_stmt	text;
	BEGIN -- procedure create_trgfn_maint_mkey

		del_stmt := 'DELETE FROM ' || schema || '.' || keycheck_table || ' WHERE ';
		ins_stmt := 'INSERT INTO ' || schema || '.' || keycheck_table || ' (';
		upd_stmt := 'UPDATE ' || schema || '.' || keycheck_table || ' SET ';

		FOR i IN array_lower(variable_names, 1) .. array_upper(variable_names, 1) LOOP
			IF (i > 1) THEN
				del_stmt := del_stmt || ' AND ';
				ins_stmt := ins_stmt || ', ';
				upd_stmt := upd_stmt || ', ';
			END IF;
			del_stmt := del_stmt || variable_names[i] || ' = OLD.' || variable_names[i];
			ins_stmt := ins_stmt || variable_names[i];
			upd_stmt := upd_stmt || variable_names[i] || ' = NEW.' || variable_names[i];
		END LOOP;

		ins_stmt := ins_stmt || ') VALUES (';
		upd_stmt := upd_stmt || ' WHERE ';

		FOR i IN array_lower(variable_names, 1) .. array_upper(variable_names, 1) LOOP
			IF (i > 1) THEN
				ins_stmt := ins_stmt || ', ';
				upd_stmt := upd_stmt || ' AND ';
			END IF;
			ins_stmt := ins_stmt || 'NEW.' || variable_names[i];
			upd_stmt := upd_stmt || variable_names[i] || ' = OLD.' || variable_names[i];
		END LOOP;

		ins_stmt := ins_stmt || ')';

EXECUTE $exec$
CREATE OR REPLACE FUNCTION  trgfn_$exec$ || keycheck_table || '_' || main_table || $exec$() RETURNS TRIGGER AS $trig$
	DECLARE
		-- no parameters
	BEGIN	-- trgfn
		IF	(TG_OP = 'DELETE') THEN
			-- DELETE FROM keycheck_table WHERE k1 = OLD.k1 AND k2 = OLD.k2
			$exec$ || del_stmt || $exec$
			;
			RETURN OLD; -- because it is a delete
		ELSIF	(TG_OP = 'INSERT') THEN
			-- INSERT INTO keycheck_table (k1, k2) VALUES (NEW.k1, NEW.k2);
			$exec$ || ins_stmt || $exec$
			;
		ELSIF	(TG_OP = 'UPDATE') THEN
			-- UPDATE keycheck_table SET k1 = NEW.k1 AND k2 = NEW.k2 WHERE k1 = OLD.k1 AND k2 = OLD.k2;
			$exec$ || upd_stmt || $exec$
			;
		END IF;

		RETURN NEW;
	END;	-- trgfn
$trig$ LANGUAGE plpgsql;

CREATE TRIGGER	trg_$exec$ || keycheck_table || '_' || main_table || $exec$
	BEFORE INSERT OR UPDATE OR DELETE ON $exec$ || schema || '.' || main_table || $exec$
	FOR EACH ROW EXECUTE PROCEDURE trgfn_$exec$ || keycheck_table || '_' || main_table || $exec$();

$exec$; -- end of massive dynamic code block
	END;	-- procedure create_trgfn_maint_mkey
$create_trgfn_maint_mkey$ LANGUAGE plpgsql;
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
-- $Id: object_audit.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


--
-- bug1590
--
-- ensure concurrent modifications to an object (whatever you want it to be)
-- are de-duplicated by the server
--

CREATE SEQUENCE e_object_audit_serial START 1024;

CREATE TABLE e_object_audit (
	obj_ser			integer		NOT NULL, -- trigger function sets this to e_object_audit_serial
	obj_lm			timestamptz	NOT NULL, -- trigger function sets this to current_timestamp
	db_user			text		NOT NULL, -- trigger function sets this to current_user
	modification		char(1)		NOT NULL, -- values 'D'elete 'U'pdate and 'I'nsert
	table_name		name		NOT NULL, -- trigger function sets this to current table (without schema)
	pkey			integer		NOT NULL
);

-- function to create a trigger function per-table being analysed and install trigger calling that trigger function.
-- trigger function tracks table primary key (int from serial generator) and sequence.
-- trigger function writes serial number information into audit_table and 'real' table before updates.
--
-- schema 
-- table
-- primary key name
-- primary key serial generator name
--
CREATE OR REPLACE FUNCTION create_trgfn_maint_object_audit(
	my_schema IN text, 
	my_table IN text, 
	pkey_name IN text, 
	pkey_serial IN text
) RETURNS void AS $create_trgfn_maint_object_audit$
	DECLARE	-- local variables
		identifier	text;
		schema_table	text;
		schema_serial	text;
	BEGIN -- procedure create_trgfn_main_object_audit

		schema_table	:= my_schema || '.' || my_table;
		schema_serial	:= my_schema || '.' || pkey_serial;
		identifier	:= my_schema || '_' || my_table;

		-- now execute create function...
EXECUTE $exec$
CREATE OR REPLACE FUNCTION trgfn_$exec$ || identifier || $exec$() RETURNS TRIGGER AS $trig$
	DECLARE
              -- no parameters
              -- local variables
		new_obj_ser	integer;
		new_obj_lm	timestamptz;
	BEGIN -- procedure trgfn_XYZ

		-- create values to be inserted...
		new_obj_ser  := nextval('e_object_audit_serial');
		new_obj_lm   := current_timestamp;

		-- behaviour depends on the operation type...
		IF    (TG_OP = 'DELETE') THEN

			INSERT INTO e_object_audit (db_user, obj_ser, obj_lm, table_name, modification, pkey)
				VALUES (current_user, new_obj_ser, new_obj_lm, $exec$ || quote_literal(schema_table) || $exec$, 'D', OLD.$exec$ || quote_ident(pkey_name) || $exec$);
			RETURN OLD; -- because it is a delete

		ELSIF (TG_OP = 'INSERT') THEN

			IF (NEW.$exec$ || quote_ident(pkey_name) || $exec$ IS NULL) THEN
				NEW.$exec$ || quote_ident(pkey_name) || $exec$ := nextval($exec$ || quote_literal(schema_serial) || $exec$);			
			END IF;
	
			INSERT INTO e_object_audit (db_user, obj_ser, obj_lm, table_name, modification, pkey)
				VALUES (current_user, new_obj_ser, new_obj_lm, $exec$ || quote_literal(schema_table) || $exec$, 'I', NEW.$exec$ || quote_ident(pkey_name) || $exec$);

		ELSIF (TG_OP = 'UPDATE') THEN
			-- check to see if bad software is modifying a primary key?
			IF (OLD.$exec$ || quote_ident(pkey_name) || $exec$ <> NEW.$exec$ || quote_ident(pkey_name) || $exec$) THEN 
				RAISE EXCEPTION 'Cannot modify the value of $exec$ || pkey_name || ' for ' || schema_table || $exec$';
			END IF;
			INSERT INTO e_object_audit (db_user, obj_ser, obj_lm, table_name, modification, pkey)
				VALUES (current_user, new_obj_ser, new_obj_lm, $exec$ || quote_literal(schema_table) || $exec$, 'U', NEW.$exec$ || quote_ident(pkey_name) || $exec$);

		END IF;

		-- finally copy this into the trigger's row data:
		NEW.db_user := current_user;
		NEW.obj_ser := new_obj_ser;
		NEW.obj_lm  := new_obj_lm;
		RETURN NEW; -- this is for the row to be inserted.
	END; -- procedure trgfn_XYZ
$trig$ LANGUAGE plpgsql;

CREATE TRIGGER trg_$exec$ || identifier || $exec$ BEFORE INSERT OR UPDATE OR DELETE ON $exec$ || schema_table || $exec$
	FOR EACH ROW EXECUTE PROCEDURE trgfn_$exec$ || identifier || $exec$();

$exec$; -- end of massive dynamic code block


	END; -- procedure create_trgfn_maint_object_audit
$create_trgfn_maint_object_audit$ LANGUAGE plpgsql;
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
-- $Id: raci_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


-- ESIS Security DataWarehouse schema - install as user 'entelligence'
--
-- contains: ESIS RACI model

CREATE SEQUENCE e_raci_obj_serial START 4096;
CREATE TABLE e_raci (
       e_raci_obj		int	NOT NULL,
       e_people_id		int	NOT NULL,
	   e_raci_object_type_id    int     NOT NULL,
       r 			boolean	NOT NULL,
       a			boolean NOT NULL,
       c			boolean NOT NULL,
       i			boolean NOT NULL
);
CREATE INDEX e_raci_idx ON e_raci (e_raci_obj, e_people_id);

-- keep raci sane...  one entry per person.  only Anonymous entry when
-- no other people referenced.
--
-- run this before actually INSERTing/UPDATEing the data, delete
-- anonymous and previous versions of a given user's raci before inserting
-- the real data.
--
CREATE OR REPLACE FUNCTION trgfn_maint_e_raci_before() RETURNS TRIGGER AS $trig$
        DECLARE
        BEGIN
			IF (NEW.e_raci_object_type_id < 1 OR NEW.e_raci_object_type_id > 16) THEN
				RAISE EXCEPTION 'Unknown raci type id.';
			END IF;

                IF      (TG_OP = 'INSERT') THEN

					-- If we're adding a 0 user and there are already rows for other users in the database then silently ignore this.
					IF (NEW.e_people_id = 0 AND (EXISTS (SELECT * FROM e_raci WHERE e_raci_obj=NEW.e_raci_obj AND e_raci_object_type_id=NEW.e_raci_object_type_id AND e_people_id <> 0))) THEN
						RETURN NULL; -- don't add anonymous if non-anon users present in the database.
					END IF;
					
                    -- Inserting 2nd RACI for any person removes previous version.
                    DELETE FROM e_raci WHERE e_raci_obj=NEW.e_raci_obj AND e_raci_object_type_id=NEW.e_raci_object_type_id AND e_people_id=NEW.e_people_id;

                ELSIF    (TG_OP = 'UPDATE') THEN
                    
    				-- can't re-add the anonymous user
                    IF (OLD.e_people_id <> 0 AND NEW.e_people_id = 0) THEN
                    	RAISE EXCEPTION 'Cannot reassign RACI to Anonymous.';
                    END IF;
    				-- if 0 is updated to !0 this is ok we don't need to do any maintenance.

					-- can't modify e_raci_obj, can't modify person
					IF (OLD.e_raci_obj <> NEW.e_raci_obj) THEN
						RAISE EXCEPTION 'Cannot reassign RACI object.';
					END IF;
					
					IF (OLD.e_people_id <> NEW.e_people_id) THEN
						RAISE EXCEPTION 'Cannot reassign RACI person.';
					END IF;
					
					-- don't need to delete 0 user items as this is not an insert.
                END IF;
                RETURN NEW;
        END;
$trig$ LANGUAGE plpgsql;

CREATE TRIGGER trg_maint_e_raci_before BEFORE INSERT OR UPDATE ON e_raci
      FOR EACH ROW EXECUTE PROCEDURE trgfn_maint_e_raci_before();

-- run this after DELETEing data, we can still raise an exception and rollback
CREATE OR REPLACE FUNCTION trgfn_maint_e_raci_after() RETURNS TRIGGER AS $trig$
	DECLARE
    BEGIN
		IF (TG_OP = 'DELETE') THEN
			-- are we deleting the 'last' row?
            IF ((NOT (EXISTS (SELECT * FROM e_raci WHERE e_raci_obj=OLD.e_raci_obj AND e_raci_object_type_id=OLD.e_raci_object_type_id AND e_people_id <> OLD.e_people_id)))) THEN
				-- no RACI remains for this user.
				
				-- if we delete a row and there are no more rows remaining for this object then we delete the e_raci_object
                IF (
				    ((OLD.e_raci_object_type_id =  1) AND (NOT EXISTS (SELECT * FROM vuln.e_vulnerability WHERE e_raci_obj = OLD.e_raci_obj))) OR
                    ((OLD.e_raci_object_type_id =  2) AND (NOT EXISTS (SELECT * FROM vuln.e_vulnerability_action WHERE e_raci_obj = OLD.e_raci_obj))) OR
                    ((OLD.e_raci_object_type_id =  3) AND (NOT EXISTS (SELECT * FROM vuln.e_vulnerability_vrt WHERE e_raci_obj = OLD.e_raci_obj))) OR
                    ((OLD.e_raci_object_type_id =  4) AND (NOT EXISTS (SELECT * FROM e_module WHERE e_raci_obj = OLD.e_raci_obj))) OR
                    ((OLD.e_raci_object_type_id =  5) AND (NOT EXISTS (SELECT * FROM audit.e_audit WHERE e_raci_obj = OLD.e_raci_obj))) OR
                    ((OLD.e_raci_object_type_id =  6) AND (NOT EXISTS (SELECT * FROM audit.e_audit_interview WHERE e_raci_obj = OLD.e_raci_obj))) OR
                    ((OLD.e_raci_object_type_id =  7) AND (NOT EXISTS (SELECT * FROM audit.e_audit_document WHERE e_raci_obj = OLD.e_raci_obj))) OR
                    ((OLD.e_raci_object_type_id =  8) AND (NOT EXISTS (SELECT * FROM audit.e_audit_rec WHERE e_raci_obj = OLD.e_raci_obj))) OR
                    ((OLD.e_raci_object_type_id =  9) AND (NOT EXISTS (SELECT * FROM audit.e_audit_rec_auditee WHERE e_raci_obj = OLD.e_raci_obj))) OR
                    ((OLD.e_raci_object_type_id = 10) AND (NOT EXISTS (SELECT * FROM audit.e_audit_action WHERE e_raci_obj = OLD.e_raci_obj))) OR
                    ((OLD.e_raci_object_type_id = 11) AND (NOT EXISTS (SELECT * FROM audit.e_audit_report WHERE e_raci_obj = OLD.e_raci_obj))) OR
                    ((OLD.e_raci_object_type_id = 12) AND (NOT EXISTS (SELECT * FROM asset.e_composite_product WHERE e_raci_obj = OLD.e_raci_obj))) OR
                    ((OLD.e_raci_object_type_id = 13) AND (NOT EXISTS (SELECT * FROM risk.e_risk WHERE e_raci_obj = OLD.e_raci_obj)))
                  OR
                    ((OLD.e_raci_object_type_id = 14) AND (NOT EXISTS (SELECT * FROM risk.e_risk_review WHERE e_raci_obj = OLD.e_raci_obj)))
                  OR
                    ((OLD.e_raci_object_type_id = 15) AND (NOT EXISTS (SELECT * FROM risk.e_risk_control WHERE e_raci_obj = OLD.e_raci_obj)))
                  OR
                    ((OLD.e_raci_object_type_id = 16) AND (NOT EXISTS (SELECT * FROM risk.e_action WHERE e_raci_obj = OLD.e_raci_obj)))
                  ) THEN
					-- this no longer references anything
					DELETE FROM e_raci_objects WHERE e_raci_obj = OLD.e_raci_obj AND e_raci_object_type_id = OLD.e_raci_object_type_id;
				ELSIF (OLD.e_raci_object_type_id < 1 OR OLD.e_raci_object_type_id > 16) THEN
					RAISE EXCEPTION 'Unknown raci object type id';
				ELSE
					-- we need to re-add the anonymous row to keep consistancy, this may only be temporary.
					INSERT INTO e_raci (e_raci_obj, e_raci_object_type_id, e_people_id, r, a, c, i)
						VALUES (OLD.e_raci_obj, OLD.e_raci_object_type_id, 0, true, false, false, false);
                END IF;
            END IF;
            RETURN OLD;
		ELSIF (TG_OP = 'INSERT') THEN
            IF (NEW.e_people_id <> 0) THEN
            	-- added someone not 0 so we need to remove all 0 entries.
                DELETE FROM e_raci WHERE e_raci_obj=NEW.e_raci_obj AND e_raci_object_type_id=NEW.e_raci_object_type_id AND e_people_id = 0;
            END IF;
			RETURN NEW;
		END IF;
	END;
$trig$ LANGUAGE plpgsql;

CREATE TRIGGER trg_maint_e_raci_after AFTER DELETE OR INSERT ON e_raci
	FOR EACH ROW EXECUTE PROCEDURE trgfn_maint_e_raci_after();



-- unusually, this table is managed by triggers on the joined object tables.
CREATE TABLE e_raci_objects (
	e_raci_obj				int NOT NULL, -- PRIMARY KEY
	e_raci_object_type_id	int NOT NULL,
	PRIMARY KEY (e_raci_obj, e_raci_object_type_id)
);

CREATE TABLE e_raci_history (
	change_date 	timestamptz 	NOT NULL 	DEFAULT current_timestamp,
	current 	boolean		NOT NULL 	DEFAULT true,
	e_raci_obj 	int 		NOT NULL,
	e_people_id 	int 		NOT NULL,
	modifier 	int 		NOT NULL,
 	r_change 	boolean 	NOT NULL,
 	a_change 	boolean 	NOT NULL,
	c_change 	boolean 	NOT NULL,
	i_change 	boolean 	NOT NULL,
	deleted 	boolean 	NOT NULL	
);

--
-- change requests for RACI
--
CREATE SEQUENCE e_raci_change_request_serial;
CREATE TABLE e_raci_change_request(
        e_raci_change_id        int DEFAULT nextval('e_raci_change_request_serial'),
        e_raci_obj              int NOT NULL,
        e_people_id             int NOT NULL,
        r                       boolean NOT NULL,
        a                       boolean NOT NULL,
        c                       boolean NOT NULL,
        i                       boolean NOT NULL,
        substitute              int,
        modifier                int NOT NULL,
        date_asked              timestamptz NOT NULL DEFAULT current_timestamp,
        is_add                  boolean NOT NULL,
        is_update               boolean NOT NULL,
        is_delete               boolean NOT NULL,
        is_force                boolean NOT NULL,
        PRIMARY KEY(e_raci_change_id)
);


CREATE TABLE e_raci_object_type (
	e_raci_object_type_id 	int 	NOT NULL,
	type_name 	text 	NOT NULL,
	description 	text,
	schema_name 	text 	NOT NULL,
	table_name 	text	NOT NULL,
	raci_class 	text 	NOT NULL,
	module_class	text,	--can be null only in case of a module object
	has_target_date boolean NOT NULL, --can this type be seen in a calendar view ?
	PRIMARY KEY(e_raci_object_type_id)
);
CREATE UNIQUE INDEX e_raci_object_type_raci_class ON e_raci_object_type (raci_class);

-- Keep all case values common to the raci object join
-- description is set up in sqlang scripts
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (1, 'vulnerability', 'vuln', 'e_vulnerability', 'com.entelience.raci.vrt.RaciVulnerability', 'com.entelience.module.Vulnerabilities', true);
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (2, 'action', 'vuln', 'e_vulnerability_action', 'com.entelience.raci.vrt.RaciAction', 'com.entelience.module.Vulnerabilities', true);
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (3, 'VRT Meeting', 'vuln', 'e_vulnerability_vrt', 'com.entelience.raci.vrt.RaciMeeting', 'com.entelience.module.Vulnerabilities', false);
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (4, 'module', 'public', 'e_module', 'com.entelience.raci.module.RaciModule', null, false);
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (5, 'audit', 'audit', 'e_audit', 'com.entelience.raci.audit.RaciAudit', 'com.entelience.module.Audit', true);
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (6, 'interview', 'audit', 'e_audit_interview', 'com.entelience.raci.audit.RaciInterview', 'com.entelience.module.Audit', true);
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (7, 'document', 'audit', 'e_audit_document', 'com.entelience.raci.audit.RaciDocument', 'com.entelience.module.Audit', false);
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (8, 'recommendation', 'audit', 'e_audit_rec', 'com.entelience.raci.audit.RaciRec', 'com.entelience.module.Audit', false);
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (9, 'recommendation', 'audit', 'e_audit_rec_auditee', 'com.entelience.raci.audit.RaciRecAuditee', 'com.entelience.module.Audit', true);
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (10, 'action', 'audit', 'e_audit_action', 'com.entelience.raci.audit.RaciAction', 'com.entelience.module.Audit', true);
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (11, 'report', 'audit', 'e_audit_report', 'com.entelience.raci.audit.RaciReport', 'com.entelience.module.Audit', true);
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (12, 'composite product', 'asset', 'e_composite_product', 'com.entelience.raci.asset.RaciCompositeApplication', 'com.entelience.module.Assets', false);
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (13, 'risk', 'risk', 'e_risk', 'com.entelience.raci.risk.RaciRisk', 'com.entelience.module.RiskModelisation', false);
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (14, 'risk_review', 'risk', 'e_risk_review', 'com.entelience.raci.risk.RaciRiskReview', 'com.entelience.module.RiskAssessment', false);
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (15, 'risk_control', 'risk', 'e_risk_control', 'com.entelience.raci.risk.RaciRiskControl', 'com.entelience.module.RiskAssessment', false);
INSERT INTO e_raci_object_type (e_raci_object_type_id, type_name, schema_name, table_name, raci_class, module_class, has_target_date) VALUES (16, 'risk_action', 'risk', 'e_action', 'com.entelience.raci.risk.RaciAction', 'com.entelience.module.RiskAssessment', true);

-- Function to create a trigger function per-table so that we 
-- always setup a 'default' RACI with default object variables
-- whenever data is inserted into a RACI compatible table
--
CREATE OR REPLACE FUNCTION create_trgfn_maint_raci(
       my_schema IN text,
       my_table  IN text
)      RETURNS void AS $create_trgfn_maint_raci$
       DECLARE -- local variables
       	       identifier	text;
	       schema_table	text;
       BEGIN -- procedure

       	     identifier	:= my_schema || '_' || my_table;
	     schema_table := my_schema || '.' || my_table;

EXECUTE $exec$
CREATE OR REPLACE FUNCTION trgfn_maint_raci_before_$exec$ || identifier || $exec$() RETURNS TRIGGER AS $trig$
        DECLARE -- no parameters
       	        -- local variables
        BEGIN -- procedure trgfn_maint_raci_XYZ

	IF	 (TG_OP = 'INSERT') THEN
		 IF (NEW.e_raci_obj IS NULL) THEN 
			NEW.e_raci_obj := nextval('e_raci_obj_serial');
			INSERT INTO e_raci (e_raci_obj, e_people_id, r, a, c, i, e_raci_object_type_id) 
				SELECT NEW.e_raci_obj, 0, true, false, false, false, e_raci_object_type_id
					FROM e_raci_object_type
					WHERE schema_name = '$exec$ || my_schema || $exec$' AND table_name = '$exec$ || my_table || $exec$';
			INSERT INTO e_raci_objects (e_raci_obj, e_raci_object_type_id)
				SELECT NEW.e_raci_obj, e_raci_object_type_id
					FROM e_raci_object_type
					WHERE schema_name = '$exec$ || my_schema || $exec$' AND table_name = '$exec$ || my_table || $exec$';
		 END IF;
	ELSIF	 (TG_OP = 'UPDATE') THEN
		 IF (OLD.e_raci_obj IS NULL) THEN
			NEW.e_raci_obj := nextval('e_raci_obj_serial');
			INSERT INTO e_raci (e_raci_obj, e_people_id, r, a, c, i, e_raci_object_type_id)
			    SELECT NEW.e_raci_obj, 0, true, false, false, false, e_raci_object_type_id
			    FROM e_raci_object_type
			    WHERE schema_name = '$exec$ || my_schema || $exec$' AND table_name = '$exec$ || my_table || $exec$';
			INSERT INTO e_raci_objects (e_raci_obj, e_raci_object_type_id)
				SELECT NEW.e_raci_obj, e_raci_object_type_id
				FROM e_raci_object_type
				WHERE schema_name = '$exec$ || my_schema || $exec$' AND table_name = '$exec$ || my_table || $exec$';
		 ELSIF (OLD.e_raci_obj <> NEW.e_raci_obj) THEN
		        RAISE EXCEPTION 'Cannot modify the value of e_raci_obj for $exec$ || schema_table || $exec$';
		 END IF;
	END IF;
	RETURN NEW;
	
	END; -- procedure trgfm_maint_raci_before_XYZ
$trig$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trgfn_maint_raci_after_$exec$ || identifier || $exec$() RETURNS TRIGGER AS $trig$
        DECLARE -- no parameters
       	        -- local variables
        BEGIN -- procedure trgfn_maint_raci_XYZ
        --IF 	 (TG_OP = 'DELETE') THEN
		 -- delete entries from e_raci because we're deleting object
       		 DELETE FROM e_raci WHERE e_raci_obj = OLD.e_raci_obj;
			 DELETE FROM e_raci_objects WHERE e_raci_obj = OLD.e_raci_obj;
		 RETURN OLD;
		--END IF;	
	END; -- procedure trgfm_maint_raci_after_XYZ
$trig$ LANGUAGE plpgsql;


-- create a trigger to maintain the value of e_raci_obj, tables e_raci and e_raci_objects.
CREATE TRIGGER trg_maint_raci_before_$exec$ || identifier || $exec$ BEFORE INSERT OR UPDATE ON $exec$ || schema_table || $exec$
       FOR EACH ROW EXECUTE PROCEDURE trgfn_maint_raci_before_$exec$ || identifier || $exec$();

-- this triggers the trigger on e_raci so it needs to be run after DELETE
CREATE TRIGGER trg_maint_raci_after_$exec$ || identifier || $exec$ AFTER DELETE ON $exec$ || schema_table || $exec$
	   FOR EACH ROW EXECUTE PROCEDURE trgfn_maint_raci_after_$exec$ || identifier || $exec$();

-- create an index to keep e_raci_obj as an alternative key to the table
CREATE UNIQUE INDEX $exec$ || my_table || '_raci_obj' || $exec$ ON $exec$ || schema_table || $exec$ (e_raci_obj);

$exec$; -- end of dynamic code block

	END; -- procedure create_trgfn_maint_raci
$create_trgfn_maint_raci$ LANGUAGE plpgsql;
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
-- $Id: directory_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


--
-- contains: ESIS directory model (Version: 1.2)

--
-- WARNING - Any modification to any of these tables must be mirrored in 
-- the file slave_directory_schema.
--

--
-- e_people - main people information repository
--
CREATE SEQUENCE e_people_serial;
CREATE TABLE e_people (
	e_people_id			int	DEFAULT nextval('e_people_serial'),
	user_name			text	NOT NULL,
	passwd				text,  -- MD5. passwd can be null if user created by the probe. he wont be able to login until an admin sets a password for this user
	first_name			text,
	last_name			text,
	display_name 			text,
	phone				text,
	email				text,
	e_location_id			integer,	--e_location
	timezone                        text,
	creation_date			timestamptz	DEFAULT current_timestamp,
	last_mod_date			timestamptz	DEFAULT current_timestamp,
	e_company_id          		integer NOT NULL,
	disabled           		boolean default false,
	is_admin			boolean default false,
	last_passwd_change 		timestamptz,
	first_login 			timestamptz,
	last_login 			timestamptz,
	last_login_failure 		timestamptz,
	account_locked                  boolean NOT NULL DEFAULT false,
	PRIMARY KEY(e_people_id)
);
CREATE UNIQUE INDEX e_people_username_idx ON e_people (user_name);
CREATE INDEX e_people_company_id ON e_people (e_company_id);

CREATE OR REPLACE FUNCTION trgfn_people_display_name() RETURNS TRIGGER AS $trig$
        DECLARE
        BEGIN
        	IF (NEW.first_name IS NOT NULL AND textlen(trim(NEW.first_name)) = 0) THEN
        		NEW.first_name = NULL;
        	ELSIF (NEW.first_name IS NOT NULL) THEN
        		NEW.first_name = trim(NEW.first_name);
        	END IF;
        		
        	IF (NEW.last_name IS NOT NULL AND textlen(trim(NEW.last_name)) = 0) THEN
        		NEW.last_name = NULL;
        	ELSIF (NEW.last_name IS NOT NULL) THEN
        		NEW.last_name = trim(NEW.last_name);
        	END IF;
        	
		IF (NEW.first_name IS NOT NULL AND NEW.last_name IS NOT NULL) THEN
				NEW.display_name = NEW.last_name || ' ' || NEW.first_name;
		ELSIF (NEW.last_name IS NOT NULL) THEN 
              			NEW.display_name = NEW.last_name;
              	ELSE 
              			NEW.display_name = NEW.user_name;
                END IF;
                RETURN NEW;
        END;
$trig$ LANGUAGE plpgsql;

CREATE TRIGGER trg_maint_e_people_before BEFORE INSERT OR UPDATE ON e_people
      FOR EACH ROW EXECUTE PROCEDURE trgfn_people_display_name();


CREATE TABLE e_people_login_history (
        try_date        timestamptz     NOT NULL DEFAULT current_timestamp,
        username        text            NOT NULL,
        e_people_id     int,            -- e_people, might be null if username unknown or mistyped
        success         boolean         NOT NULL,
        remote_ip       text           -- the IP the login comes from, did not use the inet type because it doesnt handle IPv6
);



CREATE TABLE e_people_history (
        change_date     timestamptz     NOT NULL DEFAULT current_timestamp,
        modifier        int, --e_people
        e_people_id     int NOT NULL, --the audited people
        user_name       text    NOT NULL,
        email           text,
        e_location_id   integer,
        e_company_id    integer,
        is_admin        boolean,
        disabled        boolean,
        account_locked  boolean -- true : locked, false : unlocked 
);

CREATE TABLE e_password_history(
 	e_people_id 		integer NOT NULL, --e_people
 	date_set 		timestamptz NOT NULL DEFAULT current_timestamp,
 	passwd 			text --md5
);


--this sequence is shared between e_global_group (main db) and e_company_group (cie db)
CREATE SEQUENCE e_group_serial; 
-- therefore please do not manipulate it direclty but use fn_get_group_id_nextval instead
-- fn_get_group_id_nextval has another declaration for slave dbs in slave_directory_schema.sql

CREATE OR REPLACE FUNCTION fn_get_group_id_nextval (
) RETURNS integer AS $fn$
  DECLARE
	__next_group_id       integer;
  BEGIN
        SELECT INTO __next_group_id (nextval('e_group_serial'));
        return __next_group_id;
  END;
$fn$ LANGUAGE plpgsql VOLATILE;


CREATE TABLE e_global_group (
	e_group_id 		integer   DEFAULT fn_get_group_id_nextval(),
	group_name		text	NOT NULL,
	description		text,
	creation_date		timestamptz	DEFAULT current_timestamp NOT NULL,
	mother_group_id 	integer, -- this group can be a subdivision of another group
	PRIMARY KEY(e_group_id)
);
CREATE UNIQUE INDEX e_global_group_name ON e_global_group (group_name);

CREATE TABLE e_group_to_people (
	e_group_id		integer	NOT NULL,	--e_group
	e_people_id		integer	NOT NULL	--e_people
,	PRIMARY KEY (e_group_id, e_people_id)
);

CREATE TABLE e_group_membership_history (
	e_group_id 		integer NOT NULL, 	--e_group
	e_people_id 		integer NOT NULL, 	--e_people
	change_date 		timestamptz NOT NULL DEFAULT current_timestamp,
	member 			boolean, --false : removed / true : added
	modifier 		integer NOT NULL
);



-- not used yet (cf bug2531)
--CREATE TABLE e_contact (
--	-- nothing extra
--) INHERITS (e_people);

-- not used yet (cf bug2531)
--CREATE TABLE e_system_owner (
--	business_line			int,	-- e_bl
--	employment_status		text,
--	employee_number			text,
--	manager				text
--) INHERITS (e_people);

CREATE SEQUENCE e_company_serial;
CREATE TABLE e_company (
	e_company_id        integer     	DEFAULT nextval('e_company_serial'),
	
	obj_ser		int		NOT NULL,
	obj_lm		timestamptz 	NOT NULL,
	db_user		text		NOT NULL,
	
	name                text		NOT NULL,
	logo                bytea       	DEFAULT NULL,
	logo_file_name      text        	DEFAULT NULL,
	shortname           text        	NOT NULL,
	connection_url      text        	DEFAULT NULL,
	username            text		DEFAULT NULL,
	password            text		DEFAULT NULL,
	creation_date		timestamptz	DEFAULT current_timestamp,
	PRIMARY KEY(e_company_id)
);
CREATE UNIQUE INDEX e_company_name ON e_company (name);
CREATE UNIQUE INDEX e_company_shortname ON e_company (shortname);

SELECT create_trgfn_maint_object_audit('public', 'e_company', 'e_company_id', 'e_company_serial');

CREATE TABLE e_company_history(
        change_date     timestamptz     NOT NULL DEFAULT current_timestamp,
        modifier        int, --e_people
        e_company_id    int NOT NULL, --the audited people
        name            text,
        shortname       text,
        connection_url  text,
        username        text
);

INSERT INTO e_people (user_name, e_people_id, e_company_id) VALUES ('Anonymous', 0, 0); -- Required setting for default people_id
INSERT INTO e_company (name, shortname, e_company_id) VALUES ('Entelience', 'Entel', 0); --default company

