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
-- $Id: business_views.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--

-- ESIS Security DataWarehouse schema - install as user 'entelligence'
--
-- contains: organisations views


CREATE OR REPLACE VIEW v_organisation AS
SELECT o.e_organisation_id, l.e_location_id AS id, l.location_name AS name, 1 AS type 
FROM e_location l 
INNER JOIN e_organisation o ON o.e_location_id = l.e_location_id 
UNION 
SELECT o.e_organisation_id, z.e_business_zone_id, z.name, 2 
FROM e_business_zone z 
INNER JOIN e_organisation o ON o.e_business_zone_id = z.e_business_zone_id 
UNION SELECT o.e_organisation_id, g.e_group_id, g.group_name, 3 
FROM e_company_group g 
INNER JOIN e_organisation o ON o.e_department_id = g.e_group_id;


--
-- basically, it's a simple UNION between e_company_group AND e_global_group
-- but when groups are moved from 1 db to another (2 concurrent transactions), the same group id can be found in both tables,
--  because the delete from 1 table hasn't been yet commited
-- this way we keep only the row that has its creation_date at latest
--
CREATE OR REPLACE VIEW v_group AS
SELECT e_group_id, group_name, description, creation_date, e_company_id, is_company_dept, mother_group_id
FROM e_company_group c WHERE (e_group_id, creation_date) IN(
SELECT e_group_id, MAX(creation_date) AS creation_date FROM (
SELECT e_group_id, creation_date
FROM e_company_group
UNION 
SELECT e_group_id, creation_date
FROM e_global_group) AS tmp GROUP BY e_group_id)
UNION
SELECT e_group_id, group_name, description, creation_date, null, false, mother_group_id
FROM e_global_group g WHERE (e_group_id, creation_date) IN(
SELECT e_group_id, MAX(creation_date) AS creation_date FROM (
SELECT e_group_id, creation_date
FROM e_company_group
UNION 
SELECT e_group_id, creation_date
FROM e_global_group) AS tmp GROUP BY e_group_id);

--
--view to see location + their aliases
--
CREATE OR REPLACE VIEW v_location AS
SELECT l.e_location_id, l.location_name, l.e_company_id
FROM e_location l
UNION 
SELECT a.e_location_id, a.alias_name, l.e_company_id
FROM e_location_alias a INNER JOIN e_location l ON l.e_location_id = a.e_location_id;