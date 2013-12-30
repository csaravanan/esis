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
-- $Id: vuln_views.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--


-- ESIS Security DataWarehouse schema - install as user 'entelligence'
--
-- contains: vulnerability views


CREATE OR REPLACE VIEW	vuln.v_patch
AS	
	SELECT e_patch_id, patch_name, publish_date, url, 't_patch_sun' FROM vuln.t_patch_sun
UNION SELECT e_patch_id, patch_name, publish_date, url, 't_patch_ms' FROM vuln.t_patch_ms;