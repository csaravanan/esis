UPDATE itops.t_alert_severity SET severity_name = 'Information' WHERE t_alert_severity_id = 1;
UPDATE itops.t_alert_severity SET severity_name = 'Avertissement' WHERE t_alert_severity_id = 2;
UPDATE itops.t_alert_severity SET severity_name = 'Critique' WHERE t_alert_severity_id = 3;
UPDATE itops.t_alert_priority SET priority_name = 'Bas' WHERE t_alert_priority_id = 1;
UPDATE itops.t_alert_priority SET priority_name = 'Moyen' WHERE t_alert_priority_id = 2;
UPDATE itops.t_alert_priority SET priority_name = 'Haut' WHERE t_alert_priority_id = 3;
UPDATE itops.t_event_level SET event_level = 'Succès' WHERE t_event_level_id = 1;
UPDATE itops.t_event_level SET event_level = 'Erreur' WHERE t_event_level_id = 2;
UPDATE itops.t_event_level SET event_level = 'Avertissement' WHERE t_event_level_id = 3;
UPDATE itops.t_event_level SET event_level = 'Information' WHERE t_event_level_id = 4;
UPDATE itops.t_event_level SET event_level = 'Succès de l''audit' WHERE t_event_level_id = 5;
UPDATE itops.t_event_level SET event_level = 'Echec de l''audit' WHERE t_event_level_id = 6;