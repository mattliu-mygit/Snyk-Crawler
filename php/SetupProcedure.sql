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