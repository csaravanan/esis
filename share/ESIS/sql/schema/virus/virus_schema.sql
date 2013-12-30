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
-- $Id: virus_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


--
-- contains: ESIS virus model 


--
-- #1 : delete existing schema: nb. in reverse order to create!
--

CREATE schema virus;

CREATE SEQUENCE virus.t_virus_serial;
CREATE TABLE virus.t_virus (
    t_virus_id             int DEFAULT nextval('virus.t_virus_serial'),
    virus_name           text NOT NULL,
    nb_occurence         int NOT NULL DEFAULT 0,
    first_occurence      date,
    last_occurence       date,
    t_virus_type_id      int,
    assigned_date  	 timestamptz, --date assigned in the CME list
    description 	 text,
    creation_date        timestamptz    NOT NULL DEFAULT current_timestamp,
    t_source_id         int,        --the probe it comes from 
    PRIMARY KEY(t_virus_id)
);
CREATE UNIQUE INDEX virus_name ON virus.t_virus (virus_name);

CREATE TABLE virus.t_virus_links (
    t_virus_id 	 	int NOT NULL, --virus.t_virus
    url 		text NOT NULL, 
    description 	text
);


CREATE TABLE virus.t_virus_alias (
    t_virus_id             int,
    alias               text,
    source 		text --name of the vendor that gave this name
);

CREATE TABLE virus.t_virus_to_vuln (
    t_virus_id 		int 	NOT NULL, --table virus.t_virus
    e_vuln_id 		int,  --can be null if the vulnerability does not exist (table vuln.e_vulnerability_id)
	vuln_name		text	NOT NULL,
    UNIQUE (t_virus_id, vuln_name)  -- NOT a PRIMARY KEY< as e_vuln_id can be null
);

CREATE INDEX t_virus_alias_virus_id ON virus.t_virus_alias (t_virus_id);


CREATE SEQUENCE virus.t_virus_type_serial;
CREATE TABLE virus.t_virus_type(
        t_virus_type_id     integer DEFAULT nextval('virus.t_virus_type_serial'),
        ext_type_id   integer,        -- the status in the distant db
        t_source_id     integer,        -- the source, cf tbl e_source
        label     text    NOT NULL,       -- the status name
        normalized      boolean,                -- is this a 'normalized' type
        normalized_type_id    integer,        -- id of the normalized type
        active          boolean NOT NULL,
        creation_date   timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(t_virus_type_id)
);
CREATE UNIQUE INDEX t_virus_type_unik ON virus.t_virus_type(label);
CREATE UNIQUE INDEX t_virus_type_id_unik ON virus.t_virus_type(ext_type_id, t_source_id);
INSERT INTO virus.t_virus_type(label, active) VALUES ('Unclassified', false);


CREATE TABLE virus.t_virus_origin (
    t_virus_origin_id    int, 
    origin               text UNIQUE NOT NULL,
    PRIMARY KEY(t_virus_origin_id)
);


CREATE TABLE virus.t_virus_origin_detail (
    t_virus_origin_detail_id    int, 
    t_virus_origin_id           int     NOT NULL,
    detail               text UNIQUE NOT NULL,
    PRIMARY KEY(t_virus_origin_detail_id)
);

--
-- real labels in sql lang
--
INSERT INTO virus.t_virus_origin (t_virus_origin_id, origin) VALUES (1, 'origin_file');
INSERT INTO virus.t_virus_origin (t_virus_origin_id, origin) VALUES (2, 'origin_mail');
INSERT INTO virus.t_virus_origin (t_virus_origin_id, origin) VALUES (3, 'origin_web');
INSERT INTO virus.t_virus_origin_detail (t_virus_origin_detail_id, t_virus_origin_id, detail) VALUES (1, 1, 'local_device');
INSERT INTO virus.t_virus_origin_detail (t_virus_origin_detail_id, t_virus_origin_id, detail) VALUES (2, 1, 'mobile_device');
INSERT INTO virus.t_virus_origin_detail (t_virus_origin_detail_id, t_virus_origin_id, detail) VALUES (3, 1, 'network_device');
INSERT INTO virus.t_virus_origin_detail (t_virus_origin_detail_id, t_virus_origin_id, detail) VALUES (4, 2, 'internal_mail');
INSERT INTO virus.t_virus_origin_detail (t_virus_origin_detail_id, t_virus_origin_id, detail) VALUES (5, 2, 'incoming_mail');
INSERT INTO virus.t_virus_origin_detail (t_virus_origin_detail_id, t_virus_origin_id, detail) VALUES (6, 2, 'outgoing_mail');
INSERT INTO virus.t_virus_origin_detail (t_virus_origin_detail_id, t_virus_origin_id, detail) VALUES (7, 3, 'web');


--
-- table filled by probes
--
CREATE TABLE virus.t_virus_all_daily(
        t_virus_id      int,
        calc_day        date    NOT NULL,
        e_asset_id      int,
        t_virus_origin_detail_id       int,
        t_user_base_id          int, --mim.t_user_base
        nb_occurences   int     NOT NULL DEFAULT 0, --# of time this virus happend 
        nb_success      int     NOT NULL DEFAULT 0, --# of time this virus happend and was treated successfully
        nb_failures     int     NOT NULL DEFAULT 0 --# of time this virus happend and was not treated successfully
);
CREATE UNIQUE INDEX t_virus_all_daily_unik ON virus.t_virus_all_daily(t_virus_id, calc_day, e_asset_id, t_virus_origin_detail_id, t_user_base_id);

--
-- tables computed by VirusReport
--
CREATE TABLE virus.t_viral_activity(
        calc_day        date,
        nb_occurences   int     NOT NULL DEFAULT 0,
        nb_success      int     NOT NULL DEFAULT 0,
        nb_failures     int     NOT NULL DEFAULT 0, 
        nb_assets       int     NOT NULL DEFAULT 0,
        nb_virus        int     NOT NULL DEFAULT 0,
        PRIMARY KEY(calc_day)
);

CREATE TABLE virus.t_virus_daily(
        calc_day        date,
        t_virus_id      int,
        nb_occurences   int     NOT NULL DEFAULT 0,
        nb_success      int     NOT NULL DEFAULT 0,
        nb_failures     int     NOT NULL DEFAULT 0, 
        nb_assets       int     NOT NULL DEFAULT 0,
        PRIMARY KEY(t_virus_id, calc_day)
);

CREATE TABLE virus.t_virus_type_daily(
        calc_day        date,
        t_virus_type_id int,
        nb_occurences   int     NOT NULL DEFAULT 0,
        nb_success      int     NOT NULL DEFAULT 0,
        nb_failures     int     NOT NULL DEFAULT 0, 
        nb_assets       int     NOT NULL DEFAULT 0,
        nb_virus        int     NOT NULL DEFAULT 0,
        PRIMARY KEY(t_virus_type_id, calc_day)
);

CREATE TABLE virus.t_virus_origin_daily(
        calc_day        date,
        t_virus_id      int,
        t_virus_origin_detail_id        int,
        nb_occurences   int     NOT NULL DEFAULT 0,
        nb_success      int     NOT NULL DEFAULT 0,
        nb_failures     int     NOT NULL DEFAULT 0, 
        nb_assets       int     NOT NULL DEFAULT 0,
        PRIMARY KEY(t_virus_origin_detail_id, t_virus_id, calc_day)
);

CREATE TABLE virus.t_virus_asset_daily(
        calc_day        date,
        t_virus_id      int,
        e_asset_id      int,
        nb_occurences   int     NOT NULL DEFAULT 0,
        nb_success      int     NOT NULL DEFAULT 0,
        nb_failures     int     NOT NULL DEFAULT 0, 
        PRIMARY KEY(e_asset_id, t_virus_id, calc_day)
);

CREATE TABLE virus.t_virus_location_daily(
        calc_day        date,
        t_virus_id      int,
        e_location_id   int,
        nb_occurences   int     NOT NULL DEFAULT 0,
        nb_success      int     NOT NULL DEFAULT 0,
        nb_failures     int     NOT NULL DEFAULT 0,
        nb_assets       int     NOT NULL DEFAULT 0,
        PRIMARY KEY(e_location_id, t_virus_id, calc_day)
);

--
-- assets being watched for virus at a certain date
--
CREATE TABLE virus.t_watched_assets(
        calc_day                date,
        e_asset_id              int,
        PRIMARY KEY(calc_day, e_asset_id)
);


--
-- global threat levels got from external providers
--
CREATE SEQUENCE virus.t_alert_provider_serial;
CREATE TABLE virus.t_alert_provider(
        t_alert_provider_id     int DEFAULT nextval('virus.t_alert_provider_serial'),
        name                    text    UNIQUE NOT NULL,
        PRIMARY KEY(t_alert_provider_id)
);

--
-- ESIS alert levels
-- feeded by sql lang script
--
CREATE TABLE virus.e_alert_level(
        e_alert_level_id        int     NOT NULL,
        alert_name              text    UNIQUE NOT NULL,
        PRIMARY KEY(e_alert_level_id)
);

--
-- real labels in sqllang
--
INSERT INTO virus.e_alert_level (e_alert_level_id, alert_name) VALUES (1, 'normal');
INSERT INTO virus.e_alert_level (e_alert_level_id, alert_name) VALUES (2, 'high');
INSERT INTO virus.e_alert_level (e_alert_level_id, alert_name) VALUES (3, 'very high');
INSERT INTO virus.e_alert_level (e_alert_level_id, alert_name) VALUES (4, 'extreme');

--
-- alert levels from external providers
--
CREATE SEQUENCE virus.t_alert_level_serial;
CREATE TABLE virus.t_alert_level(
        t_alert_level_id        int DEFAULT nextval('virus.t_alert_level_serial'),
        t_alert_provider_id     int NOT NULL,
        level_name              text NOT NULL,
        e_alert_level_id        int NOT NULL, --e_alert_level
        PRIMARY KEY(t_alert_level_id) 
);
CREATE UNIQUE INDEX t_alert_level_name ON virus.t_alert_level(t_alert_provider_id, level_name);

--
-- daily alert levels from external providers
--
CREATE TABLE virus.t_alert_daily(
        calc_day                date    NOT NULL,
        t_alert_provider_id     int     NOT NULL,
        t_alert_level_id        int     NOT NULL,
        PRIMARY KEY (calc_day, t_alert_provider_id)
);

--
-- daily global alert level 
--
CREATE TABLE virus.e_alert_daily(
        calc_day                date,
        e_alert_level_id        int NOT NULL,
        PRIMARY KEY(calc_day)
);