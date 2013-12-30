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