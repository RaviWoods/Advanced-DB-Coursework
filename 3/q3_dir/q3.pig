RUN /vol/automed/data/uscensus1990/load_tables.pig

state_and_place =
	JOIN place BY state_code,
	state BY code;

state_with_place =
	FILTER state_and_place
	BY place::state_code IS NOT NULL;

swp_with_town_existence =
	FOREACH state_with_place
	GENERATE state::code, place::type, (state::code==1?1:0) AS t_ex;
/*
state_places =
	GROUP state_with_place
	BY state::name;

state_town =
	FOREACH state_places
	GENERATE 	group AS name,
						(state_with_place.type=="town"?1:0 AS count);



*/
-- Return (state_name,no_city,no_town,no_village), ordered by state_name
ordered_results =
	ORDER state_populations BY name ASC;

STORE ordered_results INTO 'q2' USING PigStorage ( ',' );
