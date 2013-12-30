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
-- $Id: net_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


--
-- contains: ESIS network events data

CREATE SCHEMA net;


--
-- table of IP adresses
--
CREATE SEQUENCE net.t_ip_serial;
CREATE TABLE net.t_ip(
        t_ip_id       int     DEFAULT nextval('net.t_ip_serial'),
        ip            inet    UNIQUE NOT NULL,
        rfc1918       boolean,      --null at creation, filled during computations
        creation_date timestamptz NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(t_ip_id)
);
-- functionnal index because host(ip) is the way to lookup for IPs
CREATE INDEX net_t_ip_ip_txt ON net.t_ip(host(ip));

--
-- IP ranges
--
CREATE SEQUENCE net.t_ip_range_serial;
CREATE TABLE net.t_ip_range(
        t_ip_range_id   int     DEFAULT nextval('net.t_ip_range_serial'),
        net_range       cidr    NOT NULL,
        rfc1918         boolean NOT NULL,
        PRIMARY KEY(t_ip_range_id)
);
INSERT INTO net.t_ip_range (net_range, rfc1918) VALUES ('10/8', true);
INSERT INTO net.t_ip_range (net_range, rfc1918) VALUES ('172.16/12', true);
INSERT INTO net.t_ip_range (net_range, rfc1918) VALUES ('192.168/16', true);

--
-- table used to map IP to Locations' subnets
--
CREATE TABLE net.t_ip_location(
        t_ip_id         int,
        e_location_id   int,
        PRIMARY KEY(t_ip_id, e_location_id)
);



--
-- syslog events summary
--
CREATE TABLE net.t_syslogs_daily(
        calc_day        date,
        e_asset_id      int,
        count_debug     int     NOT NULL DEFAULT 0,
        count_info     int     NOT NULL DEFAULT 0,
        count_notice     int     NOT NULL DEFAULT 0,
        count_warning     int     NOT NULL DEFAULT 0,
        count_err     int     NOT NULL DEFAULT 0,
        count_critical     int     NOT NULL DEFAULT 0,
        count_alert     int     NOT NULL DEFAULT 0,
        count_emergency     int     NOT NULL DEFAULT 0,
        count_others     int     NOT NULL DEFAULT 0,
        PRIMARY KEY (calc_day, e_asset_id)
);

CREATE TABLE net.t_devices_daily(
        calc_day        date,
        e_asset_id      int,
        count_configured        int     NOT NULL DEFAULT 0,
        count_rebooted          int     NOT NULL DEFAULT 0,
        count_command           int     NOT NULL DEFAULT 0,
        count_login_success     int     NOT NULL DEFAULT 0,
        count_login_failure     int     NOT NULL DEFAULT 0,
        PRIMARY KEY (calc_day, e_asset_id)
);



--
-- services
--
CREATE SEQUENCE net.t_custom_service_serial;
CREATE TABLE net.t_custom_service(
        t_custom_service_id     integer DEFAULT nextval('net.t_custom_service_serial'),
        service_name            text    NOT NULL,       --name provided by the source
        e_protocol_id           integer,                -- net.e_iana_procotol
        probe_name              text    NOT NULL,       --the probe which this service come from
        t_net_iana_port_id      integer,                --the IANA port : may be null if not able to match a IANA port (filled during report)
        port                    integer, --may be null, must match the iana port if t_net_iana_port_id is not null
        creation_date           timestamptz DEFAULT current_timestamp,
        PRIMARY KEY (t_custom_service_id)
);
CREATE UNIQUE INDEX t_custom_service_unik ON net.t_custom_service(probe_name, lower(service_name), e_protocol_id);

--
-- rules
--
CREATE SEQUENCE net.t_rule_serial;
CREATE TABLE net.t_rule(
        t_rule_id               integer DEFAULT nextval('net.t_rule_serial'),
        rule_name               text    NOT NULL,
        description             text,
        probe_name              text    NOT NULL,       --the probe which this service come from
        creation_date           timestamptz DEFAULT current_timestamp,
        PRIMARY KEY(t_rule_id)
);

--
-- actions
--
CREATE SEQUENCE net.t_action_serial START 100;
CREATE TABLE net.t_action(
        t_action_id             integer DEFAULT nextval('net.t_action_serial'),
        action_name             text    UNIQUE NOT NULL,
        blocking                boolean DEFAULT false,
        creation_date           timestamptz DEFAULT current_timestamp,
        PRIMARY KEY(t_action_id)
);
INSERT INTO net.t_action(t_action_id, action_name, blocking) VALUES (1, 'Accept', false);
INSERT INTO net.t_action(t_action_id, action_name, blocking) VALUES (2, 'Reject', true);
INSERT INTO net.t_action(t_action_id, action_name, blocking) VALUES (3, 'Drop', true);
INSERT INTO net.t_action(t_action_id, action_name, blocking) VALUES (4, 'Monitor', false);
INSERT INTO net.t_action(t_action_id, action_name, blocking) VALUES (5, 'Block', true);
INSERT INTO net.t_action(t_action_id, action_name, blocking) VALUES (6, 'Pass', false);
INSERT INTO net.t_action(t_action_id, action_name, blocking) VALUES (7, 'Deny', true);

--
-- severity
--
CREATE SEQUENCE net.t_severity_serial START 100;
CREATE TABLE net.t_severity(
        t_severity_id           integer DEFAULT nextval('net.t_severity_serial'),
        severity_name           text    UNIQUE NOT NULL,
        probe_name              text,       --the probe which this service come from
        normalized              boolean,                -- is this a 'normalized' status
        normalized_severity_id  integer,        -- id of the normalized severity 
        creation_date           timestamptz DEFAULT current_timestamp,
        PRIMARY KEY(t_severity_id)
);
--
-- the WELF severities
--
INSERT INTO net.t_severity(t_severity_id, severity_name, normalized) VALUES (1, 'High', true);
INSERT INTO net.t_severity(t_severity_id, severity_name, normalized) VALUES (2, 'Medium', true);
INSERT INTO net.t_severity(t_severity_id, severity_name, normalized) VALUES (3, 'Low', true);
INSERT INTO net.t_severity(t_severity_id, severity_name, normalized, normalized_severity_id) VALUES (10, 'Emergency', false, 1);
INSERT INTO net.t_severity(t_severity_id, severity_name, normalized, normalized_severity_id) VALUES (11, 'Alert', false, 1);
INSERT INTO net.t_severity(t_severity_id, severity_name, normalized, normalized_severity_id) VALUES (12, 'Critical', false, 1);
INSERT INTO net.t_severity(t_severity_id, severity_name, normalized, normalized_severity_id) VALUES (13, 'Error', false, 2);
INSERT INTO net.t_severity(t_severity_id, severity_name, normalized, normalized_severity_id) VALUES (14, 'Warning', false, 2);
INSERT INTO net.t_severity(t_severity_id, severity_name, normalized, normalized_severity_id) VALUES (15, 'Notice', false, 3);
INSERT INTO net.t_severity(t_severity_id, severity_name, normalized, normalized_severity_id) VALUES (16, 'Information', false, 3);
INSERT INTO net.t_severity(t_severity_id, severity_name, normalized, normalized_severity_id) VALUES (17, 'Debug', false, 3);

--
-- No constraint on this table, fields may be null
-- table used during report to feed other tables
CREATE TABLE net.t_rule_action_daily(
        calc_day        date    NOT NULL,
        t_rule_id       integer,          -- net.t_rule
        t_custom_service_id     integer,  -- net.t_custom_service
        ip_src          integer,   -- net.t_ip (origin)
        ip_dest         integer,   -- net.t_ip (destination)
        e_asset_id      integer NOT NULL,   -- asset.e_asset
        t_action_id     integer NOT NULL,   -- net.t_action
        t_severity_id   integer,            -- net.t_severity
        nb_occurences   bigint NOT NULL DEFAULT 0
);
CREATE UNIQUE INDEX t_net_rule_action_daily_unik ON net.t_rule_action_daily(calc_day, t_custom_service_id, e_asset_id, t_action_id, ip_dest, ip_src, t_rule_id, t_severity_id);

--
-- metrics per rules
--
CREATE TABLE net.t_rule_daily(
        calc_day        date,
        t_rule_id       integer,
        count_all       bigint NOT NULL DEFAULT 0,  --# of occurence of this rule
        count_blocked   bigint NOT NULL DEFAULT 0,  --# of blocks by this rule
        count_allowed   bigint NOT NULL DEFAULT 0,  --# of allows by this rule
        count_distinct_ip_src   integer NOT NULL DEFAULT 0, --# of IPs as source of an occurence of this rule
        count_distinct_ip_src_blocked   integer NOT NULL DEFAULT 0, --# of IPs as source of block by this rule
        count_distinct_ip_src_allowed   integer NOT NULL DEFAULT 0, --# of IPs as source of an allow by this rule
        count_distinct_ip_dst   integer NOT NULL DEFAULT 0, --# of IPs as destination of an occurence of this rule
        count_distinct_ip_dst_blocked   integer NOT NULL DEFAULT 0, --# of IPs as destination of block by this rule
        count_distinct_ip_dst_allowed   integer NOT NULL DEFAULT 0, --# of IPs as destination of an allow by this rule
        count_distinct_locations_src   integer NOT NULL DEFAULT 0, --# of locations as source of an occurence of this rule
        count_distinct_locations_src_blocked   integer NOT NULL DEFAULT 0, --# of locations as source of block by this rule
        count_distinct_locations_src_allowed   integer NOT NULL DEFAULT 0, --# of locations as source of an allow by this rule
        count_distinct_locations_dst   integer NOT NULL DEFAULT 0, --# of locations as destination of an occurence of this rule
        count_distinct_locations_dst_blocked   integer NOT NULL DEFAULT 0, --# of locations as destination of block by this rule
        count_distinct_locations_dst_allowed   integer NOT NULL DEFAULT 0, --# of locations as destination of an allow by this rule
        count_distinct_custom_services   integer NOT NULL DEFAULT 0, --# of services as an origin of this rule
        count_distinct_custom_services_blocked   integer NOT NULL DEFAULT 0, --# of services allowed by this rule
        count_distinct_custom_services_allowed   integer NOT NULL DEFAULT 0, --# of services blocked by this rule
        PRIMARY KEY(t_rule_id, calc_day)
);
CREATE INDEX t_net_rule_daily_date_idx ON net.t_rule_daily(calc_day);

--
-- metrics per IP
--
CREATE TABLE net.t_ip_daily(
        calc_day        date,
        t_ip_id         integer,
        count_all_dest  bigint NOT NULL DEFAULT 0, --# of occurence of this IP as a destination
        count_blocked_dest   bigint NOT NULL DEFAULT 0, --# of blocks for this IP as a destination
        count_allowed_dest   bigint NOT NULL DEFAULT 0, --# of allows for this IP as a destination
        count_distinct_rules_dest   integer NOT NULL DEFAULT 0, --# of rules for this IP as a destination
        count_distinct_rules_blocked_dest   integer NOT NULL DEFAULT 0, --# of blocking rules for this IP as a destination
        count_distinct_rules_allowed_dest   integer NOT NULL DEFAULT 0, --# of allowing rules for this IP as a destination
        count_distinct_custom_services_dest   integer NOT NULL DEFAULT 0, --# of services for this IP as a destination
        count_distinct_custom_services_blocked_dest   integer NOT NULL DEFAULT 0, --# of blocked services for this IP as a destination
        count_distinct_custom_services_allowed_dest   integer NOT NULL DEFAULT 0, --# of allowed services for this IP as a destination
        count_all_src  bigint    NOT NULL DEFAULT 0, --# of occurence of this IP as a source
        count_blocked_src   bigint NOT NULL DEFAULT 0, --# of blocks for this IP as a source
        count_allowed_src   bigint NOT NULL DEFAULT 0, --# of allows for this IP as a source
        count_distinct_rules_src   integer NOT NULL DEFAULT 0, --# of blocking rules for this IP as a source
        count_distinct_rules_blocked_src   integer NOT NULL DEFAULT 0, --# of allowing rules for this IP as a source
        count_distinct_rules_allowed_src   integer NOT NULL DEFAULT 0, --# of allowing rules for this IP as a source
        count_distinct_custom_services_src   integer NOT NULL DEFAULT 0, --# of services for this IP as a source
        count_distinct_custom_services_blocked_src   integer NOT NULL DEFAULT 0, --# of blocked services for this IP as a source
        count_distinct_custom_services_allowed_src   integer NOT NULL DEFAULT 0, --# of allowed services for this IP as a source
        PRIMARY KEY(t_ip_id, calc_day)
);
CREATE INDEX t_net_t_ip_daily_date_idx ON net.t_ip_daily(calc_day);

--
-- metrics per location (cf comments of t_ip_daily)
--
CREATE TABLE net.t_location_daily(
        calc_day        date,
        e_location_id   integer,
        count_all_dest  bigint   NOT NULL DEFAULT 0,
        count_blocked_dest   bigint NOT NULL DEFAULT 0,
        count_allowed_dest   bigint NOT NULL DEFAULT 0,
        count_distinct_rules_dest   integer NOT NULL DEFAULT 0,
        count_distinct_rules_blocked_dest   integer NOT NULL DEFAULT 0,
        count_distinct_rules_allowed_dest   integer NOT NULL DEFAULT 0,
        count_distinct_custom_services_dest   integer NOT NULL DEFAULT 0,
        count_distinct_custom_services_blocked_dest   integer NOT NULL DEFAULT 0,
        count_distinct_custom_services_allowed_dest   integer NOT NULL DEFAULT 0,
        count_all_src  bigint    NOT NULL DEFAULT 0,
        count_blocked_src   bigint NOT NULL DEFAULT 0,
        count_allowed_src   bigint NOT NULL DEFAULT 0,
        count_distinct_rules_src   integer NOT NULL DEFAULT 0,
        count_distinct_rules_blocked_src   integer NOT NULL DEFAULT 0,
        count_distinct_rules_allowed_src   integer NOT NULL DEFAULT 0,
        count_distinct_custom_services_src   integer NOT NULL DEFAULT 0,
        count_distinct_custom_services_blocked_src   integer NOT NULL DEFAULT 0,
        count_distinct_custom_services_allowed_src   integer NOT NULL DEFAULT 0,
        PRIMARY KEY(e_location_id, calc_day)
);
CREATE INDEX t_location_daily_date_idx ON net.t_location_daily(calc_day);

--
-- metrics per asset(firewall) (cf comments of t_rule_daily)
--
CREATE TABLE net.t_asset_action_daily(
        calc_day        date,
        e_asset_id      integer,
        count_all       bigint NOT NULL DEFAULT 0,
        count_blocked   bigint NOT NULL DEFAULT 0,
        count_allowed   bigint NOT NULL DEFAULT 0,
        count_distinct_ip_src   integer NOT NULL DEFAULT 0,
        count_distinct_ip_src_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_ip_src_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_ip_dst   integer NOT NULL DEFAULT 0,
        count_distinct_ip_dst_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_ip_dst_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_locations_src   integer NOT NULL DEFAULT 0,
        count_distinct_locations_src_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_locations_src_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_locations_dst   integer NOT NULL DEFAULT 0,
        count_distinct_locations_dst_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_locations_dst_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_rules   integer NOT NULL DEFAULT 0, --# of rules for this asset
        count_distinct_rules_blocked   integer NOT NULL DEFAULT 0, --# of blocking rules for this asset
        count_distinct_rules_allowed   integer NOT NULL DEFAULT 0, --# of allowing rules for this asset
        count_distinct_custom_services   integer NOT NULL DEFAULT 0,
        count_distinct_custom_services_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_custom_services_allowed   integer NOT NULL DEFAULT 0,
        PRIMARY KEY(e_asset_id, calc_day)
);
CREATE INDEX t_net_t_asset_action_daily_date_idx ON net.t_asset_action_daily(calc_day);

CREATE TABLE net.t_daily_summary(
        calc_day        date,
        count_all       bigint NOT NULL DEFAULT 0,
        count_blocked   bigint NOT NULL DEFAULT 0,
        count_allowed   bigint NOT NULL DEFAULT 0,
        count_distinct_ip_src   integer NOT NULL DEFAULT 0,
        count_distinct_ip_src_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_ip_src_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_ip_dst   integer NOT NULL DEFAULT 0,
        count_distinct_ip_dst_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_ip_dst_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_locations_src   integer NOT NULL DEFAULT 0,
        count_distinct_locations_src_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_locations_src_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_locations_dst   integer NOT NULL DEFAULT 0,
        count_distinct_locations_dst_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_locations_dst_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_rules   integer NOT NULL DEFAULT 0,
        count_distinct_rules_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_rules_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_custom_services   integer NOT NULL DEFAULT 0,
        count_distinct_custom_services_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_custom_services_allowed   integer NOT NULL DEFAULT 0,
        PRIMARY KEY(calc_day)
);


CREATE TABLE net.t_custom_service_daily(
        calc_day        date,
        t_custom_service_id       integer,
        count_all       bigint NOT NULL DEFAULT 0,
        count_blocked   bigint NOT NULL DEFAULT 0,
        count_allowed   bigint NOT NULL DEFAULT 0,
        count_distinct_ip_src   integer NOT NULL DEFAULT 0,
        count_distinct_ip_src_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_ip_src_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_ip_dst   integer NOT NULL DEFAULT 0,
        count_distinct_ip_dst_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_ip_dst_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_locations_src   integer NOT NULL DEFAULT 0,
        count_distinct_locations_src_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_locations_src_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_locations_dst   integer NOT NULL DEFAULT 0,
        count_distinct_locations_dst_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_locations_dst_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_rules   integer NOT NULL DEFAULT 0,
        count_distinct_rules_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_rules_allowed   integer NOT NULL DEFAULT 0,
        PRIMARY KEY(t_custom_service_id, calc_day)
);
CREATE INDEX t_net_custom_service_date_idx ON net.t_custom_service_daily(calc_day);

CREATE TABLE net.e_port_range_daily(
        calc_day        date,
        e_iana_port_range_id       integer,
        count_all       bigint NOT NULL DEFAULT 0,
        count_blocked   bigint NOT NULL DEFAULT 0,
        count_allowed   bigint NOT NULL DEFAULT 0,
        count_distinct_ip_src   integer NOT NULL DEFAULT 0,
        count_distinct_ip_src_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_ip_src_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_ip_dst   integer NOT NULL DEFAULT 0,
        count_distinct_ip_dst_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_ip_dst_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_locations_src   integer NOT NULL DEFAULT 0,
        count_distinct_locations_src_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_locations_src_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_locations_dst   integer NOT NULL DEFAULT 0,
        count_distinct_locations_dst_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_locations_dst_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_rules   integer NOT NULL DEFAULT 0,
        count_distinct_rules_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_rules_allowed   integer NOT NULL DEFAULT 0,
        PRIMARY KEY(e_iana_port_range_id, calc_day)
);
CREATE INDEX e_net_port_range_daily_date_idx ON net.e_port_range_daily(calc_day);

CREATE TABLE net.t_severity_daily(
        calc_day        date,
        t_severity_id   int,
        count_all       bigint NOT NULL DEFAULT 0,
        count_blocked   bigint NOT NULL DEFAULT 0,
        count_allowed   bigint NOT NULL DEFAULT 0,
        count_distinct_ip_src   integer NOT NULL DEFAULT 0,
        count_distinct_ip_src_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_ip_src_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_ip_dst   integer NOT NULL DEFAULT 0,
        count_distinct_ip_dst_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_ip_dst_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_locations_src   integer NOT NULL DEFAULT 0,
        count_distinct_locations_src_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_locations_src_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_locations_dst   integer NOT NULL DEFAULT 0,
        count_distinct_locations_dst_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_locations_dst_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_rules   integer NOT NULL DEFAULT 0,
        count_distinct_rules_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_rules_allowed   integer NOT NULL DEFAULT 0,
        count_distinct_custom_services   integer NOT NULL DEFAULT 0,
        count_distinct_custom_services_blocked   integer NOT NULL DEFAULT 0,
        count_distinct_custom_services_allowed   integer NOT NULL DEFAULT 0,
        PRIMARY KEY(t_severity_id, calc_day)
);
CREATE INDEX t_net_severity_daily_date_idx ON net.t_severity_daily(calc_day);