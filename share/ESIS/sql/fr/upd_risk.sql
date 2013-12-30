UPDATE risk.e_category SET category_name = 'Maladies' WHERE e_category_id = 1;
UPDATE risk.e_category SET category_name = 'Economique' WHERE e_category_id = 2;
UPDATE risk.e_category SET category_name = 'Environnemental' WHERE e_category_id = 3;
UPDATE risk.e_category SET category_name = 'Financier' WHERE e_category_id = 4;
UPDATE risk.e_category SET category_name = 'Humain' WHERE e_category_id = 5;
UPDATE risk.e_category SET category_name = 'Naturel' WHERE e_category_id = 6;
UPDATE risk.e_category SET category_name = 'Santé' WHERE e_category_id = 7;
UPDATE risk.e_category SET category_name = 'Responsabilité produit' WHERE e_category_id = 8;
UPDATE risk.e_category SET category_name = 'Responsabilité professionnelle' WHERE e_category_id = 9;
UPDATE risk.e_category SET category_name = 'Dégâts matériels' WHERE e_category_id = 10;
UPDATE risk.e_category SET category_name = 'Responsabilité publique' WHERE e_category_id = 11;
UPDATE risk.e_category SET category_name = 'Sécurité' WHERE e_category_id = 12;
UPDATE risk.e_category SET category_name = 'Technologique' WHERE e_category_id = 13;
UPDATE risk.e_risk_decision SET decision = 'Réduction' WHERE e_risk_decision_id = 1;
UPDATE risk.e_risk_decision SET decision = 'Atténuation' WHERE e_risk_decision_id = 2;
UPDATE risk.e_risk_decision SET decision = 'Eviter' WHERE e_risk_decision_id = 3;
UPDATE risk.e_risk_decision SET decision = 'Transfert' WHERE e_risk_decision_id = 4;
UPDATE risk.e_risk_priority SET priority = 'Mineur' WHERE e_risk_priority_id = 1;
UPDATE risk.e_risk_priority SET priority = 'Faible' WHERE e_risk_priority_id = 2;
UPDATE risk.e_risk_priority SET priority = 'Normal' WHERE e_risk_priority_id = 3;
UPDATE risk.e_risk_priority SET priority = 'Important' WHERE e_risk_priority_id = 4;
UPDATE risk.e_risk_priority SET priority = 'Urgent' WHERE e_risk_priority_id = 5;
UPDATE risk.e_risk_priority SET priority = 'Critique' WHERE e_risk_priority_id = 6;
UPDATE risk.e_risk_level SET level = 'Faible' WHERE e_risk_level_id = 1;
UPDATE risk.e_risk_level SET level = 'Moyen' WHERE e_risk_level_id = 2;
UPDATE risk.e_risk_level SET level = 'Significatif' WHERE e_risk_level_id = 3;
UPDATE risk.e_risk_level SET level = 'Elevé' WHERE e_risk_level_id = 4;
UPDATE risk.e_action_status SET action_status = 'Planifié' WHERE e_action_status_id = 1;
UPDATE risk.e_action_status SET action_status = 'En cours' WHERE e_action_status_id = 2;
UPDATE risk.e_action_status SET action_status = 'Finalisé' WHERE e_action_status_id = 3;
UPDATE risk.e_action_status SET action_status = 'Annulé' WHERE e_action_status_id = 4;
UPDATE risk.e_action_status SET action_status = 'En pause' WHERE e_action_status_id = 5;