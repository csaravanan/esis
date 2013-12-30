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
-- $Id: mail_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


--
-- contains: ESIS spam mails counters model

CREATE schema mail;

--
-- #2 : define tables
--
CREATE TABLE mail.t_spam_daily(
    calc_day        date,
    instances   int NOT NULL DEFAULT 0,
    t_spam_status_id 	int NOT NULL,
    PRIMARY KEY(calc_day, t_spam_status_id)
);
CREATE INDEX t_spam_daily_date ON mail.t_spam_daily(calc_day);

CREATE SEQUENCE mail.t_spam_status_serial;
CREATE TABLE mail.t_spam_status(
	t_spam_status_id 	integer 	DEFAULT nextval('mail.t_spam_status_serial'),
	status 			text 		NOT NULL,
	blocked 		boolean 	DEFAULT true,
	quarantine              boolean         NOT NULL,
	PRIMARY KEY (t_spam_status_id)
);
CREATE UNIQUE INDEX t_spam_status_status_name ON mail.t_spam_status (lower(status));
INSERT INTO mail.t_spam_status (status, blocked, quarantine) VALUES ('QUARANTINE', true, true);
INSERT INTO mail.t_spam_status (status, blocked, quarantine) VALUES ('DROP', true, false);
INSERT INTO mail.t_spam_status (status, blocked, quarantine) VALUES ('LOG_ONLY', false, false);
INSERT INTO mail.t_spam_status (status, blocked, quarantine) VALUES ('SUBJ_REWRITE', false, false);

CREATE TABLE mail.t_email_daily(
    calc_day                date,
    count               bigint NOT NULL DEFAULT 0,        --global email counter
    count_in            bigint NOT NULL DEFAULT 0,        --inbound emails
    count_out           bigint NOT NULL DEFAULT 0,        --outbound emails
    count_internal      bigint NOT NULL DEFAULT 0,        --internal emails
    count_external      bigint NOT NULL DEFAULT 0,        --external emails relayed by email platforms
    count_inbound_blocked bigint NOT NULL DEFAULT 0,      --inbound emails blocked by security
    count_outbound_blocked bigint NOT NULL DEFAULT 0,     --outbound emails blocked by security
    count_internal_blocked bigint NOT NULL DEFAULT 0,     --internal emails blocked by security
    count_external_blocked bigint NOT NULL DEFAULT 0,
    volume_in           bigint NOT NULL DEFAULT 0,        --email volume inbound
    volume_out          bigint NOT NULL DEFAULT 0,        --email volume outbound
    volume_internal     bigint NOT NULL DEFAULT 0,        --email volume internal
    volume_external     bigint NOT NULL DEFAULT 0,
    volume              bigint NOT NULL DEFAULT 0,         --email volume
    count_domains_in    int NOT NULL DEFAULT 0,         -- how many domains have received emails (report)
    count_domains_out   int NOT NULL DEFAULT 0,         -- how many domains have sent emails (report)
    count_domains_internal   int NOT NULL DEFAULT 0,    -- how many internal domains this day
    count_domains       int NOT NULL DEFAULT 0,
    count_users_in      int NOT NULL DEFAULT 0,         -- how many users have received emails (report)
    count_users_out     int NOT NULL DEFAULT 0,         -- how many users have sent emails (report)
    count_users_internal     int NOT NULL DEFAULT 0,    -- how many internal users this day
    count_users         int NOT NULL DEFAULT 0,
    count_attachments_in        int NOT NULL DEFAULT 0,
    count_attachments_out       int NOT NULL DEFAULT 0,
    count_attachments_internal  int NOT NULL DEFAULT 0,
    users_with_quarantine_received      int NOT NULL DEFAULT 0, -- distinct users that received a quarantine email
    domains_with_quarantine_received    int NOT NULL DEFAULT 0, -- distinct domains that received a quarantine email
    users_received_blocked_email        int NOT NULL DEFAULT 0, -- distinct users that received a blocked email
    domains_received_blocked_email      int NOT NULL DEFAULT 0, -- distinct domains that received a blocked email
    emails_received_in_quarantine       bigint NOT NULL DEFAULT 0, -- emails received put in quarantine
    emails_dropped_from_quarantine      bigint NOT NULL DEFAULT 0, -- emails dropped from quarantine
    emails_released_from_quarantine     bigint NOT NULL DEFAULT 0, -- emails released from quarantine
    count_spam_in                       bigint NOT NULL DEFAULT 0,
    count_spam_out                      bigint NOT NULL DEFAULT 0,
    count_spam_internal                 bigint NOT NULL DEFAULT 0,
    count_spam_external                 bigint NOT NULL DEFAULT 0,
    PRIMARY KEY(calc_day)
);


CREATE SEQUENCE mail.t_domain_serial;
CREATE TABLE mail.t_domain(
    t_domain_id         int     DEFAULT nextval('mail.t_domain_serial'),
    domain_name         text    NOT NULL,	--user@domain.com -> domain.com
    first_occurrence    timestamp   DEFAULT current_timestamp,
    last_occurrence     timestamp   DEFAULT current_timestamp,
    known_cd  		boolean  	DEFAULT false, --is the domain known is e_cross_domain
    spam                boolean         NOT NULL DEFAULT false, --(report)
    rfc_compliance      boolean         DEFAULT NULL,
    PRIMARY KEY (t_domain_id)
);
CREATE UNIQUE INDEX t_domain_domain_name ON mail.t_domain (domain_name);

CREATE SEQUENCE mail.t_domain_user_serial;
CREATE TABLE mail.t_domain_user(
        t_domain_user_id        int     DEFAULT nextval('mail.t_domain_user_serial'),
        t_domain_id             int     NOT NULL,
        user_name               text    NOT NULL,
        first_occurrence        timestamp NOT NULL DEFAULT current_timestamp,
        last_occurrence         timestamp NOT NULL DEFAULT current_timestamp,
        rfc_compliance          boolean DEFAULT NULL, --if null needs to be evaluated-
        domain_name             text NOT NULL,
        PRIMARY KEY(t_domain_user_id)
);
CREATE UNIQUE INDEX t_domain_user_user_domain ON mail.t_domain_user (t_domain_id, user_name);


--
-- this table contains data on internal communications for a user.
-- Note : internal communication means emails within the company (a company can have several domains) 
--
CREATE TABLE mail.t_domain_user_internal_daily(
    t_domain_user_id    int,
    calc_day            date,
    count_in            int NOT NULL DEFAULT 0, -- # of internal emails received by this user
    count_out           int NOT NULL DEFAULT 0, -- # of internal emails sent to this user
    volume_in           bigint NOT NULL DEFAULT 0, -- volume of internal emails received by this user
    volume_out          bigint NOT NULL DEFAULT 0, -- volume of internal emails sent to this user
    count_attachments_in        int NOT NULL DEFAULT 0, -- # of attachments received in internal emails by this user
    count_attachments_out       int NOT NULL DEFAULT 0, -- # of attachments sent in internal emails to this user
    volume_attachments_in       bigint NOT NULL DEFAULT 0, -- volume of attachments received by this user
    volume_attachments_out      bigint NOT NULL DEFAULT 0, -- volume of attachments sent to this user
    count_failed_in     int NOT NULL DEFAULT 0, -- # of failure from internal emails sent by this user
    count_failed_out    int NOT NULL DEFAULT 0, -- # of failure from internal emails received by this user
    count_spam_sent     int     NOT NULL DEFAULT 0,     -- emails marked as spams from this user
    count_spam_received int     NOT NULL DEFAULT 0,     -- emails marked as spams received by this user        
    count_blocked_in    int NOT NULL DEFAULT 0,		-- blocked emails (including spam) received by this user
    count_blocked_out   int NOT NULL DEFAULT 0,		-- blocked emails (including spam) to this user
    count_domains_in    int     NOT NULL DEFAULT 0,  -- this user has received emails from N different internal domains (report)
    count_domains_out   int     NOT NULL DEFAULT 0,  -- this user has sent emails to N different internal domains (report)
    count_users_in      int     NOT NULL DEFAULT 0,  -- this user has received emails from N different internal users (report)
    count_users_out     int     NOT NULL DEFAULT 0,  -- this user has sent emails to N different internal users
    user_name                   text NOT NULL,
    domain_name                 text NOT NULL,
    PRIMARY KEY(t_domain_user_id, calc_day)
);
CREATE INDEX t_domain_user_internal_daily_calc_day ON mail.t_domain_user_internal_daily (calc_day);

CREATE TABLE mail.t_domain_internal_daily(
    t_domain_id         int,
    calc_day            date,
    count_in            int NOT NULL DEFAULT 0, -- # of internal emails received by this domain
    count_out           int NOT NULL DEFAULT 0, -- # of internal emails sent by this domain
    volume_in           bigint NOT NULL DEFAULT 0, -- volume of internal emails received by this domain
    volume_out          bigint NOT NULL DEFAULT 0, -- volume of internal emails sent by this domain
    count_attachments_in        int NOT NULL DEFAULT 0, -- # of attachments received in internal emails by this domain
    count_attachments_out       int NOT NULL DEFAULT 0, -- # of attachments sent in internal emails
    volume_attachments_in       bigint NOT NULL DEFAULT 0, -- volume of attachments received by this domain
    volume_attachments_out      bigint NOT NULL DEFAULT 0, -- volume of attachments sent by this domain
    count_failed_in     int NOT NULL DEFAULT 0, -- # of failure when receiving internal emails by this domain
    count_failed_out    int NOT NULL DEFAULT 0, -- # of failure when sending internal emails by this domain
    count_spam_sent     bigint     NOT NULL DEFAULT 0,     -- emails marked as spams from this domain
    count_spam_received bigint     NOT NULL DEFAULT 0,     -- emails marked as spams received by this domain  
    count_blocked_in    int NOT NULL DEFAULT 0,		-- blocked emails (including spam) received by this domain
    count_blocked_out   int NOT NULL DEFAULT 0,		-- blocked emails (including spam) sent by this domain
    count_domains_in    int     NOT NULL DEFAULT 0,  -- this domain has received emails from N different internal domains (report)
    count_domains_out   int     NOT NULL DEFAULT 0,  -- this domain has sent emails to N different internal domains (report)
    count_users_in      int     NOT NULL DEFAULT 0,  -- this domain has received emails from N different internal users (report)
    count_users_out     int     NOT NULL DEFAULT 0,  -- this domain has sent emails to N different internal users
    domain_name                 text NOT NULL,
    PRIMARY KEY(t_domain_id, calc_day)
);
CREATE INDEX t_domain_internal_daily_calc_day ON mail.t_domain_internal_daily (calc_day);


CREATE TABLE mail.t_domain_user_daily(
    t_domain_user_id    int,		-- mail.t_domain_user
    calc_day            date,
    count_to		int NOT NULL DEFAULT 0, -- this user has been found N times in the To fields of an email (=received)
    count_from		int NOT NULL DEFAULT 0, -- this user has been found N times in the From fields of an email (=sent)
    count_cc		int NOT NULL DEFAULT 0, -- this user has been found N times in the Cc fields of an email (=received)
    count_bcc		int NOT NULL DEFAULT 0, -- this user has been found N times in the Bcc fields of an email (=received)
    volume_in           bigint  NOT NULL DEFAULT 0, -- volume of data this user has received 
    volume_out          bigint  NOT NULL DEFAULT 0, -- volume of data this user has sent
    count_domains_in    int     NOT NULL DEFAULT 0, -- this user has received emails from N different domains (report)
    count_domains_out   int     NOT NULL DEFAULT 0, -- this user has sent emails to N different domains (report)
    count_users_in      int     NOT NULL DEFAULT 0, -- this user has received emails from N different users (report)
    count_users_out     int     NOT NULL DEFAULT 0, -- this user has sent emails to N different users
    count_spam_sent     int     NOT NULL DEFAULT 0,     -- emails marked as spams from this user
    count_spam_received int     NOT NULL DEFAULT 0,     -- emails marked as spams received by this user  
    count_blocked_in    int NOT NULL DEFAULT 0,		-- blocked emails (including spam) received by this user
    count_blocked_out   int NOT NULL DEFAULT 0,		-- blocked emails (including spam) sent from this user
    attachment_in_volume        bigint NOT NULL DEFAULT 0,	-- volume of attachments received from this user 
    attachment_out_volume       bigint NOT NULL DEFAULT 0,	-- volume of attachments sent by this user
    count_attachments_in        int NOT NULL DEFAULT 0,         -- nb of attachments in
    count_attachments_out       int NOT NULL DEFAULT 0,         -- nb of attachments out
    count_failed_in             int     NOT NULL DEFAULT 0,     -- nb of failure to receive an email from this user
    count_failed_out            int     NOT NULL DEFAULT 0,     -- nb of failure to send an email to this user
    count_distinct_mime         int     NOT NULL DEFAULT 0,     -- distinct mime types found (report)
    count_distinct_mime_in      int     NOT NULL DEFAULT 0,     -- distinct mime types found in emails coming from this user (report)
    count_distinct_mime_out     int     NOT NULL DEFAULT 0,     -- distinct mime types found in emails sent to this user (report)
    count_received_in_quarantine        int    NOT NULL DEFAULT 0, -- # of emails received and put in quarantine
    count_dropped_from_quarantine       int    NOT NULL DEFAULT 0, -- # of emails dropped from quarantine for this user
    count_released_from_quarantine      int    NOT NULL DEFAULT 0, -- # of emails released from quarantine for this user
    count_received_externally           int    NOT NULL DEFAULT 0, -- # of emails received by this user and relayed externally
    count_sent_externally               int    NOT NULL DEFAULT 0, -- # of emails sent by this user and relayed externally
    user_name                   text NOT NULL,
    domain_name                 text NOT NULL,
    PRIMARY KEY(t_domain_user_id, calc_day)
);
CREATE INDEX t_domain_user_daily_calc_day ON mail.t_domain_user_daily (calc_day);


CREATE TABLE mail.t_domain_daily(
    calc_day			date,
    t_domain_id 		int,
    count_email_in		bigint NOT NULL DEFAULT 0,		-- emails received by this domain
    count_email_out		bigint NOT NULL DEFAULT 0,		-- emails sent by this domain
    volume_in			bigint NOT NULL DEFAULT 0,	-- volume of emails received by this domain
    volume_out			bigint NOT NULL DEFAULT 0,	-- volume of emails sent by this domain
    count_users_to		int NOT NULL DEFAULT 0,		-- number of differents users for this domain in the To field (report)
    count_users_from		int NOT NULL DEFAULT 0,		-- number of differents users for this domain in the From field (report)
    count_users_cc		int NOT NULL DEFAULT 0,		-- number of differents users for this domain in the Cc field (report)
    count_users_bcc		int NOT NULL DEFAULT 0,		-- number of differents users for this domain in the Bcc field (report)
    count_users                 int NOT NULL DEFAULT 0,         -- global # of distinct users (report)
    count_spam_sent     bigint     NOT NULL DEFAULT 0,     -- emails marked as spams from this user
    count_spam_received bigint     NOT NULL DEFAULT 0,     -- emails marked as spams received by this user  
    count_blocked_in		bigint NOT NULL DEFAULT 0,		-- blocked emails received by this domain
    count_blocked_out		bigint NOT NULL DEFAULT 0,		-- blocked emails counter sent by this domain
    attachment_in_volume	bigint NOT NULL DEFAULT 0,	-- volume of attachments received by this domain 
    attachment_out_volume	bigint NOT NULL DEFAULT 0,	-- volume of attachments sent by this domain
    count_attachments_in        bigint NOT NULL DEFAULT 0,      -- # of attachments received by this domain
    count_attachments_out       bigint NOT NULL DEFAULT 0,      -- # of attachments sent by this domain
    count_failed                int     NOT NULL DEFAULT 0,     -- nb of failure to send email
    count_failed_in             int     NOT NULL DEFAULT 0,     -- nb of failure to receive an email by this domain
    count_failed_out            int     NOT NULL DEFAULT 0,     -- nb of failure to send an email by this domain
    count_distinct_mime         int     NOT NULL DEFAULT 0,     -- distinct mime types found (report)
    count_distinct_mime_in      int     NOT NULL DEFAULT 0,     -- distinct mime types found in emails received by this domain (report)
    count_distinct_mime_out     int     NOT NULL DEFAULT 0,     -- distinct mime types found in emails sent by this domain (report)
    count_domains_in            int     NOT NULL DEFAULT 0,     -- this domain has received emails from N different domains (report)
    count_domains_out           int     NOT NULL DEFAULT 0,     -- this domain has sent emails to N different domains (report)
    count_users_in              int     NOT NULL DEFAULT 0,     -- this domain has received emails from N different users (report)
    count_users_out             int     NOT NULL DEFAULT 0,     -- this domain has sent emails to N different users (report)
    count_received_in_quarantine        bigint    NOT NULL DEFAULT 0, -- # of emails received and put in quarantine
    count_dropped_from_quarantine       bigint    NOT NULL DEFAULT 0, -- # of emails dropped from quarantine for this domain
    count_released_from_quarantine      bigint    NOT NULL DEFAULT 0, -- # of emails released from quarantine for this domain
    count_received_externally           bigint    NOT NULL DEFAULT 0, -- # of emails received by this domain and relayed externally
    count_sent_externally               bigint    NOT NULL DEFAULT 0, -- # of emails sent by this domain and relayed externally
    domain_name                 text    NOT NULL,
    PRIMARY KEY(calc_day, t_domain_id)
);
CREATE INDEX t_domain_daily_domain_id ON mail.t_domain_daily (t_domain_id);

CREATE TABLE mail.t_email_daily_file_attachments(
    calc_day			date,
    mime_type_id		int, 	-- e_mime_type
    count_in			int NOT NULL DEFAULT 0,			-- count of files received of this type 
    count_out			int NOT NULL DEFAULT 0,			-- count of files sent of this type
    count_internal		int NOT NULL DEFAULT 0,			
    count_blocked_in		int NOT NULL DEFAULT 0, 			
    count_blocked_out		int NOT NULL DEFAULT 0,
    count_blocked_internal	int NOT NULL DEFAULT 0,
    volume_in			bigint NOT NULL DEFAULT 0,			
    volume_out			bigint NOT NULL DEFAULT 0,			
    volume_internal		bigint NOT NULL DEFAULT 0,
    volume_blocked_in		bigint NOT NULL DEFAULT 0,
    volume_blocked_out		bigint NOT NULL DEFAULT 0,
    volume_blocked_internal	bigint NOT NULL DEFAULT 0,
    PRIMARY KEY(calc_day, mime_type_id)
);
CREATE INDEX t_email_daily_file_attachments_mime_type_id ON mail.t_email_daily_file_attachments (mime_type_id);


CREATE TABLE mail.t_domain_mime_daily(
        calc_day                date,
        t_domain_id             int,
        t_mime_type_id          int,
        count                   int     NOT NULL DEFAULT 0,     -- # of instances
        count_in                int     NOT NULL DEFAULT 0,     -- # of instances the domain has received this mime type
        count_out               int     NOT NULL DEFAULT 0,     -- # of instances the domain has sent this mime type
        count_internal          int     NOT NULL DEFAULT 0,     -- # of instances in internal emails
        count_internal_in       int     NOT NULL DEFAULT 0,     -- # of instances in internal emails the user has received this mime type
        count_internal_out      int     NOT NULL DEFAULT 0,     -- # of instances in internal emails the user has sent this mime type
        volume                  bigint  NOT NULL DEFAULT 0,     -- volume
        volume_in               bigint  NOT NULL DEFAULT 0,     -- incoming volume 
        volume_out              bigint  NOT NULL DEFAULT 0,     -- outgoing volume
        volume_internal         bigint  NOT NULL DEFAULT 0,     -- volume in internal emails
        volume_internal_in      bigint  NOT NULL DEFAULT 0,     -- incoming volume in internal emails
        volume_internal_out     bigint  NOT NULL DEFAULT 0,     -- outgoing volume in internal emails
        PRIMARY KEY (calc_day, t_domain_id, t_mime_type_id)
);
CREATE INDEX t_domain_mime_daily_domain ON mail.t_domain_mime_daily (t_domain_id);
CREATE INDEX t_domain_mime_daily_mime ON mail.t_domain_mime_daily (t_mime_type_id);


CREATE TABLE mail.t_user_mime_daily(
        calc_day                date,
        t_domain_user_id        int,
        t_mime_type_id          int,
        count                   int     NOT NULL DEFAULT 0,     -- # of instances
        count_in                int     NOT NULL DEFAULT 0,     -- # of instances the user has received this mime type
        count_out               int     NOT NULL DEFAULT 0,     -- # of instances the user has sent this mime type
        count_internal          int     NOT NULL DEFAULT 0,     -- # of instances in internal emails
        count_internal_in       int     NOT NULL DEFAULT 0,     -- # of instances in internal emails the user has received this mime type
        count_internal_out      int     NOT NULL DEFAULT 0,     -- # of instances in internal emails the user has sent this mime type
        volume                  bigint  NOT NULL DEFAULT 0,     -- volume
        volume_in               bigint  NOT NULL DEFAULT 0,     -- incoming volume 
        volume_out              bigint  NOT NULL DEFAULT 0,     -- outgoing volume
        volume_internal         bigint  NOT NULL DEFAULT 0,     -- volume in internal emails
        volume_internal_in      bigint  NOT NULL DEFAULT 0,     -- incoming volume in internal emails
        volume_internal_out     bigint  NOT NULL DEFAULT 0,     -- outgoing volume in internal emails
        PRIMARY KEY (calc_day, t_domain_user_id, t_mime_type_id)
);
CREATE INDEX t_user_mime_daily_user ON mail.t_user_mime_daily (t_domain_user_id);
CREATE INDEX t_user_mime_daily_mime ON mail.t_user_mime_daily (t_mime_type_id);


--
-- used to compute other metrics 
--
CREATE TABLE mail.t_message_daily(
        calc_day        date,
        sender          int,    -- mail.t_domain_user
        receiver        int,    -- mail.t_domain_user
        count_msg       int     NOT NULL DEFAULT 0,
        volume_msg      bigint  NOT NULL DEFAULT 0,
        PRIMARY KEY(calc_day, sender, receiver)
);


--
-- external metrics on domains (not computed by us but provided directly from an external source)
--
CREATE TABLE mail.t_external_domain_info(
    e_cross_domain_id   int,
    registration_date   date,   --registration date of the domain
    expiration_date     date,   --expiration date of the domain
    first_message_date  date,   --1st message from the domain
    PRIMARY KEY (e_cross_domain_id)
);

--
-- metrics on world wide emails : provided by an external source 
--
CREATE TABLE mail.t_global_daily(
    calc_day    date,
    count_emails    bigint NOT NULL DEFAULT 0,
    count_spams     bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (calc_day)
);

--
-- metrics on 1 specific domain provided by external sources
--
CREATE TABLE mail.t_external_domain_daily(
    calc_day    date,
    e_cross_domain_id   int,
    magnitude   double precision,   --http://www.senderbase.org/help/magnitude
    ratio_to_worldwide  double precision,   --ratio, computed from magnitude
    estimated_email_count   bigint, -- computed from ratio (magnitude) and data in t_global_daily
    PRIMARY KEY(e_cross_domain_id, calc_day)
);
CREATE INDEX  t_external_domain_daily_day ON mail.t_external_domain_daily(calc_day);