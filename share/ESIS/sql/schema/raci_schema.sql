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