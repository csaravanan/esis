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
-- $Id: assets_schema.sql 406 2010-04-13 07:31:03Z pleberre $
--
--

--
-- contains: ESIS asset management model (Version: 1.2)

CREATE SCHEMA asset;

--
-- #2 : define tables
--

--
-- e_asset - main repository
--

-- Link assets to IP address (see net schema)
CREATE TABLE asset.e_asset_ip (
        e_asset_id      int,
        t_ip_id         int,		-- an IP can be assigned to more than one asset !
        date_added      timestamptz NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(e_asset_id, t_ip_id)
);

-- Assets network interface, if we ever have mac address
CREATE SEQUENCE asset.e_asset_network_interface_serial;
CREATE TABLE asset.e_asset_network_interface (
        e_asset_network_interface_id    int     DEFAULT nextval('asset.e_asset_network_interface_serial'), -- primary key
        e_asset_id                      int     NOT NULL,
        mac_address                     text    NOT NULL,
        PRIMARY KEY(e_asset_network_interface_id)
);
CREATE UNIQUE INDEX e_asset_network_interface_mac ON asset.e_asset_network_interface(mac_address);

-- Assets main table
CREATE SEQUENCE asset.e_asset_serial;
CREATE TABLE asset.e_asset (
        e_asset_id              int             DEFAULT nextval('asset.e_asset_serial'), -- primary key
        obj_ser                 int             NOT NULL,
        obj_lm                  timestamptz     NOT NULL,
        db_user                 text            NOT NULL,
        creation_date           timestamptz     NOT NULL DEFAULT current_timestamp,
        fqdn                    text,           -- fully qualified domain name
        host                    text,           -- host name
        domain                  text,           -- domain name
        serial_number           text,           -- dream
        dhcp                    boolean         NOT NULL        DEFAULT false,       -- is it managed by DHCP or not
        t_main_ip_id            int,                -- this one is not unique so this might lead to issues... 
		gateway_ip_id			int,				-- the net.t_ip of the gateway
        e_main_network_interface_id     int,        -- asset.e_network_interface
        system_owner            int,                    -- key into e_people
        security_classification int,                    -- key into e_sc
        business_line           int,                    -- key into e_bl
        availability            int,                    -- key into e_availabliity
        asset_type              int,                    -- key into e_asset_type
        active                  boolean         NOT NULL default false,
        unique_name             text            NOT NULL, --not null, maintained by trigger
        display_name            text,   --maintained by trigger
        timezone                text,
        PRIMARY KEY(e_asset_id)
);
CREATE UNIQUE INDEX e_asset_unique_fqdn ON asset.e_asset(fqdn);
CREATE UNIQUE INDEX e_asset_unique_serial ON asset.e_asset(serial_number);
CREATE UNIQUE INDEX e_asset_unique_host ON asset.e_asset(host, domain);
CREATE UNIQUE INDEX e_asset_unique_interface ON asset.e_asset(e_main_network_interface_id);
CREATE UNIQUE INDEX e_asset_unique_name ON asset.e_asset(unique_name);
CREATE INDEX e_asset_main_ip ON asset.e_asset(t_main_ip_id);

--
-- Links assets -> IP -> IP ports
--
CREATE TABLE asset.e_asset_port_daily (
	calc_day		date,	-- day when this service was detected
	t_ip_id			int,	-- which IP was it on (DHCP case)
	e_asset_id		int,	-- the asset,
	t_iana_port_id	int,	-- which port
	PRIMARY KEY(calc_day, t_ip_id, e_asset_id, t_iana_port_id)
);

--
-- Links assets -> IP -> protocols (those with no ports per se)
--
CREATE TABLE asset.e_asset_protocol_daily (
	calc_day			date,	-- day when this service was detected
	t_ip_id				int,	-- which IP was it on (DHCP case)
	e_asset_id			int,	-- the asset,
	e_protocol_id		int,	-- which protocol
	PRIMARY KEY(calc_day, t_ip_id, e_asset_id, e_protocol_id)
);

--
-- e_asset_product - asset <-> product relationships
--
-- please do not modify this table directly, use functions add_asset_product and remove_asset_product instead
--
CREATE TABLE asset.e_asset_product (
	e_asset_id		int NOT NULL, -- key into e_asset
	e_product_id		int NOT NULL, -- key into e_product
	e_version_id		int, -- (optional) key into e_version
	date_added              timestamptz NOT NULL DEFAULT current_timestamp,
	is_main			boolean NOT NULL default false -- if true, this is the assets' "Operating System" (main software) (hack)
	-- regarding is_main there *SHOULD* be only one "is_main == true" for each different e_asset_id.
,	PRIMARY KEY(e_asset_id, e_product_id)
);

CREATE TABLE asset.e_asset_product_history (
        e_asset_id              int     NOT NULL,
        e_product_id            int     NOT NULL,
        modification_date       timestamptz NOT NULL DEFAULT current_timestamp,
        added                   boolean NOT NULL, --added? (true) or removed? (false)
        modifier                int NOT NULL --e_people_id
);


CREATE SEQUENCE asset.e_detected_product_serial;
CREATE TABLE asset.e_detected_product (
        e_detected_product_id   int     DEFAULT nextval('asset.e_detected_product_serial'),
        detected_product        text    UNIQUE NOT NULL,
        e_product_id            int,  --can be null if not able to resolve to an existing product
        creation_date           timestamptz NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(e_detected_product_id)
);

CREATE TABLE asset.e_asset_product_detected (
        calc_day                date,
        e_asset_id              int,
        e_detected_product_id   int,
        probe_name              text,
        PRIMARY KEY(calc_day, e_asset_id, e_detected_product_id, probe_name)
);


--
-- e_asset_type - asset type
--
CREATE SEQUENCE asset.e_asset_type_serial	START 100;
CREATE TABLE asset.e_asset_type (
	id			integer   DEFAULT nextval('asset.e_asset_type_serial'),
	name			text NOT NULL,
	PRIMARY KEY(id)
);
CREATE UNIQUE INDEX e_asset_type_name ON asset.e_asset_type (name);
-- see sql/lang/assets_strings.sqltemplate

--
-- e_sc - security classification
--
CREATE SEQUENCE asset.e_sc_serial	START 100;
CREATE TABLE asset.e_sc (
	id			integer   DEFAULT nextval('asset.e_sc_serial'),
	name			text NOT NULL,
	PRIMARY KEY(id)
);
CREATE UNIQUE INDEX e_sc_name ON asset.e_sc (name);
-- see sql/lang/assets_strings.sqltemplate

--
-- e_bl - business line
--
CREATE SEQUENCE asset.e_bl_serial	START 100;
CREATE TABLE asset.e_bl (
	id			integer   DEFAULT nextval('asset.e_bl_serial'),
	name			text NOT NULL,
	PRIMARY KEY(id)
);
CREATE UNIQUE INDEX e_bl_name ON asset.e_bl (name);
-- see sql/lang/assets_strings.sqltemplate

--
-- e_availability
--
CREATE SEQUENCE asset.e_availability_serial	START 100;
CREATE TABLE asset.e_availability (
	id			int   DEFAULT nextval('asset.e_availability_serial'),
	name		text NOT NULL,
	PRIMARY KEY(id)
);
CREATE UNIQUE INDEX e_availability_name ON asset.e_availability (name);
-- see sql/lang/assets_strings.sqltemplate

--
-- e_expertise
--
CREATE TABLE asset.e_expertise (
	e_people_id		integer,	        --e_people
        e_group_id		integer,		--e_group
	e_vendor_id		integer,		--e_vendor
	e_product_id		integer,		--e_product
	e_product_technology_id	integer			--e_product_technology
);
-- no constraints, an expertise is for a user OR a group, and a vendor OR a product
--
CREATE INDEX e_expertise_people_i_ppl ON asset.e_expertise (e_people_id);

SELECT create_trgfn_maint_object_audit('asset', 'e_asset', 'e_asset_id', 'e_asset_serial');


--
-- assets compliant with a policy tool (= correctly registered with this policy tool)
--
CREATE TABLE asset.e_asset_compliance_daily(
        calc_day        date,
        e_asset_id      integer,
        e_compliance_policy_tool_id    integer, --compliance.e_policy_tool
        compliant       boolean         NOT NULL,
        PRIMARY KEY(calc_day, e_asset_id, e_compliance_policy_tool_id)
);

--
-- anomalies found per day on an asset
--
CREATE TABLE asset.e_asset_anomaly_daily(
        calc_day        date,
        e_asset_id      integer,
        antivirus_notinstalled    int NOT NULL,
        antivirus_outdated        int NOT NULL,
        missed_check              int NOT NULL, --cannot connect to host, no response
        denied_check              int NOT NULL, --cannot connect to host, acces denied
        interrupted_check         int NOT NULL, --scan interrupted
        PRIMARY KEY(calc_day, e_asset_id)
);

CREATE TABLE asset.e_asset_antivirus_update (
        e_asset_id      int,
        last_update     timestamptz,
        PRIMARY KEY (e_asset_id)
);

--
-- devices types
--
CREATE SEQUENCE asset.e_asset_device_type_serial;
CREATE TABLE asset.e_asset_device_type(
        e_asset_device_type_id  int     DEFAULT nextval('asset.e_asset_device_type_serial'),
        type_name       text UNIQUE NOT NULL,
        PRIMARY KEY(e_asset_device_type_id)
);

CREATE SEQUENCE asset.e_asset_device_serial;
CREATE TABLE asset.e_asset_device(
        e_asset_device_id       int     DEFAULT nextval('asset.e_asset_device_serial'),
        e_asset_device_type_id  int NOT NULL,
        name                    text UNIQUE NOT NULL,
        probe_name              text,
        creation_date           timestamptz NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(e_asset_device_id)
);

CREATE TABLE asset.e_asset_device_daily(
        calc_day                date,
        e_asset_device_id       int,
        e_asset_id              int,
        PRIMARY KEY(calc_day, e_asset_device_id,e_asset_id)
);

CREATE TABLE asset.e_asset_daily(
        calc_day        date,
        count_active_assets     int     NOT NULL DEFAULT 0,
        count_inactive_assets   int     NOT NULL DEFAULT 0,
        PRIMARY KEY(calc_day)
);

CREATE TABLE asset.e_asset_location_daily(
        calc_day        date,
        e_location_id           int,
        count_active_assets     int     NOT NULL DEFAULT 0,
        count_inactive_assets   int     NOT NULL DEFAULT 0,
        PRIMARY KEY(calc_day, e_location_id)
);
