-- (1). What country has the greatest number of facilities? 
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
SELECT country
FROM numFac,
  greatestAmount
WHERE total = greatest_amount;
-- (2). How many mental health units are available for patients per region?
SELECT region,
  SUM(unit_count) * 100000 AS available_mental_health_units
FROM Country
  JOIN Facility ON Country.name = Facility.country
WHERE Facility.facility_type = "mental health unit"
GROUP BY region;
-- (3). What region/country has the greatest number of psychiatrists working in the mental health sector?
WITH psychCount AS (
  SELECT name,
    SUM(population / 100 * psychiatrist_count) as psych_count
  FROM Country
  GROUP BY name
),
greatestPsych AS (
  SELECT MAX(psych_count) as greatest_psych
  FROM psychCount
)
SELECT name
FROM psychCount,
  greatestPsych
WHERE psych_count = greatest_psych;
-- (4). In 2019, how many males vs females committed suicide for each country?
WITH maleSuicide AS (
  SELECT Country.name AS country,
    Country.population / 100000 * Suicide_Rates.age_standardized_suicide_rates AS number_of_male_suicides
  FROM Suicide_Rates
    JOIN Country ON Suicide_Rates.country = Country.name
  WHERE Suicide_Rates.year = "2019"
    AND Suicide_Rates.sex = "male"
),
femaleSuicide AS (
  SELECT Country.name AS country,
    Country.population / 100000 * Suicide_Rates.age_standardized_suicide_rates AS number_of_female_suicides
  FROM Suicide_Rates
    JOIN Country ON Suicide_Rates.country = Country.name
  WHERE Suicide_Rates.year = "2019"
    AND Suicide_Rates.sex = "female"
)
SELECT maleSuicide.country,
  number_of_male_suicides,
  number_of_female_suicides
FROM maleSuicide
  JOIN femaleSuicide ON maleSuicide.country = femaleSuicide.country;
-- (5). In which facility did patients spend the most on average.
WITH AverageCost AS (
  SELECT Facility.year,
    Facility.country,
    AVG(Patient_Ledger.cost) * 100 as cost
  FROM Facility
    JOIN Patient_Ledger on Facility.year = Patient_Ledger.year
    AND Facility.country = Patient_Ledger.country
    AND Facility.facility_type = Patient_Ledger.facility_type
  GROUP BY Facility.country
)
SELECT *
FROM AverageCost
WHERE cost = (
    SELECT MAX(cost)
    FROM AverageCost
  );
-- (6). What countries have total patient count for all facilities below ______ (total patient count)?
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
  WHERE count < 400000;
-- (7). What type of facility do most people go to for each country
SELECT Facility.country,
  MAX(Patient_Ledger.patient_count) as count,
  Facility.facility_type
FROM Facility
  JOIN Patient_Ledger on Facility.year = Patient_Ledger.year
  AND Facility.country = Patient_Ledger.country
  AND Facility.facility_type = Patient_Ledger.facility_type
GROUP BY Facility.country,
  Facility.year
ORDER BY Facility.country;
-- (8). What is total mental health allocation of each country?
SELECT General_Hospital.country,
  (
    General_Hospital.mental_health_allocation + Outpatient.mental_health_allocation
  ) * 10000000 AS mental_health_allocation
FROM Outpatient
  JOIN General_Hospital ON General_Hospital.country = Outpatient.country
GROUP BY Outpatient.country;
-- (9). What region has the highest rates of suicide?
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
SELECT region
FROM maxSuicideRegion;
-- (10)23. For each country, what percentage of a patients at a general hospital were rehabilitated after being diagnosed?
SELECT General_Hospital.country,
  rehabilitation_count / diagnoses_count * 100 AS percentage_rehabilitated
FROM General_Hospital
  JOIN Patient_Ledger ON General_Hospital.country = Patient_Ledger.country
WHERE Patient_Ledger.facility_type = "mental health unit";
-- (11)24. What percentage of diagnoses were for ptsd, insanity and depression in mental health hospitals for each country?
SELECT Patient_Ledger.country,
  ptsd_count / diagnoses_count * 100 AS percentage_ptsd,
  Insanity_count / diagnoses_count * 100 AS percentage_insanity,
  depression_count / diagnoses_count * 100 AS percentage_depression
FROM Patient_Ledger
  JOIN Mental_Hospital ON Patient_Ledger.country = Mental_Hospital.country
WHERE Patient_Ledger.facility_type = "mental hospital";
-- (12)25. What is the average stay for each facility with overnight capacity in each region?
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
GROUP BY region;
-- (13) 8. Spending the most on what type of facility is correlated the lowest amounts of suicide_rates?
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
-- (14) What is the United States allocating most of its resources to (greatest to least)?
SELECT Facility.facility_type,
  cost * 10000000
FROM Facility
WHERE Facility.country = "United States of America"
ORDER BY cost DESC;
-- (15) What are the top 10 countries with the most suicides committed in 2016?
WITH popSuicide AS (
  SELECT Country.name,
    Suicide_Rates.year,
    Country.population / 100000 * Suicide_Rates.age_standardized_suicide_rates AS number_of_suicides
  FROM Country
    JOIN Suicide_Rates ON Country.name = country
  WHERE Suicide_Rates.sex = "Both sexes"
),
popSuicideYearAvg AS (
  SELECT popSuicide.name,
    AVG(number_of_suicides) AS average_number_of_suicides
  FROM popSuicide
  GROUP BY name
)
SELECT *
FROM popSuicideYearAvg
ORDER BY average_number_of_suicides DESC
LIMIT 10;