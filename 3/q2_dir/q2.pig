RUN /vol/automed/data/uscensus1990/load_tables.pig

state_and_county =
	JOIN county BY state_code,
	state BY code;

state_with_county =
	FILTER state_and_county
	BY county::state_code IS NOT NULL;

state_counties =
	GROUP state_with_county
	BY state::name;

state_populations =
	FOREACH state_counties
	GENERATE group AS name,
					SUM(state_with_county.population) AS population,
					SUM(state_with_county.land_area) AS land_area;

STORE state_names_with_county INTO 'q2' USING PigStorage ( ',' );
