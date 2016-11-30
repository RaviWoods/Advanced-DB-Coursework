RUN /vol/automed/data/uscensus1990/load_tables.pig

state_and_place =
	JOIN place BY state_code,
	state BY code;

state_with_place =
	FILTER state_and_place
	BY place::state_code IS NOT NULL;

swp_with_town_existence =
	FOREACH state_with_place
	GENERATE *, (place::type=='town'?1:0) AS town_ex;

stuff = FILTER swp_with_town_existence BY state::abbr=='MP';

state_places =
	GROUP swp_with_town_existence
	BY state::name;

state_town =
	FOREACH state_places
	GENERATE 	group AS state_name,
						SUM(swp_with_town_existence.town_ex) AS no_town;



-- Return (state_name,no_city,no_town,no_village), ordered by state_name
ordered_results =
	ORDER state_populations BY name ASC;

STORE ordered_results INTO 'q2' USING PigStorage ( ',' );
