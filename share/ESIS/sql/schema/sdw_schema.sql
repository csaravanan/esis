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
-- $Id: sdw_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


--
-- contains: sdw information schema (extends 'report' schema)

--
-- Security Data Warehouse schema
--
CREATE SCHEMA sdw;

--
-- SDW management schema - finding things in files from names (a single metric or a whole group of metrics)
--
-- Note that when set-up properly metrics from different files can be loaded into the same
-- configuration bundle for querying, etc.
-- 
CREATE SEQUENCE sdw.e_bundle_serial;
CREATE TABLE sdw.e_bundle (
       e_bundle_id		integer		NOT NULL DEFAULT nextval('sdw.e_bundle_serial'), -- unique key
       xml_decl_path		text		NOT NULL, -- path to bundle *inside jar file* unless bundle is "on disk"
       xml_text			text		NULL, -- null -> not yet stored in database, not-null string value is the entire XML metrics declaration loaded from the path mentioned.
       sdw_major_version	integer		NOT NULL,
       sdw_minor_version	integer		NOT NULL,
       file_major_version	integer		NOT NULL,
       file_minor_version	integer		NOT NULL,
       PRIMARY KEY (e_bundle_id)
);

CREATE SEQUENCE sdw.e_metric_name_serial;
CREATE TABLE sdw.e_metric_name (
       e_metric_name_id	       integer		NOT NULL DEFAULT nextval('sdw.e_metric_name_serial'), -- unique key
       bundle_id	       integer		NOT NULL, -- see: sdw.e_bundle
       metric_name	       text		NOT NULL, -- hierarchical name of this metric
       PRIMARY KEY (e_metric_name_id)
);
CREATE UNIQUE INDEX e_metric_name_idx ON sdw.e_metric_name (metric_name); -- text index

CREATE SEQUENCE sdw.e_metric_group_serial;
CREATE TABLE sdw.e_metric_group (
       e_metric_group_id	integer		NOT NULL DEFAULT nextval('sdw.e_metric_group_serial'), -- unique key
       bundle_id		integer		NOT NULL, -- see: sdw.e_bundle
       metric_group_name	text		NOT NULL, -- hierarchical group name
       --group_major_version	integer		NOT NULL, 
       --group_minor_version	integer		NOT NULL,
       PRIMARY KEY (e_metric_group_id)
);
CREATE UNIQUE INDEX e_metric_group_idx ON sdw.e_metric_group (metric_group_name); -- text index

CREATE TABLE sdw.e_metric_groups (
       metric_name_id		 integer	NOT NULL,
       metric_group_id		 integer	NOT NULL,
       PRIMARY KEY (metric_name_id, metric_group_id)
);

--
-- SDW transaction information
--

-- tracks new event imports
CREATE SEQUENCE sdw.e_metric_status_serial;
CREATE TABLE sdw.e_metric_status (
       e_metric_status_id	integer		NOT NULL DEFAULT nextval('sdw.e_metric_status_serial'), -- unique key
       metric_name_id		integer		NOT NULL, -- metric name
       new_events		integer		NOT NULL, -- # new events
       min_date			timestamptz	NOT NULL, -- first new event
       max_date			timestamptz	NOT NULL, -- last new event
       PRIMARY KEY (e_metric_status_id)
);
CREATE INDEX e_metric_status_idx ON sdw.e_metric_status (metric_name_id);

-- table analgous to e_report (see report_schema.sql)
CREATE SEQUENCE sdw.e_metric_report_serial	START 1001;
CREATE TABLE sdw.e_metric_report (
       e_metric_report_id	 integer	NOT NULL DEFAULT nextval('sdw.e_metric_report_serial'), -- unique key
       metric_name_id		 integer	NOT NULL,
--       task_id		 integer	NOT NULL,
--       good			 boolean	NOT NULL DEFAULT false,
       --
       report_date		 timestamptz	NOT NULL, -- date (usually 00h00.000) corresponding to the most recent data analyzed
       run_date			 timestamptz	NOT NULL DEFAULT current_timestamp, -- actually when the report was run
       PRIMARY KEY(e_metric_report_id)
);
CREATE UNIQUE INDEX e_metric_report_idx ON sdw.e_metric_report (metric_name_id, report_date);

-- entries no longer in e_metric_report are no longer visible to web-services regardless of the 'state
-- of the operation'.  
CREATE SEQUENCE sdw.e_operation_serial;
CREATE TABLE sdw.e_operation (
       e_operation_id		integer		NOT NULL DEFAULT nextval('sdw.e_operation_serial'), -- unique key
       metric_name_id		integer		NOT NULL, -- which metric are we reporting on
       state_id			integer		NOT NULL DEFAULT 0, -- what state this operation is in
       --
       target_report_date	timestamptz	NOT NULL,
       metric_report_id		integer		NULL, -- null -> no report has yet been built for this.
       --
       start_date		timestamptz 	NOT NULL DEFAULT current_timestamp, -- when record was created
       end_date			timestamptz, -- if operation finishes without error incomplete is set to false (its complete), rolled_back is false and end_date is the time when the operation finished.  duration is usually end_date - start_date when these conditions are true.
       err_date			timestamptz, -- if the operation leaves the database in a state where it first needs a new, working, transaction to rollback the effects of the operation; this is the date that this error is first recorded by the API.
       undo_date			timestamptz, -- when the operation is successfully 'undone'
       PRIMARY KEY (e_operation_id)
);

-- what has been started etc.
CREATE TABLE sdw.e_operation_state (
       e_state_id		integer		NOT NULL,
       state_descr		text		NOT NULL	UNIQUE,
       PRIMARY KEY (e_state_id)
);
-- see sql/lang/sdw_strings.sqltemplate for all values.
