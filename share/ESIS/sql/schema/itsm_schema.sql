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
-- $Id: itsm_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--

CREATE SCHEMA itsm;


--
-- unified status table
--
CREATE SEQUENCE itsm.t_status_serial START 100;
CREATE TABLE itsm.t_status(
        t_status_id     integer DEFAULT nextval('itsm.t_status_serial'),
        ext_status_id   integer,        -- the status in the distant db
        t_source_id     integer,        -- the source, cf tbl e_source
        status_name     text    NOT NULL,       -- the status name
        normalized      boolean,                -- is this a 'normalized' status
        normalized_status_id    integer,        -- id of the normalized status 
        active          boolean NOT NULL,
        creation_date   timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(t_status_id)
);
CREATE UNIQUE INDEX t_status_unik ON itsm.t_status(ext_status_id, t_source_id, status_name);
CREATE UNIQUE INDEX t_status_id_unik ON itsm.t_status(ext_status_id, t_source_id);

--
-- is being correclty filled in lang sql
--
INSERT INTO itsm.t_status(t_status_id, status_name, normalized, active) VALUES (1, 'st_new', true, true);
INSERT INTO itsm.t_status(t_status_id, status_name, normalized, active) VALUES (2, 'st_pending', true, true);
INSERT INTO itsm.t_status(t_status_id, status_name, normalized, active) VALUES (3, 'st_cncl', true, true);
INSERT INTO itsm.t_status(t_status_id, status_name, normalized, active) VALUES (4, 'st_fixed', true, true);
INSERT INTO itsm.t_status(t_status_id, status_name, normalized, active) VALUES (5, 'st_wont_fix', true, true);
INSERT INTO itsm.t_status(t_status_id, status_name, normalized, active) VALUES (6, 'st_closed', true, true);


--
-- unified support_level table
--
CREATE SEQUENCE itsm.t_support_level_serial START 100;
CREATE TABLE itsm.t_support_level(
        t_support_level_id      integer DEFAULT nextval('itsm.t_support_level_serial'),
        ext_support_level_id    integer,        -- the status in the distant db
        t_source_id             integer,        -- the source, cf tbl e_source
        support_level_name      text    NOT NULL,       -- the support level name
        rank                    integer,
        normalized              boolean,                -- is this a 'normalized' status
        normalized_support_level_id     integer,        -- id of the normalized status 
        active                  boolean NOT NULL,
        creation_date           timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(t_support_level_id)
);
CREATE UNIQUE INDEX t_support_level_unik ON itsm.t_support_level(ext_support_level_id, t_source_id, support_level_name);
CREATE UNIQUE INDEX t_support_level_id_unik ON itsm.t_support_level(ext_support_level_id, t_source_id);

CREATE SEQUENCE itsm.t_type_serial START 100;
CREATE TABLE itsm.t_type(
        t_type_id               integer DEFAULT nextval('itsm.t_type_serial'),
        ext_type_id             integer,        -- the type in the distant db
        t_source_id             integer,        -- the source, cf tbl e_source
        type_name               text    NOT NULL,       -- the category name
        normalized              boolean,                -- is this a 'normalized' type
        normalized_type_id      integer,        -- id of the normalized type
        active                  boolean NOT NULL,
        creation_date           timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(t_type_id)
);
CREATE UNIQUE INDEX t_type_unik ON itsm.t_type(ext_type_id, t_source_id, type_name);
CREATE UNIQUE INDEX t_type_id_unik ON itsm.t_type(ext_type_id, t_source_id);


--
-- unified category table
--
CREATE SEQUENCE itsm.t_category_serial START 100;
CREATE TABLE itsm.t_category(
        t_category_id   integer DEFAULT nextval('itsm.t_category_serial'),
        ext_category_id integer,        -- the category in the distant db
        t_source_id     integer,        -- the source, cf tbl e_source
        category_name   text    NOT NULL,       -- the category name
        normalized      boolean,                -- is this a 'normalized' category
        normalized_category_id  integer,        -- id of the normalized category
        active          boolean NOT NULL,
        creation_date   timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(t_category_id)
);
CREATE UNIQUE INDEX t_category_unik ON itsm.t_category(ext_category_id, t_source_id, category_name);
CREATE UNIQUE INDEX t_category_id_unik ON itsm.t_category(ext_category_id, t_source_id);

CREATE SEQUENCE itsm.t_ipsu_serial START 100;
CREATE TABLE itsm.t_ipsu(
        t_ipsu_id       integer DEFAULT nextval('itsm.t_ipsu_serial'),
        ext_ipsu_id     integer,        -- the ipsu in the distant db
        t_source_id     integer,        -- the source, cf tbl e_source
        i               boolean NOT NULL,       -- impact
        p               boolean NOT NULL,       -- priority
        s               boolean NOT NULL,       -- status
        u               boolean NOT NULL,       -- urgency
        ipsu_name       text    NOT NULL,       -- name
        normalized      boolean,                -- is this a 'normalized' category
        normalized_ipsu_id      integer,        -- id of the normalized category
        active          boolean NOT NULL,
        creation_date   timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(t_ipsu_id)
);
CREATE UNIQUE INDEX t_ipsu_unik ON itsm.t_ipsu(ext_ipsu_id, t_source_id, ipsu_name);
CREATE UNIQUE INDEX t_ipsu_id_unik ON itsm.t_ipsu(ext_ipsu_id, t_source_id);

--
-- is being correclty filled in lang sql
--
INSERT INTO itsm.t_ipsu(t_ipsu_id, i, p, s, u, ipsu_name, normalized, active) VALUES (1, true, false, false, false, 'i_nonb', true, true);
INSERT INTO itsm.t_ipsu(t_ipsu_id, i, p, s, u, ipsu_name, normalized, active) VALUES (2, true, false, false, false, 'i_ind', true, true);
INSERT INTO itsm.t_ipsu(t_ipsu_id, i, p, s, u, ipsu_name, normalized, active) VALUES (3, true, false, false, false, 'i_grp', true, true);
INSERT INTO itsm.t_ipsu(t_ipsu_id, i, p, s, u, ipsu_name, normalized, active) VALUES (11, false, true, false, false, 'p_low', true, true);
INSERT INTO itsm.t_ipsu(t_ipsu_id, i, p, s, u, ipsu_name, normalized, active) VALUES (12, false, true, false, false, 'p_medium', true, true);
INSERT INTO itsm.t_ipsu(t_ipsu_id, i, p, s, u, ipsu_name, normalized, active) VALUES (13, false, true, false, false, 'p_high', true, true);
INSERT INTO itsm.t_ipsu(t_ipsu_id, i, p, s, u, ipsu_name, normalized, active) VALUES (21, false, false, true, false, 's_low', true, true);
INSERT INTO itsm.t_ipsu(t_ipsu_id, i, p, s, u, ipsu_name, normalized, active) VALUES (22, false, false, true, false, 's_medium', true, true);
INSERT INTO itsm.t_ipsu(t_ipsu_id, i, p, s, u, ipsu_name, normalized, active) VALUES (23, false, false, true, false, 's_high', true, true);
INSERT INTO itsm.t_ipsu(t_ipsu_id, i, p, s, u, ipsu_name, normalized, active) VALUES (31, false, false, false, true, 'u_normal', true, true);
INSERT INTO itsm.t_ipsu(t_ipsu_id, i, p, s, u, ipsu_name, normalized, active) VALUES (32, false, false, false, true, 'u_urgent', true, true);
INSERT INTO itsm.t_ipsu(t_ipsu_id, i, p, s, u, ipsu_name, normalized, active) VALUES (33, false, false, false, true, 'u_immediate', true, true);

CREATE SEQUENCE itsm.t_ticket_serial;
CREATE TABLE itsm.t_ticket(
        t_ticket_id     bigint  DEFAULT nextval('itsm.t_ticket_serial'),
        open_date       timestamptz     NOT NULL, -- from probe
        close_date      timestamptz,              -- from probe
        resolve_date    timestamptz,              -- from probe
        last_update     timestamptz     NOT NULL, -- from probe
        t_source_id     integer         NOT NULL,        -- the source, cf tbl e_source
        ext_id          bigint          NOT NULL,
        title           text            NOT NULL,
        description     text,
        t_location_id   integer,        -- affected location
        t_group_id      integer,        -- affected group
        t_status_id     integer,
        t_support_level_id      integer,
        t_type_id       integer,
        active          boolean NOT NULL,
        count_sla_violations    integer NOT NULL DEFAULT 0,     --# of service license agreement violations
        creation_date   timestamptz     NOT NULL DEFAULT current_timestamp, --esis creation
        last_mod_date   timestamptz     NOT NULL DEFAULT current_timestamp, --esis last mod
        PRIMARY KEY(t_ticket_id)
);

--
-- 
--
CREATE TABLE itsm.t_ticket_history(
        t_ticket_id     bigint  NOT NULL,
        change_date     timestamptz     NOT NULL,
        t_category_id   int,
        t_status_id     int,
        impact          int,
        priority        int,
        severity        int,
        urgency         int,
        assignee        int,
        support_level_id        int,
        sla_violation   boolean,        --is it a sla
        field           text
);

CREATE TABLE itsm.t_ticket_category(
        t_ticket_id     bigint,
        t_category_id       integer,
        PRIMARY KEY(t_ticket_id, t_category_id)
);

CREATE TABLE itsm.t_ticket_ipsu(
        t_ticket_id     bigint,
        t_ipsu_id       integer,
        PRIMARY KEY(t_ticket_id, t_ipsu_id)
);

CREATE TABLE itsm.t_ticket_raci(
        t_ticket_id     integer,
        t_app_login_id  integer,
        r               boolean NOT NULL,
        a               boolean NOT NULL,
        c               boolean NOT NULL,
        i               boolean NOT NULL,
        PRIMARY KEY(t_ticket_id, t_app_login_id)
);

CREATE TABLE itsm.t_incident() INHERITS (itsm.t_ticket);
CREATE UNIQUE INDEX t_incident_unik ON itsm.t_incident(t_source_id, ext_id);

CREATE TABLE itsm.t_change_request() INHERITS (itsm.t_ticket);
CREATE UNIQUE INDEX t_change_req_unik ON itsm.t_change_request(t_source_id, ext_id);

CREATE TABLE itsm.t_ticket_product(
        t_ticket_id     bigint  NOT NULL,
        e_product_id    int     NOT NULL,
        e_version_id    int
);
CREATE UNIQUE INDEX t_ticket_product_unik ON itsm.t_ticket_product(t_ticket_id, e_product_id, e_version_id);




--
-- Reporting tables
--
-- global
CREATE TABLE itsm.t_ticket_daily(
        calc_day                date,
        count_existing          int     NOT NULL DEFAULT 0,       -- how many tickets available at this day
        count_new               int     NOT NULL DEFAULT 0,       -- how many tickets are newly opened this day
        count_opened            int     NOT NULL DEFAULT 0,       -- how many tickets are currently opened this day (do not use SUM on this one)
        count_unresolved        int     NOT NULL DEFAULT 0,       -- how many tickets are currently active and unresolved this day (do not use SUM on this one)
        count_closed            int     NOT NULL DEFAULT 0,       -- how many tickets have been closed this day
        count_updated           int     NOT NULL DEFAULT 0,       -- how many tickets have been updated this day
        count_resolved          int     NOT NULL DEFAULT 0,       -- how many tickets have been resolved this day
        count_status_changed    int     NOT NULL DEFAULT 0,       -- how many tickets have had their status changed
        count_ipsu_changed      int     NOT NULL DEFAULT 0,       -- how many tickets have had their ipsu changed
        count_category_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their category changed
        count_assignee_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their assignee changed
        count_supp_lvl_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their support level changed
        count_with_sla_violation    int     NOT NULL DEFAULT 0,       -- how many tickets had a SLA violation this day
        min_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, min time to close for tickets closed that day
        max_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, max time to close for tickets closed that day
        avg_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, avg time to close for tickets closed that day
        min_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, min time to resolve for tickets closed that day
        max_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, max time to resolve for tickets closed that day
        avg_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, avg time to resolve for tickets closed that day
        min_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, min opened time for tickets currently opened
        max_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, max opened time for tickets currently opened
        avg_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, avg opened time for tickets currently opened
        PRIMARY KEY(calc_day)
);

-- by type
CREATE TABLE itsm.t_ticket_type_daily(
        calc_day                date,
        t_ticket_type_id        int,
        count_existing          int     NOT NULL DEFAULT 0,       -- how many tickets available at this day
        count_new               int     NOT NULL DEFAULT 0,       -- how many tickets are newly opened this day
        count_opened            int     NOT NULL DEFAULT 0,       -- how many tickets are currently opened this day (do not use SUM on this one)
        count_unresolved        int     NOT NULL DEFAULT 0,       -- how many tickets are currently active and unresolved this day (do not use SUM on this one)
        count_closed            int     NOT NULL DEFAULT 0,       -- how many tickets have been closed this day
        count_updated           int     NOT NULL DEFAULT 0,       -- how many tickets have been updated this day
        count_resolved          int     NOT NULL DEFAULT 0,       -- how many tickets have been resolved this day
        count_status_changed    int     NOT NULL DEFAULT 0,       -- how many tickets have had their status changed
        count_ipsu_changed      int     NOT NULL DEFAULT 0,       -- how many tickets have had their ipsu changed
        count_category_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their category changed
        count_assignee_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their assignee changed
        count_supp_lvl_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their support level changed
        count_with_sla_violation    int     NOT NULL DEFAULT 0,       -- how many tickets had a SLA violation this day
        min_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, min time to close for tickets closed that day
        max_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, max time to close for tickets closed that day
        avg_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, avg time to close for tickets closed that day
        min_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, min time to resolve for tickets closed that day
        max_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, max time to resolve for tickets closed that day
        avg_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, avg time to resolve for tickets closed that day
        min_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, min opened time for tickets currently opened
        max_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, max opened time for tickets currently opened
        avg_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, avg opened time for tickets currently opened
        PRIMARY KEY(calc_day, t_ticket_type_id)
);

-- by category itsm.t_category
CREATE TABLE itsm.t_ticket_category_daily(
        calc_day                date,
        t_ticket_type_id        int,
        t_category_id           int,
        count_existing          int     NOT NULL DEFAULT 0,       -- how many tickets available at this day
        count_new               int     NOT NULL DEFAULT 0,       -- how many tickets are newly opened this day
        count_opened            int     NOT NULL DEFAULT 0,       -- how many tickets are currently opened this day (do not use SUM on this one)
        count_unresolved        int     NOT NULL DEFAULT 0,       -- how many tickets are currently active and unresolved this day (do not use SUM on this one)
        count_closed            int     NOT NULL DEFAULT 0,       -- how many tickets have been closed this day
        count_updated           int     NOT NULL DEFAULT 0,       -- how many tickets have been updated this day
        count_resolved          int     NOT NULL DEFAULT 0,       -- how many tickets have been resolved this day
        count_status_changed    int     NOT NULL DEFAULT 0,       -- how many tickets have had their status changed
        count_ipsu_changed      int     NOT NULL DEFAULT 0,       -- how many tickets have had their ipsu changed
        count_category_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their category changed
        count_assignee_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their assignee changed
        count_supp_lvl_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their support level changed
        count_with_sla_violation    int     NOT NULL DEFAULT 0,       -- how many tickets had a SLA violation
        min_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, min time to close for tickets closed that day
        max_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, max time to close for tickets closed that day
        avg_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, avg time to close for tickets closed that day
        min_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, min time to resolve for tickets closed that day
        max_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, max time to resolve for tickets closed that day
        avg_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, avg time to resolve for tickets closed that day
        min_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, min opened time for tickets currently opened
        max_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, max opened time for tickets currently opened
        avg_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, avg opened time for tickets currently opened
        PRIMARY KEY(calc_day, t_ticket_type_id, t_category_id)
);

-- by user mim.t_app_login
CREATE TABLE itsm.t_ticket_user_daily(
        calc_day                date,
        t_ticket_type_id        int,
        t_app_login_id          int,
        r                       boolean,
        a                       boolean,
        c                       boolean,
        i                       boolean,
        count_existing          int     NOT NULL DEFAULT 0,       -- how many tickets available at this day
        count_new               int     NOT NULL DEFAULT 0,       -- how many tickets are newly opened this day
        count_opened            int     NOT NULL DEFAULT 0,       -- how many tickets are currently opened this day (do not use SUM on this one)
        count_unresolved        int     NOT NULL DEFAULT 0,       -- how many tickets are currently active and unresolved this day (do not use SUM on this one)
        count_closed            int     NOT NULL DEFAULT 0,       -- how many tickets have been closed this day
        count_updated           int     NOT NULL DEFAULT 0,       -- how many tickets have been updated this day
        count_resolved          int     NOT NULL DEFAULT 0,       -- how many tickets have been resolved this day
        count_status_changed    int     NOT NULL DEFAULT 0,       -- how many tickets have had their status changed
        count_ipsu_changed      int     NOT NULL DEFAULT 0,       -- how many tickets have had their ipsu changed
        count_category_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their category changed
        count_assignee_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their assignee changed
        count_supp_lvl_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their support level changed
        count_with_sla_violation    int     NOT NULL DEFAULT 0,       -- how many tickets had a SLA violation
        min_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, min time to close for tickets closed that day
        max_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, max time to close for tickets closed that day
        avg_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, avg time to close for tickets closed that day
        min_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, min time to resolve for tickets closed that day
        max_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, max time to resolve for tickets closed that day
        avg_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, avg time to resolve for tickets closed that day
        min_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, min opened time for tickets currently opened
        max_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, max opened time for tickets currently opened
        avg_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, avg opened time for tickets currently opened
        PRIMARY KEY(calc_day, t_ticket_type_id, t_app_login_id, r, a, c, i)
);

-- by ipsu itsm.t_ipsu
CREATE TABLE itsm.t_ticket_ipsu_daily(
        calc_day                date,
        t_ticket_type_id        int,
        t_ipsu_id           int,
        count_existing          int     NOT NULL DEFAULT 0,       -- how many tickets available at this day
        count_new               int     NOT NULL DEFAULT 0,       -- how many tickets are newly opened this day
        count_opened            int     NOT NULL DEFAULT 0,       -- how many tickets are currently opened this day (do not use SUM on this one)
        count_unresolved        int     NOT NULL DEFAULT 0,       -- how many tickets are currently active and unresolved this day (do not use SUM on this one)
        count_closed            int     NOT NULL DEFAULT 0,       -- how many tickets have been closed this day
        count_updated           int     NOT NULL DEFAULT 0,       -- how many tickets have been updated this day
        count_resolved          int     NOT NULL DEFAULT 0,       -- how many tickets have been resolved this day
        count_status_changed    int     NOT NULL DEFAULT 0,       -- how many tickets have had their status changed
        count_ipsu_changed      int     NOT NULL DEFAULT 0,       -- how many tickets have had their ipsu changed
        count_category_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their category changed
        count_assignee_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their assignee changed
        count_supp_lvl_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their support level changed
        count_with_sla_violation    int     NOT NULL DEFAULT 0,       -- how many tickets had a SLA violation
        min_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, min time to close for tickets closed that day
        max_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, max time to close for tickets closed that day
        avg_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, avg time to close for tickets closed that day
        min_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, min time to resolve for tickets closed that day
        max_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, max time to resolve for tickets closed that day
        avg_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, avg time to resolve for tickets closed that day
        min_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, min opened time for tickets currently opened
        max_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, max opened time for tickets currently opened
        avg_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, avg opened time for tickets currently opened
        PRIMARY KEY(calc_day, t_ticket_type_id, t_ipsu_id)
);

-- by status itsm.t_status
--
CREATE TABLE itsm.t_ticket_status_daily(
        calc_day                date,
        t_ticket_type_id        int,
        t_status_id           int,
        count_existing          int     NOT NULL DEFAULT 0,       -- how many tickets available at this day
        count_new               int     NOT NULL DEFAULT 0,       -- how many tickets are newly opened this day
        count_opened            int     NOT NULL DEFAULT 0,       -- how many tickets are currently opened this day (do not use SUM on this one)
        count_unresolved        int     NOT NULL DEFAULT 0,       -- how many tickets are currently active and unresolved this day (do not use SUM on this one)
        count_closed            int     NOT NULL DEFAULT 0,       -- how many tickets have been closed this day
        count_updated           int     NOT NULL DEFAULT 0,       -- how many tickets have been updated this day
        count_resolved          int     NOT NULL DEFAULT 0,       -- how many tickets have been resolved this day
        count_status_changed    int     NOT NULL DEFAULT 0,       -- how many tickets have had their status changed
        count_ipsu_changed      int     NOT NULL DEFAULT 0,       -- how many tickets have had their ipsu changed
        count_category_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their category changed
        count_assignee_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their assignee changed
        count_supp_lvl_changed  int     NOT NULL DEFAULT 0,       -- how many tickets have had their support level changed
        count_with_sla_violation    int     NOT NULL DEFAULT 0,       -- how many tickets had a SLA violation
        min_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, min time to close for tickets closed that day
        max_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, max time to close for tickets closed that day
        avg_time_to_close       bigint  NOT NULL DEFAULT 0,       -- in s, avg time to close for tickets closed that day
        min_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, min time to resolve for tickets closed that day
        max_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, max time to resolve for tickets closed that day
        avg_time_to_resolve     bigint  NOT NULL DEFAULT 0,       -- in s, avg time to resolve for tickets closed that day
        min_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, min opened time for tickets currently opened
        max_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, max opened time for tickets currently opened
        avg_open_time           bigint  NOT NULL DEFAULT 0,       -- in s, avg opened time for tickets currently opened
        PRIMARY KEY(calc_day, t_ticket_type_id, t_status_id)
);





--
-- a survey : is an ensemble of questions
--
CREATE SEQUENCE itsm.t_satisfaction_survey_serial;
CREATE TABLE itsm.t_satisfaction_survey(
        t_satisfaction_survey_id        int     DEFAULT nextval('itsm.t_satisfaction_survey_serial'),
        ext_survey_id                   integer,        -- the survey id in the distant db
        t_source_id                     integer,        -- the source, cf tbl e_source
        survey_name                     text,
        survey_code                     text,
        creation_date           timestamptz DEFAULT current_timestamp,
        start_date              timestamptz,
        end_date                timestamptz,
        PRIMARY KEY(t_satisfaction_survey_id)
);

--
-- a question : part of a survey, have several possible answers
--
CREATE SEQUENCE itsm.t_satisfaction_question_serial;
CREATE TABLE itsm.t_satisfaction_question(
        t_satisfaction_question_id      int  DEFAULT nextval('itsm.t_satisfaction_question_serial'),
        t_satisfaction_survey_id        int     NOT NULL,
        ext_question_id                   integer,        -- the question id in the distant db
        t_source_id                     integer,        -- the source, cf tbl e_source
        question                        text NOT NULL,
        creation_date                   timestamptz     DEFAULT current_timestamp NOT NULL,
        t_satisfaction_question_category_id     int,
        PRIMARY KEY(t_satisfaction_question_id)
);
CREATE UNIQUE INDEX t_itsm_satisfaction_question_unik ON itsm.t_satisfaction_question(t_satisfaction_survey_id, question);

--
-- each answer is related to a question 
--
CREATE SEQUENCE itsm.t_satisfaction_answer_serial;
CREATE TABLE itsm.t_satisfaction_answer(
        t_satisfaction_answer_id      int  DEFAULT nextval('itsm.t_satisfaction_answer_serial'),
        t_satisfaction_question_id      int     NOT NULL,
        ext_answer_id                   integer,        -- the answer id in the distant db
        t_source_id                     integer,        -- the source, cf tbl e_source
        answer                          text NOT NULL,
        creation_date                   timestamptz     DEFAULT current_timestamp NOT NULL,
        satisfaction_level_id           int, -- level in t_satisfaction_level
        PRIMARY KEY(t_satisfaction_answer_id)
);
CREATE UNIQUE INDEX  t_itsm_satisfaction_answer_unik ON itsm.t_satisfaction_answer(t_satisfaction_question_id, answer);


CREATE SEQUENCE itsm.t_satisfaction_level_serial START 100;
CREATE TABLE itsm.t_satisfaction_level(
        t_satisfaction_level_id int     DEFAULT nextval('itsm.t_satisfaction_level_serial'),
        satisfaction_level      text    UNIQUE NOT NULL, --set by CLI
        min_level               int     NOT NULL,
        max_level               int     NOT NULL,
        PRIMARY KEY(t_satisfaction_level_id),
        CONSTRAINT level_cstr CHECK (min_level >= 0 AND min_level <= 20 AND max_level >= 0 AND max_level <= 20)
);
--
-- filled by sqllang scripts
--
INSERT INTO itsm.t_satisfaction_level(t_satisfaction_level_id, satisfaction_level, min_level, max_level) VALUES (1, 'sl_vh', 16, 20);
INSERT INTO itsm.t_satisfaction_level(t_satisfaction_level_id, satisfaction_level, min_level, max_level) VALUES (2, 'sl_h', 12, 15);
INSERT INTO itsm.t_satisfaction_level(t_satisfaction_level_id, satisfaction_level, min_level, max_level) VALUES (3, 'sl_m', 8, 11);
INSERT INTO itsm.t_satisfaction_level(t_satisfaction_level_id, satisfaction_level, min_level, max_level) VALUES (4, 'sl_l', 0, 7);


CREATE SEQUENCE itsm.t_satisfaction_question_category_serial;
CREATE TABLE itsm.t_satisfaction_question_category(
        t_satisfaction_question_category_id     int     DEFAULT nextval('itsm.t_satisfaction_question_category_serial'),
        category_name                           text    NOT NULL,
        positive_question                       boolean NOT NULL,
        PRIMARY KEY(t_satisfaction_question_category_id)
);
INSERT INTO itsm.t_satisfaction_question_category (category_name, positive_question) VALUES ('Positive', true);
INSERT INTO itsm.t_satisfaction_question_category (category_name, positive_question) VALUES ('Negative', false);

CREATE TABLE itsm.t_satisfaction_answer_pattern(
        pattern         text    NOT NULL,
        positive        boolean NOT NULL, --is it a positive answer or not
        always_positive boolean NOT NULL, --is the positive attribute altered by the kind of question or not 
        value           int     NOT NULL, --value for the attribute, muste be between 0 and 10 (10=big value, 0 no value)
        CONSTRAINT value_cstr CHECK (value >= 0 AND value<=10)
);

INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('oui', true, false, 10);
INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('non', false, false, 10);
INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('utile', true, true, 10);
INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('inutile', false, true, 10);
INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('partiellement', true, false, 1);
INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('complet', true, true, 10);
INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('incomplet', false, true, 10);
INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('moyennement', true, false, 1);
INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('yes', true, false, 10);
INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('no', false, false, 10);
INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('usefull', true, true, 10);
INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('useless', false, true, 10);
INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('partially', true, false, 1);
INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('complete', true, true, 10);
INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('uncomplete', false, true, 10);
INSERT INTO itsm.t_satisfaction_answer_pattern (pattern, positive, always_positive, value) VALUES ('moderately', true, false, 1);


--
-- 1 instance for each user that answer to the survey a 1 time
--
CREATE SEQUENCE itsm.t_satisfaction_survey_result_serial;
CREATE TABLE itsm.t_satisfaction_survey_result(
        t_satisfaction_survey_result_id int  DEFAULT nextval('itsm.t_satisfaction_survey_result_serial'),
        t_satisfaction_survey_id        int     NOT NULL,
        t_app_login_id                  int     NOT NULL,
        result_date                     timestamptz     NOT NULL,
        creation_date                   timestamptz     DEFAULT current_timestamp NOT NULL,
        PRIMARY KEY (t_satisfaction_survey_result_id)
);
CREATE UNIQUE INDEX t_itsm_satisfaction_survey_result_unik ON itsm.t_satisfaction_survey_result(t_satisfaction_survey_id, t_app_login_id, result_date);


--
-- list of answers selected for a survey
--
CREATE TABLE itsm.t_satisfaction_survey_response(
        t_satisfaction_survey_result_id int     NOT NULL,
        t_satisfaction_answer_id        int     NOT NULL,
        answer_date                     timestamptz     NOT NULL,
        creation_date                   timestamptz     DEFAULT current_timestamp NOT NULL
);

--
-- 1 survey can get comments
--
CREATE TABLE itsm.t_satisfaction_survey_comment(
        t_satisfaction_survey_result_id int     NOT NULL,
        comment                         text,
        comment_date                    timestamptz     NOT NULL,
        creation_date                   timestamptz     DEFAULT current_timestamp NOT NULL
);

--
-- survey are related to tickets
--
CREATE TABLE itsm.t_satisfaction_survey_to_ticket(
        t_satisfaction_survey_result_id int     NOT NULL,
        t_ticket_id                     int     NOT NULL,
        creation_date                   timestamptz     DEFAULT current_timestamp NOT NULL
);

--
-- daily global table
--
CREATE TABLE itsm.t_satisfaction_daily(
        calc_day                date,
        count_answers           int     NOT NULL DEFAULT 0, --# of answers that day
        count_users             int     NOT NULL DEFAULT 0, --# of users that day
        count_unanswered_questions      int NOT NULL DEFAULT 0, --#of unanwered questions
        count_related_tickets   int     NOT NULL DEFAULT 0, -- #of tickets affected
        PRIMARY KEY(calc_day) 
);

--
-- daily table for satisfaction level metric
--
CREATE TABLE itsm.t_satisfaction_level_daily(
        calc_day                date,
        t_satisfaction_level_id int, --the level, cf satisfaction_level_id in t_satisfaction_answer
        count_answers           int     NOT NULL DEFAULT 0,     -- how many answers with this level that day
        count_users             int     NOT NULL DEFAULT 0,     -- how many users answered with that level
        count_related_tickets   int     NOT NULL DEFAULT 0,     -- how many tickets got an answer with that- level
        PRIMARY KEY(calc_day, t_satisfaction_level_id) 
);