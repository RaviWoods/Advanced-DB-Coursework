-- Q1 returns (state_name,name)
SELECT state.name AS state_name, place.name
FROM state JOIN place ON state.code = place.state_code
WHERE place.name LIKE '%City'
AND type <> 'city';

-- Q2 returns (state_name,no_big_city,big_city_population)

;

-- Q3 returns (type,place,mcd,county)

; 

-- Q4 returns (name,population,pc_population,land_area,pc_land_area)

;

-- Q5 returns (state_name,county_name,population)

;

-- Q6 returns (zip_code,zip_name,name,distance)

;

