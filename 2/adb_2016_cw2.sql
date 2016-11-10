-- Q1 returns (state_name,name)

SELECT state.name AS state_name, place.name AS name
FROM state JOIN place ON state.code = place.state_code
WHERE place.name LIKE '%City'
AND type <> 'city'
ORDER BY state.name, name ASC;


-- Q2 returns (state_name,no_big_city,big_city_population)

SELECT 	state.name AS state_name,
		COUNT(place.name) AS no_big_city,
		SUM(population) AS big_city_population
FROM state JOIN place ON state.code = place.state_code
WHERE type = 'city'
AND population > 100000
GROUP BY state.name
HAVING SUM(population) >= 1000000 OR COUNT(place.name) >= 5
ORDER BY state.name;



-- Q3 returns (type,place,mcd,county)

WITH all_types(type,name) AS
		(SELECT type, 'place' AS name
		FROM place
		WHERE type IS NOT NULL
		UNION ALL
		SELECT type, 'mcd' AS name
		FROM mcd
		WHERE type IS NOT NULL
		UNION ALL
		SELECT type, 'county' AS name
		FROM county
		WHERE type IS NOT NULL)
SELECT	all_types.type AS type,
		SUM(CASE WHEN all_types.name = 'place' THEN 1 ELSE 0 END) AS place,
		SUM(CASE WHEN all_types.name = 'mcd' THEN 1 ELSE 0 END) AS mcd,
		SUM(CASE WHEN all_types.name = 'county' THEN 1 ELSE 0 END) AS county
FROM 	all_types
GROUP BY 	all_types.type
ORDER BY 	all_types.type;

-- Q4 returns (name,population,pc_population,land_area,pc_land_area)

SELECT 	state.name AS name,
		CAST(SUM(mcd.population) AS BIGINT) AS population,
		ROUND(100.0*SUM(mcd.population)/total_population.population,2) AS pc_population,
		CAST(SUM(mcd.land_area) AS BIGINT) AS land_area,
		ROUND(100.0*SUM(mcd.land_area)/total_land_area.land_area,2) AS pc_land_area
FROM		state LEFT JOIN mcd ON state.code = mcd.state_code,
		(SELECT SUM(population) AS population FROM mcd) total_population,
		(SELECT SUM(land_area) AS land_area FROM mcd) total_land_area
GROUP BY state.name, total_population.population, total_land_area.land_area
ORDER BY state.name;

-- Q5 returns (state_name,county_name,population)

SELECT ranked_counties.state_name AS state_name, ranked_counties.county_name AS county_name, ranked_counties.population AS population
FROM (
  SELECT  state.name AS state_name,
          county.name AS county_name,
          population,
          RANK( ) OVER
            (PARTITION BY state.name ORDER BY population DESC) AS rank
  FROM    state JOIN county ON state.code = county.state_code
) AS ranked_counties
WHERE ranked_counties.rank <= 5
ORDER BY ranked_counties.state_name ASC, ranked_counties.population DESC;

-- Q6 returns (zip_code,zip_name,name,distance)
SELECT ranked.zip_code AS zip_code, ranked.zip_name AS zip_name, ranked.name AS name, ROUND(CAST(ranked.distance AS NUMERIC),2) AS distance
FROM (
	SELECT distances.zip_code AS zip_code, distances.zip_name AS zip_name, distances.name AS name, distances.distance AS distance, RANK() OVER (PARTITION BY distances.name, distances.place_lat,distances.place_long ORDER BY distances.distance ASC) AS rank
	FROM(	SELECT zip_code, zip_name, name, place.latitude AS place_lat, place.longitude AS place_long, (3959 * acos((sin(radians(zip.latitude))*sin(radians(place.latitude))) + (cos(radians(zip.latitude))*cos(radians(place.latitude))*cos(radians(place.longitude-zip.longitude))))) as distance

		FROM zip JOIN place ON zip.state_code = place.state_code
		WHERE zip.state_code = 6) AS distances
	WHERE distances.distance <=5 ) AS ranked
WHERE ranked.rank = 1
ORDER BY zip_code;
