RUN /vol/automed/data/uscensus1990/load_tables.pig

county_density =
	FOREACH county
	GENERATE state_code ,
		name AS county_name ,
		ROUND(10.0* population / land_area )/10.0 AS density;


high_density_county =
	FILTER county_density
	BY density >1.0;


state_and_county =
	JOIN state BY code LEFT OUTER,
		high_density_county BY state_code ;

state_and_county_projected =
	FOREACH state_and_county
	GENERATE 	name AS state_name ,
				county_name ,
				density ;

state_and county_ordered =
	ORDER state_and_county_projected
	BY 	state_name ,
		county name ;

STORE state_and_county_ordered INTO ’q0 ’ USING PigStorage ( ’ , ’ );