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
-- $Id: spool_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


-- ESIS Security DataWarehouse schema
--
-- contains: spooled items that need special treatment

-- create email queue table

CREATE SEQUENCE e_email_queue_serial;

--
-- 
--
CREATE TABLE e_email_queue(
        e_email_queue_id     int             DEFAULT nextval('e_email_queue_serial'),
        sender_id 	     int 	     NOT NULL, --e_people
        sender               text            NOT NULL,
        receiver             text            NOT NULL,
        message              text            NOT NULL,  --a text version of the message
        subject              text            NOT NULL,
        content              bytea           NOT NULL,  --the whole email content, formatted as for RFC 822
        date_created         timestamptz     NOT NULL DEFAULT current_timestamp,
        date_last_try        timestamptz,
        tries                integer         DEFAULT 0,
	failure_reason       text            DEFAULT NULL,
        PRIMARY KEY (e_email_queue_id)
);



CREATE SEQUENCE t_client_errors_serial;
CREATE TABLE t_client_errors(
	t_client_errors_id 	int 	DEFAULT nextval('t_client_errors_serial'),
	incident_date 	timestamptz 	NOT NULL 	DEFAULT current_timestamp,
	client_ip 	text,
	e_people_id 	int, --can be null if we have a problem with authentication or the incident come from a probe
	probe_name      text, 
	client_os 	text,
 	user_agent 	text,
	flash_version 	text,
	error 		text, --all the data we can get
	error_summary 	text, -- name of the exception
	exception_log 	text, -- stack trace
	user_comment 	text,
	email_sent 	boolean 	NOT NULL 	DEFAULT false
);

