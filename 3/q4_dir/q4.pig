RUN /vol/automed/data/uscensus1990/load_tables.pig

state_and_place =
	JOIN place BY state_code,
	state BY code;

sp_just_cities =
	FILTER state_and_place
	BY place::type=='city';

state_cities = 
	GROUP sp_just_cities
	BY state::name;

state_cities_top5 = 
	FOREACH state_cities {
		ordered_cities = ORDER sp_just_cities BY place::population DESC;
		top5_cities = LIMIT ordered_cities 5;
		GENERATE FLATTEN(top5_cities);
	};

unordered_results = 
	FOREACH state_cities_top5
	GENERATE state::name AS state_name, place::name AS city, place::population;

ordered_results =
	ORDER unordered_results BY state_name ASC, population DESC;

STORE ordered_results INTO 'q4' USING PigStorage ( ',' );
