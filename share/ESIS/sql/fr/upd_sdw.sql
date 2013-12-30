UPDATE sdw.e_operation_state SET state_descr = 'Prêt' WHERE e_state_id = 0;
UPDATE sdw.e_operation_state SET state_descr = 'Démarré' WHERE e_state_id = 1;
UPDATE sdw.e_operation_state SET state_descr = 'Fini' WHERE e_state_id = 2;
UPDATE sdw.e_operation_state SET state_descr = 'Besion d''annulation' WHERE e_state_id = 3;
UPDATE sdw.e_operation_state SET state_descr = 'Annulation démarrée' WHERE e_state_id = 4;
UPDATE sdw.e_operation_state SET state_descr = 'Annulé' WHERE e_state_id = 5;
