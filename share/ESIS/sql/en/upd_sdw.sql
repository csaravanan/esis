UPDATE sdw.e_operation_state SET state_descr = 'Ready' WHERE e_state_id = 0;
UPDATE sdw.e_operation_state SET state_descr = 'Started' WHERE e_state_id = 1;
UPDATE sdw.e_operation_state SET state_descr = 'Complete' WHERE e_state_id = 2;
UPDATE sdw.e_operation_state SET state_descr = 'Needs undo' WHERE e_state_id = 3;
UPDATE sdw.e_operation_state SET state_descr = 'Undo started' WHERE e_state_id = 4;
UPDATE sdw.e_operation_state SET state_descr = 'Undone' WHERE e_state_id = 5;
