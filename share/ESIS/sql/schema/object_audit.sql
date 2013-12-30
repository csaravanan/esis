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