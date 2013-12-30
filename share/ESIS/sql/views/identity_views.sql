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
-- $Id: identity_views.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--

-- ESIS Security DataWarehouse schema - install as user 'entelligence'
--
-- contains: IM usertools procedures to insert/update users and ASL


-- TODO ou -> path representation, l -> path representation
-- 
-- Note that after running this function in a loop, we need to be able
-- to drop all asls that are no longer referenced by the asl-to-user table.
-- (Effectively, they've just gone away.)
--
CREATE OR REPLACE FUNCTION fn_update_im_user(
    _user_id            IN  text
,   _z_asl              IN  text[]
,   _v_asl              IN  text[]
,   _d_asl              IN  text[]
,   _ou_l1              IN  text
,   _ou_l2              IN  text
,   _ou_l3              IN  text
,   _ou_l4              IN  text
,	_c                  IN  char(2)
,	_l_1                IN  text
,	_l_2                IN  text
,   _l_3                IN  text
,	_d_1sthire	        IN  date
,	_d_con_end	        IN  date
,	_d_sa		        IN  date
,	_ad_logoncount	    IN  int
,	_ad_lastlogon	    IN  date
,	_ad_lastlogontimestamp      IN  timestamptz
,	_ad_pwdlastset	    IN  date
,	_ad_whenchanged	    IN  date
,	_ad_whencreated	    IN  date
,	_tss_logoncount	    IN  int
,	_tss_lastlogon	    IN  date
,	_tss_lastlogontimestamp     IN  timestamptz
,	_tss_pwdexpires     IN  date
,	_tss_pwdlastset     IN  date
,	_tss_whenchanged	IN  date
,	_tss_whencreated	IN  date
,	_esis_watch	        IN  boolean
,	_esis_firstlogon	IN  date
,   _esis_lastlogon     IN  date
,	_anomaly_id         IN  integer
) RETURNS integer AS $fn$
    DECLARE
        _e_user_id	integer;
	_e_asl_id	integer;
    BEGIN

        SELECT INTO _e_user_id (e_user_id) FROM mim.t_im_user WHERE user_id = _user_id;
        IF (_e_user_id IS NULL) THEN
            -- adding new user
            INSERT INTO mim.t_im_user (
                user_id, z_asl, v_asl, d_asl,
                ou_l1, ou_l2, ou_l3, ou_l4, c, l_1, l_2, l_3, 
                d_1sthire, d_con_end, d_sa, 
                ad_logoncount, ad_lastlogon, ad_lastlogontimestamp, ad_pwdlastset, ad_whenchanged, ad_whencreated,
                tss_logoncount, tss_lastlogon, tss_lastlogontimestamp, tss_pwdexpires, tss_pwdlastset, tss_whenchanged, tss_whencreated,
                esis_watch, esis_firstlogon, esis_lastlogon,
                anomaly_id
            ) VALUES (
                _user_id, _z_asl, _v_asl, _d_asl,
                _ou_l1, _ou_l2, _ou_l3, _ou_l4, _c, _l_1, _l_2, _l_3, 
                _d_1sthire, _d_con_end, _d_sa, 
                _ad_logoncount, _ad_lastlogon, _ad_lastlogontimestamp, _ad_pwdlastset, _ad_whenchanged, _ad_whencreated,
                _tss_logoncount, _tss_lastlogon, _tss_lastlogontimestamp, _tss_pwdexpires, _tss_pwdlastset, _tss_whenchanged, _tss_whencreated,
                _esis_watch, _esis_firstlogon, _esis_lastlogon,
                _anomaly_id
            );
            _e_user_id := currval('mim.t_im_user_serial');
        ELSE
            -- updating existing user (user_id doesn't change then!)
            -- Note the COALESCE() calls to ensure I don't overwrite
            -- an important field with NULL.
            UPDATE mim.t_im_user SET
                z_asl = _z_asl
            ,   v_asl = _v_asl
            ,   d_asl = _d_asl
            ,   ou_l1 = _ou_l1
            ,   ou_l2 = _ou_l2
            ,   ou_l3 = _ou_l3
            ,   ou_l4 = _ou_l4
            ,   c = _c
            ,   l_1 = _l_1
            ,   l_2 = _l_2
            ,   l_3 = _l_3
            ,   d_1sthire = COALESCE(_d_1sthire, d_1sthire)
            ,   d_con_end = COALESCE(_d_con_end, d_con_end)
            ,   d_sa = COALESCE(_d_sa, d_sa)
            ,   ad_logoncount = _ad_logoncount
            ,   ad_lastlogon = _ad_lastlogon
            ,   ad_lastlogontimestamp = _ad_lastlogontimestamp
            ,   ad_pwdlastset = _ad_pwdlastset
            ,   ad_whenchanged = _ad_whenchanged
            ,   ad_whencreated = _ad_whencreated
            ,   tss_logoncount = _tss_logoncount
            ,   tss_lastlogon = _tss_lastlogon
            ,   tss_lastlogontimestamp = _tss_lastlogontimestamp
            ,   tss_pwdexpires = _tss_pwdexpires
            ,   tss_pwdlastset = _tss_pwdlastset
            ,   tss_whenchanged = _tss_whenchanged
            ,   tss_whencreated = _tss_whencreated
            ,   esis_watch = _esis_watch
            ,   esis_firstlogon = COALESCE(_esis_firstlogon, esis_firstlogon)
            ,   esis_lastlogon = COALESCE(_esis_lastlogon, esis_lastlogon)
            ,   anomaly_id = _anomaly_id
            WHERE e_user_id = _e_user_id;
        END IF;

        RETURN _e_user_id;
    END
$fn$ LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION fn_update_im_asl_to_user () RETURNS void AS $fn$
  DECLARE
	_asl	integer;
	usr	RECORD;
	_asls	integer[];
	_found	boolean;
	_index	integer;
  BEGIN

	DELETE FROM mim.t_im_asl_to_user;

	FOR usr IN SELECT e_user_id, z_asl, v_asl, d_asl FROM mim.t_im_user LOOP
	    _asl  := NULL;
	    _asls := '{ }';
	    _index := 0;
	    IF (array_lower(usr.z_asl, 1) IS NOT NULL) THEN
		FOR i IN array_lower(usr.z_asl, 1) .. array_upper(usr.z_asl, 1) LOOP
		    SELECT INTO _asl (e_asl_id) FROM mim.t_im_asl WHERE asl_id = usr.z_asl[i];
		    IF (_asl IS NULL) THEN
		       INSERT INTO mim.t_im_asl (asl_id, level) VALUES (usr.z_asl[i], 'Z');
		       _asl := currval('mim.t_im_asl_serial');
		    END IF;
		    _found := false;
		    IF (array_lower(_asls, 1) IS NOT NULL) THEN
		        FOR i IN array_lower(_asls, 1) .. array_upper(_asls, 1) LOOP
			    IF (_asls[i] = _asl) THEN
			        _found := true;
				EXIT;
			    END IF;
			END LOOP;
		    END IF;
		    IF (NOT _found) THEN
			INSERT INTO mim.t_im_asl_to_user (e_asl_id, e_user_id) VALUES (_asl, usr.e_user_id);			
		    	_asls[_index] := _asl;
			_index := _index+1;
		    END IF;
		    _asl := NULL;
            	END LOOP;  
	    END IF;
	    IF (array_lower(usr.v_asl, 1) IS NOT NULL) THEN
		FOR i IN array_lower(usr.v_asl, 1) .. array_upper(usr.v_asl, 1) LOOP
		    SELECT INTO _asl (e_asl_id) FROM mim.t_im_asl WHERE asl_id = usr.v_asl[i];
		    IF (_asl IS NULL) THEN
		       INSERT INTO mim.t_im_asl (asl_id, level) VALUES (usr.v_asl[i], 'V');
		       _asl := currval('mim.t_im_asl_serial');
		    END IF;
		    _found := false;
		    IF (array_lower(_asls, 1) IS NOT NULL) THEN
		        FOR i IN array_lower(_asls, 1) .. array_upper(_asls, 1) LOOP
			    IF (_asls[i] = _asl) THEN
			        _found := true;
				EXIT;
			    END IF;
			END LOOP;
		    END IF;
		    IF (NOT _found) THEN
			INSERT INTO mim.t_im_asl_to_user (e_asl_id, e_user_id) VALUES (_asl, usr.e_user_id);
		    	_asls[_index] := _asl;
			_index := _index+1;
		    END IF;
		    _asl := NULL;
            	END LOOP;  
	    END IF;
	    IF (array_lower(usr.d_asl, 1) IS NOT NULL) THEN
		FOR i IN array_lower(usr.d_asl, 1) .. array_upper(usr.d_asl, 1) LOOP
		    SELECT INTO _asl (e_asl_id) FROM mim.t_im_asl WHERE asl_id = usr.d_asl[i];
		    IF (_asl IS NULL) THEN
		       INSERT INTO mim.t_im_asl (asl_id, level) VALUES (usr.d_asl[i], 'D');
		       _asl := currval('mim.t_im_asl_serial');
		    END IF;		    
		    _found := false;
		    IF (array_lower(_asls, 1) IS NOT NULL) THEN
		        FOR i IN array_lower(_asls, 1) .. array_upper(_asls, 1) LOOP
			    IF (_asls[i] = _asl) THEN
			        _found := true;
				EXIT;
			    END IF;
			END LOOP;
		    END IF;
		    IF (NOT _found) THEN
			INSERT INTO mim.t_im_asl_to_user (e_asl_id, e_user_id) VALUES (_asl, usr.e_user_id);
		    	_asls[_index] := _asl;
			_index := _index+1;
		    END IF;
		    _asl := NULL;
            	END LOOP;  
	    END IF;
	END LOOP;

  END
$fn$ LANGUAGE plpgsql VOLATILE;