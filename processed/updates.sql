-- Karen He, khe8
-- Matthew Liu, mliu78
/* Insertion */
-- Country Insertion
INSERT INTO Country
VALUES (
    'New Country Name',
    'Western Pacific',
    2.27,
    357109
  );
-- Suicide_Rates Insertion
INSERT INTO Suicide_Rates
VALUES (
    2019,
    'New Country Name',
    'male',
    12.56
  );
/* To insert a facility for each type of facility */
-- Mental_Hospital Facility Insertion
INSERT INTO Facility
VALUES (
    'mental hospital',
    2019,
    'New Country Name',
    110,
    24,
    0.47
  );
-- Outpatient Facility Insertion
INSERT INTO Facility
VALUES (
    'outpatient facility',
    2019,
    'New Country Name',
    94,
    25,
    0.36
  );
-- General_Hospital Facility Insertion
INSERT INTO Facility
VALUES (
    'mental health unit',
    2019,
    'New Country Name',
    101,
    23,
    0.42
  );
-- Day_Treatment Facility Insertion
INSERT INTO Facility
VALUES (
    'day treatment facility',
    2019,
    'New Country Name',
    102,
    22,
    0.37
  );
-- Mental_Hospital Insertion
INSERT INTO Mental_Hospital
VALUES (
    2019,
    'New Country Name',
    5,
    6,
    10
  );
-- Outpatient Insertion
INSERT INTO Outpatient
VALUES (
    2019,
    'New Country Name',
    0.7
  );
-- General_Hospital Insertion
INSERT INTO General_Hospital
VALUES (
    2019,
    'New Country Name',
    12,
    0.6,
    8
  );
-- Day_Treatment Insertion
INSERT INTO Day_Treatment
VALUES (
    2019,
    'New Country Name',
    10,
    0.26
  );
/* To insert a patient ledger for each type of facility */
-- Mental_Hospital Patient_Ledger Insertion
INSERT INTO Patient_Ledger
VALUES (
    'mental hospital',
    2019,
    'New Country Name',
    15,
    43,
    25
  );
-- Outpatient Patient_Ledger Insertion
INSERT INTO Patient_Ledger
VALUES (
    'outpatient facility',
    2019,
    'New Country Name',
    14,
    37,
    26
  );
-- General_Hospital Patient_Ledger Insertion
INSERT INTO Patient_Ledger
VALUES (
    'mental health unit',
    2019,
    'New Country Name',
    6,
    40,
    27
  );
-- Day_Treatment Patient_Ledger Insertion
INSERT INTO Patient_Ledger
VALUES (
    'day treatment facility',
    2019,
    'New Country Name',
    7,
    39,
    28
  );
/* Deletion */
-- Mental_Hospital Patient_Ledger Deletion
DELETE FROM Patient_Ledger
WHERE year = 2019
  AND country = 'New Country Name'
  AND facility_type = 'mental hospital';
-- Outpatient Patient_Ledger Deletion
DELETE FROM Patient_Ledger
WHERE year = 2019
  AND country = 'New Country Name'
  AND facility_type = 'outpatient facility';
-- General_Hospital Patient_Ledger Deletion
DELETE FROM Patient_Ledger
WHERE year = 2019
  AND country = 'New Country Name'
  AND facility_type = 'mental health unit';
-- Day_Treatment Patient_Ledger Deletion
DELETE FROM Patient_Ledger
WHERE year = 2019
  AND country = 'New Country Name'
  AND facility_type = 'day treatment facility';
-- Mental_Hospital Deletion
DELETE FROM Mental_Hospital
WHERE year = 2019
  AND country = 'New Country Name';
-- Outpatient Deletion
DELETE FROM Outpatient
WHERE year = 2019
  AND country = 'New Country Name';
-- General_Hospital Deletion
DELETE FROM General_Hospital
WHERE year = 2019
  AND country = 'New Country Name';
-- Day_Treatment Deletion
DELETE FROM Day_Treatment
WHERE year = 2019
  AND country = 'New Country Name';
-- Mental_Hospital Facility Deletion
DELETE FROM Facility
WHERE year = 2019
  AND country = 'New Country Name'
  AND facility_type = 'mental hospital';
-- Outpatient Facility Deletion
DELETE FROM Facility
WHERE year = 2019
  AND country = 'New Country Name'
  AND facility_type = 'outpatient facility';
-- General_Hospital Facility Deletion
DELETE FROM Facility
WHERE year = 2019
  AND country = 'New Country Name'
  AND facility_type = 'mental health unit';
-- Day_Treatment Facility Deletion
DELETE FROM Facility
WHERE year = 2019
  AND country = 'New Country Name'
  AND facility_type = 'day treatment facility';
-- Suicide_Rates Deletion
DELETE FROM Country
WHERE name = 'New Country Name';
-- Country Deletion
DELETE FROM Country
WHERE name = 'New Country Name';