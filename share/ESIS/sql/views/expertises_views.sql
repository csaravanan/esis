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
-- $Id: expertises_views.sql 11 2009-07-07 15:02:53Z tburdairon $
--
--

-- ESIS Security DataWarehouse schema - install as user 'entelligence'
--
-- contains: expertises procedures and views


DROP FUNCTION is_expert(integer, integer);
CREATE FUNCTION is_expert(e_vuln_id IN integer, people IN integer) RETURNS boolean AS $fn$
	DECLARE result boolean;
	BEGIN
		SELECT INTO result (COUNT(*)>0)
			FROM (
				SELECT DISTINCT p.e_people_id 
				FROM e_people p 
				INNER JOIN asset.e_expertise xp ON xp.e_people_id = p.e_people_id 
				LEFT JOIN asset.e_vendor v ON v.e_vendor_id = xp.e_vendor_id 
				LEFT JOIN asset.e_product pr ON pr.e_product_id = xp.e_product_id 
				LEFT JOIN vuln.e_vulnerability_vpv vpv ON (vpv.e_vendor_id = v.e_vendor_id OR vpv.e_product_id = pr.e_product_id) 
				WHERE vpv.e_vulnerability_id = e_vuln_id 
			UNION 
				SELECT DISTINCT p.e_people_id 
				FROM e_company_group gr 
				LEFT JOIN e_group_to_people gtp ON gtp.e_group_id = gr.e_group_id 
				LEFT JOIN e_people p ON p.e_people_id = gtp.e_people_id 
				INNER JOIN asset.e_expertise xp ON xp.e_group_id = gr.e_group_id 
				LEFT JOIN asset.e_vendor v ON v.e_vendor_id = xp.e_vendor_id 
				LEFT JOIN asset.e_product pr ON pr.e_product_id = xp.e_product_id 
				LEFT JOIN vuln.e_vulnerability_vpv vpv ON (vpv.e_vendor_id = v.e_vendor_id OR vpv.e_product_id = pr.e_product_id) 
			WHERE vpv.e_vulnerability_id = e_vuln_id) 
			AS experts
		WHERE e_people_id = people;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;

DROP FUNCTION is_group_expert(integer, integer);
CREATE FUNCTION is_group_expert(e_vuln_id IN integer, group_id IN integer) RETURNS boolean AS $fn$
	DECLARE result boolean;
	BEGIN
		SELECT INTO result COUNT(DISTINCT xp.e_group_id)>0
			FROM asset.e_expertise xp
			LEFT JOIN asset.e_vendor v ON v.e_vendor_id = xp.e_vendor_id 
			LEFT JOIN asset.e_product pr ON pr.e_product_id = xp.e_product_id 
			LEFT JOIN vuln.e_vulnerability_vpv vpv ON (vpv.e_vendor_id = v.e_vendor_id OR vpv.e_product_id = pr.e_product_id) 
			WHERE vpv.e_vulnerability_id = e_vuln_id
			AND e_group_id = group_id;
		return result;
	END
$fn$ LANGUAGE plpgsql STABLE STRICT;



CREATE OR REPLACE VIEW v_vulnerability_xps_votes
(e_vulnerability_id, direct_experts, indirect_experts, users_experts, groups_experts, direct_voters, indirect_voters, users_votes, groups_votes)
AS
SELECT ev.e_vulnerability_id,
ARRAY
(
   SELECT
   DISTINCT xp.e_people_id
   FROM asset.e_expertise xp
   LEFT JOIN asset.e_vendor v ON v.e_vendor_id = xp.e_vendor_id 
   LEFT JOIN asset.e_product pr ON pr.e_product_id = xp.e_product_id 
   LEFT JOIN vuln.e_vulnerability_vpv vpv ON (vpv.e_vendor_id = v.e_vendor_id OR vpv.e_product_id = pr.e_product_id)
   WHERE ev.e_vulnerability_id = vpv.e_vulnerability_id AND xp.e_people_id IS NOT NULL
   ORDER BY 1
) AS direct_experts,
ARRAY
(
   SELECT
   DISTINCT gtp.e_people_id
   FROM e_group_to_people gtp 
   INNER JOIN asset.e_expertise xp ON xp.e_group_id = gtp.e_group_id
   LEFT JOIN asset.e_vendor v ON v.e_vendor_id = xp.e_vendor_id 
   LEFT JOIN asset.e_product pr ON pr.e_product_id = xp.e_product_id 
   LEFT JOIN vuln.e_vulnerability_vpv vpv ON (vpv.e_vendor_id = v.e_vendor_id OR vpv.e_product_id = pr.e_product_id)
   WHERE ev.e_vulnerability_id = vpv.e_vulnerability_id AND xp.e_group_id IS NOT NULL
   ORDER BY 1
) AS indirect_experts,
ARRAY(
   SELECT
   DISTINCT xp.e_people_id
   FROM asset.e_expertise xp
   LEFT JOIN asset.e_vendor v ON v.e_vendor_id = xp.e_vendor_id 
   LEFT JOIN asset.e_product pr ON pr.e_product_id = xp.e_product_id 
   LEFT JOIN vuln.e_vulnerability_vpv vpv ON (vpv.e_vendor_id = v.e_vendor_id OR vpv.e_product_id = pr.e_product_id)
   WHERE ev.e_vulnerability_id = vpv.e_vulnerability_id AND xp.e_people_id IS NOT NULL
   UNION ALL
   SELECT
   DISTINCT gtp.e_people_id
   FROM e_group_to_people gtp 
   INNER JOIN asset.e_expertise xp ON xp.e_group_id = gtp.e_group_id
   LEFT JOIN asset.e_vendor v ON v.e_vendor_id = xp.e_vendor_id 
   LEFT JOIN asset.e_product pr ON pr.e_product_id = xp.e_product_id 
   LEFT JOIN vuln.e_vulnerability_vpv vpv ON (vpv.e_vendor_id = v.e_vendor_id OR vpv.e_product_id = pr.e_product_id)
   WHERE ev.e_vulnerability_id = vpv.e_vulnerability_id AND xp.e_group_id IS NOT NULL
   ORDER BY 1
) AS users_experts,
ARRAY
(
   SELECT
   DISTINCT xp.e_group_id
   FROM asset.e_expertise xp 
   LEFT JOIN asset.e_vendor v ON v.e_vendor_id = xp.e_vendor_id 
   LEFT JOIN asset.e_product pr ON pr.e_product_id = xp.e_product_id 
   LEFT JOIN vuln.e_vulnerability_vpv vpv ON (vpv.e_vendor_id = v.e_vendor_id OR vpv.e_product_id = pr.e_product_id)
   WHERE ev.e_vulnerability_id = vpv.e_vulnerability_id AND xp.e_group_id IS NOT NULL
   ORDER BY 1
) AS groups_experts,
ARRAY
(
   SELECT DISTINCT
   vo.e_people_id
   FROM vuln.e_vote vo
   WHERE ev.e_vulnerability_id = vo.e_vulnerability_id AND vo.e_people_id IS NOT NULL
   ORDER BY 1
) AS direct_voters,
ARRAY
(
   SELECT DISTINCT
   gtp.e_people_id
   FROM e_group_to_people gtp
   INNER JOIN vuln.e_vote vo ON vo.e_group_id = gtp.e_group_id
   WHERE ev.e_vulnerability_id = vo.e_vulnerability_id AND vo.e_group_id IS NOT NULL
   ORDER BY 1
) AS indirect_voters,
ARRAY
(
   SELECT DISTINCT
   vo.e_people_id
   FROM vuln.e_vote vo
   WHERE ev.e_vulnerability_id = vo.e_vulnerability_id AND vo.e_people_id IS NOT NULL
   UNION ALL
   SELECT DISTINCT
   gtp.e_people_id
   FROM e_group_to_people gtp
   INNER JOIN vuln.e_vote vo ON vo.e_group_id = gtp.e_group_id
   WHERE ev.e_vulnerability_id = vo.e_vulnerability_id AND vo.e_group_id IS NOT NULL
   ORDER BY 1
) AS users_votes,
ARRAY
(
   SELECT DISTINCT
   vo.e_group_id
   FROM vuln.e_vote vo
   WHERE ev.e_vulnerability_id = vo.e_vulnerability_id AND vo.e_group_id IS NOT NULL
   ORDER BY 1
) AS groups_votes
FROM vuln.e_vulnerability ev;