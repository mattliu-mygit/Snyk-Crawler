-- 4. What type of facility do most people go to for each country
SELECT Facility.country,
  Facility.year,
  MAX(Patient_Ledger.patient_count) as count,
  Facility.facility_type
FROM Facility
  JOIN Patient_Ledger on Facility.year = Patient_Ledger.year
  AND Facility.country = Patient_Ledger.country
  AND Facility.facility_type = Patient_Ledger.facility_type
GROUP BY Facility.country,
  Facility.year
ORDER BY Facility.country;