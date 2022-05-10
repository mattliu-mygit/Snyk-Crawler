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

CREATE FUNCTION CheckNumber()
RETURNS INTEGER
BEGIN
      RETURN (SELECT COUNT(name) FROM Country);
END; //
DROP PROCEDURE IF EXISTS ShowTopCountrySuicides //

CREATE PROCEDURE ShowTopCountrySuicides(IN num int)
BEGIN
    IF num < CheckNumber() THEN
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

DELIMITER //

DROP PROCEDURE IF EXISTS ShowPatientRehabilitation //

CREATE PROCEDURE ShowPatientRehabilitation(IN country varchar(70))
BEGIN
   IF CheckCountry(country) != 0 THEN
        WITH rehabilitation AS (
        SELECT rehabilitation_count / diagnoses_count * 100 AS percentage_rehabilitated, diagnoses_count * 100000 AS total_patients
        FROM General_Hospital
            JOIN Patient_Ledger ON General_Hospital.country = Patient_Ledger.country
        WHERE Patient_Ledger.facility_type = "mental health unit" AND General_Hospital.country = country)
        SELECT percentage_rehabilitated, 100 - percentage_rehabilitated AS percentage_not_rehabilitated, total_patients
        FROM rehabilitation;
    ELSE
       SELECT NULL as Error;
   END IF;
END; //

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS ShowPercentageDiagnoses //

CREATE PROCEDURE ShowPercentageDiagnoses(IN country varchar(70))
BEGIN
    IF CheckCountry(country) != 0 THEN
        WITH diagnoses AS(
        SELECT ptsd_count / diagnoses_count * 100 AS percentage_ptsd,
               Insanity_count / diagnoses_count * 100 AS percentage_insanity,
               depression_count / diagnoses_count * 100 AS percentage_depression,
               diagnoses_count * 90000 as total_patients
        FROM Patient_Ledger
            JOIN Mental_Hospital ON Patient_Ledger.country = Mental_Hospital.country
        WHERE Patient_Ledger.facility_type = "mental hospital" AND Mental_Hospital.country = country)
        SELECT percentage_ptsd, percentage_insanity, percentage_depression, 100 - percentage_depression - percentage_insanity - percentage_insanity AS percentage_other, total_patients
        FROM diagnoses;
    ELSE
       SELECT NULL as Error;
    END IF;
END; //

DELIMITER ;

DELIMITER //

DROP FUNCTION IF EXISTS CheckYear //

CREATE FUNCTION CheckYear(day int)
RETURNS INTEGER
BEGIN
      RETURN (SELECT COUNT(year) FROM Suicide_Rates WHERE year = day);
END; //

DROP PROCEDURE IF EXISTS ShowMaleFemaleSuicideRates //

CREATE PROCEDURE ShowMaleFemaleSuicideRates(IN day int)
BEGIN
    IF CheckYear(day) != 0 THEN
        WITH maleSuicide AS (
            SELECT Country.name AS country,
                Country.population / 100000 * Suicide_Rates.age_standardized_suicide_rates AS number_of_male_suicides
            FROM Suicide_Rates
                JOIN Country ON Suicide_Rates.country = Country.name
            WHERE Suicide_Rates.year = day
                AND Suicide_Rates.sex = "male"
        ),
        femaleSuicide AS (
            SELECT Country.name AS country,
                Country.population / 100000 * Suicide_Rates.age_standardized_suicide_rates AS number_of_female_suicides
            FROM Suicide_Rates
                JOIN Country ON Suicide_Rates.country = Country.name
            WHERE Suicide_Rates.year = day
                AND Suicide_Rates.sex = "female"
        )
        SELECT maleSuicide.country AS country,
            number_of_male_suicides,
            number_of_female_suicides
        FROM maleSuicide
            JOIN femaleSuicide ON maleSuicide.country = femaleSuicide.country;
    ELSE
       SELECT NULL as Error;
    END IF;
END; //

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS ShowCountryGreatestFacilities //

CREATE PROCEDURE ShowCountryGreatestFacilities()
BEGIN
    WITH numFac AS (
        SELECT country,
            SUM(population / 100 * unit_count) as total
        FROM Facility
            JOIN Country on Country.name = Facility.country
        GROUP BY Facility.country
    ),
    greatestAmount AS (
        SELECT MAX(total) as greatest_amount
        FROM numFac
    )
    SELECT country, greatest_amount
    FROM numFac,
            greatestAmount
    WHERE total = greatest_amount;
END; //

DELIMITER ;

DELIMITER //

DROP FUNCTION IF EXISTS CheckRegion //

CREATE FUNCTION CheckRegion(reg VARCHAR(50))
RETURNS INTEGER
BEGIN
      RETURN (SELECT COUNT(region) FROM Country WHERE region = reg);
END; //
DROP PROCEDURE IF EXISTS ShowAverageStayRegion//

CREATE PROCEDURE ShowAverageStayRegion(IN reg varchar(50))
BEGIN
   IF CheckRegion(reg) != 0 THEN
        WITH mentalHealthUnitAvgStay AS (
            SELECT region,
                AVG(avg_stay) AS mental_health_units_avg_stay
            FROM Country
                JOIN Facility ON Country.name = Facility.country
            WHERE Facility.facility_type = "mental health unit"
            GROUP BY region
        ),
        mentalHospitalAvgStay AS (
            SELECT region,
                AVG(avg_stay) AS mental_hospital_avg_stay
            FROM Country
                JOIN Facility ON Country.name = Facility.country
            WHERE Facility.facility_type = "mental hospital"
            GROUP BY region
        )
        SELECT Country.region,
            mental_health_units_avg_stay,
            mental_hospital_avg_stay
        FROM Country
            JOIN mentalHealthUnitAvgStay ON Country.region = mentalHealthUnitAvgStay.region
            JOIN mentalHospitalAvgStay ON Country.region = mentalHospitalAvgStay.region
        WHERE Country.region = reg
        GROUP BY region;
   ELSE
       SELECT NULL as Error;
   END IF;
END; //

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS ShowMaxPsychiatrists//

CREATE PROCEDURE ShowMaxPsychiatrists(IN reg varchar(50))
BEGIN
   IF CheckRegion(reg) != 0 THEN
        WITH psychCount AS (
            SELECT name, region,
                SUM(population / 100 * psychiatrist_count) as psych_count
            FROM Country
            WHERE region = reg
            GROUP BY name
        ),
        greatestPsych AS (
            SELECT MAX(psych_count) as greatest_psych
            FROM psychCount
        )
        SELECT name, region
        FROM psychCount,
            greatestPsych
        WHERE psych_count = greatest_psych;
   ELSE
       SELECT NULL as Error;
   END IF;
END; //

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS ShowRegionHighestSuicide//

CREATE PROCEDURE ShowRegionHighestSuicide()
BEGIN
    WITH avgSuicideRegion AS (
    SELECT region,
        AVG(age_standardized_suicide_rates) AS avg_suicide_rate
    FROM Country
        JOIN Suicide_Rates ON Country.name = Suicide_Rates.country
    WHERE sex = "Both sexes"
    GROUP BY region
    ),
    maxSuicideRegion AS (
    SELECT region,
        MAX(avg_suicide_rate) AS max_suicide_rate
    FROM avgSuicideRegion
    )
    SELECT region, max_suicide_rate
    FROM maxSuicideRegion;
END; //

DELIMITER ;