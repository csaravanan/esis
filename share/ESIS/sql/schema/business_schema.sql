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
-- $Id: business_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--

--
-- contains: ESIS business tables


--
-- company groups
--
CREATE TABLE e_company_group (
        e_group_id              int    DEFAULT fn_get_group_id_nextval(), --cf slave_directory_schema and directory_schema
        group_name		text	NOT NULL,
	description		text,
	creation_date		timestamptz	DEFAULT current_timestamp NOT NULL,
	e_company_id 		integer         NOT NULL, --can be null if the group is multicompany
	is_company_dept 	boolean 	NOT NULL, --if true, e_company_id must be filled
	mother_group_id 	integer, -- this group can be a subdivision of another group
	PRIMARY KEY(e_group_id)
);
CREATE UNIQUE INDEX e_company_group_name ON e_company_group (group_name);


--
-- e_location - main location information repository
--
CREATE SEQUENCE e_location_serial;
CREATE TABLE e_location (
	e_location_id			int	DEFAULT nextval('e_location_serial'),
	e_company_id			int	NOT NULL,
	location_name			text	NOT NULL,
	building			text,
	site				text,
	city				text,
	country_iso			integer NOT NULL,	--e_country
	zipcode 			text,
	e_region_id 			int,
	timezone 			text,
	deleted 			boolean  NOT NULL  DEFAULT false,
	PRIMARY KEY(e_location_id)
);
CREATE UNIQUE INDEX e_location_unique ON e_location (e_company_id, location_name);

CREATE TABLE e_location_alias(
        alias_name      text,
        e_location_id   integer NOT NULL, --e_location
        modifier        integer NOT NULL, --e_people
        date_added      timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(alias_name)
);

CREATE SEQUENCE e_location_network_serial;
CREATE TABLE e_location_network(
 	e_location_network_id 	integer 	DEFAULT nextval('e_location_network_serial'),
 	net_range 		cidr 		NOT NULL,
 	e_location_id 		integer 	NOT NULL,
 	PRIMARY KEY (e_location_network_id)
);
CREATE UNIQUE INDEX e_location_network_inet ON e_location_network(net_range, e_location_id);

--
-- group to location
--
CREATE TABLE e_group_location (
 	e_group_id 	integer NOT NULL, --company group
 	e_location_id 	integer NOT NULL,
 	date_added                 timestamptz     NOT NULL DEFAULT current_timestamp,
 	PRIMARY KEY (e_group_id, e_location_id)
);


CREATE SEQUENCE e_business_zone_serial;
CREATE TABLE e_business_zone(
 	e_business_zone_id 	integer DEFAULT nextval('e_business_zone_serial'),
 	name 			text 	NOT NULL,
 	deleted 		boolean NOT NULL DEFAULT false,
 	e_company_id 		integer NOT NULL,
 	PRIMARY KEY (e_business_zone_id)
);
CREATE UNIQUE INDEX e_business_zone_name ON e_business_zone (name);

--
-- zones locations
--
CREATE TABLE e_business_zone_location(
	e_business_zone_id 	integer 	NOT NULL,
	e_location_id 		integer 	NOT NULL,
	e_main_zone_id 		integer,  --in case of a zone inside another zone, fill it with the zone id that has been declared for the location
	date_added                 timestamptz     NOT NULL DEFAULT current_timestamp,
	PRIMARY KEY (e_business_zone_id, e_location_id)
);

--
-- zones departments
--
CREATE TABLE e_business_zone_department(
	e_business_zone_id 	integer 	NOT NULL,
	e_department_id		integer 	NOT NULL,
	e_main_zone_id 		integer,  --in case of a zone inside another zone, fill it with the zone id that has been declared for the dept
	date_added                 timestamptz     NOT NULL DEFAULT current_timestamp,
	PRIMARY KEY (e_business_zone_id, e_department_id)
);

--
-- zones dependencies
--
CREATE TABLE e_business_zone_dependencies(
 	e_business_zone_id 	integer 	NOT NULL,  -- the zone
 	e_inner_zone_id 	integer 	NOT NULL,  -- the zone inside (inherited or not)
 	e_direct_zone_id 	integer,  		   -- the zone that is directly linked to e_inner_zone_id
 	date_added              timestamptz     NOT NULL DEFAULT current_timestamp,
 	PRIMARY KEY (e_business_zone_id, e_inner_zone_id)
);


--
-- link to organisations within the company
--
CREATE SEQUENCE e_organisation_serial;
CREATE TABLE e_organisation(
 	e_organisation_id 		integer 	DEFAULT nextval('e_organisation_serial'),
 	e_department_id 		integer, 	-- e_group         | ONLY 1 must be set
 	e_location_id 			integer,	-- e_location      |
 	e_business_zone_id 		integer 	-- e_business_zone |
);
CREATE UNIQUE INDEX e_organisation_unique_idx ON e_organisation(e_department_id, e_location_id, e_business_zone_id);

--
-- links between other modules elements and organisations must be materialized by tables inheriting of the following table
--
CREATE TABLE e_organisation_to_elements(
        e_organisation_id               integer         NOT NULL
);

--
-- organsations can be linked to 0..N domains
--
CREATE TABLE e_organisation_domain(
        e_cross_domain_id       integer, --e_cross_domain
        e_organisation_id       integer,
        date_added              timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(e_cross_domain_id, e_organisation_id)
);