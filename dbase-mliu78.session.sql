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
  MIN(min_rate)
FROM MinRates;