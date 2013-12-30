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
