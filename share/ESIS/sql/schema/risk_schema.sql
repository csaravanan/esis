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
-- $Id: risk_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


-- ESIS Security DataWarehouse schema - install as user 'esis_user'
--
-- contains: risk assessment schema

CREATE SCHEMA risk;

--
-- filled by SQL lang script
--
CREATE SEQUENCE risk.e_category_serial    START 100;
CREATE TABLE risk.e_category(
        e_category_id          integer         DEFAULT nextval('risk.e_category_serial'),
        category_name          text            UNIQUE NOT NULL,
        PRIMARY KEY(e_category_id)
);

--
-- filled by SQL lang field 
--
CREATE SEQUENCE risk.e_likelihood_serial START 100;
CREATE TABLE risk.e_likelihood(
        e_likelihood_id         integer         DEFAULT nextval('risk.e_likelihood_serial'),
        name                    text            UNIQUE,
        description             text,
        probability             double precision          UNIQUE NOT NULL,
        PRIMARY KEY(e_likelihood_id),
        CHECK (probability >= 0 AND probability <= 1)
);
--name and description filled with sql lang scripts, but probability has to be set here
INSERT INTO risk.e_likelihood(e_likelihood_id, probability) VALUES (1, 0.0001);
INSERT INTO risk.e_likelihood(e_likelihood_id, probability) VALUES (2, 0.1);
INSERT INTO risk.e_likelihood(e_likelihood_id, probability) VALUES (3, 0.4);
INSERT INTO risk.e_likelihood(e_likelihood_id, probability) VALUES (4, 0.6);
INSERT INTO risk.e_likelihood(e_likelihood_id, probability) VALUES (5, 0.9);

-- decisions for a risk review
-- filled by SQL lang script
--
CREATE TABLE risk.e_risk_decision(
        e_risk_decision_id      integer PRIMARY KEY,
        decision                text    UNIQUE NOT NULL
);


CREATE TABLE risk.e_risk_priority(
        e_risk_priority_id      integer PRIMARY KEY,
        priority                text    UNIQUE NOT NULL
);

-- levels of risk
--
CREATE TABLE risk.e_risk_level(
        e_risk_level_id      integer PRIMARY KEY,
        level                text    UNIQUE NOT NULL
);


-- action status
--
CREATE TABLE risk.e_action_status(
        e_action_status_id      integer PRIMARY KEY,
        action_status           text    UNIQUE NOT NULL
);

-- consequence level, labels are filled by sql lang scripts
--
CREATE SEQUENCE risk.e_consequence_level_serial START 100;
CREATE TABLE risk.e_consequence_level(
        e_consequence_level_id        integer DEFAULT nextval('risk.e_consequence_level_serial'),
        label                    text,
        description              text,
        min_financial_consequence       bigint,
        max_financial_consequence       bigint,
        benefic                 boolean         NOT NULL,
        PRIMARY KEY(e_consequence_level_id)
);
INSERT INTO risk.e_consequence_level(e_consequence_level_id, min_financial_consequence, max_financial_consequence, benefic)
        VALUES (1, 1, 99999, false);
INSERT INTO risk.e_consequence_level(e_consequence_level_id, min_financial_consequence, max_financial_consequence, benefic)
        VALUES (2, 100000, 499999, false);
INSERT INTO risk.e_consequence_level(e_consequence_level_id, min_financial_consequence, max_financial_consequence, benefic)
        VALUES (3, 500000, 4999999, false);
INSERT INTO risk.e_consequence_level(e_consequence_level_id, min_financial_consequence, max_financial_consequence, benefic)
        VALUES (4, 5000000, 24999999, false);
INSERT INTO risk.e_consequence_level(e_consequence_level_id, min_financial_consequence, max_financial_consequence, benefic)
        VALUES (5, 25000000, null, false);
INSERT INTO risk.e_consequence_level(e_consequence_level_id, min_financial_consequence, max_financial_consequence, benefic)
        VALUES (11, 1, 99999, true);
INSERT INTO risk.e_consequence_level(e_consequence_level_id, min_financial_consequence, max_financial_consequence, benefic)
        VALUES (12, 100000, 499999, true);
INSERT INTO risk.e_consequence_level(e_consequence_level_id, min_financial_consequence, max_financial_consequence, benefic)
        VALUES (13, 500000, 4999999, true);
INSERT INTO risk.e_consequence_level(e_consequence_level_id, min_financial_consequence, max_financial_consequence, benefic)
        VALUES (14, 5000000, 24999999, true);
INSERT INTO risk.e_consequence_level(e_consequence_level_id, min_financial_consequence, max_financial_consequence, benefic)
        VALUES (15, 25000000, null, true);

--
-- the matrix of risks
--
CREATE SEQUENCE e_risk_level_matrix_sequence;
CREATE TABLE risk.e_risk_level_matrix(
        e_risk_level_matrix_id  integer         DEFAULT nextval('e_risk_level_matrix_sequence'),
        e_likelihood_id         integer         NOT NULL,
        e_consequence_level_id  integer         NOT NULL,
        e_risk_level_id         integer,
        PRIMARY KEY(e_risk_level_matrix_id)
);
CREATE UNIQUE INDEX e_risk_level_matrix_unik ON risk.e_risk_level_matrix(e_likelihood_id, e_consequence_level_id);

--
-- prefill this table with default values
--
INSERT INTO risk.e_risk_level_matrix(e_likelihood_id, e_consequence_level_id, e_risk_level_id)
SELECT generate_series(1,5,1), e_consequence_level_id, 1
FROM risk.e_consequence_level;

UPDATE risk.e_risk_level_matrix 
SET e_risk_level_id = int4(1+float8((e_consequence_level_id+e_likelihood_id-2)*3)/8)
WHERE e_consequence_level_id < 10;

UPDATE risk.e_risk_level_matrix 
SET e_risk_level_id = int4(1+float8((e_consequence_level_id+e_likelihood_id-12)*3)/8)
WHERE e_consequence_level_id > 10;
--
-- add trigger that fill /unfill this table if risk.e_likelihood or risk.e_consequence_level have new rows in it
--
CREATE OR REPLACE FUNCTION trgfn_e_risk_level_matrix_ins_likelihood() RETURNS TRIGGER AS $trig$
    DECLARE
    BEGIN
        INSERT INTO risk.e_risk_level_matrix(e_likelihood_id, e_consequence_level_id, e_risk_level_id) 
        SELECT NEW.e_likelihood_id, e_consequence_level_id, 1 FROM risk.e_consequence_level;
        RETURN NEW;
    END;
$trig$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION trgfn_e_risk_level_matrix_del_likelihood() RETURNS TRIGGER AS $trig$
    DECLARE
    BEGIN
        DELETE FROM risk.e_risk_level_matrix WHERE e_likelihood_id = OLD.e_likelihood_id;
        RETURN OLD;
    END;
$trig$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION trgfn_e_risk_level_matrix_ins_cs_level() RETURNS TRIGGER AS $trig$
    DECLARE
    BEGIN
        INSERT INTO risk.e_risk_level_matrix(e_likelihood_id, e_consequence_level_id, e_risk_level_id) 
        SELECT e_likelihood_id, NEW.e_consequence_level_id, 1 FROM risk.e_likelihood;
        RETURN NEW;
    END;
$trig$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION trgfn_e_risk_level_matrix_del_cs_level() RETURNS TRIGGER AS $trig$
    DECLARE
    BEGIN
        DELETE FROM risk.e_risk_level_matrix WHERE e_consequence_level_id = OLD.e_consequence_level_id;
        RETURN OLD;
    END;
$trig$ LANGUAGE plpgsql;

CREATE TRIGGER trg_maint_e_risk_level_matrix_ins_likelihood AFTER INSERT ON risk.e_likelihood 
    FOR EACH ROW EXECUTE PROCEDURE trgfn_e_risk_level_matrix_ins_likelihood();
CREATE TRIGGER trg_maint_e_risk_level_matrix_del_likelihood AFTER DELETE ON risk.e_likelihood 
    FOR EACH ROW EXECUTE PROCEDURE trgfn_e_risk_level_matrix_del_likelihood();
CREATE TRIGGER trg_maint_e_risk_level_matrix_ins_cs_level AFTER INSERT ON risk.e_consequence_level
    FOR EACH ROW EXECUTE PROCEDURE trgfn_e_risk_level_matrix_ins_cs_level();
CREATE TRIGGER trg_maint_e_risk_level_matrix_del_cs_level AFTER DELETE ON risk.e_consequence_level
    FOR EACH ROW EXECUTE PROCEDURE trgfn_e_risk_level_matrix_del_cs_level();



--
-- events
--
CREATE SEQUENCE risk.e_primary_event_serial;
CREATE TABLE risk.e_primary_event(
    e_primary_event_id     integer         DEFAULT nextval('risk.e_primary_event_serial'),
        -- for object audit
        obj_ser                integer         NOT NULL,
        obj_lm                 timestamptz     NOT NULL,
        db_user                text            NOT NULL,
        --
        creation_date          timestamptz     NOT NULL DEFAULT current_timestamp,
        reference              text,
        title                  text            NOT NULL,
        description            text,
        default_likelihood     integer, -- risk.e_likelihood, can be null
        default_probability    double precision          NOT NULL,
        default_period         integer         NOT NULL, -- # of year
        e_category_id          integer         NOT NULL, -- risk.e_category
        deleted                boolean         NOT NULL DEFAULT false,
        PRIMARY KEY(e_primary_event_id),
        CHECK (default_probability >= 0 AND default_probability <= 1)
);
SELECT create_trgfn_maint_object_audit('risk', 'e_primary_event', 'e_primary_event_id', 'e_primary_event_serial');


--
-- events to events dependencies
--
CREATE TABLE risk.e_event_dependencie(
     e_event_id              integer     NOT NULL,  -- the 'main' event
     e_contained_event_id     integer     NOT NULL,  -- the event that is inside this event (inherited or not)
     e_direct_event_id     integer,             -- the event that is directly linked to e_contained_event_id
     date_added                 timestamptz     NOT NULL DEFAULT current_timestamp,
     PRIMARY KEY (e_event_id, e_contained_event_id)
);

--
-- events to events dependencies
--
CREATE TABLE risk.e_event_to_cause(
        e_primary_event_id     integer,
        e_cause_id             integer,
        date_added             timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(e_primary_event_id, e_cause_id)
);

--
-- causes
--
CREATE SEQUENCE risk.e_cause_serial;
CREATE TABLE risk.e_cause(
        e_cause_id             integer          DEFAULT nextval('risk.e_cause_serial'),
        -- for object audit
        obj_ser                integer         NOT NULL,
        obj_lm                 timestamptz     NOT NULL,
        db_user                text            NOT NULL,
        --
        creation_date          timestamptz     NOT NULL DEFAULT current_timestamp,
        reference              text,
        title                  text            NOT NULL,
        description            text,
        e_likelihood_id        integer, -- risk.e_likelihood, can be null again
        probability    double precision          NOT NULL,
        period                integer            NOT NULL, --# of year
        number_of_occurences    integer          NOT NULL,
        horizon_start_date      timestamptz,
        horizon_end_date        timestamptz,
        e_organisation_id       integer,   -- organisations tables
        deleted                 boolean         NOT NULL DEFAULT false,
        PRIMARY KEY(e_cause_id),
        CHECK (probability >= 0 AND probability <= 1),
        CHECK (number_of_occurences>=0)
);
SELECT create_trgfn_maint_object_audit('risk', 'e_cause', 'e_cause_id', 'e_cause_serial');

CREATE TABLE risk.e_cause_history(
        e_cause_id              integer         NOT NULL,
        change_date             timestamptz     NOT NULL DEFAULT current_timestamp,
        modifier                integer         NOT NULL,
        title                   text            NOT NULL,
        probability             double precision        NOT NULL,
        period                  integer         NOT NULL,
        number_of_occurences    integer         NOT NULL
);

--
-- cause to risk dependencies
--
CREATE TABLE risk.e_cause_to_risk(
        e_cause_id             integer,
        e_risk_id              integer,
        date_added             timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(e_cause_id, e_risk_id)
);

--
-- scenario : set of causes
--
CREATE SEQUENCE risk.e_scenario_serial;
CREATE TABLE risk.e_scenario(
        e_scenario_id           integer         DEFAULT nextval('risk.e_scenario_serial'),
        -- for object audit
        obj_ser                integer         NOT NULL,
        obj_lm                 timestamptz     NOT NULL,
        db_user                text            NOT NULL,
        --
        creation_date           timestamptz     NOT NULL DEFAULT current_timestamp,
        reference               text,
        title                   text    NOT NULL,
        description             text,
        PRIMARY KEY(e_scenario_id)
);
SELECT create_trgfn_maint_object_audit('risk', 'e_scenario', 'e_scenario_id', 'e_scenario_serial');

CREATE TABLE risk.e_scenario_to_causes(
        e_scenario_id          integer,
        e_cause_id              integer,
        date_added              timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY (e_scenario_id, e_cause_id)
);

--
-- a risk
--
CREATE SEQUENCE risk.e_risk_serial;
CREATE TABLE risk.e_risk(
        e_risk_id               integer         DEFAULT nextval('risk.e_risk_serial'),
        -- for object audit
        obj_ser                integer         NOT NULL,
        obj_lm                 timestamptz     NOT NULL,
        db_user                text            NOT NULL,
        --
        creation_date          timestamptz     NOT NULL DEFAULT current_timestamp,
        reference              text,
        title                  text            NOT NULL,
        description            text,
        expires_by             timestamptz,
        e_likelihood_id        integer NOT NULL,
        review_period          integer  NOT NULL,         -- # of days, period when this risk must be reviewed
        forced_review          boolean         NOT NULL DEFAULT false,
        e_category_id          integer          NOT NULL,
        e_raci_obj             integer         NOT NULL,
        e_compliance_standard_id   integer,        --compliance.e_topic
        PRIMARY KEY(e_risk_id)
);
SELECT create_trgfn_maint_object_audit('risk', 'e_risk', 'e_risk_id', 'e_risk_serial');
SELECT create_trgfn_maint_raci('risk', 'e_risk');

--
-- a risk can related to a topic 
--
CREATE TABLE risk.e_risk_topic(
        e_risk_id       integer,
        e_compliance_topic_id       integer,
        date_added              timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(e_risk_id, e_compliance_topic_id)
);

--
-- a risk can be related to an organisation
--
CREATE TABLE risk.e_risk_organisation(
        e_risk_id       integer,
        date_added              timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(e_risk_id, e_organisation_id)
) INHERITS (e_organisation_to_elements);

CREATE TABLE risk.e_risk_history(
        e_risk_id               integer         NOT NULL,
        change_date             timestamptz     NOT NULL DEFAULT current_timestamp,
        modifier                integer         NOT NULL,
        title                   text            NOT NULL,
        expires_by              timestamptz,
        review_period           integer         NOT NULL,
        e_likelihood_id         integer         NOT NULL,
        owner                   integer         NOT NULL
);

--
-- risks can be grouped ... in groups
--
CREATE SEQUENCE risk.e_risk_group_serial;
CREATE TABLE risk.e_risk_group(
        e_risk_group_id         integer         DEFAULT nextval('risk.e_risk_group_serial'),
        -- for object audit
        obj_ser                 integer         NOT NULL,
        obj_lm                  timestamptz     NOT NULL,
        db_user                 text            NOT NULL,
        --
        name                    text            NOT NULL,
        description             text,
        creation_date           timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(e_risk_group_id)
);
SELECT create_trgfn_maint_object_audit('risk', 'e_risk_group', 'e_risk_group_id', 'e_risk_group_serial');

CREATE TABLE risk.e_risk_to_group(
        e_risk_group_id         integer,
        e_risk_id               integer,
        date_added              timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(e_risk_group_id, e_risk_id)
);


--
-- risks can be commented
--
CREATE SEQUENCE    risk.e_risk_comment_serial;
CREATE TABLE risk.e_risk_comment (
    e_risk_comment_id      integer         DEFAULT nextval('risk.e_risk_comment_serial'),
    -- for object audit
    obj_ser                integer         NOT NULL,
    obj_lm                 timestamptz     NOT NULL,
    db_user                text            NOT NULL,
    --
    e_risk_id              integer         NOT NULL,
    creation_date          timestamptz     DEFAULT current_timestamp,
    author                 integer         NOT NULL,     -- see e_people
    comment                text,           -- comment body
    deleted                boolean         DEFAULT false,
    PRIMARY KEY (e_risk_comment_id)
);
SELECT create_trgfn_maint_object_audit('risk', 'e_risk_comment', 'e_risk_comment_id', 'e_risk_comment_serial');

--
-- comments have an history !
--
CREATE TABLE risk.e_risk_comment_history (
     e_risk_comment_id     integer         NOT NULL,
     change_date           timestamptz     NOT NULL DEFAULT current_timestamp,
     modifier              integer         NOT NULL,
     comment               text,
     deleted               boolean
);

--
-- history is auto updated, because the modifier is in the comment table 
--
CREATE OR REPLACE FUNCTION trgfn_risk_comment_history() RETURNS TRIGGER AS $trig$
    DECLARE
    BEGIN
        IF (TG_OP = 'INSERT') THEN
                INSERT INTO risk.e_risk_comment_history (e_risk_comment_id, modifier, comment, deleted) 
                        VALUES (NEW.e_risk_comment_id, NEW.author, NEW.comment, false);
        ELSIF (TG_OP = 'UPDATE') THEN
                INSERT INTO risk.e_risk_comment_history (e_risk_comment_id, modifier, comment, deleted)
                        VALUES (NEW.e_risk_comment_id, NEW.author, NEW.comment, NEW.deleted);
    END IF;
    RETURN NEW;
    END;
$trig$ LANGUAGE plpgsql;

CREATE TRIGGER trg_maint_comment_history AFTER INSERT OR UPDATE ON risk.e_risk_comment
    FOR EACH ROW EXECUTE PROCEDURE trgfn_risk_comment_history();


--
-- a criteria 
--
CREATE SEQUENCE risk.e_criteria_serial;
CREATE TABLE risk.e_criteria(
        e_criteria_id           integer         DEFAULT nextval('risk.e_criteria_serial'),
    -- for object audit
    obj_ser                integer         NOT NULL,
    obj_lm                 timestamptz     NOT NULL,
    db_user                text            NOT NULL,
    --
    reference              text            NOT NULL,
    description            text,
    criteria_description   text            NOT NULL,
    e_category_id          integer         NOT NULL,
    creation_date          timestamptz     NOT NULL DEFAULT current_timestamp,
    deleted                boolean      NOT NULL DEFAULT false,
    expected_answer_type   text         NOT NULL,
    PRIMARY KEY(e_criteria_id),
    CHECK (expected_answer_type IN ('text', 'boolean', 'integer'))
);
SELECT create_trgfn_maint_object_audit('risk', 'e_criteria', 'e_criteria_id', 'e_criteria_serial');


CREATE TABLE risk.e_risk_to_criteria(
        e_criteria_id   integer,
        e_risk_id       integer,
        date_added              timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(e_criteria_id, e_risk_id)
);

--
-- a risk review
--
CREATE SEQUENCE risk.e_risk_review_serial;
CREATE TABLE risk.e_risk_review(
        e_risk_review_id        integer         DEFAULT nextval('risk.e_risk_review_serial'),
        -- for object audit
        obj_ser                 integer         NOT NULL,
        obj_lm                  timestamptz     NOT NULL,
        db_user                 text            NOT NULL,
        --
        e_risk_id               integer         NOT NULL,
        review_date             timestamptz,
        e_organisation_id       integer,
        reference               text,
        treatment_description   text,
        e_decision_id           integer,
        e_priority_id    integer,
        -- e_risk_level_id  integer, -- taken from the matrix :  
        adequacy_of_controls    boolean,
        e_consequence_level_id  integer,
        e_raci_obj              integer,
        deleted                 boolean,
        PRIMARY KEY(e_risk_review_id)
);
SELECT create_trgfn_maint_object_audit('risk', 'e_risk_review', 'e_risk_review_id', 'e_risk_review_serial');
SELECT create_trgfn_maint_raci('risk', 'e_risk_review');
CREATE UNIQUE INDEX risk_review_unik ON risk.e_risk_review(e_risk_id, e_organisation_id);

--
-- functions to maintain all records in risk_review
--
CREATE OR REPLACE FUNCTION trgfn_risk_review_ins_risk() RETURNS TRIGGER AS $trig$
    DECLARE
    review_id INTEGER;
    BEGIN
        SELECT e_risk_review_id INTO review_id FROM risk.e_risk_review WHERE e_risk_id = NEW.e_risk_id AND e_organisation_id IS NULL;
        IF (review_id IS NULL) THEN
                INSERT INTO risk.e_risk_review(e_risk_id, e_organisation_id, deleted) VALUES (NEW.e_risk_id, null, false);
        ELSE
                UPDATE risk.e_risk_review SET deleted = false WHERE e_risk_id = NEW.e_risk_id AND e_organisation_id IS NULL;
        END IF;
        RETURN NEW;
    END;
$trig$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trgfn_risk_review_del_risk() RETURNS TRIGGER AS $trig$
    DECLARE
    BEGIN
        UPDATE risk.e_risk_review SET deleted = true WHERE e_risk_id = OLD.e_risk_id;
        RETURN OLD;
    END;
$trig$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trgfn_risk_review_ins_risk_org() RETURNS TRIGGER AS $trig$
    DECLARE
    review_id INTEGER;
    BEGIN
        SELECT e_risk_review_id INTO review_id 
        FROM risk.e_risk_review 
        WHERE e_risk_id = NEW.e_risk_id AND e_organisation_id = NEW.e_organisation_id;
        IF (review_id IS NULL) THEN
                INSERT INTO risk.e_risk_review(e_risk_id, e_organisation_id,  deleted) VALUES (NEW.e_risk_id, NEW.e_organisation_id, false);
        ELSE
                UPDATE risk.e_risk_review SET deleted = false 
                WHERE e_risk_id = NEW.e_risk_id AND e_organisation_id = NEW.e_organisation_id;
        END IF;
        RETURN NEW;
    END;
$trig$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trgfn_risk_review_del_risk_org() RETURNS TRIGGER AS $trig$
    DECLARE
    BEGIN
        UPDATE risk.e_risk_review SET deleted = true WHERE e_risk_id = OLD.e_risk_id AND e_organisation_id = OLD.e_organisation_id;
        RETURN OLD;
    END;
$trig$ LANGUAGE plpgsql;

CREATE TRIGGER trg_maint_risk_review_ins_risk AFTER INSERT ON risk.e_risk
    FOR EACH ROW EXECUTE PROCEDURE trgfn_risk_review_ins_risk();
CREATE TRIGGER trg_maint_risk_review_del_risk AFTER DELETE ON risk.e_risk
    FOR EACH ROW EXECUTE PROCEDURE trgfn_risk_review_del_risk();
CREATE TRIGGER trg_maint_risk_review_ins_risk AFTER INSERT ON risk.e_risk_organisation
    FOR EACH ROW EXECUTE PROCEDURE trgfn_risk_review_ins_risk_org();
CREATE TRIGGER trg_maint_risk_review_del_risk AFTER DELETE ON risk.e_risk_organisation
    FOR EACH ROW EXECUTE PROCEDURE trgfn_risk_review_del_risk_org();

CREATE TABLE risk.e_risk_review_history(
        change_date             timestamptz     NOT NULL DEFAULT current_timestamp,
        modifier                integer         NOT NULL,
        e_risk_review_id        integer NOT NULL,
        e_decision_id           integer,
        e_priority_id           integer,
        e_risk_level_id         integer, --saved in history 
        e_consequence_level_id  integer,
        treatment_description   text,
        owner                   integer NOT NULL
);

--
-- users evaluate criteria for a risk review
--
CREATE TABLE risk.e_risk_evaluation(
        e_risk_review_id        integer,
        e_criteria_id           integer,
        evaluation_text         text,
        evaluation_value        integer,
        evaluation_bool         boolean,
        date_filled              timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(e_risk_review_id, e_criteria_id)
);

CREATE TABLE risk.e_risk_evaluation_history(
        e_risk_review_id        integer NOT NULL,
        e_criteria_id           integer NOT NULL,
        change_date             timestamptz     NOT NULL DEFAULT current_timestamp,
        modifier                integer         NOT NULL,
        evaluation_text         text,
        evaluation_value        integer,
        evaluation_bool         boolean
);

CREATE SEQUENCE risk.e_impact_serial;
CREATE TABLE risk.e_impact(
        e_impact_id             integer         DEFAULT nextval('risk.e_impact_serial'),
        -- for object audit
        obj_ser                 integer         NOT NULL,
        obj_lm                  timestamptz     NOT NULL,
        db_user                 text            NOT NULL,
        --
        e_risk_id               integer         NOT NULL,
        e_risk_review_id        integer         NOT NULL,
        creation_date           timestamptz     NOT NULL DEFAULT current_timestamp,
        title                   text            NOT NULL,
        description             text,
        e_consequence_level_id  integer         NOT NULL,
        deleted                 boolean         NOT NULL DEFAULT false,
        PRIMARY KEY (e_impact_id)
);
SELECT create_trgfn_maint_object_audit('risk', 'e_impact', 'e_impact_id', 'e_impact_serial');




CREATE SEQUENCE risk.e_consequence_serial;
CREATE TABLE risk.e_consequence(
        e_consequence_id        integer         DEFAULT nextval('risk.e_consequence_serial'),
        -- for object audit
        obj_ser                 integer         NOT NULL,
        obj_lm                  timestamptz     NOT NULL,
        db_user                 text            NOT NULL,
        --
        e_impact_id             integer         NOT NULL,
        creation_date           timestamptz     NOT NULL DEFAULT current_timestamp,
        title                   text            NOT NULL,
        description             text,
        e_consequence_level_id  integer         NOT NULL,
        deleted                 boolean         NOT NULL DEFAULT false,
        PRIMARY KEY(e_consequence_id)
);
SELECT create_trgfn_maint_object_audit('risk', 'e_consequence', 'e_consequence_id', 'e_consequence_serial');

CREATE SEQUENCE risk.e_risk_control_serial;
CREATE TABLE risk.e_risk_control(
        e_risk_control_id       integer         DEFAULT nextval('risk.e_risk_control_serial'), 
        -- for object audit
        obj_ser                 integer         NOT NULL,
        obj_lm                  timestamptz     NOT NULL,
        db_user                 text            NOT NULL,
        --
        e_raci_obj              integer         NOT NULL,
        e_impact_id             integer,
        e_risk_review_id        integer         NOT NULL,
        e_risk_id               integer         NOT NULL,
        resource_requirement    text            NOT NULL,
        description             text,
        deleted                 boolean         NOT NULL DEFAULT false,
        creation_date           timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(e_risk_control_id)
);
SELECT create_trgfn_maint_object_audit('risk', 'e_risk_control', 'e_risk_control_id', 'e_risk_control_serial');
SELECT create_trgfn_maint_raci('risk', 'e_risk_control');

CREATE SEQUENCE risk.e_action_serial;
CREATE TABLE risk.e_action(
        e_action_id             integer        DEFAULT nextval('risk.e_action_serial'),
        -- for object audit
        obj_ser                 integer         NOT NULL,
        obj_lm                  timestamptz     NOT NULL,
        db_user                 text            NOT NULL,
        --
        e_raci_obj              integer         NOT NULL,
        e_risk_control_id       integer         NOT NULL,
        e_consequence_id        integer,
        reference               text,
        title                   text            NOT NULL,
        description             text,
        target_date             timestamptz,
        e_status_id             integer         NOT NULL DEFAULT 1,
        creation_date           timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY(e_action_id)
);
SELECT create_trgfn_maint_object_audit('risk', 'e_action', 'e_action_id', 'e_action_serial');
SELECT create_trgfn_maint_raci('risk', 'e_action');

--
-- Actions changes
--
CREATE TABLE risk.e_action_history(
        change_date             timestamptz     NOT NULL DEFAULT current_timestamp,
        modifier                integer         NOT NULL,
        e_action_id             integer         NOT NULL,
        e_status_id             integer         NOT NULL,
        owner                   integer         NOT NULL,
        title                   text            NOT NULL,
        target_date             timestamptz     -- may be null
);

