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