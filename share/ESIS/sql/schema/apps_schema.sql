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
-- $Id: apps_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--

--
-- Contains schema required for applications schema and their event

--
-- an application instance
--
CREATE SCHEMA apps;

CREATE SEQUENCE	apps.t_app_serial;
CREATE TABLE apps.t_app(
        t_app_id        integer DEFAULT nextval('apps.t_app_serial'),
        e_product_id    integer NOT NULL, --asset.e_product
        probe_source    text    NOT NULL,
        creation_date   timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(t_app_id)
);


CREATE SEQUENCE apps.t_log_level_serial;
CREATE TABLE apps.t_log_level(
        t_log_level_id  integer DEFAULT nextval('apps.t_log_level_serial'),
        level_name      text    UNIQUE NOT NULL,
        PRIMARY KEY(t_log_level_id)
);
--
-- prefill with default values
--
INSERT INTO apps.t_log_level(level_name) VALUES ('DEBUG');
INSERT INTO apps.t_log_level(level_name) VALUES ('INFO');
INSERT INTO apps.t_log_level(level_name) VALUES ('NOTICE');
INSERT INTO apps.t_log_level(level_name) VALUES ('WARN');
INSERT INTO apps.t_log_level(level_name) VALUES ('ERROR');
INSERT INTO apps.t_log_level(level_name) VALUES ('CRITICAL');
INSERT INTO apps.t_log_level(level_name) VALUES ('ALERT');
INSERT INTO apps.t_log_level(level_name) VALUES ('EMERGENCY');


CREATE TABLE apps.t_app_log_level_daily(
        calc_day        date    NOT NULL,
        t_app_id        integer NOT NULL,
        t_log_level_id  integer NOT NULL,
        nb_instances    integer NOT NULL DEFAULT 0,
        PRIMARY KEY(calc_day, t_app_id, t_log_level_id)
);

CREATE SEQUENCE apps.t_app_event_serial;
CREATE TABLE apps.t_app_event(
        t_app_event_id  integer DEFAULT nextval('apps.t_app_event_serial'),
        t_app_id        integer NOT NULL,
        event_name      text    NOT NULL,
        description     text,
        t_log_level_id  integer,
        sub_system      text,
        creation_date   timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(t_app_event_id)
);
CREATE UNIQUE INDEX t_app_event_uniq ON apps.t_app_event(t_app_id, event_name);

CREATE TABLE apps.t_app_event_daily(
        calc_day        date    NOT NULL,
        t_app_event_id  integer NOT NULL,
        count_events    integer NOT NULL DEFAULT 0,
        PRIMARY KEY(calc_day, t_app_event_id)
);