UPDATE audit.e_audit_rec_status SET rec_status = 'Ouvert' WHERE e_audit_rec_status_id = 1;
UPDATE audit.e_audit_rec_status SET rec_status = 'Fermé' WHERE e_audit_rec_status_id = 2;
UPDATE audit.e_audit_rec_status SET rec_status = 'Risque accepté' WHERE e_audit_rec_status_id = 3;
UPDATE audit.e_audit_rec_status SET rec_status = 'Dupliqué' WHERE e_audit_rec_status_id = 4;
UPDATE audit.e_audit_severity SET severity = 'Faible' WHERE e_audit_severity_id = 1;
UPDATE audit.e_audit_severity SET severity = 'Moyenne' WHERE e_audit_severity_id = 2;
UPDATE audit.e_audit_severity SET severity = 'Elevée' WHERE e_audit_severity_id = 3;
UPDATE audit.e_audit_topic SET topic = 'Sécurité réseau' WHERE e_audit_topic_id = 1;
UPDATE audit.e_audit_topic SET topic = 'Sûrété physique' WHERE e_audit_topic_id = 2;
UPDATE audit.e_audit_topic SET topic = 'Sécurité système' WHERE e_audit_topic_id = 3;
UPDATE audit.e_audit_topic SET topic = 'Accès' WHERE e_audit_topic_id = 4;
UPDATE audit.e_audit_topic SET topic = 'Applications' WHERE e_audit_topic_id = 5;
UPDATE audit.e_audit_topic SET topic = 'Business' WHERE e_audit_topic_id = 6;
UPDATE audit.e_audit_topic SET topic = 'Autres' WHERE e_audit_topic_id = 7;
UPDATE audit.e_audit_origin SET origin = 'Audit interne' WHERE e_audit_origin_id = 1;
UPDATE audit.e_audit_origin SET origin = 'Audit externe' WHERE e_audit_origin_id = 2;
UPDATE audit.e_audit_origin SET origin = 'Régulateurs' WHERE e_audit_origin_id = 3;
UPDATE audit.e_audit_origin SET origin = 'Auto-audit' WHERE e_audit_origin_id = 4;
UPDATE audit.e_audit_action_status SET action_status = 'Planifié' WHERE e_audit_action_status_id = 1;
UPDATE audit.e_audit_action_status SET action_status = 'En cours' WHERE e_audit_action_status_id = 2;
UPDATE audit.e_audit_action_status SET action_status = 'Finalisé' WHERE e_audit_action_status_id = 3;
UPDATE audit.e_audit_action_status SET action_status = 'Annulé' WHERE e_audit_action_status_id = 4;
UPDATE audit.e_audit_action_status SET action_status = 'En pause' WHERE e_audit_action_status_id = 5;
UPDATE audit.e_audit_priority SET priority = 'Faible' WHERE e_audit_priority_id = 1;
UPDATE audit.e_audit_priority SET priority = 'Moyenne' WHERE e_audit_priority_id = 2;
UPDATE audit.e_audit_priority SET priority = 'Elevée' WHERE e_audit_priority_id = 3;
UPDATE audit.e_audit_rec_topic SET topic = 'Accès' WHERE e_audit_rec_topic_id = 1;
UPDATE audit.e_audit_rec_topic SET topic = 'Réseau' WHERE e_audit_rec_topic_id = 2;
UPDATE audit.e_audit_rec_topic SET topic = 'Locaux' WHERE e_audit_rec_topic_id = 3;
UPDATE audit.e_audit_rec_topic SET topic = 'Gestion' WHERE e_audit_rec_topic_id = 4;
UPDATE audit.e_audit_rec_topic SET topic = 'Globale' WHERE e_audit_rec_topic_id = 5;
UPDATE audit.e_audit_rec_topic SET topic = 'Veille' WHERE e_audit_rec_topic_id = 6;
UPDATE audit.e_audit_rec_topic SET topic = 'Connaissances' WHERE e_audit_rec_topic_id = 7;
UPDATE audit.e_audit_confidentiality SET confidentiality = 'Interne' WHERE e_audit_confidentiality_id = 1;
UPDATE audit.e_audit_confidentiality SET confidentiality = 'Confidentiel' WHERE e_audit_confidentiality_id = 2;
UPDATE audit.e_audit_confidentiality SET confidentiality = 'Responsable seul' WHERE e_audit_confidentiality_id = 3;
UPDATE audit.e_audit_confidentiality SET confidentiality = 'Secret d''entreprise' WHERE e_audit_confidentiality_id = 4;
UPDATE audit.e_audit_status SET status = 'Planifié' WHERE e_audit_status_id = 1;
UPDATE audit.e_audit_status SET status = 'Prestations' WHERE e_audit_status_id = 2;
UPDATE audit.e_audit_status SET status = 'Entretiens' WHERE e_audit_status_id = 3;
UPDATE audit.e_audit_status SET status = 'Réunion d''ouverture' WHERE e_audit_status_id = 4;
UPDATE audit.e_audit_status SET status = 'Premier rapport' WHERE e_audit_status_id = 5;
UPDATE audit.e_audit_status SET status = 'Rapport final' WHERE e_audit_status_id = 6;
UPDATE audit.e_audit_status SET status = 'Réunion de clôture' WHERE e_audit_status_id = 7;
UPDATE audit.e_audit_status SET status = 'Remédiation' WHERE e_audit_status_id = 8;
UPDATE audit.e_audit_status SET status = 'Fermé' WHERE e_audit_status_id = 9;
UPDATE audit.e_audit_report_status SET report_status = 'Ebauche' WHERE e_audit_report_status_id = 1;
UPDATE audit.e_audit_report_status SET report_status = 'Finalisé' WHERE e_audit_report_status_id = 2;
UPDATE audit.e_audit_report_status SET report_status = 'Approuvé' WHERE e_audit_report_status_id = 3;
UPDATE audit.e_audit_report_status SET report_status = 'Publié' WHERE e_audit_report_status_id = 4;
UPDATE audit.e_audit_document_type SET document_type = 'Preuve' WHERE e_audit_document_type_id = 1;
UPDATE audit.e_audit_document_type SET document_type = 'Information' WHERE e_audit_document_type_id = 2;
UPDATE audit.e_audit_document_type SET document_type = 'Email' WHERE e_audit_document_type_id = 3;
UPDATE audit.e_audit_document_type SET document_type = 'Document' WHERE e_audit_document_type_id = 4;