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
-- $Id: http_schema.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


--
-- contains: ESIS http model

CREATE schema http;
--
-- #2 : define tables
--


--
-- RFC 2616
--
CREATE TABLE http.e_http_status(
        http_status_code        int     NOT NULL,       --200
        status                  text    NOT NULL,       --OK
        status_class            text    NOT NULL,       --Successfull
        information             boolean NOT NULL,
        successfull             boolean NOT NULL,
        redirect                boolean NOT NULL,
        client_error            boolean NOT NULL,
        server_error            boolean NOT NULL,
        -- customer definable fields
        security                boolean NOT NULL DEFAULT false,
        PRIMARY KEY(http_status_code)
);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (100, 'Continue', 'Informational', true, false, false, false, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (101, 'Switching Protocols', 'Informational', true, false, false, false, false);

INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (200, 'OK', 'Successfull', false, true, false, false, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (201, 'Created', 'Successfull', false, true, false, false, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (202, 'Accepted', 'Successfull', false, true, false, false, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (203, 'Non-Authoritative Information', 'Successfull', false, true, false, false, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (204, 'No Content', 'Successfull', false, true, false, false, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (205, 'Reset Content', 'Successfull', false, true, false, false, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (206, 'Partial Content', 'Successfull', false, true, false, false, false);

INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (300, 'Multiple Choices', 'Redirection', false, false, true, false, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (301, 'Moved Permanently', 'Redirection', false, false, true, false, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (302, 'Found', 'Redirection', false, false, true, false, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (303, 'See Other', 'Redirection', false, false, true, false, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (304, 'Not Modified', 'Redirection', false, false, true, false, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (305, 'Use Proxy', 'Redirection', false, false, true, false, false);
-- 306 is unused
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (307, 'Temporary Redirect', 'Redirection', false, false, true, false, false);

INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (400, 'Bad Request', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (401, 'Unauthorized', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (402, 'Payment Required', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (403, 'Forbidden', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (404, 'Not Found', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (405, 'Method Not Allowed', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (406, 'Not Acceptable', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (407, 'Proxy Authentication Required', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (408, 'Request Timeout', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (409, 'Conflict', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (410, 'Gone', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (411, 'Length Required', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (412, 'Precondition Failed', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (413, 'Request Entity Too Large', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (414, 'Request-URI Too Long', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (415, 'Unsupported Media Type', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (416, 'Requested Range Not Satisfiable', 'Client Error', false, false, false, true, false);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (417, 'Expectation Failed', 'Client Error', false, false, false, true, false);

INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (500, 'Internal Server Error', 'Server Error', false, false, false, false, true);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (501, 'Not Implemented', 'Server Error', false, false, false, false, true);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (502, 'Bad Gateway', 'Server Error', false, false, false, false, true);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (503, 'Service Unavailable', 'Server Error', false, false, false, false, true);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (504, 'Gateway Timeout', 'Server Error', false, false, false, false, true);
INSERT INTO http.e_http_status(http_status_code, status, status_class, information, successfull, redirect, client_error, server_error) VALUES (505, 'HTTP Version Not Supported', 'Server Error', false, false, false, false, true);


CREATE SEQUENCE http.t_authorization_serial;
CREATE TABLE http.t_authorization (
        t_authorization_id      integer DEFAULT nextval('http.t_authorization_serial'),
        authorization_name      text UNIQUE NOT NULL,
        PRIMARY KEY(t_authorization_id)
);

--
-- t_domain - domain info table
--
CREATE SEQUENCE http.t_domain_serial;
CREATE TABLE http.t_domain (
	t_domain_id			int	DEFAULT nextval('http.t_domain_serial'),
	domain_name			text	NOT NULL,
	first_occurence		timestamp DEFAULT current_timestamp,
	last_occurence		timestamp DEFAULT current_timestamp,
	known_cd  		boolean  	DEFAULT false, --is the domain known is e_cross_domain
	PRIMARY KEY(t_domain_id)
);

CREATE INDEX t_domain_name ON http.t_domain (domain_name);

--
-- t_domain_category - domain category table
CREATE SEQUENCE http.t_domain_category_serial;
CREATE TABLE http.t_domain_category (
	t_domain_category_id	int	DEFAULT nextval('http.t_domain_category_serial'),
	category_name		text	NOT NULL,
	PRIMARY KEY(t_domain_category_id)
);

CREATE TABLE http.t_domain_category_daily(
        calc_day        date,
        t_domain_category_id     int,
        t_authorization_id            int,
        request_statuscode          int,
        count_http         int  not null DEFAULT 0,
	count_ftp          int  not null DEFAULT 0,
	count_https        int  not null DEFAULT 0,
	count_other        int     NOT NULL DEFAULT 0,
	volume_in_http     bigint  not null DEFAULT 0,
	volume_out_http    bigint  not null DEFAULT 0,
	volume_in_ftp      bigint  not null DEFAULT 0,
	volume_out_ftp     bigint  not null DEFAULT 0,
	volume_in_https    bigint  not null DEFAULT 0,
	volume_out_https   bigint  not null DEFAULT 0,
	volume_out_other   bigint not null default 0,
        volume_in_other    bigint not null default 0,
        count_domains       int not null default 0,  --number of != domains for this category/day
        count_sites         int not null default 0,  --number of != sites for this category/day
        count_users         int not null default 0,
        count_ips           int not null default 0,
        PRIMARY KEY(calc_day, t_domain_category_id, t_authorization_id, request_statuscode)
);

CREATE TABLE http.t_domain_daily(
        calc_day        date,
        t_domain_id     int,
        t_authorization_id            int,
        request_statuscode          int,
        count_http         int  not null DEFAULT 0,
	count_ftp          int  not null DEFAULT 0,
	count_https        int  not null DEFAULT 0,
	count_other        int     NOT NULL DEFAULT 0,
	volume_in_http     bigint  not null DEFAULT 0,
	volume_out_http    bigint  not null DEFAULT 0,
	volume_in_ftp      bigint  not null DEFAULT 0,
	volume_out_ftp     bigint  not null DEFAULT 0,
	volume_in_https    bigint  not null DEFAULT 0,
	volume_out_https   bigint  not null DEFAULT 0,
	volume_out_other   bigint not null default 0,
        volume_in_other    bigint not null default 0,
        domain_name        text,
	count_sites        integer NOT NULL DEFAULT 0,
	count_users         int not null default 0,
        count_ips           int not null default 0,
        PRIMARY KEY(calc_day, t_domain_id, t_authorization_id, request_statuscode)
);


--
-- t_domain_site - domain site table
--
CREATE SEQUENCE http.t_domain_site_serial;
CREATE TABLE http.t_domain_site (
	t_domain_site_id	   int	DEFAULT nextval('http.t_domain_site_serial'),
	site_name          text		NOT NULL,
        first_occurence	   timestamp DEFAULT current_timestamp,
	last_occurence     timestamp DEFAULT current_timestamp,
	t_domain_category_id        int     NOT NULL,
	auth               text,
	t_domain_id          int     NOT NULL,
	domain_name        text,
	intranet           boolean     NOT NULL,
	PRIMARY KEY(t_domain_site_id)
);
CREATE UNIQUE INDEX t_domain_site_unik ON http.t_domain_site(t_domain_id, site_name);
CREATE INDEX t_domain_site_category_id ON http.t_domain_site (t_domain_category_id);
CREATE INDEX t_domain_site_name ON http.t_domain_site (site_name);
CREATE INDEX t_domain_site_dom_name ON http.t_domain_site (domain_name);



--
-- t_domain_site_daily - domain site daily table
--
CREATE TABLE http.t_domain_site_daily (
	calc_day        date,
        t_domain_site_id     int,
        t_authorization_id            int,
        request_statuscode          int,
	count_http         int  not null DEFAULT 0,
	count_ftp          int  not null DEFAULT 0,
	count_https        int  not null DEFAULT 0,
	count_other         int not null default 0,
	volume_in_http     bigint  not null DEFAULT 0,
	volume_out_http    bigint  not null DEFAULT 0,
	volume_in_ftp      bigint  not null DEFAULT 0,
	volume_out_ftp     bigint  not null DEFAULT 0,
	volume_in_https    bigint  not null DEFAULT 0,
	volume_out_https   bigint  not null DEFAULT 0,
	volume_out_other    bigint not null default 0,
        volume_in_other     bigint not null default 0,
	count_ips	   int  not null DEFAULT 0,
	count_users	   int  not null DEFAULT 0,
	PRIMARY KEY (calc_day, request_statuscode, t_domain_site_id, t_authorization_id)
);

CREATE INDEX t_domain_site_daily_statuscode ON http.t_domain_site_daily (request_statuscode);
CREATE INDEX t_domain_site_daily_site_id ON http.t_domain_site_daily (t_domain_site_id);


CREATE TABLE http.t_site_anomalies_daily (
    calc_day            date,
    t_domain_site_id    int,
    count_robots_txt    int NOT NULL DEFAULT 0, -- # of robots.txt calls
    count_special_files_without_referer int NOT NULL DEFAULT 0, -- # of calls on special files (gif, css, cf W3C probe parameters) without referer (may be phishing emails)
    PRIMARY KEY(calc_day, t_domain_site_id)
);

CREATE SEQUENCE http.t_site_path_serial;
CREATE TABLE http.t_site_path (
	t_site_path_id	   int DEFAULT nextval('http.t_site_path_serial'),
	path          text	 NOT NULL,
        first_occurence	   timestamp DEFAULT current_timestamp,
	last_occurence     timestamp DEFAULT current_timestamp,
	t_domain_site_id          int     NOT NULL,
	site_name        text,
	depth              int,
	PRIMARY KEY(t_site_path_id)
);
CREATE UNIQUE INDEX t_site_path_unik ON http.t_site_path(t_domain_site_id, path);

CREATE TABLE http.t_site_path_daily (
	calc_day        date,
        t_site_path_id     int,
        t_authorization_id            int,
        request_statuscode          int,
	count_http         int  not null DEFAULT 0,
	count_ftp          int  not null DEFAULT 0,
	count_https        int  not null DEFAULT 0,
	count_other         int not null default 0,
	volume_in_http     bigint  not null DEFAULT 0,
	volume_out_http    bigint  not null DEFAULT 0,
	volume_in_ftp      bigint  not null DEFAULT 0,
	volume_out_ftp     bigint  not null DEFAULT 0,
	volume_in_https    bigint  not null DEFAULT 0,
	volume_out_https   bigint  not null DEFAULT 0,
	volume_out_other    bigint not null default 0,
        volume_in_other     bigint not null default 0,
        count_users             int not null default 0,
        count_ips               int not null default 0,
	PRIMARY KEY (calc_day, request_statuscode, t_site_path_id, t_authorization_id)
);

CREATE TABLE http.t_path_daily_user (
        calc_day        date,
        t_site_path_id  integer,
        t_user_id       integer,
        occurences      integer not null default 0,
        volume          bigint not null default 0,
        PRIMARY KEY(calc_day, t_site_path_id, t_user_id)
);

CREATE TABLE http.t_path_daily_ip (
        calc_day        date,
        t_site_path_id  integer,
        t_ip_id       integer,
        occurences      integer not null default 0,
        volume          bigint not null default 0,
        PRIMARY KEY(calc_day, t_site_path_id, t_ip_id)
);

CREATE TABLE http.t_site_path_dependencie (
     root_path_id              integer     NOT NULL,  -- the root path ex : '/'
     leaf_path_id              integer     NOT NULL,  -- the leaf path ex : '/publication/2007/december/noel/'
     lastnode_path_id          integer,               -- the last node before the leaf ex : '/publication/2007/december/'
     date_add                  timestamptz     NOT NULL DEFAULT current_timestamp,
     PRIMARY KEY (root_path_id, leaf_path_id)
);

--
-- t_http_day - global day table
--
CREATE TABLE http.t_http_day (
	calc_day               date DEFAULT current_date,
        first_request_hour time NOT NULL ,
	last_request_hour  time NOT NULL ,
	count              int NOT NULL DEFAULT 0,
	count_internet     int NOT NULL DEFAULT 0,
	count_intranet     int NOT NULL DEFAULT 0,
	volume_in          bigint NOT NULL DEFAULT 0,
	volume_out         bigint NOT NULL DEFAULT 0,
	volume_in_internet          bigint NOT NULL DEFAULT 0,
	volume_out_internet         bigint NOT NULL DEFAULT 0,
	volume_in_intranet          bigint NOT NULL DEFAULT 0,
	volume_out_intranet         bigint NOT NULL DEFAULT 0,
	total_time         bigint NOT NULL DEFAULT 0,
	count_ips	   int NOT NULL DEFAULT 0 ,
	count_users	   int NOT NULL DEFAULT 0,
	count_sites        int NOT NULL DEFAULT 0,
	count_domains      int NOT NULL DEFAULT 0,
	PRIMARY KEY(calc_day)
);


--
-- t_https_day - global day table
--
CREATE TABLE http.t_https_day (
	calc_day               date DEFAULT current_date,
        first_request_hour time NOT NULL ,
	last_request_hour  time NOT NULL ,
	count              int NOT NULL DEFAULT 0,
	count_internet     int NOT NULL DEFAULT 0,
	count_intranet     int NOT NULL DEFAULT 0,
	volume_in          bigint NOT NULL DEFAULT 0,
	volume_out         bigint NOT NULL DEFAULT 0,
	volume_in_internet          bigint NOT NULL DEFAULT 0,
	volume_out_internet         bigint NOT NULL DEFAULT 0,
	volume_in_intranet          bigint NOT NULL DEFAULT 0,
	volume_out_intranet         bigint NOT NULL DEFAULT 0,
	total_time         bigint NOT NULL DEFAULT 0,
	count_ips	   int NOT NULL DEFAULT 0 ,
	count_users	   int NOT NULL DEFAULT 0,
	count_sites        int NOT NULL DEFAULT 0,
	count_domains      int NOT NULL DEFAULT 0,
	PRIMARY KEY(calc_day)
);


--
-- t_ftp_day - global day table
--
CREATE TABLE http.t_ftp_day (
	calc_day               date DEFAULT current_date,
        first_request_hour time NOT NULL ,
	last_request_hour  time NOT NULL ,
	count              int NOT NULL DEFAULT 0,
	count_internet     int NOT NULL DEFAULT 0,
	count_intranet     int NOT NULL DEFAULT 0,
	volume_in          bigint NOT NULL DEFAULT 0,
	volume_out         bigint NOT NULL DEFAULT 0,
	volume_in_internet          bigint NOT NULL DEFAULT 0,
	volume_out_internet         bigint NOT NULL DEFAULT 0,
	volume_in_intranet          bigint NOT NULL DEFAULT 0,
	volume_out_intranet         bigint NOT NULL DEFAULT 0,
	total_time         bigint NOT NULL DEFAULT 0,
	count_ips	   int NOT NULL DEFAULT 0 ,
	count_users	   int NOT NULL DEFAULT 0,
	count_sites        int NOT NULL DEFAULT 0,
	count_domains      int NOT NULL DEFAULT 0,
	PRIMARY KEY(calc_day)
);


--
-- t_other_day - global day table
--
CREATE TABLE http.t_other_day (
	calc_day               date DEFAULT current_date,
        first_request_hour time NOT NULL ,
	last_request_hour  time NOT NULL ,
	count              int NOT NULL DEFAULT 0,
	count_internet     int NOT NULL DEFAULT 0,
	count_intranet     int NOT NULL DEFAULT 0,
	volume_in          bigint NOT NULL DEFAULT 0,
	volume_out         bigint NOT NULL DEFAULT 0,
	volume_in_internet          bigint NOT NULL DEFAULT 0,
	volume_out_internet         bigint NOT NULL DEFAULT 0,
	volume_in_intranet          bigint NOT NULL DEFAULT 0,
	volume_out_intranet         bigint NOT NULL DEFAULT 0,
	total_time         bigint NOT NULL DEFAULT 0,
	count_ips	   int NOT NULL DEFAULT 0 ,
	count_users	   int NOT NULL DEFAULT 0,
	count_sites        int NOT NULL DEFAULT 0,
	count_domains      int NOT NULL DEFAULT 0,
	PRIMARY KEY(calc_day)
);



--
-- t_http_agent - http agents table
--
CREATE SEQUENCE http.t_http_agent_serial;

CREATE TABLE http.t_http_agent (
	t_http_agent_id    int	DEFAULT nextval('http.t_http_agent_serial'),
        agent_name       text NOT NULL ,
	version          text,
	first_occurence  timestamp ,
	last_occurence   timestamp ,
	authorized       text,
	web_crawler      boolean   NOT NULL DEFAULT false,
	PRIMARY KEY(t_http_agent_id)
);

CREATE INDEX t_http_agent_auth ON http.t_http_agent (authorized);

--
-- t_http_agent_daily - http agents per day stats
--

CREATE TABLE http.t_http_agent_daily (
	calc_day               date DEFAULT current_date,
	count              int NOT NULL DEFAULT 0,
	count_users        int NOT NULL DEFAULT 0,
	count_ips          int NOT NULL DEFAULT 0,
	t_http_agent_id    int NOT NULL,
	PRIMARY KEY (calc_day, t_http_agent_id)
);

CREATE INDEX t_http_agent_daily_agent_id ON http.t_http_agent_daily (t_http_agent_id);

CREATE SEQUENCE http.t_user_serial;
CREATE TABLE http.t_user(
        t_user_id       int     DEFAULT nextval('http.t_user_serial'),
        user_name       text    UNIQUE NOT NULL,
        PRIMARY KEY(t_user_id)
);


CREATE TABLE http.t_ip_users_daily(
        calc_day      date,
        t_ip_id        integer,
        t_user_id       integer,
        PRIMARY KEY(calc_day, t_ip_id, t_user_id)
);

CREATE TABLE http.t_ip_to_user_daily(
        calc_day      date,
        t_ip_id        integer,
        count_users     integer NOT NULL DEFAULT 0,
        PRIMARY KEY (t_ip_id, calc_day)
);
CREATE TABLE http.t_user_to_ip_daily(
        calc_day      date,
        t_user_id        integer,
        count_ips     integer NOT NULL DEFAULT 0,
        PRIMARY KEY (t_user_id, calc_day)
);

--
-- t_user_daily
--
CREATE TABLE http.t_user_daily (
    t_user_id		int,
    calc_day		date,
    t_domain_site_id	int,
    trafic_type		int,
    mime_type_id	int,
    t_http_agent_id     int,
    request_statuscode  int,
    t_authorization_id  int,
    occurences  	int NOT NULL DEFAULT 0,
    volume		bigint NOT NULL DEFAULT 0,
    PRIMARY KEY(t_user_id, calc_day, t_domain_site_id, trafic_type, mime_type_id, t_http_agent_id, request_statuscode, t_authorization_id)
);
CREATE INDEX t_user_daily_calc_day ON http.t_user_daily (calc_day);

CREATE TABLE http.t_ip_daily (
    t_ip_id             int,
    calc_day		date,
    t_domain_site_id	int,
    trafic_type		int,
    mime_type_id	int,
    t_http_agent_id     int,
    request_statuscode  int,
    t_authorization_id  int,
    occurences  	int NOT NULL DEFAULT 0,
    volume 		bigint NOT NULL DEFAULT 0,
    PRIMARY KEY(t_ip_id, calc_day, t_domain_site_id, trafic_type, mime_type_id, t_http_agent_id, request_statuscode, t_authorization_id)
);
CREATE INDEX t_ip_daily_calc_day ON http.t_ip_daily (calc_day);


--
-- link to location is provided using ip_daily and location networks 
--
CREATE TABLE http.t_location_daily (
    e_location_id       int,
    calc_day    	date,
    trafic_type	        int,
    mime_type_id        int,
    occurences          int NOT NULL DEFAULT 0,
    volume 	        bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (e_location_id, calc_day, trafic_type, mime_type_id)
);
CREATE INDEX t_location_daily_calc_day ON http.t_location_daily (calc_day);

CREATE TABLE http.t_location_site_daily (
        e_location_id           int, 
        calc_day                date, 
        t_domain_site_id        int, 
        occurences              int     NOT NULL, 
        volume                  bigint  NOT NULL, 
        PRIMARY KEY (e_location_id, calc_day, t_domain_site_id)
);
CREATE INDEX t_location_site_daily_calc_day ON http.t_location_site_daily (calc_day);

CREATE TABLE http.t_mime_daily (
    calc_day		date,
    mime_type_id	int,	--e_mime_type
    count		int NOT NULL DEFAULT 0,	--# of occurences
    count_ips		int NOT NULL DEFAULT 0,	--# of ip that have downloaded this file
    count_users		int NOT NULL DEFAULT 0,	--# of users that have downloaded this file
    volume		bigint NOT NULL DEFAULT 0,	--volume dowloaded
    count_sites         int NOT NULL DEFAULT 0,
    count_domains       int NOT NULL DEFAULT 0,
    PRIMARY KEY(calc_day, mime_type_id)
);
CREATE INDEX t_mime_daily_mime_id ON http.t_mime_daily (mime_type_id);

CREATE TABLE http.t_users_daily (
    calc_day		date,
    count_users		int NOT NULL DEFAULT 0,
    count_users_http	int NOT NULL DEFAULT 0,
    count_users_https	int NOT NULL DEFAULT 0,
    count_users_ftp	int NOT NULL DEFAULT 0,
    count_users_other	int NOT NULL DEFAULT 0,
    count_ips		int NOT NULL DEFAULT 0,
    count_ips_http	int NOT NULL DEFAULT 0,
    count_ips_https	int NOT NULL DEFAULT 0,
    count_ips_ftp	int NOT NULL DEFAULT 0,
    count_ips_other	int NOT NULL DEFAULT 0,
    PRIMARY KEY(calc_day)
);

CREATE TABLE http.t_users_weekly (
    calc_day		date,
    count_users		int NOT NULL DEFAULT 0,
    count_users_http	int NOT NULL DEFAULT 0,
    count_users_https	int NOT NULL DEFAULT 0,
    count_users_ftp	int NOT NULL DEFAULT 0,
    count_users_other	int NOT NULL DEFAULT 0,
    count_ips		int NOT NULL DEFAULT 0,
    count_ips_http	int NOT NULL DEFAULT 0,
    count_ips_https	int NOT NULL DEFAULT 0,
    count_ips_ftp	int NOT NULL DEFAULT 0,
    count_ips_other	int NOT NULL DEFAULT 0,
    PRIMARY KEY(calc_day)
);

CREATE TABLE http.t_users_monthly (
    calc_day		date,
    count_users		int NOT NULL DEFAULT 0,
    count_users_http	int NOT NULL DEFAULT 0,
    count_users_https	int NOT NULL DEFAULT 0,
    count_users_ftp	int NOT NULL DEFAULT 0,
    count_users_other	int NOT NULL DEFAULT 0,
    count_ips		int NOT NULL DEFAULT 0,
    count_ips_http	int NOT NULL DEFAULT 0,
    count_ips_https	int NOT NULL DEFAULT 0,
    count_ips_ftp	int NOT NULL DEFAULT 0,
    count_ips_other	int NOT NULL DEFAULT 0,
    PRIMARY KEY(calc_day)
);

CREATE TABLE http.t_users_yearly (
    calc_day		date,
    count_users		int NOT NULL DEFAULT 0,
    count_users_http	int NOT NULL DEFAULT 0,
    count_users_https	int NOT NULL DEFAULT 0,
    count_users_ftp	int NOT NULL DEFAULT 0,
    count_users_other	int NOT NULL DEFAULT 0,
    count_ips		int NOT NULL DEFAULT 0,
    count_ips_http	int NOT NULL DEFAULT 0,
    count_ips_https	int NOT NULL DEFAULT 0,
    count_ips_ftp	int NOT NULL DEFAULT 0,
    count_ips_other	int NOT NULL DEFAULT 0,
    PRIMARY KEY(calc_day)
);


CREATE TABLE http.e_tld_daily( --e_top_level_domains
        calc_day            date,
        e_top_domain_id     int,
        t_authorization_id  int,
        request_statuscode  int,
        count_http          int  not null DEFAULT 0,
	count_ftp           int  not null DEFAULT 0,
	count_https         int  not null DEFAULT 0,
	count_other         int     NOT NULL DEFAULT 0,
	volume_in_http      bigint  not null DEFAULT 0,
	volume_out_http     bigint  not null DEFAULT 0,
	volume_in_ftp       bigint  not null DEFAULT 0,
	volume_out_ftp      bigint  not null DEFAULT 0,
	volume_in_https     bigint  not null DEFAULT 0,
	volume_out_https    bigint  not null DEFAULT 0,
	volume_out_other    bigint not null default 0,
        volume_in_other     bigint not null default 0,
        tld_name            text,
	count_domains       integer NOT NULL DEFAULT 0,
	count_users         int not null default 0,
        count_ips           int not null default 0,
        PRIMARY KEY(calc_day, e_top_domain_id, t_authorization_id, request_statuscode)
);

CREATE SEQUENCE http.t_invalid_url_serial;
CREATE TABLE http.t_invalid_url(
        t_invalid_url_id        int     DEFAULT nextval('http.t_invalid_url_serial'),
        invalid_url             text,
        creation_ts     timestamptz     NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY (t_invalid_url_id)
);

CREATE UNIQUE INDEX t_invalid_url_unik ON http.t_invalid_url(invalid_url);

CREATE TABLE http.t_invalid_url_daily_user(
        calc_day        date    NOT NULL,
        t_invalid_url_id        int NOT NULL,
        t_user_id       int,
        t_ip_id         int,
        nb_events       bigint  NOT NULL
);
CREATE UNIQUE INDEX t_invalid_url_daily_user_unik ON http.t_invalid_url_daily_user(calc_day, t_invalid_url_id, t_ip_id, t_user_id);

CREATE TABLE http.t_invalid_url_daily(
        calc_day        date,
        t_invalid_url_id        int,
        nb_events       bigint  NOT NULL,
        nb_ips          int     NOT NULL,
        nb_users        int     NOT NULL,
        PRIMARY KEY(t_invalid_url_id, calc_day)
);
CREATE INDEX t_invalid_url_daily_date ON http.t_invalid_url_daily(calc_day);

--
-- Security rules
--

CREATE SEQUENCE http.t_security_rule_serial;
CREATE TABLE http.t_security_rule(
        t_security_rule_id      integer DEFAULT nextval('http.t_security_rule_serial'),
        rule_def                text    NOT NULL,
        probe_name              text    NOT NULL,
        description             text,
        t_security_rule_category_id     integer,
        creation_date           timestamptz     NOT NULL DEFAULT current_timestamp,
        first_occurence         timestamptz,
        last_occurence          timestamptz,
        obsolete                boolean         NOT NULL DEFAULT false,
        PRIMARY KEY(t_security_rule_id)
);
CREATE UNIQUE INDEX t_security_rule_unik ON http.t_security_rule(probe_name, rule_def);


CREATE SEQUENCE http.t_security_rule_category_serial;
CREATE TABLE http.t_security_rule_category(
        t_security_rule_category_id     integer DEFAULT nextval('http.t_security_rule_category_serial'),
        category_name        text    UNIQUE NOT NULL,
        PRIMARY KEY (t_security_rule_category_id)
);

CREATE TABLE http.t_security_rule_alias(
        t_security_rule_id      integer NOT NULL, --the refering rule
        t_alias_rule_id         integer NOT NULL, --the rule that is the alias
        PRIMARY KEY(t_alias_rule_id)
);

CREATE TABLE http.t_security_rule_to_vulnerability(
        t_security_rule_id      integer NOT NULL,
        vuln_name               text    NOT NULL,
        e_vuln_id               integer,                --to vuln.e_vulnerability, can be null if the vuln cannot be resolved
        obsolete                boolean NOT NULL DEFAULT false,
        PRIMARY KEY(t_security_rule_id, vuln_name)
);

--
-- mother of all report tables
--  not supposed to be used by WS, but by reports
--
CREATE TABLE http.t_security_action_daily(
        calc_day                date, 
        t_ip_id                 int, --the IP accessing the site
        t_domain_site_id        int, --the protected site
        t_security_rule_id      int, -- the rule
        rule_count              int, -- how many rules shared this action : if 1 -> only this rule triggered the action
        count_denied            int NOT NULL DEFAULT 0,
        count_granted           int NOT NULL DEFAULT 0,
        count_warn              int NOT NULL DEFAULT 0,
        PRIMARY KEY(calc_day, t_ip_id, t_domain_site_id, t_security_rule_id, rule_count)
);

CREATE TABLE http.t_security_rule_category_daily(
        calc_day                date,
        t_security_rule_category_id      int,
        count_all               int NOT NULL DEFAULT 0, -- # of times this category has been seen
        count_denied            int NOT NULL DEFAULT 0, -- # of times this category has denied an access (maybe alone, maybe with some others)
        count_granted           int NOT NULL DEFAULT 0, -- # of times this category has granted an access (maybe alone, maybe with some others)
        count_warn              int NOT NULL DEFAULT 0, -- # of times this category has warned (maybe alone, maybe with some others)
        count_denied_ips        int NOT NULL DEFAULT 0, -- # of distinct IPs denied by this category
        count_granted_ips       int NOT NULL DEFAULT 0, -- # of distinct IPs granted by this category
        count_warn_ips          int NOT NULL DEFAULT 0, -- # of distinct IPs warned by this category
        count_req_denied        int NOT NULL DEFAULT 0, -- # of access denied for this category (can be < of count_denied if several rules of this category triggered on the same request (ie scoring list))
        count_req_granted       int NOT NULL DEFAULT 0, -- # of access granted for this category (can be < of count_granted if several rules of this category triggered on the same request (ie scoring list))
        count_req_warn          int NOT NULL DEFAULT 0, -- # of warns for this category (can be < of count_warn if several rules of this category triggered on the same request (ie scoring list))
        PRIMARY KEY(t_security_rule_category_id, calc_day)
);
CREATE INDEX t_security_rule_category_daily_day ON http.t_security_rule_category_daily(calc_day);

CREATE TABLE http.t_security_rule_daily(
        calc_day                date,
        t_security_rule_id      int,
        count_all               int NOT NULL DEFAULT 0, -- # of times this rule has been seen, alone or with others
        count_denied            int NOT NULL DEFAULT 0, -- # of times this rule (and no others) has denied an access
        count_granted           int NOT NULL DEFAULT 0, -- # of times this rule (and no others) has granted an access
        count_warn              int NOT NULL DEFAULT 0, -- # of times this rule (and no others) has warned
        count_denied_partial    int NOT NULL DEFAULT 0, -- # of times this rule (+ some others) has denied an access
        count_granted_partial   int NOT NULL DEFAULT 0, -- # of times this rule (+ some others) has granted an access
        count_warn_partial      int NOT NULL DEFAULT 0, -- # of times this rule (+ some others) has warned
        count_denied_ips        int NOT NULL DEFAULT 0, -- # of distinct IPs denied by this rule
        count_granted_ips       int NOT NULL DEFAULT 0, -- # of distinct IPs granted by this rule
        count_warn_ips          int NOT NULL DEFAULT 0, -- # of distinct IPs warned by this rule
        PRIMARY KEY(t_security_rule_id, calc_day)
);
CREATE INDEX t_security_rule_daily_day ON http.t_security_rule_daily(calc_day);

CREATE TABLE http.t_security_site_daily(
        calc_day                date,
        t_domain_site_id        int,
        count_rules_denied      int NOT NULL DEFAULT 0, -- # of distinct rules (with no other rules) that denied access to this site
        count_rules_granted     int NOT NULL DEFAULT 0, -- # of distinct rules (with no other rules) that granted access to this site
        count_rules_warn        int NOT NULL DEFAULT 0, -- # of distinct rules (with no other rules) that warned for this site
        count_rules_denied_partial      int NOT NULL DEFAULT 0, -- # of distinct rules (+ some others) that denied access to this site
        count_rules_granted_partial     int NOT NULL DEFAULT 0, -- # of distinct rules (+ some others) that granted access to this site
        count_rules_warn_partial        int NOT NULL DEFAULT 0, -- # of distinct rules (+ some others) that warned for this site
        count_denied_ips        int NOT NULL DEFAULT 0, -- this site has been denied to N distinct IPs
        count_granted_ips       int NOT NULL DEFAULT 0, -- this site has been granted to N distinct IPs
        count_warn_ips          int NOT NULL DEFAULT 0, -- this site has been warned for N distinct IPs
        count_denied            int NOT NULL DEFAULT 0, -- # of times this site has been denied
        count_granted           int NOT NULL DEFAULT 0, -- # of times this site has been granted
        count_warn              int NOT NULL DEFAULT 0, -- # of warns for this site
        PRIMARY KEY(t_domain_site_id, calc_day)
);
CREATE INDEX t_security_site_daily_day ON http.t_security_site_daily(calc_day);

CREATE TABLE http.t_security_daily(
        calc_day                date,
        count_sites             int NOT NULL DEFAULT 0, -- # of distinct sites with data this day
        count_rules_denied      int NOT NULL DEFAULT 0, -- # of distinct rules (with no other rules) that denied access this day
        count_rules_granted     int NOT NULL DEFAULT 0, -- # of distinct rules (with no other rules) that granted access this day
        count_rules_warn        int NOT NULL DEFAULT 0, -- # of distinct rules (with no other rules) that warned this day
        count_rules_denied_partial      int NOT NULL DEFAULT 0, -- # of distinct rules (+ some others) that denied access this day
        count_rules_granted_partial     int NOT NULL DEFAULT 0, -- # of distinct rules (+ some others) that granted access this day
        count_rules_warn_partial        int NOT NULL DEFAULT 0, -- # of distinct rules (+ some others) that warned this day
        count_denied_ips        int NOT NULL DEFAULT 0, -- N distinct IPs have been denied
        count_granted_ips       int NOT NULL DEFAULT 0, -- N distinct IPs have been granted
        count_warn_ips          int NOT NULL DEFAULT 0, -- N distinct IPs have triggered a warn
        count_denied            int NOT NULL DEFAULT 0, -- # of denied
        count_granted           int NOT NULL DEFAULT 0, -- # of granted
        count_warn              int NOT NULL DEFAULT 0, -- # of warns
        PRIMARY KEY(calc_day)
);


CREATE TABLE http.t_security_rule_site_daily(
        calc_day                date,
        t_domain_site_id        int,
        t_security_rule_id      int,
        count_all               int NOT NULL DEFAULT 0, -- # of times this rule has been seen on this site, alone or with others
        count_denied            int NOT NULL DEFAULT 0, -- # of times this rule (and no others) has denied an access
        count_granted           int NOT NULL DEFAULT 0, -- # of times this rule (and no others) has granted an access
        count_warn              int NOT NULL DEFAULT 0, -- # of times this rule (and no others) has warned
        count_denied_partial    int NOT NULL DEFAULT 0, -- # of times this rule (+ some others) has denied an access
        count_granted_partial   int NOT NULL DEFAULT 0, -- # of times this rule (+ some others) has granted an access
        count_warn_partial      int NOT NULL DEFAULT 0, -- # of times this rule (+ some others) has warned
        count_denied_ips        int NOT NULL DEFAULT 0, -- # of distinct IPs denied by this rule
        count_granted_ips       int NOT NULL DEFAULT 0, -- # of distinct IPs granted by this rule
        count_warn_ips          int NOT NULL DEFAULT 0, -- # of distinct IPs warned by this rule
        PRIMARY KEY(t_domain_site_id, t_security_rule_id, calc_day)
);
CREATE INDEX t_security_rule_site_daily_day ON http.t_security_rule_site_daily(calc_day);


--
-- global table filled by probe
--
CREATE TABLE http.t_security_access_daily(
        calc_day                date    NOT NULL,
        e_asset_id              int     NOT NULL,    --the device that does the protection
        t_user_id               int,    --the authenticated user, null if no auth
        t_ip_id                 int,    --the IP where the query comes from, null if for any reason this is not available
        t_domain_site_id        int     NOT NULL,    --the accessed site
        t_site_path_id          int     NOT NULL,    --the path accessed
        http_status_code        int     NOT NULL,
        nb_occurences           int     NOT NULL DEFAULT 0,
        volume                  bigint  NOT NULL DEFAULT 0,
        total_response_time     float8  NOT NULL DEFAULT 0, --total time taken to manage the queries 
        proxy_response_time     float8  NOT NULL DEFAULT 0, --time taken by the reverse proxy to manage the queries 
        internal_response_time  float8  NOT NULL DEFAULT 0  --time taken by the protected server to answer the query 
);
CREATE UNIQUE INDEX http_t_security_access_daily_unik ON http.t_security_access_daily(t_domain_site_id, t_site_path_id, calc_day, e_asset_id, t_user_id, t_ip_id, http_status_code);

--
-- metrics per asset (filtering device)
--
CREATE TABLE http.t_security_access_asset_daily(
    calc_day    date,
    e_asset_id  int,            --the device
    count_all   int             NOT NULL DEFAULT 0,     --how many events that day
    count_security_status       int       NOT NULL DEFAULT 0,     --how many events with security status that day (cf http.e_http_status)
    volume      bigint          NOT NULL DEFAULT 0,     -- volume of data returned
    count_ips   int             NOT NULL DEFAULT 0,     -- distinct number of IPs that day
    count_users int             NOT NULL DEFAULT 0,     -- distinct number of authenticated user that day
    average_response_time       float8  NOT NULL DEFAULT 0,     --average response time
    PRIMARY KEY(e_asset_id, calc_day)
);
CREATE INDEX http_t_security_access_asset_daily_date ON http.t_security_access_asset_daily(calc_day);


--
-- metrics per protected site
--
CREATE TABLE http.t_security_access_site_daily(
    calc_day    date,
    t_domain_site_id    int,            --the site
    count_all   int             NOT NULL DEFAULT 0,     --how many events that day
    count_security_status       int       NOT NULL DEFAULT 0,     --how many events with security status that day (cf http.e_http_status)
    volume      bigint          NOT NULL DEFAULT 0,     -- volume of data returned
    count_ips   int             NOT NULL DEFAULT 0,     -- distinct number of IPs that day
    count_users int             NOT NULL DEFAULT 0,     -- distinct number of authenticated user that day
    average_response_time       float8  NOT NULL DEFAULT 0,     --average response time
    PRIMARY KEY(t_domain_site_id, calc_day)
);
CREATE INDEX http_t_security_access_site_daily_date ON http.t_security_access_site_daily(calc_day);

--
-- metrics per path in a site
--
CREATE TABLE http.t_security_access_site_path_daily(
    calc_day    date,
    t_site_path_id    int,            --the path
    count_all   int             NOT NULL DEFAULT 0,     --how many events that day
    count_security_status       int       NOT NULL DEFAULT 0,     --how many events with security status that day (cf http.e_http_status)
    volume      bigint          NOT NULL DEFAULT 0,     -- volume of data returned
    count_ips   int             NOT NULL DEFAULT 0,     -- distinct number of IPs that day
    count_users int             NOT NULL DEFAULT 0,     -- distinct number of authenticated user that day
    average_response_time       float8  NOT NULL DEFAULT 0,     --average response time
    PRIMARY KEY(t_site_path_id, calc_day)
);
CREATE INDEX http_t_security_access_site_path_daily_date ON http.t_security_access_site_path_daily(calc_day);

--
-- metrics per status
--
CREATE TABLE http.t_security_access_status_daily(
    calc_day    date,
    http_status int,            --the status (cf http.e_http_status)
    count_all   int             NOT NULL DEFAULT 0,     --how many events that day
    volume      bigint          NOT NULL DEFAULT 0,     -- volume of data returned
    count_ips   int             NOT NULL DEFAULT 0,     -- distinct number of IPs that day
    count_users int             NOT NULL DEFAULT 0,     -- distinct number of authenticated user that day
    average_response_time       float8  NOT NULL DEFAULT 0,     --average response time
    PRIMARY KEY(http_status, calc_day)
);
CREATE INDEX http_t_security_access_status_daily_date ON http.t_security_access_status_daily(calc_day);

