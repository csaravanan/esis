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
-- $Id: lang_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--

--
-- contains: localization tables

CREATE SEQUENCE e_supported_lang_serial;
CREATE TABLE e_supported_lang(
    e_supported_lang_id int	DEFAULT nextval('e_supported_lang_serial'),
    lang    text    UNIQUE NOT NULL,
    PRIMARY KEY(e_supported_lang_id)
);


CREATE SEQUENCE e_label_serial;
CREATE TABLE e_label(
    e_label_id int	DEFAULT nextval('e_label_serial'),
    lbl     text    UNIQUE NOT NULL,
    PRIMARY KEY(e_label_id)
);

CREATE TABLE e_label_lang(
    e_label_id  int NOT NULL,
    e_lang_id   int NOT NULL,
    value       text    NOT NULL,
    default_value   text    NOT NULL,
    lm_user         int, --e_people
    lm_timestamp    timestamptz     DEFAULT current_timestamp,
    PRIMARY KEY(e_label_id, e_lang_id)
);

CREATE SEQUENCE e_frontend_lang_entity_serial;
CREATE TABLE e_frontend_lang_entity(
    e_frontend_lang_entity_id   int DEFAULT nextval('e_frontend_lang_entity_serial'),
    entity      text    UNIQUE NOT NULL,
    PRIMARY KEY(e_frontend_lang_entity_id)
);

CREATE TABLE e_frontend_lang_entity_labels(
    e_frontend_lang_entity_id   int NOT NULL,
    e_label_id  int NOT NULL,
    PRIMARY KEY(e_frontend_lang_entity_id, e_label_id)
);