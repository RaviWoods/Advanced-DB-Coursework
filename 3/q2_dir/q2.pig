RUN /vol/automed/data/uscensus1990/load_tables.pig

county_and_place =
	JOIN county BY state_code,
	place BY state_code;

state_counties_and_places = 
	GROUP county_and_place
	BY place::state_code;

state_codes_with_population = 
	FOREACH state_counties_and_places
	GENERATE place::state_code,
				SUM()

-- NO PLACES NEEDED
STORE state_name_without_county INTO 'q1' USING PigStorage ( ',' );
