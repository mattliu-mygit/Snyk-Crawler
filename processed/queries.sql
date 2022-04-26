--11. What country has the greatest number of facilities? 
WITH numFac AS (
SELECT country, SUM(population / 100 * unit_count) as total
FROM Facility JOIN Country on Country.name = Facility.country
GROUP BY Facility.country),
greatestAmount AS (
SELECT MAX(total) as greatest_amount
FROM numFac)
SELECT country
FROM numFac, greatestAmount 
WHERE total = greatest_amount;

--1. How many mental health units are available for patients per region?
SELECT region, SUM(unit_count) * 100000 AS available_mental_health_units
FROM Country JOIN Facility ON Country.name = Facility.country
WHERE Facility.facility_type = "mental health unit"
GROUP BY region;

--17. What is the most prominent type of patient (PTSD, insanity, depression) in mental health hospitals?
--need type labels? not sure how to write this query
WITH conditionCount AS(
SELECT SUM(ptsd_count) AS ptsd, SUM(depression_count) AS depression, SUM (Insanity_count) AS insanity
FROM Mental_Hospital);

--5. What region/country has the greatest number of psychiatrists working in the mental health sector?
WITH psychCount AS (
SELECT name, SUM(population / 100 * psychiatrist_count) as psych_count
FROM Country
GROUP BY name),
greatestPsych AS (
SELECT MAX(psych_count) as greatest_psych
FROM psychCount)
SELECT name
FROM psychCount, greatestPsych
WHERE psych_count = greatest_psych;

--16. In 2019, how many males vs females committed suicide for each country?
WITH maleSuicide AS (
SELECT Country.name AS country, Country.population / 100000 * Suicide_Rates.age_standardized_suicide_rates AS number_of_male_suicides
FROM Suicide_Rates JOIN Country ON Suicide_Rates.country = Country.name
WHERE Suicide_Rates.year = "2019" AND Suicide_Rates.sex = "male"),
femaleSuicide AS (
SELECT Country.name AS country, Country.population / 100000 * Suicide_Rates.age_standardized_suicide_rates AS number_of_female_suicides
FROM Suicide_Rates JOIN Country ON Suicide_Rates.country = Country.name
WHERE Suicide_Rates.year = "2019" AND Suicide_Rates.sex = "female")
SELECT maleSuicide.country, number_of_male_suicides, number_of_female_suicides
FROM maleSuicide JOIN femaleSuicide ON maleSuicide.country = femaleSuicide.country;