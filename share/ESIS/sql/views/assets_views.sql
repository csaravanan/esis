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
-- $Id: assets_views.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--

CREATE OR REPLACE FUNCTION trgfn_asset_names() RETURNS TRIGGER AS $trig$
        DECLARE -- local variables
       	       main_mac_address text;
	       main_ip text;
        BEGIN
        	SELECT INTO main_mac_address (mac_address) FROM asset.e_asset_network_interface WHERE e_asset_network_interface_id = NEW.e_main_network_interface_id;
        	SELECT INTO main_ip (host(ip)) FROM net.t_ip WHERE t_ip_id = NEW.t_main_ip_id;

                -- unique name part
		IF (NEW.serial_number IS NOT NULL AND NEW.serial_number IS NOT NULL) THEN
				NEW.unique_name = 'SER_' || NEW.serial_number;
		ELSIF (NEW.fqdn IS NOT NULL) THEN 
              			NEW.unique_name = 'FQDN_' || NEW.fqdn;
              	ELSIF (NEW.host IS NOT NULL AND NEW.domain IS NOT NULL) THEN 
              			NEW.unique_name = 'DOM_' || NEW.domain || 'HOST_' || NEW.host;
                ELSIF (NEW.host IS NOT NULL) THEN 
              			NEW.unique_name = 'HOST_' || NEW.host;
              	ELSIF (main_mac_address IS NOT NULL) THEN 
              			NEW.unique_name = 'MAC_' || main_mac_address;
              	ELSIF (main_ip IS NOT NULL) THEN 
              			NEW.unique_name = 'IP__' ||main_ip;
              	ELSE 
              			RAISE EXCEPTION 'No enough info for asset';
                END IF;
                
                IF (NEW.fqdn IS NOT NULL) THEN
                        NEW.display_name = NEW.fqdn;
                ELSIF (NEW.host IS NOT NULL AND NEW.domain IS NOT NULL) THEN 
                        NEW.display_name = NEW.host || ' (domain ' || NEW.domain || ')';
                ELSIF (main_ip IS NOT NULL) THEN
                        NEW.display_name = main_ip;
                ELSIF (NEW.host IS NOT NULL) THEN 
                        NEW.display_name = NEW.host;
                ELSE 
                        NEW.display_name = NEW.unique_name;
                END IF;
                RETURN NEW;
        END;
$trig$ LANGUAGE plpgsql;

CREATE TRIGGER trg_maint_e_asset_before BEFORE INSERT OR UPDATE ON asset.e_asset
      FOR EACH ROW EXECUTE PROCEDURE trgfn_asset_names();


CREATE OR REPLACE FUNCTION trgfn_asset_deps() RETURNS TRIGGER AS $trig$
        DECLARE
        BEGIN
        	DELETE FROM asset.e_asset_ip WHERE e_asset_id = OLD.e_asset_id;
        	DELETE FROM asset.e_asset_network_interface WHERE e_asset_id = OLD.e_asset_id;
        	RETURN OLD;
        END;
$trig$ LANGUAGE plpgsql;


CREATE TRIGGER trg_maint_e_asset_afterdel AFTER DELETE ON asset.e_asset
      FOR EACH ROW EXECUTE PROCEDURE trgfn_asset_deps();
      

CREATE OR REPLACE FUNCTION fn_get_asset_id (
        _serial         IN text,
	_mac            IN text,
	_fqdn           IN text,
	_domain         IN text,
	_host           IN text,
	_ip             IN text
) RETURNS integer AS $fn$
  DECLARE
	_asset_id       integer;
  BEGIN
        SELECT INTO _asset_id (e_asset_id) FROM asset.e_asset WHERE lower(serial_number) = lower(_serial);
        IF (_asset_id IS NOT NULL) THEN
                RETURN _asset_id;
        END IF;
        SELECT INTO _asset_id (e_asset_id) FROM asset.e_asset WHERE lower(fqdn) = lower(_fqdn);
        IF (_asset_id IS NOT NULL) THEN
                RETURN _asset_id;
        END IF;
        SELECT INTO _asset_id (e_asset_id) FROM asset.e_asset WHERE lower(domain) = lower(_domain) AND lower(host) = lower(_host);
        IF (_asset_id IS NOT NULL) THEN
                RETURN _asset_id;
        END IF;
        SELECT INTO _asset_id (e_asset_id) FROM asset.e_asset WHERE lower(host) = lower(_host);
        IF (_asset_id IS NOT NULL) THEN
                RETURN _asset_id;
        END IF;
        SELECT INTO _asset_id (ass.e_asset_id) FROM asset.e_asset_network_interface ni INNER JOIN asset.e_asset ass ON ass.e_asset_id = ni.e_asset_id WHERE lower(mac_address) = lower(_mac);
        IF (_asset_id IS NOT NULL) THEN
                RETURN _asset_id;
        END IF;
        SELECT INTO _asset_id (ass.e_asset_id) FROM asset.e_asset_ip ai INNER JOIN asset.e_asset ass ON ass.e_asset_id = ai.e_asset_id INNER JOIN net.t_ip i ON i.t_ip_id = ai.t_ip_id WHERE host(ip) = _ip;
        IF (_asset_id IS NOT NULL) THEN
                RETURN _asset_id;
        END IF;
        RETURN null;
  END;
$fn$ LANGUAGE plpgsql VOLATILE;


CREATE OR REPLACE FUNCTION add_asset_product (
        _e_asset_id      IN      integer,
        _e_product_id    IN      integer,
        _e_version_id    IN      integer,
        _is_main         IN      boolean,
        _modifier        IN      integer
) RETURNS integer AS $fn$
  DECLARE
  BEGIN
        INSERT INTO asset.e_asset_product(e_asset_id, e_product_id, e_version_id, is_main) VALUES (_e_asset_id, _e_product_id, _e_version_id, _is_main);
        INSERT INTO asset.e_asset_product_history(e_asset_id, e_product_id, added, modifier) VALUES (_e_asset_id, _e_product_id, true, _modifier);
        RETURN 1;
  END;
$fn$ LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION remove_asset_product (
        _e_asset_id      IN      integer,
        _e_product_id    IN      integer,
        _modifier        IN      integer
) RETURNS integer AS $fn$
  DECLARE
  BEGIN
        DELETE FROM asset.e_asset_product WHERE e_asset_id = _e_asset_id AND e_product_id = _e_product_id ;
        IF NOT FOUND THEN
                RETURN 0;
        END IF;
        INSERT INTO asset.e_asset_product_history(e_asset_id, e_product_id, added, modifier) VALUES (_e_asset_id, _e_product_id, false, _modifier);
        RETURN 1;
  END;
$fn$ LANGUAGE plpgsql VOLATILE;