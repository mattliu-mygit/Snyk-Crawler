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

DELIMITER //

DROP PROCEDURE IF EXISTS ShowFacilityLowestSuicide//

CREATE PROCEDURE ShowFacilityLowestSuicide()
BEGIN
    WITH FacilityCount as (
    SELECT name,
        MAX(Facility.cost) as max_cost,
        facility_type
    FROM Country
        JOIN Facility ON Country.name = Facility.country
    GROUP BY name
    ),
    AverageSuicide as (
    SELECT country,
        AVG(age_standardized_suicide_rates) as suicide_rates_avg
    FROM Suicide_Rates
    WHERE sex = 'Both sexes'
    GROUP BY country
    ),
    MinRates as (
    SELECT facility_type,
        MIN(suicide_rates_avg) as min_rate
    FROM AverageSuicide
        JOIN FacilityCount ON name = country
    GROUP BY facility_type
    )
    SELECT facility_type,
        MIN(min_rate) AS lowest_suicide_rate
    FROM MinRates;
END; //

DELIMITER ;

DELIMITER //

DROP FUNCTION IF EXISTS CheckPatientCount //

CREATE FUNCTION CheckPatientCount(num int)
RETURNS INTEGER
BEGIN
    RETURN (WITH totalPatients AS (
    SELECT Facility.country AS country,
        SUM(Patient_Ledger.patient_count) * 10000 AS checkCount
    FROM Facility
        JOIN Patient_Ledger on Facility.year = Patient_Ledger.year
        AND Facility.country = Patient_Ledger.country
        AND Facility.facility_type = Patient_Ledger.facility_type
    GROUP BY Facility.year,
        Facility.country) SELECT COUNT(checkCount) FROM totalPatients WHERE checkCount < num);
END; //
DROP PROCEDURE IF EXISTS ShowTotalPatientsFacility //

CREATE PROCEDURE ShowTotalPatientsFacility(IN num int)
BEGIN
    IF CheckPatientCount(num) != 0 THEN
        WITH totalPatients AS (
        SELECT Facility.country AS country,
            SUM(Patient_Ledger.patient_count) * 10000 AS count
        FROM Facility
            JOIN Patient_Ledger on Facility.year = Patient_Ledger.year
            AND Facility.country = Patient_Ledger.country
            AND Facility.facility_type = Patient_Ledger.facility_type
        GROUP BY Facility.year,
            Facility.country)
        SELECT country, count
        FROM totalPatients
        WHERE count < num;
    ELSE
       SELECT NULL as Error;
   END IF;
END; //

DELIMITER ;

DELIMITER //

DROP FUNCTION IF EXISTS CheckAllocation //

CREATE FUNCTION CheckAllocation(num int)
RETURNS INTEGER
BEGIN
    RETURN (WITH totalAllocation AS (
            SELECT General_Hospital.country AS country,
            (
                General_Hospital.mental_health_allocation + Outpatient.mental_health_allocation
            ) * 10000000 AS mental_health_allocation
            FROM Outpatient
                JOIN General_Hospital ON General_Hospital.country = Outpatient.country
            GROUP BY Outpatient.country) SELECT COUNT(mental_health_allocation) FROM totalAllocation WHERE mental_health_allocation > num);
END; //
DROP PROCEDURE IF EXISTS ShowTotalAllocation //

CREATE PROCEDURE ShowTotalAllocation(IN num int)
BEGIN
    IF CheckAllocation(num) != 0 THEN
        WITH totalAllocation AS (
        SELECT General_Hospital.country AS country,
        (
            General_Hospital.mental_health_allocation + Outpatient.mental_health_allocation
        ) * 10000000 AS mental_health_allocation
        FROM Outpatient
            JOIN General_Hospital ON General_Hospital.country = Outpatient.country
        GROUP BY Outpatient.country) 
        SELECT country, mental_health_allocation
        FROM totalAllocation
        WHERE mental_health_allocation > num;
    ELSE
       SELECT NULL as Error;
   END IF;
END; //

DELIMITER ;