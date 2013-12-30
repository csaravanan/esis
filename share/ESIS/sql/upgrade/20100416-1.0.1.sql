--
--
-- ESIS
--
-- Copyright (c) 2004-2008 Entelience SARL,  Copyright (c) 2008-2009 Equity SA
-- Copyright (c) 2009-2010 Consulare sarl
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
-- $Id$
--
--

--
-- SQL upgrade from 1.0 to 1.0.1

-- Adding indexes to probes table
CREATE INDEX probe_name_history_idx ON e_probe_history(probe_name);
CREATE INDEX probe_file_name_history_idx on e_probe_file_history(file_name);
CREATE INDEX probe_file_name_hist_idx on e_probe_file_history(e_probe_history_id);
CREATE INDEX probe_parameter_hist_idx on e_probe_parameter_history(e_probe_history_id);
CREATE INDEX probe_db_hist_idx on e_probe_db_history(e_probe_history_id);

-- Removing of all licensing bits
ALTER TABLE e_probes DROP COLUMN license;
ALTER TABLE e_module DROP COLUMN license;
DELETE FROM public.e_preference_descriptions WHERE parameter='com.entelience.license.LicenseHelper.publicStore';

----------------------------------------------------------
--             Assets to Protocol (new)                 --
----------------------------------------------------------

-- Adding creation date tracking for asset.e_asset_ip
ALTER TABLE asset.e_asset_ip ADD COLUMN date_added timestamptz NOT NULL DEFAULT current_timestamp;
ALTER TABLE asset.e_asset_ip ADD COLUMN gateway_ip_id int;

-- Adding index
CREATE INDEX e_asset_main_ip ON asset.e_asset(t_main_ip_id);

--
-- Links assets -> IP -> IP ports
--
CREATE TABLE asset.e_asset_port_daily (
       calc_day                date,   -- day when this service was detected
       t_ip_id                 int,    -- which IP was it on (DHCP case)
       e_asset_id              int,    -- the asset,
       t_iana_port_id  int,    -- which port
       PRIMARY KEY(calc_day, t_ip_id, e_asset_id, t_iana_port_id)
);

--
-- Links assets -> IP -> protocols (those with no ports per se)
--
CREATE TABLE asset.e_asset_protocol_daily (
       calc_day                        date,   -- day when this service was detected
       t_ip_id                         int,    -- which IP was it on (DHCP case)
       e_asset_id                      int,    -- the asset,
       e_protocol_id           int,    -- which protocol
       PRIMARY KEY(calc_day, t_ip_id, e_asset_id, e_protocol_id)
);

-----------------------------------------------------------
--               Db Version Tracking  (new)              --
-----------------------------------------------------------

-- Adding basic db version tracking
CREATE TABLE e_esisdbversion (
        revision_tag            text NOT NULL,          -- revision level (ie. STABLE-20091111) 
        update_file        text,
        last_updated            timestamptz NOT NULL DEFAULT current_timestamp,
		current					boolean DEFAULT false,	-- current running version
        PRIMARY KEY (revision_tag)
);    

-- Updating Db version
UPDATE e_esisdbversion SET current=false;
INSERT INTO e_esisdbversion (revision_tag, last_update_file, current) VALUES ('1.0.1', '201004012-1.0.1.sql', true);

-----------------------------------------------------------
--              ESIS command history (new)               --
-----------------------------------------------------------

-- Adding table to track esis ran command
CREATE TABLE e_esiscmd_history  (
	run_date	timestamptz DEFAULT current_timestamp,	-- when the command was run
	cmd			text,									-- the command
	args		text,									-- the args
	PRIMARY KEY(run_date, cmd, args)
	);
-- property
INSERT INTO e_esisconfig (parameter, value, default_value, lm_user) VALUES ('com.entelience.esis.cmdHistorySize', '5000', '5000', 0);

-----------------------------------------------------------
--              TLD & Regions (update)                   --
-----------------------------------------------------------

-- TLD Updates
INSERT into e_top_level_domains (tld) VALUES ('ASIA');
INSERT into e_top_level_domains (tld) VALUES ('TEL');

-- Countries updates
-- Italy
-- see: http://fr.wikipedia.org/wiki/ISO_3166-2:IT
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Abruzzo', 	380, '65');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Basilicata', 	380, '77');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Calabria', 	380, '78');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Campania', 	380, '72');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Emilia-Romagna', 380, '45');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Friuli-Venezia Giulia', 380, '36');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Lazio', 		380, '62');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Liguria', 	380, '42');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Lombardia', 	380, '25');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Marche', 		380, '57');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Molise', 		380, '67');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Piemonte', 	380, '21');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Puglia',	 	380, '75');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Sardegna', 	380, '88');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Sicilia', 	380, '82');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Toscana', 	380, '52');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Trentino-Alto Adige', 380, '32');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Umbria', 		380, '55');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Valle d Aosta', 380, '23');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Veneto', 		380, '34');

-- Spain
-- see: http://fr.wikipedia.org/wiki/ISO_3166-2:ES
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Andalucía', 	724, 'AN');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Aragon', 		724, 'AR');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Asturias', 	724, 'O');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Canarias', 	724, 'CN');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Cantabria', 	724, 'S');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Castilla-La Mancha', 	724, 'CM');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Castilla y León', 	724, 'CL');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Extremadura', 724, 'EX');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Galicia', 	724, 'GA');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Illes Balears', 	724, 'IB');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'La Rioja', 	724, 'LO');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Madrid',	 	724, 'M');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Murcia', 		724, 'MU');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Navarra', 	724, 'NA');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Valenciana', 	724, 'VC');
