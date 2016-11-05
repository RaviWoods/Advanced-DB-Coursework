-- Q1 returns (state_name,name)
/*
SELECT state.name AS state_name, place.name
FROM state JOIN place ON state.code = place.state_code
WHERE place.name LIKE '%City'
AND type <> 'city'
ORDER BY state_name, name ASC;
*/
-- Q2 returns (state_name,no_big_city,big_city_population)
/*
SELECT 	state.name AS state_name,
		COUNT(place.name) AS no_big_city,
		SUM(population) AS big_city_population
FROM state JOIN place ON state.code = place.state_code
WHERE type = 'city'
AND population > 100000
GROUP BY state_name
HAVING SUM(population) >= 1000000 OR COUNT(place.name) >= 5 
ORDER BY state_name
*/

-- Q3 returns (type,place,mcd,county)

SELECT 		type,
			SUM(type) AS place.
FROM 		place
GROUP BY 	type
-- Q4 returns (name,population,pc_population,land_area,pc_land_area)
/*
SELECT 		state.name AS state_name, 
		total_population.population,
		SUM(mcd.population) AS population,
		ROUND((100.0*SUM(mcd.population))/total_population.population,2) AS pc_population,
		SUM(mcd.land_area) AS land_area,
		ROUND((100.0*SUM(mcd.land_area))/total_land_area.land_area,2) AS pc_land_area
FROM		state LEFT JOIN mcd ON state.code = mcd.state_code,
		(SELECT SUM(population) AS population FROM mcd) total_population,
		(SELECT SUM(land_area) AS land_area FROM mcd) total_land_area
GROUP BY state_name, total_population.population, total_land_area.land_area
ORDER BY state_name;
*/
-- Q5 returns (state_name,county_name,population)
SELECT	state_name,

		population

FROM 	SELECT (RANK() OVER (ORDER BY population DESC) FROM 

;

-- Q6 returns (zip_code,zip_name,name,distance)

;

