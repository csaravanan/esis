INSERT INTO audit.e_audit_rec_status (e_audit_rec_status_id, rec_status) VALUES (1, 'Ouvert');
INSERT INTO audit.e_audit_rec_status (e_audit_rec_status_id, rec_status) VALUES (2, 'Fermé');
INSERT INTO audit.e_audit_rec_status (e_audit_rec_status_id, rec_status) VALUES (3, 'Risque accepté');
INSERT INTO audit.e_audit_rec_status (e_audit_rec_status_id, rec_status) VALUES (4, 'Dupliqué');
INSERT INTO audit.e_audit_severity (e_audit_severity_id, severity) VALUES (1, 'Faible');
INSERT INTO audit.e_audit_severity (e_audit_severity_id, severity) VALUES (2, 'Moyenne');
INSERT INTO audit.e_audit_severity (e_audit_severity_id, severity) VALUES (3, 'Elevée');
INSERT INTO audit.e_audit_topic (e_audit_topic_id, topic) VALUES (1, 'Sécurité réseau');
INSERT INTO audit.e_audit_topic (e_audit_topic_id, topic) VALUES (2, 'Sûrété physique');
INSERT INTO audit.e_audit_topic (e_audit_topic_id, topic) VALUES (3, 'Sécurité système');
INSERT INTO audit.e_audit_topic (e_audit_topic_id, topic) VALUES (4, 'Accès');
INSERT INTO audit.e_audit_topic (e_audit_topic_id, topic) VALUES (5, 'Applications');
INSERT INTO audit.e_audit_topic (e_audit_topic_id, topic) VALUES (6, 'Business');
INSERT INTO audit.e_audit_topic (e_audit_topic_id, topic) VALUES (7, 'Autres');
INSERT INTO audit.e_audit_origin (e_audit_origin_id, origin) VALUES (1, 'Audit interne');
INSERT INTO audit.e_audit_origin (e_audit_origin_id, origin) VALUES (2, 'Audit externe');
INSERT INTO audit.e_audit_origin (e_audit_origin_id, origin) VALUES (3, 'Régulateurs');
INSERT INTO audit.e_audit_origin (e_audit_origin_id, origin) VALUES (4, 'Auto-audit');
INSERT INTO audit.e_audit_action_status (e_audit_action_status_id, action_status) VALUES (1, 'Planifié');
INSERT INTO audit.e_audit_action_status (e_audit_action_status_id, action_status) VALUES (2, 'En cours');
INSERT INTO audit.e_audit_action_status (e_audit_action_status_id, action_status) VALUES (3, 'Finalisé');
INSERT INTO audit.e_audit_action_status (e_audit_action_status_id, action_status) VALUES (4, 'Annulé');
INSERT INTO audit.e_audit_action_status (e_audit_action_status_id, action_status) VALUES (5, 'En pause');
INSERT INTO audit.e_audit_priority (e_audit_priority_id, priority) VALUES (1, 'Faible');
INSERT INTO audit.e_audit_priority (e_audit_priority_id, priority) VALUES (2, 'Moyenne');
INSERT INTO audit.e_audit_priority (e_audit_priority_id, priority) VALUES (3, 'Elevée');
INSERT INTO audit.e_audit_rec_topic (e_audit_rec_topic_id, topic) VALUES (1, 'Accès');
INSERT INTO audit.e_audit_rec_topic (e_audit_rec_topic_id, topic) VALUES (2, 'Réseau');
INSERT INTO audit.e_audit_rec_topic (e_audit_rec_topic_id, topic) VALUES (3, 'Locaux');
INSERT INTO audit.e_audit_rec_topic (e_audit_rec_topic_id, topic) VALUES (4, 'Gestion');
INSERT INTO audit.e_audit_rec_topic (e_audit_rec_topic_id, topic) VALUES (5, 'Globale');
INSERT INTO audit.e_audit_rec_topic (e_audit_rec_topic_id, topic) VALUES (6, 'Veille');
INSERT INTO audit.e_audit_rec_topic (e_audit_rec_topic_id, topic) VALUES (7, 'Connaissances');
INSERT INTO audit.e_audit_confidentiality (e_audit_confidentiality_id, confidentiality) VALUES (1, 'Interne');
INSERT INTO audit.e_audit_confidentiality (e_audit_confidentiality_id, confidentiality) VALUES (2, 'Confidentiel');
INSERT INTO audit.e_audit_confidentiality (e_audit_confidentiality_id, confidentiality) VALUES (3, 'Responsable seul');
INSERT INTO audit.e_audit_confidentiality (e_audit_confidentiality_id, confidentiality) VALUES (4, 'Secret d''entreprise');
INSERT INTO audit.e_audit_status (e_audit_status_id, status) VALUES (1, 'Planifié');
INSERT INTO audit.e_audit_status (e_audit_status_id, status) VALUES (2, 'Prestations');
INSERT INTO audit.e_audit_status (e_audit_status_id, status) VALUES (3, 'Entretiens');
INSERT INTO audit.e_audit_status (e_audit_status_id, status) VALUES (4, 'Réunion d''ouverture');
INSERT INTO audit.e_audit_status (e_audit_status_id, status) VALUES (5, 'Premier rapport');
INSERT INTO audit.e_audit_status (e_audit_status_id, status) VALUES (6, 'Rapport final');
INSERT INTO audit.e_audit_status (e_audit_status_id, status) VALUES (7, 'Réunion de clôture');
INSERT INTO audit.e_audit_status (e_audit_status_id, status) VALUES (8, 'Remédiation');
INSERT INTO audit.e_audit_status (e_audit_status_id, status) VALUES (9, 'Fermé');
INSERT INTO audit.e_audit_report_status (e_audit_report_status_id, report_status) VALUES (1, 'Ebauche');
INSERT INTO audit.e_audit_report_status (e_audit_report_status_id, report_status) VALUES (2, 'Finalisé');
INSERT INTO audit.e_audit_report_status (e_audit_report_status_id, report_status) VALUES (3, 'Approuvé');
INSERT INTO audit.e_audit_report_status (e_audit_report_status_id, report_status) VALUES (4, 'Publié');
INSERT INTO audit.e_audit_document_type (e_audit_document_type_id, document_type) VALUES (1, 'Preuve');
INSERT INTO audit.e_audit_document_type (e_audit_document_type_id, document_type) VALUES (2, 'Information');
INSERT INTO audit.e_audit_document_type (e_audit_document_type_id, document_type) VALUES (3, 'Email');
INSERT INTO audit.e_audit_document_type (e_audit_document_type_id, document_type) VALUES (4, 'Document');