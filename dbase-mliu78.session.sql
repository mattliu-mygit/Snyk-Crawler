-- 7. What region has the highest rates of depression?
SELECT region,
  AVG(age_standardized_suicide_rates) AS available_mental_health_units
FROM Country
  JOIN Suicide_Rates ON Country.name = Suicide_Rates.country
GROUP BY region;