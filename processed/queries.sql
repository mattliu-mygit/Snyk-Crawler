--What country has the greatest number of facilities? 
SELECT country, SUM(unit_count)
FROM Facility
GROUP BY country;