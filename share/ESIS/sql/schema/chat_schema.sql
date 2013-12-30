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
-- $Id: chat_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


--
-- contains: chat and instant messaging schema
--

CREATE SCHEMA chat;

CREATE SEQUENCE chat.t_domain_serial;
CREATE TABLE chat.t_domain(
    t_domain_id         int     DEFAULT nextval('chat.t_domain_serial'),
    domain_name         text    NOT NULL,	--user@domain.com -> domain.com
    first_occurrence    timestamp,
    last_occurrence     timestamp,
    known_cd  		    boolean  	DEFAULT false, --is the domain known in e_cross_domain
    spam                boolean     NOT NULL DEFAULT false, --(report)
    PRIMARY KEY (t_domain_id)
);
CREATE UNIQUE INDEX t_domain_domain_name ON chat.t_domain (domain_name);

CREATE SEQUENCE chat.t_user_serial;
CREATE TABLE chat.t_user(
    t_user_id           int     DEFAULT nextval('chat.t_user_serial'),
    original_user_name  text    NOT NULL, -- the original user name
    user_name           text    NOT NULL, -- if the original user name is of the form user@domain, the user part is stored here, else it is the original user name
    t_domain_id         int,              -- if original name contains a domain, then <-> to t_domain table
    first_occurrence    timestamp,
    last_occurrence     timestamp,
    PRIMARY KEY(t_user_id)
);
CREATE UNIQUE INDEX t_domain_user_user_domain ON chat.t_user (original_user_name);

--
-- a conversation is a chat room. several people can come in and leave messages to others
--
CREATE SEQUENCE chat.t_conversation_serial;
CREATE TABLE chat.t_conversation(
    t_conversation_id   int     DEFAULT nextval('chat.t_conversation_serial'),
    internal_name       text,               -- always provided by the probe?
    start_date          timestamptz,        -- not null constraint may be needed
    end_date            timestamptz,        -- not null constraint may be needed
    count_messages      int NOT NULL DEFAULT 0,
    count_messages_with_patterns    int NOT NULL DEFAULT 0, -- messages that match some specific patterns
    count_active_participants       int NOT NULL DEFAULT 0, -- participants that wrote messages in the conversation
    count_passive_participants      int NOT NULL DEFAULT 0, -- participants that wrote no messages but were present in the conversation
    count_participants              int NOT NULL DEFAULT 0, -- all participants
    count_attachments               int NOT NULL DEFAULT 0, -- # of attachments
    PRIMARY KEY(t_conversation_id)
);
CREATE UNIQUE INDEX t_conversation_unik ON chat.t_conversation (internal_name);

--
-- to know when people come in and out in a conversation
--
CREATE TABLE chat.t_conversation_participant_history(
    t_conversation_id   int  NOT NULL,
    t_user_id           int  NOT NULL,
    event_date          timestamptz NOT NULL,
    entered             boolean NOT NULL
);

CREATE SEQUENCE chat.t_message_serial;
CREATE TABLE chat.t_message(
    t_message_id    int DEFAULT nextval('chat.t_message_serial'),
    msg_date    timestamptz NOT NULL,
    sender      int NOT NULL,
    t_conversation_id   int,
    pattern_flagged     boolean NOT NULL,
    count_attachments   int NOT NULL DEFAULT 0,
    PRIMARY KEY(t_message_id)
);

CREATE TABLE chat.t_message_recipient(
    t_message_id    int,
    t_user_id       int,
    PRIMARY KEY(t_message_id, t_user_id)
);

--
-- private messages
--
CREATE TABLE chat.t_user_private_message_daily(
    calc_day            date,
    sender              int, -- t_user
    receiver            int, -- t_user
    count_messages      int NOT NULL DEFAULT 0,
    count_messages_with_patterns    int NOT NULL DEFAULT 0,
    count_attachments   int NOT NULL DEFAULT 0,
    PRIMARY KEY(calc_day, sender, receiver)
);

CREATE TABLE chat.t_message_daily(
    calc_day            date,
    count_messages      int NOT NULL DEFAULT 0,
    count_messages_with_patterns    int NOT NULL DEFAULT 0,
    count_conversations         int NOT NULL DEFAULT 0,
    count_attachments           int NOT NULL DEFAULT 0,
    PRIMARY KEY (calc_day)
);

CREATE TABLE chat.t_conversation_daily(
    calc_day            date,
    t_conversation_id   int,
    count_messages      int NOT NULL DEFAULT 0,
    count_messages_with_patterns    int NOT NULL DEFAULT 0,
    PRIMARY KEY (calc_day, t_conversation_id)
);

--
-- in messages received we count only private messages 
--
CREATE TABLE chat.t_user_daily(
    calc_day            date,
    t_user_id           int,
    count_received_all  int NOT NULL DEFAULT 0,   -- # of messages received
    count_received_internal  int NOT NULL DEFAULT 0, -- # of internal messages received (from users inside the cie, cf company domains)
    count_received_external  int NOT NULL DEFAULT 0, -- # of external messages received (from users outside of the cie)
    count_sent_all  int NOT NULL DEFAULT 0,       -- # of messages sent
    count_sent_internal  int NOT NULL DEFAULT 0,  -- # of internal messages sent (to users inside the cie, cf company domains)
    count_sent_external  int NOT NULL DEFAULT 0,  -- # of external messages sent (to users outside of the cie)
    count_correspondent  int NOT NULL DEFAULT 0,
    PRIMARY KEY (calc_day, t_user_id)
);