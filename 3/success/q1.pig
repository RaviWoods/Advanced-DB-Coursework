
RUN /vol/automed/data/uscensus1990/load_tables.pig

state_and_county =
	JOIN state BY code LEFT,
	county BY state_code;

state_without_county =
	FILTER state_and_county
	BY county::state_code IS NULL;

state_name_without_county =
	FOREACH state_without_county
	GENERATE state::name;

ordered_results =
	ORDER state_name_without_county BY state::name ASC;

STORE state_name_without_county INTO 'q1' USING PigStorage ( ',' );
