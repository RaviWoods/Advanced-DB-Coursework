RUN /vol/automed/data/uscensus1990/load_tables.pig

state_and_place =
	JOIN place BY state_code,
	state BY code;

state_with_place =
	FILTER state_and_place
	BY place::state_code IS NOT NULL;

swp_with_existences =
	FOREACH state_with_place
	GENERATE *,
	(place::type=='city'?1:0) AS city_ex,
	(place::type=='town'?1:0) AS town_ex,
	(place::type=='village'?1:0) AS village_ex;

state_places =
	GROUP swp_with_existences
	BY state::name;

states_and_counts =
	FOREACH state_places
	GENERATE 	group AS state_name,
						SUM(swp_with_existences.city_ex) AS no_city,
						SUM(swp_with_existences.town_ex) AS no_town,
						SUM(swp_with_existences.village_ex) AS no_village;

ordered_results =
	ORDER states_and_counts BY state_name ASC;

STORE ordered_results INTO 'q3' USING PigStorage ( ',' );
