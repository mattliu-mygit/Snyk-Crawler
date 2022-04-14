CREATE TABLE Country (
  name varchar(50),
  region varchar(10),
  psychiatrist_count float,
  PRIMARY KEY(name)
);
CREATE TABLE Suicide_Rates (
  year int,
  country varchar(50),
  sex varchar(10),
  age_standardized_suicide_rates float,
  PRIMARY KEY(country, year, sex),
  FOREIGN KEY(country) REFERENCES Country(name)
);
CREATE TABLE Facility (
  type_of varchar(50),
  year int,
  country varchar(50),
  avg_stay int,
  cost int,
  unit_count float,
  PRIMARY KEY(type_of, year, country),
  FOREIGN KEY(country) REFERENCES Country(name)
);
CREATE TABLE Mental_Hospital (
  year int,
  country varchar(50),
  ptsd_count int,
  depression_count int,
  Insanity_count int,
  PRIMARY KEY(year, country),
  FOREIGN KEY(country) REFERENCES Facility(country),
  FOREIGN KEY(year) REFERENCES Facility(year)
);
CREATE TABLE Outpatient (
  year int,
  country varchar(50),
  mental_health_allocation float,
  PRIMARY KEY(year, country),
  FOREIGN KEY(country) REFERENCES Facility(country),
  FOREIGN KEY(year) REFERENCES Facility(year)
);
CREATE TABLE General_Hospital (
  year int,
  country varchar(50),
  rehabilitation_count int,
  mental_health_allocation float,
  mental_health_prescription_count int,
  PRIMARY KEY(year, country),
  FOREIGN KEY(country) REFERENCES Facility(country),
  FOREIGN KEY(year) REFERENCES Facility(year)
);
CREATE TABLE Day_Treatment (
  year int,
  country varchar(50),
  closing_hour int,
  non_drug_alc_count float,
  drug_alc_count float,
  PRIMARY KEY(year, country),
  FOREIGN KEY(country) REFERENCES Facility(country),
  FOREIGN KEY(year) REFERENCES Facility(year)
);
CREATE TABLE Patient_Ledger (
  type_of varchar(50),
  year int,
  country varchar(50),
  cost int,
  diagnoses_count int,
  patient_count int,
  PRIMARY KEY(year, country, type_of),
  FOREIGN KEY(country) REFERENCES Facility(country),
  FOREIGN KEY(year) REFERENCES Facility(year)
);

LOAD DATA LOCAL INFILE './country-small.csv' INTO TABLE Country FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE './facility-small.csv' INTO TABLE Facility FIELDS TERMINATED BY ','  LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE './suicide-small.csv' INTO TABLE Suicide_Rates FIELDS TERMINATED BY ','  LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE './mh-small.csv' INTO TABLE Mental_Hospital FIELDS TERMINATED BY ','  LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE './mhu-small.csv' INTO TABLE General_Hospital FIELDS TERMINATED BY ','  LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE './outpatient-small.csv' INTO TABLE Outpatient FIELDS TERMINATED BY ','  LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE './day_treatment-small.csv' INTO TABLE Day_Treatment FIELDS TERMINATED BY ','  LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE './patient_ledger-small.csv' INTO TABLE Patient_Ledger FIELDS TERMINATED BY ','  LINES TERMINATED BY '\n';