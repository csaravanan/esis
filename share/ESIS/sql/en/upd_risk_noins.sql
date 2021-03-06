UPDATE risk.e_likelihood SET name = 'Rare' WHERE e_likelihood_id = 1;
UPDATE risk.e_likelihood SET name = 'Unlikely' WHERE e_likelihood_id = 2;
UPDATE risk.e_likelihood SET name = 'Moderate' WHERE e_likelihood_id = 3;
UPDATE risk.e_likelihood SET name = 'Likely' WHERE e_likelihood_id = 4;
UPDATE risk.e_likelihood SET name = 'Certain' WHERE e_likelihood_id = 5;
UPDATE risk.e_likelihood SET description = 'The event may only occur in exceptional circumstances' WHERE e_likelihood_id = 1;
UPDATE risk.e_likelihood SET description = 'The event could occur at some time' WHERE e_likelihood_id = 2;
UPDATE risk.e_likelihood SET description = 'the event will probably occur at some time' WHERE e_likelihood_id = 3;
UPDATE risk.e_likelihood SET description = 'The event will probably occur in most circumstances' WHERE e_likelihood_id = 4;
UPDATE risk.e_likelihood SET description = 'The event is expected to occur in most circumstances' WHERE e_likelihood_id = 5;
UPDATE risk.e_consequence_level SET label = 'Insignificant' WHERE e_consequence_level_id = 1;
UPDATE risk.e_consequence_level SET label = 'Minor' WHERE e_consequence_level_id = 2;
UPDATE risk.e_consequence_level SET label = 'Moderate' WHERE e_consequence_level_id = 3;
UPDATE risk.e_consequence_level SET label = 'Major' WHERE e_consequence_level_id = 4;
UPDATE risk.e_consequence_level SET label = 'Catastrophic' WHERE e_consequence_level_id = 5;
UPDATE risk.e_consequence_level SET label = 'Insignificant' WHERE e_consequence_level_id = 11;
UPDATE risk.e_consequence_level SET label = 'Minor' WHERE e_consequence_level_id = 12;
UPDATE risk.e_consequence_level SET label = 'Moderate' WHERE e_consequence_level_id = 13;
UPDATE risk.e_consequence_level SET label = 'Major' WHERE e_consequence_level_id = 14;
UPDATE risk.e_consequence_level SET label = 'Outstanding' WHERE e_consequence_level_id = 15;
UPDATE risk.e_consequence_level SET description = 'No injuries, low financial loss' WHERE e_consequence_level_id = 1;
UPDATE risk.e_consequence_level SET description = 'First aid treatment, medium financial loss' WHERE e_consequence_level_id = 2;
UPDATE risk.e_consequence_level SET description = 'Treatment required, high financial loss' WHERE e_consequence_level_id = 3;
UPDATE risk.e_consequence_level SET description = 'Extensive injuries, major financial loss' WHERE e_consequence_level_id = 4;
UPDATE risk.e_consequence_level SET description = 'Death, huge financial loss' WHERE e_consequence_level_id = 5;
UPDATE risk.e_consequence_level SET description = 'Small benefit, low financial gain' WHERE e_consequence_level_id = 11;
UPDATE risk.e_consequence_level SET description = 'Minor improvement, some financial gain' WHERE e_consequence_level_id = 12;
UPDATE risk.e_consequence_level SET description = 'Some enhancements, high financial gain' WHERE e_consequence_level_id = 13;
UPDATE risk.e_consequence_level SET description = 'Great enhancements, major financial gain' WHERE e_consequence_level_id = 14;
UPDATE risk.e_consequence_level SET description = 'Significantly enhanced reputation, huge financial gain' WHERE e_consequence_level_id = 15;
