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
-- $Id: slave_directory_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


--
-- contains: ESIS directory model (slave of version 1.2)


--
-- bug2191 - bring slave tables in from main database.
--

CREATE VIEW e_people AS
	SELECT * FROM
		dblink(	'dbname=esis_sdw hostaddr=127.0.0.1 port=5432 user=esis_user password=Pa55w0rd connect_timeout=2',
			'SELECT 
				e_people_id,
				user_name,
			        passwd,
		        	first_name,
			        last_name,
			        display_name,
			        phone,
			        email,
		        	e_location_id,
		        	timezone,
			        creation_date,
			        last_mod_date,
			        e_company_id,
		        	disabled,
			        is_admin,
			        last_passwd_change,
			        first_login,
			        last_login,
			        last_login_failure,
			        account_locked
			FROM e_people', true) AS tableType(
				e_people_id		int,
				user_name		text,
				passwd			text,
				first_name		text,
				last_name		text,
				display_name 		text,
				phone			text,
				email			text,
				e_location_id		integer,
				timezone                text,
				creation_date		timestamptz,
				last_mod_date		timestamptz,
				e_company_id          	integer,
				disabled           	boolean,
				is_admin		boolean,
				last_passwd_change 	timestamptz,
				first_login 		timestamptz,
				last_login 		timestamptz,
				last_login_failure 	timestamptz,
				account_locked          boolean
		);


CREATE VIEW e_people_login_history AS 
        SELECT * FROM
		dblink(	'dbname=esis_sdw hostaddr=127.0.0.1 port=5432 user=esis_user password=Pa55w0rd connect_timeout=2',
			'SELECT 
				try_date,
                                username,
                                e_people_id,
                                success,
                                remote_ip
			FROM e_people_history', true) AS tableType(
				try_date            timestamptz,
                                username            text,
                                e_people_id         int,
                                success             boolean,
                                remote_ip           text
                      );


CREATE VIEW e_people_history AS
	SELECT * FROM
		dblink(	'dbname=esis_sdw hostaddr=127.0.0.1 port=5432 user=esis_user password=Pa55w0rd connect_timeout=2',
			'SELECT 
				change_date,
                                modifier,
                                e_people_id,
                                user_name,
                                email,
                                e_location_id,
                                e_company_id,
                                is_admin,
                                disabled,
                                account_locked
			FROM e_people_history', true) AS tableType(
				change_date     timestamptz,
                                modifier        int,
                                e_people_id     int,
                                user_name       text,
                                email           text,
                                e_location_id   integer,
                                e_company_id    integer,
                                is_admin        boolean,
                                disabled        boolean,
                                account_locked  boolean
               );

CREATE OR REPLACE FUNCTION fn_get_group_id_nextval (
) RETURNS integer AS $fn$
  DECLARE
	__next_group_id       integer;
  BEGIN
        SELECT INTO __next_group_id (nextval) 
        FROM dblink( 'dbname=esis_sdw hostaddr=127.0.0.1 port=5432 user=esis_user password=Pa55w0rd connect_timeout=2',
                     'SELECT nextval(''e_group_serial'')', true) AS tableType(
                     nextval int
        );
        return __next_group_id;
  END;
$fn$ LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE VIEW e_global_group AS
	SELECT * FROM
		dblink(	'dbname=esis_sdw hostaddr=127.0.0.1 port=5432 user=esis_user password=Pa55w0rd connect_timeout=2',
			'SELECT
				e_group_id,
				group_name,
				description,
				creation_date,
				mother_group_id
			FROM e_global_group', true) AS tableType(
				e_group_id 	int,
				group_name 	text,
				description 	text,
				creation_date    timestamptz,
				mother_group_id int
		);

CREATE VIEW e_group_to_people AS
	SELECT * FROM
		dblink(	'dbname=esis_sdw hostaddr=127.0.0.1 port=5432 user=esis_user password=Pa55w0rd connect_timeout=2',
			'SELECT
				e_group_id,
				e_people_id
			FROM e_group_to_people', true) AS tableType(
				e_group_id		int,
				e_people_id		int
		);	



--CREATE VIEW e_contact AS
--	SELECT * FROM
--		dblink(	'dbname=esis_sdw hostaddr=127.0.0.1 port=5432 user=esis_user password=Pa55w0rd connect_timeout=2',
--			'SELECT
--				e_people_id,
--				user_name,
--			        passwd,
--		        	first_name,
--			        last_name,
--			        phone,
--			        email,
--		        	e_location_id,
--			        creation_date,
--			        last_mod_date,
--			        e_company_id,
--		        	disabled,
--			        is_admin
--			FROM e_contact', true) AS tableType(
--				e_people_id		int,
--				user_name		text,
--				passwd			text,
--				first_name		text,
--				last_name		text,
--				phone			text,
--				email			text,
--				e_location_id		integer,
--				creation_date		timestamptz,
--				last_mod_date		timestamptz,
--				e_company_id          	integer,
--				disabled           	boolean,
--				is_admin		boolean
--		);
--
--CREATE VIEW e_system_owner AS
--	SELECT * FROM
--		dblink(	'dbname=esis_sdw hostaddr=127.0.0.1 port=5432 user=esis_user password=Pa55w0rd connect_timeout=2',
--			'SELECT
--				e_people_id,
--				user_name,
--			        passwd,
--		        	first_name,
--			        last_name,
--			        phone,
--			        email,
--		        	e_location_id,
--			        creation_date,
--			        last_mod_date,
--			        e_company_id,
--		        	disabled,
--			        is_admin,
--				business_line,
--				employment_status,
--				employee_number,
--				manager
--			FROM e_system_owner', true) AS tableType(
--				e_people_id		int,
--				user_name		text,
--				passwd			text,
--				first_name		text,
--				last_name		text,
--				phone			text,
--				email			text,
--				e_location_id		integer,
--				creation_date		timestamptz,
--				last_mod_date		timestamptz,
--				e_company_id          	integer,
--				disabled           	boolean,
--				is_admin		boolean,
--				business_line		int,
--				employment_status	text,
--				employee_number		text,
--				manager			text				
--		);

CREATE VIEW e_company AS
	SELECT * FROM
		dblink(	'dbname=esis_sdw hostaddr=127.0.0.1 port=5432 user=esis_user password=Pa55w0rd connect_timeout=2',
			'SELECT
				e_company_id,
				
				obj_ser,
				obj_lm,
				db_user,
				
				name,
				logo,
				logo_file_name,
				shortname,
				connection_url,
				username,
				password,
				creation_date
			FROM e_company', true) AS tableType(
				e_company_id        	integer,
				
				obj_ser 		int,
				obj_lm 			timestamptz,
				db_user 		text,
				
				name                	text,
				logo                	bytea,
				logo_file_name      	text,
				shortname           	text,
				connection_url        	text,
				username		text,
				password		text,
				creation_date		timestamptz
		);

CREATE VIEW e_company_history AS
	SELECT * FROM
		dblink(	'dbname=esis_sdw hostaddr=127.0.0.1 port=5432 user=esis_user password=Pa55w0rd connect_timeout=2',
			'SELECT
				change_date,
                                modifier,
                                e_company_id,
                                name,
                                shortname,
                                connection_url,
                                username
			FROM e_company_history', true) AS tableType(
				change_date     timestamptz,
                                modifier        int,
                                e_company_id    int,
                                name            text,
                                shortname       text,
                                connection_url  text,
                                username        text
		);
		
