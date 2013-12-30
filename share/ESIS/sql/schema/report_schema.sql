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
-- $Id: report_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--

--
-- contains: report information schema

--
-- #0 : Schema declaration for unit tests; mostly used for
-- metrics that are only used to calculate unit tests.
--
CREATE SCHEMA unittest;

--
-- #1 : Report meta-data
--

CREATE SEQUENCE e_report_serial;
CREATE TABLE e_report (
	e_report_id	integer		DEFAULT nextval('e_report_serial'), -- unique key
	report_type	text,		-- eg. "com.entelience.report.patch.compliancy.analyticTimeToFix" (old style) "com.entelience.portal.users" (new style uses the metric name)
	report_date	timestamptz	NOT NULL, -- date corresponding to the most recent data analysed
	run_date	timestamptz	DEFAULT current_timestamp, -- actually when the report was run
	PRIMARY KEY(e_report_id)
);
CREATE UNIQUE INDEX e_report_idx ON e_report (report_type, report_date);

CREATE TABLE e_metric_targets (
	report_type	text		NOT NULL,	-- eg. "com.entelience.report.patch.compliancy.analyticTimeToFix"
	metric		text		NOT NULL,	-- eg. "tr_xxx_yyy"
	target		double precision NOT NULL
);

CREATE SEQUENCE i_report_data_serial;
CREATE TABLE i_report_data (
	i_report_data_id		integer		DEFAULT nextval('i_report_data_serial'), -- unique key
	e_report_id	integer,	-- @see e_report
	name		text,		-- key to the report information, eg "10.0.0.1", may be compound.
	value		double precision, -- data value calculated
	PRIMARY KEY(i_report_data_id)
);

CREATE SEQUENCE i_report_aggregate_serial;
CREATE TABLE i_report_aggregate (
	i_report_aggregate_id		integer		DEFAULT nextval('i_report_aggregate_serial'), -- unique key	
	e_report_id	integer,	-- @see e_report
	name		text,		-- key to the report information
	minimum		double precision,	-- minimum
	average		double precision,	-- mean
	n		double precision, 	-- n (used for calculating the mean)
	maximum		double precision,	-- maximum
	PRIMARY KEY(i_report_aggregate_id)
);

--
-- #2. Specific reports' data types
--

-- #2.1 bug67 analytic time to threat

-- per-system-vulnerability
CREATE TABLE er_patch_com_att_v (
	-- name is ip.address
	-- value is calculated between published and reported
	e_vulnerability_id	integer,
	date_published	timestamptz,
	date_reported	timestamptz
) INHERITS (i_report_data) 
WITH OIDS; -- e_vulnerability_id

-- per-system
CREATE TABLE er_patch_com_att_s (
	-- name is ip.address
	-- value is mean (average) over all vulns for that system	
) INHERITS (i_report_data);

-- global
CREATE TABLE er_patch_com_att_g (
	-- name is 'global'
	-- value is mean (average) over all vulns for that system
) INHERITS (i_report_data);


-- #2.2 bug68 analytic time to fix

-- per-system-vulnerability
CREATE TABLE er_patch_com_atf_v (
	-- name is ip.address
	-- value is calculated between reported and fixed
	e_vulnerability_id	integer,
	date_reported	timestamptz,
	date_fixed	timestamptz
) INHERITS (i_report_data)
WITH OIDS; -- e_vulnerability_id

-- per-system
CREATE TABLE er_patch_com_atf_s (
	-- name is ip.address
	-- value is mean (average) over all vulns for that system	
) INHERITS (i_report_data);

-- global
CREATE TABLE er_patch_com_atf_g (
	-- name is 'global'
	-- value is mean (average) over all vulns for that system
) INHERITS (i_report_data);
