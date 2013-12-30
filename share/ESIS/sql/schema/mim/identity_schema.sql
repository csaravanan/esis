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
-- $Id: identity_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--

-- ESIS Security DataWarehouse schema - install as user 'entelligence'
--
-- contains: IM usertools schema
-- 	TABLE t_im_user corresponding with IM XML file
--	sample target values for the metrics
CREATE schema mim;

CREATE SEQUENCE	mim.t_im_user_serial;

CREATE TABLE	mim.t_im_user
(
	e_user_id	integer	NOT NULL DEFAULT nextval('mim.t_im_user_serial')
,	user_id	text		NOT NULL	-- example: P251166, psa user identifier
,	z_asl   text[]   NOT NULL   -- z level asls in an array
,	v_asl   text[]   NOT NULL   -- v level asls in an array
,	d_asl   text[]   NOT NULL   -- d level asls in an array
	-- sn -- not needed
	-- ou -- split into hierarchical information.
,	ou_l4	text
,	ou_l3	text
,	ou_l2	text
,	ou_l1	text		-- example: ou_l1/ou_l2/ou_l3/ou_l4 -- ou data
				--          DNIQ/DSIN/INSI/PGIN/ITAN (drop 5th level)
,	c	char(2)	-- country (2 char iso code)
,	l_1	text		-- location, country
,	l_2	text		-- location, town
,	l_3	text		-- location, site/building
,	d_1sthire	date	-- date 1st hire
,	d_con_end	date	-- date contract ends
,	d_sa		date	-- date taken on by security admin
	-- Active Directory (System AD INETPSA)
,	ad_logoncount	int	-- number of logons to active directory
,	ad_lastlogon	date	-- date last seen logged onto active directory
,	ad_lastlogontimestamp	timestamptz 	-- date & time last logged in
,	ad_pwdlastset	date	-- date last changed password
,	ad_whenchanged	date	-- date this record was last modified
,	ad_whencreated	date	-- date this record was created
	-- TSS system
,	tss_logoncount	int
,	tss_lastlogon	date
,	tss_lastlogontimestamp	timestamptz
,	tss_pwdexpires  date
,	tss_pwdlastset	date
,	tss_whenchanged	date
,	tss_whencreated	date
	--
	-- ESIS calculated values for this user
	--
,	esis_watch	boolean -- true -> watch for 1st login, false -> 1st login already happened.
,	esis_firstlogon	date	-- calculated 1st logon time (ad -or- tss)
,	esis_lastlogon  date   -- calculated "last" logon time (ad -or- tss)
	-- other values will need to be stored in tr_im_ report tables.
,	anomaly_id integer default 1 -- key to t_user_anomalies
--
,   ev_dde      boolean NOT NULL default false
,   ev_dde_ts   date    
,   ev_dde_v    double precision
--
,   ev_ddc      boolean NOT NULL default false
,   ev_ddc_ts   date
,   ev_ddc_v    double precision
--
,   ev_dpc      boolean NOT NULL default false
,   ev_dpc_ts   date
,   ev_dpc_v    double precision
--
,   ev_dds      boolean NOT NULL default false
,   ev_dds_ts   date
,   ev_dds_v    double precision
--
,	PRIMARY KEY (e_user_id)
);
CREATE UNIQUE INDEX t_im_user_user_id ON mim.t_im_user (user_id);

CREATE INDEX t_im_user_anomaly ON mim.t_im_user (anomaly_id);

CREATE SEQUENCE mim.t_user_anomaly_serial START 100;
CREATE TABLE mim.t_user_anomaly
(
	t_user_anomaly_id integer 	DEFAULT nextval('mim.t_user_anomaly_serial'),
	description text,      -- anomaly name
	PRIMARY KEY(t_user_anomaly_id)
);

CREATE TABLE mim.t_im_failed_import_user
(
	probe_file_id integer,
	user_id text,
	anomaly_id integer
);
CREATE INDEX	t_failed_usr_ano ON mim.t_im_failed_import_user (anomaly_id);
CREATE INDEX	t_failed_usr_probe_id ON mim.t_im_failed_import_user (probe_file_id);

-- t_user_anomaly values - see sql/lang/mim/identity_strings.sqltemplate

CREATE SEQUENCE mim.t_im_asl_serial;

CREATE TABLE mim.t_im_asl
(
	e_asl_id	integer		NOT NULL DEFAULT nextval('mim.t_im_asl_serial'),
	asl_id      text,       -- like user_id (A166716) but not guarenteed to exist in user_id table
	level       char(1),    -- Z for ASL de zone / V ASL de division / D ASL de departement
	nb_users    integer default(0),
	PRIMARY KEY (e_asl_id)
);
CREATE UNIQUE INDEX t_im_asl_asl_id ON mim.t_im_asl (asl_id);

CREATE TABLE mim.t_im_user_metrics
(
    e_user_id   integer NOT NULL,
    dpc         integer,
    dde         integer,
    ddc         integer,
    dds         integer,
    date_1st_hire date,
    date_sa       date,
    date_end_contract date,
    date_last_login date,
    date_1st_login date,
    PRIMARY KEY (e_user_id)
);


--
-- Sample target values.
--

INSERT INTO e_metric_targets (report_type, metric, target) VALUES ('com.entelience.report.usertools.compliancy.PSAUserReport', 'dde', 15.0);
INSERT INTO e_metric_targets (report_type, metric, target) VALUES ('com.entelience.report.usertools.compliancy.PSAUserReport', 'ddc', 4.0);
INSERT INTO e_metric_targets (report_type, metric, target) VALUES ('com.entelience.report.usertools.compliancy.PSAUserReport', 'dpc', 7.0);
INSERT INTO e_metric_targets (report_type, metric, target) VALUES ('com.entelience.report.usertools.compliancy.PSAUserReport', 'dds', 5.0);
INSERT INTO e_metric_targets (report_type, metric, target) VALUES ('com.entelience.report.usertools.compliancy.PSAUserReport', 'pdi', 90.0);

CREATE TABLE mim.t_im_asl_to_user (
       e_asl_id  integer NOT NULL,
       e_user_id integer NOT NULL,
       PRIMARY KEY (e_asl_id, e_user_id)
);
CREATE UNIQUE INDEX t_im_asl_to_user_u2a ON mim.t_im_asl_to_user (e_user_id, e_asl_id); -- user to asl




-- ends
