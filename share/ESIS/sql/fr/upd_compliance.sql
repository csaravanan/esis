UPDATE compliance.e_standard_category SET standard_category = 'Technologies de l''information' WHERE e_standard_category_id = 1;
UPDATE compliance.e_standard_category SET standard_category = 'Gestion globale' WHERE e_standard_category_id = 2;
UPDATE compliance.e_topic_category SET topic_category = 'Gestion de la sécurité' WHERE e_topic_category_id = 1;
UPDATE compliance.e_topic_category SET topic_category = 'Contrôle des accès' WHERE e_topic_category_id = 2;
UPDATE compliance.e_compliance_kind SET kind = 'Remarque d''application' WHERE e_compliance_kind_id = 1;
UPDATE compliance.e_compliance_kind SET kind = 'Remarque documentaire' WHERE e_compliance_kind_id = 2;
UPDATE compliance.e_compliance_type SET compliance_type = 'Non conformité mineure d''une application' WHERE e_compliance_type_id = 1;
UPDATE compliance.e_compliance_type SET compliance_type = 'Non conformité mineure documentaire' WHERE e_compliance_type_id = 2;
UPDATE compliance.e_compliance_type SET compliance_type = 'Non conformité majeure d''une application' WHERE e_compliance_type_id = 3;
UPDATE compliance.e_compliance_type SET compliance_type = 'Non conformité majeure documentaire' WHERE e_compliance_type_id = 4;
