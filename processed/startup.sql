-- Matthew Liu, mliu78
-- Karen He, khe8
CREATE TABLE Country (
  name varchar(70),
  region varchar(50),
  psychiatrist_count float,
  population int,
  PRIMARY KEY(name)
);
CREATE TABLE Suicide_Rates (
  year int,
  country varchar(70),
  sex varchar(10),
  age_standardized_suicide_rates float,
  PRIMARY KEY(country, year, sex),
  FOREIGN KEY(country) REFERENCES Country(name)
);
CREATE TABLE Facility (
  facility_type varchar(50),
  year int,
  country varchar(70),
  avg_stay int,
  cost int,
  unit_count float,
  PRIMARY KEY(year, country, facility_type),
  FOREIGN KEY(country) REFERENCES Country(name)
);
CREATE TABLE Mental_Hospital (
  year int,
  country varchar(70),
  ptsd_count int,
  depression_count int,
  Insanity_count int,
  PRIMARY KEY(year, country),
  FOREIGN KEY(country) REFERENCES Facility(country),
  FOREIGN KEY(year) REFERENCES Facility(year)
);
CREATE TABLE Outpatient (
  year int,
  country varchar(70),
  mental_health_allocation float,
  PRIMARY KEY(year, country),
  FOREIGN KEY(country) REFERENCES Facility(country),
  FOREIGN KEY(year) REFERENCES Facility(year)
);
CREATE TABLE General_Hospital (
  year int,
  country varchar(70),
  rehabilitation_count int,
  mental_health_allocation float,
  mental_health_prescription_count int,
  PRIMARY KEY(year, country),
  FOREIGN KEY(country) REFERENCES Facility(country),
  FOREIGN KEY(year) REFERENCES Facility(year)
);
CREATE TABLE Day_Treatment (
  year int,
  country varchar(70),
  closing_hour int,
  non_drug_alc_count float,
  drug_alc_count float,
  PRIMARY KEY(year, country),
  FOREIGN KEY(country) REFERENCES Facility(country),
  FOREIGN KEY(year) REFERENCES Facility(year)
);
CREATE TABLE Patient_Ledger (
  facility_type varchar(50),
  year int,
  country varchar(70),
  cost int,
  diagnoses_count int,
  patient_count int,
  PRIMARY KEY(year, country, facility_type),
  FOREIGN KEY(country) REFERENCES Facility(country),
  FOREIGN KEY(year) REFERENCES Facility(year)
);
LOAD DATA LOCAL INFILE '~/public_html/phase-e/processed/country.csv' INTO TABLE Country FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '~/public_html/phase-e/processed/suicide.csv' INTO TABLE Suicide_Rates FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '~/public_html/phase-e/processed/facility.csv' INTO TABLE Facility FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '~/public_html/phase-e/processed/mh.csv' INTO TABLE Mental_Hospital FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '~/public_html/phase-e/processed/mhu.csv' INTO TABLE General_Hospital FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '~/public_html/phase-e/processed/outpatient.csv' INTO TABLE Outpatient FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '~/public_html/phase-e/processed/day_treatment.csv' INTO TABLE Day_Treatment FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '~/public_html/phase-e/processed/patient_ledger.csv' INTO TABLE Patient_Ledger FIELDS TERMINATED BY ',';