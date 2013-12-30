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
-- $Id: itops_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--

--
-- Contains schema required for system events and alerts

CREATE SCHEMA itops;
--
-- alert type
--
CREATE SEQUENCE itops.t_alert_type_serial;
CREATE TABLE itops.t_alert_type (
	t_alert_type_id        integer DEFAULT nextval('itops.t_alert_type_serial'),
	alert_type              text UNIQUE NOT NULL,
	PRIMARY KEY(t_alert_type_id)
);

--
-- alerts, probe specific
--
CREATE SEQUENCE itops.t_alert_serial;
CREATE TABLE itops.t_alert (
	t_alert_id		integer	DEFAULT nextval('itops.t_alert_serial'),
	t_alert_type_id         integer NOT NULL, -- e_alert_type
	probe_name              text    NOT NULL, --name of the probe the alert come from
	alert_name              text    NOT NULL,
	PRIMARY KEY(t_alert_id)
);
CREATE UNIQUE INDEX itops_t_alert_unik ON itops.t_alert(probe_name, alert_name);

--
-- alert severity
--
CREATE TABLE itops.t_alert_severity (
        t_alert_severity_id     integer,
        severity_name           text    UNIQUE NOT NULL,
        PRIMARY KEY(t_alert_severity_id)
);

--
-- alert priority
--
CREATE TABLE itops.t_alert_priority (
        t_alert_priority_id     integer,
        priority_name           text    UNIQUE NOT NULL,
        PRIMARY KEY(t_alert_priority_id)
);

--
-- Severity and priority cannot be related to alerts 
-- http://blogs.msdn.com/mariussutara/archive/2007/12/17/alert-severity-and-priority-use-with-override.aspx 
--
CREATE TABLE itops.t_alert_daily (
        t_alert_id              integer,
        calc_day                date,
        t_severity_id           integer,
        t_priority_id           integer,
        count_added_businesshour             integer NOT NULL,
        count_added_offhour                  integer NOT NULL,
        count_resolved_businesshour          integer NOT NULL,
        count_resolved_offhour  integer NOT NULL,
        total_time_to_resolve   bigint, --in s, null if no resolution this day
        avg_time_to_resolve     int, --in s, null if no resolution this day
        PRIMARY KEY(t_alert_id, calc_day, t_severity_id, t_priority_id)
);


CREATE TABLE itops.t_alert_asset_daily (
        t_alert_id              integer,
        e_asset_id              integer,
        calc_day                date,
        t_severity_id           integer,
        t_priority_id           integer,
        count_added_businesshour             integer NOT NULL,
        count_added_offhour                  integer NOT NULL,
        count_resolved_businesshour          integer NOT NULL,
        count_resolved_offhour  integer NOT NULL,
        total_time_to_resolve   bigint, --in s, null if no resolution this day
        avg_time_to_resolve     int, --in s, null if no resolution this day
        PRIMARY KEY(t_alert_id, e_asset_id, calc_day, t_severity_id, t_priority_id)
);

--
-- channel for windows events
--
CREATE SEQUENCE itops.t_event_channel_serial;
CREATE TABLE itops.t_event_channel (
        t_event_channel_id      integer DEFAULT nextval('itops.t_event_channel_serial'),
        channel_name            text    UNIQUE  NOT NULL,
        PRIMARY KEY(t_event_channel_id)
);

--
-- publisher for windows events
--
CREATE SEQUENCE itops.t_event_publisher_serial;
CREATE TABLE itops.t_event_publisher (
        t_event_publisher_id      integer DEFAULT nextval('itops.t_event_publisher_serial'),
        t_event_channel_id        integer, --can be null if no channel
        publisher_name            text    UNIQUE  NOT NULL,
        probe_name                text    NOT NULL, --name of the probe the alert come from
        PRIMARY KEY(t_event_publisher_id)
);

--
-- levels for windows events
--
CREATE TABLE itops.t_event_level (
        t_event_level_id          integer,
        event_level               text    UNIQUE NOT NULL,
        PRIMARY KEY(t_event_level_id)
);

CREATE TABLE itops.t_event_daily (
        calc_day                date    NOT NULL,
        t_user_base_id          integer,        --nullable, some events do not come from an user
        t_event_publisher_id      integer NOT NULL,
        t_event_level_id        integer NOT NULL,
        e_asset_id              integer NOT NULL,
        count_events_businesshour            integer NOT NULL,
        count_events_offhour    integer NOT NULL
);
-- NO PK because t_user_base_id can be null : UNIQUE INDEX instead
CREATE UNIQUE INDEX itops_t_event_daily_unik ON itops.t_event_daily(calc_day, t_user_base_id, t_event_publisher_id, t_event_level_id, e_asset_id);


CREATE TABLE itops.t_managed_computer (
        calc_day        date,
        e_asset_id      integer,
        tool_name       text,
        PRIMARY KEY(calc_day, e_asset_id, tool_name)
);

CREATE TABLE itops.t_managed_computer_daily (
        calc_day        date,
        count_assets    integer NOT NULL,
        PRIMARY KEY(calc_day)
);