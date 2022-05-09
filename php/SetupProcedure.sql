DELIMITER //

DROP FUNCTION IF EXISTS CheckFacility //

CREATE FUNCTION CheckFacility(fac VARCHAR(50))
RETURNS INTEGER
BEGIN
      RETURN (SELECT COUNT(facility_type) FROM Facility WHERE facility_type = fac);
END; //
DROP PROCEDURE IF EXISTS ShowFacilityAvailability //

CREATE PROCEDURE ShowFacilityAvailability(IN fac varchar(50))
BEGIN
   IF CheckFacility(fac) != 0 THEN
        SELECT region,
            SUM(unit_count) * 100000 AS available_units
        FROM Country
        JOIN Facility ON Country.name = Facility.country
        WHERE Facility.facility_type = fac
        GROUP BY region;
   ELSE
       SELECT NULL as Error;
   END IF;
END; //

DELIMITER ;

DELIMITER //

DROP FUNCTION IF EXISTS CheckCountry //

CREATE FUNCTION CheckCountry(country VARCHAR(70))
RETURNS INTEGER
BEGIN
      RETURN (SELECT COUNT(name) FROM Country WHERE name = country);
END; //
DROP PROCEDURE IF EXISTS ShowCountryResourceAllocation //

CREATE PROCEDURE ShowCountryResourceAllocation(IN country varchar(70))
BEGIN
   IF CheckCountry(country) != 0 THEN
        SELECT Facility.facility_type AS facility, cost * 10000000 AS cost
        FROM Facility
        WHERE Facility.country = country
        ORDER BY cost DESC;
   ELSE
       SELECT NULL as Error;
   END IF;
END; //

DELIMITER ;

DELIMITER //

DROP FUNCTION IF EXISTS CheckNumber //

CREATE FUNCTION CheckNumber(num int)
RETURNS INTEGER
BEGIN
      RETURN (SELECT COUNT(name) FROM Country);
END; //
DROP PROCEDURE IF EXISTS ShowTopCountrySuicides //

CREATE PROCEDURE ShowTopCountrySuicides(IN num int)
BEGIN
    IF num < CheckNumber(num) THEN
        WITH popSuicide AS (
            SELECT Country.name,
                Suicide_Rates.year,
                Country.population / 100000 * Suicide_Rates.age_standardized_suicide_rates AS number_of_suicides
            FROM Country
            JOIN Suicide_Rates ON Country.name = country
            WHERE Suicide_Rates.sex = "Both sexes"
        ),
        popSuicideYearAvg AS (
            SELECT popSuicide.name AS country,
                AVG(number_of_suicides) AS average_number_of_suicides
            FROM popSuicide
            GROUP BY name
        )
        SELECT *
        FROM popSuicideYearAvg
        ORDER BY average_number_of_suicides DESC
        LIMIT num;
    ELSE
       SELECT NULL as Error;
   END IF;
END; //

DELIMITER ;