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
-- $Id: accounting_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--

--
-- Contains schema required for unix/windows accounting
-- information - login / logout / login failures etc.

CREATE SEQUENCE	mim.t_wtmp_serial;
CREATE TABLE	mim.t_wtmp
(
	t_wtmp_id	integer		DEFAULT nextval('mim.t_wtmp_serial'),
	acct_date	timestamptz,    -- may be null, indicates login (null implies logout without login)
	acct_other_date	timestamptz,	-- may be null, indicates logout (null implies login without logout)
	login_out_join	text,		-- may be null, for joining acct_date and acct_other_date
	uniq		text		NOT NULL, -- or asset id...
	user_base_id	integer,	-- may be null in rare cases where no prior login information known
	su_user_base_id	integer,	-- may be null, not null indicates privilege change
	success_count	integer		DEFAULT 0, -- # successful logins
	failure_count	integer		DEFAULT 0, -- # un-successful logins
	su_success_count	integer		DEFAULT 0, -- # successful su / sudo
	su_failure_count	integer		DEFAULT 0, -- # un-successful su / sudo
	command		text,		-- may be null, for sudo this is the command run with privs
	PRIMARY KEY(t_wtmp_id)
);
-- for import:
-- nb. this is an 'uniq' index; or an 'uniq, user_base_id' index; or an 'uniq, user_base_id, login_out_join' index
CREATE INDEX	t_wtmp_i_composite	ON	mim.t_wtmp (uniq, user_base_id, login_out_join);
-- for reports:
CREATE INDEX	t_wtmp_i_date		ON	mim.t_wtmp (acct_date);
CREATE INDEX	t_wtmp_i_other_date	ON	mim.t_wtmp (acct_other_date);

--
-- mim.t_wtmp_events and mim.t_wtmp share
-- serial generator mim.t_wtmp_serial to ensure 
-- consistancy in the order of imported data.
--
CREATE TABLE	mim.t_wtmp_events
(
	t_wtmp_id	integer		DEFAULT nextval('mim.t_wtmp_serial'),
	acct_date	timestamptz	NOT NULL,
	uniq		text		NOT NULL, -- or asset id...
	event_type	integer		NOT NULL,
	PRIMARY KEY(t_wtmp_id)
);
--
-- event_type codes:
--
-- 0	system available
-- 1	system starting
-- 2	system restart demanded
--

--
-- mim.t_wtmp_other and mim.t_wtmp share
-- serial generator mim.t_wtmp_serial to ensure
-- consistnacy in the order of imported data.
--
CREATE TABLE	mim.t_wtmp_other
(
	t_wtmp_id	integer		DEFAULT nextval('mim.t_wtmp_serial'),
	acct_date	timestamptz	NOT NULL,
	uniq		text		NOT NULL, -- or asset id...
	message		text		NOT NULL,
	PRIMARY KEY(t_wtmp_id)
);

CREATE SEQUENCE	mim.t_daily_user_global_serial;
CREATE TABLE	mim.t_daily_user_global
(
	t_daily_user_global_id		integer		DEFAULT nextval('mim.t_daily_user_global_serial'),
	report_id			integer		NOT NULL,
	users_count			integer		NOT NULL,
	account_count			integer 	NOT NULL,
	users_without_account		integer 	NOT NULL,
	accounts_without_user		integer 	NOT NULL,
	PRIMARY KEY(t_daily_user_global_id)
);

CREATE SEQUENCE	mim.t_daily_account_global_serial;
CREATE TABLE 	mim.t_daily_account_global
(
	t_daily_account_global_id	integer		DEFAULT nextval('mim.t_daily_account_global_serial'),
	report_id			integer		NOT NULL,
	account_login_count		integer		NOT NULL,
	account_failed_login_count	integer		NOT NULL,
	account_success_login_count	integer		NOT NULL,
	account_logout_count		integer		NOT NULL,
	account_dormant_count		integer		NOT NULL,
	account_nap_count		integer		NOT NULL,
	account_inactive_count		integer		NOT NULL,
	account_locked_count		integer		NOT NULL,
	PRIMARY KEY(t_daily_account_global_id)
);

CREATE SEQUENCE mim.t_daily_priv_global_serial;
CREATE TABLE	mim.t_daily_priv_global
(
	t_daily_priv_global_id		integer		DEFAULT nextval('mim.t_daily_priv_global_serial'),
	report_id			integer		NOT NULL,
	admin_login_count		integer		NOT NULL,
	admin_failed_login_count	integer		NOT NULL,
	admin_success_login_count	integer		NOT NULL,
	admin_logout_count		integer		NOT NULL,
	privilege_count			integer		NOT NULL,
	privilege_admin_count		integer		NOT NULL,
	privilege_admin_failed_count	integer		NOT NULL,
	privilege_admin_success_count	integer		NOT NULL,
	privilege_other_count		integer		NOT NULL,
	privilege_other_failed_count	integer		NOT NULL,
	privilege_other_success_count	integer		NOT NULL,
	system_diff_admin_count		integer		NOT NULL,
	system_diff_failed_admin_count	integer		NOT NULL,
	system_diff_success_admin_count	integer		NOT NULL,
	account_priv_count		integer		NOT NULL,
	account_priv_other_count	integer		NOT NULL,
	account_priv_other_failed_count	integer		NOT NULL,
	account_priv_other_success_count	integer	NOT NULL,
	account_priv_admin_count	integer		NOT NULL,
	account_priv_admin_failed_count	integer		NOT NULL,
	account_priv_admin_success_count	integer NOT NULL,
	PRIMARY KEY(t_daily_priv_global_id)
);

CREATE SEQUENCE	mim.t_daily_system_global_serial;
CREATE TABLE	mim.t_daily_system_global
(
	t_daily_system_global_id	integer		DEFAULT nextval('mim.t_daily_system_global_serial'),
	report_id			integer		NOT NULL,
	system_count			integer		NOT NULL,
	system_login_count		integer		NOT NULL,
	system_failed_login_count	integer		NOT NULL,
	system_success_login_count	integer		NOT NULL,
	PRIMARY KEY(t_daily_system_global_id)
);

--
-- Patterns for default properties for certain usernames.
--
CREATE SEQUENCE mim.t_userpatterns_serial;
CREATE TABLE	mim.t_userpatterns
(
	t_userpatterns_id		integer		DEFAULT nextval('mim.t_userpatterns_serial'),
	-- need some mapping to assets here (asset type, asset id)
	user_pattern			text		NOT NULL,
	is_admin			boolean		DEFAULT false,
	is_service			boolean		DEFAULT false,
	PRIMARY KEY(t_userpatterns_id)
);

--
-- Table to contain people (entry in the human resources database)
--
CREATE SEQUENCE mim.t_user_ppl_serial;
CREATE TABLE mim.t_user_ppl(
        t_user_ppl_id           int     DEFAULT nextval('mim.t_user_ppl_serial'),
        user_id                 text    NOT NULL, -- global user id
        name                    text    NOT NULL,
        deleted                 boolean NOT NULL DEFAULT false,
        first_name              text,
        last_name               text,
        t_location_id           int,
        t_department_id         int,
        PRIMARY KEY (t_user_ppl_id)
); 
CREATE UNIQUE INDEX t_user_ppl_unik ON mim.t_user_ppl (user_id);

CREATE TABLE	mim.t_user_base_keycheck
(
	t_user_base_id			integer		NOT NULL,
	uniq				text		NOT NULL,
	user_name			text		NOT NULL,
	PRIMARY KEY (t_user_base_id, uniq, user_name)
);
CREATE UNIQUE INDEX t_user_base_keycheck_t_user_base_id ON mim.t_user_base_keycheck (t_user_base_id);
CREATE UNIQUE INDEX t_user_base_keycheck_uniq_user_name ON mim.t_user_base_keycheck (uniq, user_name);

-- in t_user_sys uniq is "sys_" + ip
-- in t_user_app uniq is "app_" + ip + "_" + app
-- in t_user_rlm uniq is "rlm_" + rlm
CREATE SEQUENCE mim.t_user_base_serial;
CREATE TABLE	mim.t_user_base
(
	t_user_base_id			integer		DEFAULT nextval('mim.t_user_base_serial'),
	uniq				text		NOT NULL,
	user_name			text		NOT NULL, -- user id per sys/app/rlm
	deleted				boolean		DEFAULT false, -- true -> user has been deleted (no longer exists)
	is_admin			boolean		DEFAULT false, -- true -> user is an administrator
	is_service			boolean		DEFAULT false, -- true -> user is a service account (backup, ftp, ...)
	user_id				text,		-- may be null -> indicates no join with ppl
	PRIMARY KEY(t_user_base_id)
);

--
-- Table to contain user id per system (where systems have local users)
--
CREATE TABLE	mim.t_user_sys
(
	t_ip_id        integer		NOT NULL,
	PRIMARY KEY(t_user_base_id)
) INHERITS (mim.t_user_base);

--
-- Table to contain user id per application (where systems have application users)
--
CREATE TABLE	mim.t_user_app
(
	t_ip_id        integer		NOT NULL,
	app				text		NOT NULL,
	PRIMARY KEY(t_user_base_id)
) INHERITS (mim.t_user_base);


CREATE SEQUENCE mim.t_realm_serial;
CREATE TABLE mim.t_realm(
        t_realm_id      integer DEFAULT nextval('mim.t_realm_serial'),
        realm_name      text     UNIQUE NOT NULL,
        PRIMARY KEY(t_realm_id)
);

--
-- Table to contain user id per authentication realm (where systems share network/realm users)
--
CREATE TABLE	mim.t_user_rlm
(
	t_realm_id	    integer	NOT NULL,
	PRIMARY KEY(t_user_base_id)
) INHERITS (mim.t_user_base);


SELECT create_trgfn_maint_mkey('mim', 't_user_base',		't_user_base_keycheck', ARRAY[ 't_user_base_id', 'uniq', 'user_name' ]);
SELECT create_trgfn_maint_mkey('mim', 't_user_sys',		't_user_base_keycheck', ARRAY[ 't_user_base_id', 'uniq', 'user_name' ]);
SELECT create_trgfn_maint_mkey('mim', 't_user_app',		't_user_base_keycheck', ARRAY[ 't_user_base_id', 'uniq', 'user_name' ]);
SELECT create_trgfn_maint_mkey('mim', 't_user_rlm',		't_user_base_keycheck', ARRAY[ 't_user_base_id', 'uniq', 'user_name' ]);

--
-- infos on what we get per active directory
--
CREATE TABLE mim.t_user_daily(
        calc_day                date, 
        t_user_base_id          int, 
        count_login             int NOT NULL DEFAULT 0, 
        count_password_set      int NOT NULL DEFAULT 0, 
        count_failed_login      int NOT NULL DEFAULT 0,
        PRIMARY KEY (calc_day, t_user_base_id)
);

--
-- 
--
CREATE TABLE mim.t_user_login_daily(
        calc_day                date,
        nn_days                 int,
        users_with_password_older       int NOT NULL DEFAULT 0, --how many people had at calc_day a password older than nn_days
        users_without_login             int NOT NULL DEFAULT 0, --how many people did not login for nn_days
        PRIMARY KEY(calc_day, nn_days)
);

CREATE TABLE mim.t_user_ad_daily(
        calc_day                        date,
        count_never_logged_in           int NOT NULL DEFAULT 0, -- how many people have never logged in at this date
        count_with_failed_login         int NOT NULL DEFAULT 0, -- how many people have failed to login at this date
        count_with_success_login        int NOT NULL DEFAULT 0, -- how many people have logged in successfully
        count_with_password_change      int NOT NULL DEFAULT 0, -- how many people have changd their password
        PRIMARY KEY(calc_day)
);

--
-- daily metrics on login attempt, filled by cisco logs
--
CREATE TABLE mim.t_network_device_login_daily(
        calc_day        date,
        t_user_base_id  int,
        e_asset_id      int,
        source_cx       text,           --connected from where?
        count_success   int     NOT NULL,               --how many success login from this user
        count_failures  int     NOT NULL,               --how many failure login from this user
        PRIMARY KEY (calc_day, t_user_base_id, e_asset_id, source_cx)
);


-- Standard usernames for unix systems
INSERT INTO 	mim.t_userpatterns	(user_pattern, is_admin, is_service)	VALUES ('root', true, false);
INSERT INTO 	mim.t_userpatterns	(user_pattern, is_admin, is_service)	VALUES ('backup', false, true);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) 	VALUES ('ftp', false, true);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) 	VALUES ('toor', true, false);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) 	VALUES ('daemon', false, true);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) 	VALUES ('bin', false, true);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) 	VALUES ('sshd', false, true);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) 	VALUES ('smmsp', false, true);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) 	VALUES ('bin', false, true);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) 	VALUES ('daemon', false, true);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) 	VALUES ('sys', false, true);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) 	VALUES ('nobody', false, true);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) 	VALUES ('adm', false, true);

-- Standard usernames for Windows systems (which cause us to have to join tables with LIKE)
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) VALUES ('NT AUTHORITY\\SYSTEM', true, true);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) VALUES ('NT AUTHORITY\\ANONYMOUS', false, true);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) VALUES ('%\\Administrator', true, false);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) VALUES ('%\\Administrateur', true, false);

-- Standard usernames for Tandem (remember to double %% characters to escape them)
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) VALUES ('SUPER.SUPER', true, true);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) VALUES ('SUPER.%', true, false);

-- Some test data that should really be moved into another file
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) VALUES ('%\\superoot', true, false);
INSERT INTO	mim.t_userpatterns	(user_pattern, is_admin, is_service) VALUES ('superoot', true, false);


--
-- users compliant with a policy tool
--
CREATE TABLE mim.t_user_compliance_daily(
        calc_day        date,
        t_user_base_id      integer,
        e_compliance_policy_tool_id    integer, --compliance.e_policy_tool
        compliant       boolean         NOT NULL,
        PRIMARY KEY(calc_day, t_user_base_id, e_compliance_policy_tool_id)
);

--
-- anomalies found per day on a user
--
CREATE TABLE mim.t_user_anomaly_daily(
        calc_day        date,
        t_user_base_id      integer,
        antivirus_notinstalled    int NOT NULL,
        antivirus_outdated        int NOT NULL,
        PRIMARY KEY(calc_day, t_user_base_id)
);



--
-- user accounts that appear on applications
--
CREATE SEQUENCE	mim.t_app_login_serial;
CREATE TABLE mim.t_app_login(
        t_app_login_id integer         DEFAULT nextval('mim.t_app_login_serial'),
        t_app_id        integer NOT NULL, --apps.t_app
        login_name      text    NOT NULL,
        gecos           text,
        creation_date   timestamptz     NOT NULL DEFAULT current_timestamp, --ESIS creation
        last_used_date  timestamptz, --from app
        PRIMARY KEY(t_app_login_id)
);
CREATE UNIQUE INDEX t_app_login_uniq ON mim.t_app_login(t_app_id, login_name);

--
-- daily login infos
--
CREATE TABLE mim.t_app_login_daily(
        calc_day        date    NOT NULL,
        t_app_login_id integer NOT NULL,
        count_login_attempt     integer NOT NULL DEFAULT 0,
        count_login_success     integer NOT NULL DEFAULT 0,
        count_login_failed      integer NOT NULL DEFAULT 0,
        count_logout            integer NOT NULL DEFAULT 0,
        count_offhour_login_attempt     integer NOT NULL DEFAULT 0,
        count_offhour_login_success     integer NOT NULL DEFAULT 0,
        count_offhour_login_failed      integer NOT NULL DEFAULT 0,
        count_changed_password  integer NOT NULL DEFAULT 0,
        expired_password        boolean DEFAULT false,
        PRIMARY KEY(calc_day, t_app_login_id)
);


CREATE SEQUENCE	mim.t_department_serial;
CREATE TABLE mim.t_department(
        t_department_id         int     DEFAULT nextval('mim.t_department_serial'),
        name                    text    NOT NULL,
        e_cie_group_id          int --mapping to e_cie_group
);

CREATE SEQUENCE	mim.t_location_serial;
CREATE TABLE mim.t_location(
        t_location_id           int     DEFAULT nextval('mim.t_location_serial'),
        name                    text    NOT NULL,
        e_location_id           int --mapping to e_location
);

CREATE TABLE mim.t_location_user(
        t_app_login_id  integer,
        t_location_id   integer,
        PRIMARY KEY(t_app_login_id, t_location_id)
);

CREATE TABLE mim.t_department_user(
        t_app_login_id  integer,
        t_department_id integer,
        PRIMARY KEY(t_app_login_id, t_department_id)
);

CREATE TABLE mim.t_location_daily(
        calc_day        date,
        t_location_id   int,    --mim.t_location
        count_active_users      int     NOT NULL DEFAULT 0,
        count_deleted_users     int     NOT NULL DEFAULT 0,
        PRIMARY KEY(calc_day, t_location_id)
);

CREATE TABLE mim.t_department_daily(
        calc_day        date,
        t_department_id int,    --mim.t_department
        count_active_users      int     NOT NULL DEFAULT 0,
        count_deleted_users     int     NOT NULL DEFAULT 0,
        PRIMARY KEY(calc_day, t_department_id)
);
