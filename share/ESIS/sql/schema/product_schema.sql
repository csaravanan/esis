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
-- $Id: product_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


--
-- contains: ESIS product model (Version: 1.2)


--
-- #2 : define tables
--

--
-- e_product - main product information repository
--
CREATE SEQUENCE asset.e_product_serial;
CREATE TABLE asset.e_product (
	e_product_id		int	DEFAULT nextval('asset.e_product_serial'),
	obj_ser			int	NOT NULL,
	obj_lm			timestamptz NOT NULL,
	db_user			text	NOT NULL,
	name				text NOT NULL,
	type				int,	-- e_product_type
	technology			int,	-- e_product_technology
	vendor			int   NOT NULL,		-- e_vendor 
	vendor_obsoleted	boolean,
	vendor_supported	boolean,
	support_contract	int, -- e_support_contract
	obsolescence_date	timestamptz,
	active				boolean NOT NULL DEFAULT false, -- product etc. inactive by default
	default_security_classification	int,	-- e_sc
	esis_hide			boolean NOT NULL DEFAULT false,	-- we wish to hide this product for vulnerabilities
	creation_date timestamptz NOT NULL default current_timestamp,
	PRIMARY KEY(e_product_id)
);
CREATE INDEX e_product_index_n ON asset.e_product (name);
CREATE INDEX e_product_index_v ON asset.e_product (vendor);
CREATE UNIQUE INDEX e_product_name_vendor ON asset.e_product (name, vendor);


CREATE TABLE asset.e_product_history (
	e_product_id	int	NOT NULL,
	change_date	timestamptz	NOT NULL,
	modifier	int,	--e_people_id, can be null if automated
	active		boolean	NOT NULL,
	esis_hide	boolean	NOT NULL,
	name            text
);

CREATE SEQUENCE asset.e_product_technology_serial;
CREATE TABLE asset.e_product_technology (
	e_product_technology_id		int	DEFAULT nextval('asset.e_product_technology_serial'),
	type				text 	NOT NULL,
	opensource			boolean NOT NULL,
	propriatary			boolean NOT NULL,
	multivendor			boolean NOT NULL,
	PRIMARY KEY(e_product_technology_id)
);
CREATE UNIQUE INDEX e_product_technology_type ON asset.e_product_technology (type);

INSERT INTO asset.e_product_technology (type, opensource, propriatary, multivendor) VALUES ('Linux',true,false,true);
INSERT INTO asset.e_product_technology (type, opensource, propriatary, multivendor) VALUES ('Windows',false,true,false);
INSERT INTO asset.e_product_technology (type, opensource, propriatary, multivendor) VALUES ('J2EE',false,true,true);

CREATE SEQUENCE asset.e_product_type_serial START 100;
CREATE TABLE asset.e_product_type (
	id				int  DEFAULT nextval('asset.e_product_type_serial'),
	name			text NOT NULL,
	PRIMARY KEY(id)
);
CREATE UNIQUE INDEX e_product_type_name ON asset.e_product_type (name);
-- see sql/lang/product_strings.sqltemplate

CREATE SEQUENCE asset.e_vendor_serial;
CREATE TABLE asset.e_vendor (
	e_vendor_id			int	DEFAULT nextval('asset.e_vendor_serial'),
	obj_ser				int	NOT NULL,
	obj_lm				timestamptz NOT NULL,
	db_user				text	NOT NULL,
	name				text	NOT NULL,
	preferred_relationship		int,
	active				boolean NOT NULL DEFAULT false, -- default to inactive
	support_contract		int,
	security_contact		int, --e_people
	escalation_contact		int, --e_people
	esis_hide			boolean NOT NULL DEFAULT false,	-- we wish to hide this vendor
	creation_date timestamptz NOT NULL default current_timestamp,
	e_company_id                   integer,  --if this vendor is a known company
	PRIMARY KEY(e_vendor_id)
);
CREATE UNIQUE INDEX e_vendor_index_n ON asset.e_vendor (name);

CREATE TABLE asset.e_vendor_history (
	e_vendor_id	int	NOT NULL,
	change_date	timestamptz	NOT NULL,
	modifier	int,	--e_people_id, can be null if automated
	active		boolean	NOT NULL,
	esis_hide	boolean	NOT NULL,
	name            text
);


CREATE TABLE asset.e_preferred_relationship (
	id				int,
	name				text NOT NULL,
	PRIMARY KEY(id)
);
CREATE UNIQUE INDEX e_preferred_relationship_name ON asset.e_preferred_relationship (name);
-- see sql/lang/product_strings.sqltemplate

CREATE SEQUENCE asset.e_support_contract_serial;
CREATE TABLE asset.e_support_contract (
	support_contract_id		int	DEFAULT nextval('asset.e_support_contract_serial'),
	start_date			timestamptz,
	end_date			timestamptz,
	level				text,
	owner				int, -- e_people
	contact				int, -- e_people
	PRIMARY KEY(support_contract_id)
);

CREATE SEQUENCE asset.e_version_serial;
CREATE TABLE asset.e_version (
	e_version_id			int	DEFAULT nextval('asset.e_version_serial'),
	obj_ser				int	NOT NULL,
	obj_lm				timestamptz NOT NULL,
	db_user				text	NOT NULL,
	e_product_id			int     NOT NULL, -- e_product
	version_number			text NOT NULL,
	vendor_obsoleted		boolean,
	vendor_supported		boolean,
	obsolescence_date		timestamptz,
	active					boolean NOT NULL DEFAULT false,
	creation_date timestamptz  NOT NULL default current_timestamp,
	PRIMARY KEY(e_version_id, e_product_id)
);

CREATE INDEX e_version_i_vn ON asset.e_version (version_number);
CREATE INDEX e_version_i_p ON asset.e_version (e_product_id);


CREATE TABLE asset.e_version_history (
	e_version_id	int	NOT NULL,
	change_date	timestamptz	NOT NULL,
	modifier	int,	--e_people_id, can be null if automated
	active		boolean	NOT NULL,
	name            text
);

SELECT create_trgfn_maint_object_audit('asset', 'e_product', 'e_product_id', 'e_product_serial');
SELECT create_trgfn_maint_object_audit('asset', 'e_vendor', 'e_vendor_id', 'e_vendor_serial');
SELECT create_trgfn_maint_object_audit('asset', 'e_version', 'e_version_id', 'e_version_serial');

CREATE TABLE asset.e_vendor_alias (
	e_vendor_id 	int 	NOT NULL,
	alias 		text 	NOT NULL
);
CREATE UNIQUE INDEX e_vendor_alias_unique ON asset.e_vendor_alias (e_vendor_id, alias);
CREATE UNIQUE INDEX e_vendor_alias_unique_alias ON asset.e_vendor_alias (alias);


CREATE TABLE asset.e_product_alias (
	e_product_id 	int 	NOT NULL,
	alias 		text 	NOT NULL
);
CREATE UNIQUE INDEX e_product_alias_unique ON asset.e_product_alias (e_product_id, alias);
CREATE UNIQUE INDEX e_product_alias_unique_alias ON asset.e_product_alias (alias);


--
-- composite application
--
CREATE SEQUENCE asset.e_composite_product_serial;
CREATE TABLE asset.e_composite_product (
        e_composite_product_id          integer     DEFAULT nextval('asset.e_composite_product_serial'),
        obj_ser			        integer	    NOT NULL,
	obj_lm			        timestamptz NOT NULL,
	db_user			        text        NOT NULL,
        e_raci_obj                      integer     NOT NULL,   --e_raci
        e_product_id                    integer     NOT NULL,
        creation_date                   timestamptz  NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(e_composite_product_id)
);

CREATE SEQUENCE asset.e_composite_version_serial;
CREATE TABLE asset.e_composite_version (
        e_composite_version_id          integer     DEFAULT nextval('asset.e_composite_version_serial'),
        obj_ser			        integer	    NOT NULL,
	obj_lm			        timestamptz NOT NULL,
	db_user			        text        NOT NULL,
        e_version_id                    integer     NOT NULL,
        creation_date                   timestamptz  NOT NULL DEFAULT current_timestamp,
        latest                          boolean     NOT NULL DEFAULT false,
        PRIMARY KEY(e_composite_version_id)
);

CREATE TABLE asset.e_composite_application (
        e_composite_product_id          integer     NOT NULL,
        e_product_id                    integer     NOT NULL,
        e_composite_version_id          integer,
        e_version_id                    integer
);
CREATE UNIQUE INDEX e_composite_app_unik ON asset.e_composite_application(e_composite_product_id, e_product_id, e_composite_version_id, e_version_id);

SELECT create_trgfn_maint_object_audit('asset', 'e_composite_product', 'e_composite_product_id', 'e_composite_product_serial');
SELECT create_trgfn_maint_object_audit('asset', 'e_composite_version', 'e_composite_version_id', 'e_composite_version_serial');
SELECT create_trgfn_maint_raci('asset', 'e_composite_product');
