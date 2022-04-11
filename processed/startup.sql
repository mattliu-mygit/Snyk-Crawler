SET FOREIGN_KEY_CHECKS = 0;
-- to disable them
DROP TABLE Country;
DROP TABLE Suicide_Rates;
DROP TABLE Mental_Hospital;
DROP TABLE Facility;
DROP TABLE Outpatient;
DROP TABLE General_Hospital;
DROP TABLE Day_Treatment;
CREATE TABLE Country (
  name varchar(20),
  region varchar(10),
  psychiatrist_count float,
  PRIMARY KEY(name)
);
CREATE TABLE Suicide_Rates (
  year int,
  country varchar(20),
  sex varchar(5),
  age_standardized_suicide_rates float,
  PRIMARY KEY(country, year, sex),
  FOREIGN KEY(country) REFERENCES Country(name)
);
CREATE TABLE Facility (
  type varchar(20),
  year int,
  country varchar(20),
  avg_stay int,
  cost int,
  unit_count float,
  PRIMARY KEY(year, country, type),
  FOREIGN KEY(country) REFERENCES Country(name)
);
CREATE TABLE Mental_Hospital (
  year int,
  country varchar(20),
  ptsd_count int,
  depression_count int,
  Insanity_count int,
  PRIMARY KEY(year, country),
  FOREIGN KEY(country) REFERENCES Facility(country),
  FOREIGN KEY(year) REFERENCES Facility(year)
);
CREATE TABLE Outpatient (
  year int,
  country varchar(20),
  mental_health_allocation float,
  PRIMARY KEY(year, country),
  FOREIGN KEY(country) REFERENCES Facility(country),
  FOREIGN KEY(year) REFERENCES Facility(year)
);
CREATE TABLE General_Hospital (
  year int,
  country varchar(20),
  rehabilitation_count int,
  mental_health_allocation float,
  mental_health_prescription_count int,
  PRIMARY KEY(year, country),
  FOREIGN KEY(country) REFERENCES Facility(country),
  FOREIGN KEY(year) REFERENCES Facility(year)
);
CREATE TABLE Day_Treatment (
  year int,
  country varchar(20),
  closing_hour int,
  non_drug_alc_count float,
  frug_alc_count float,
  PRIMARY KEY(year, country),
  FOREIGN KEY(country) REFERENCES Facility(country),
  FOREIGN KEY(year) REFERENCES Facility(year)
);
SET FOREIGN_KEY_CHECKS = 1;
-- to re-enable them
LOAD DATA LOCAL INFILE './country.csv' INTO TABLE Country FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE './suicide.csv' INTO TABLE Suicide_Rates FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE './facility.csv' INTO TABLE Facility FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE './mh.csv' INTO TABLE Mental_Hospital FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE './mhu.csv' INTO TABLE General_Hospital FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE './outpatient.csv' INTO TABLE Outpatient FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE './day_treatment.csv' INTO TABLE Day_Treatment FIELDS TERMINATED BY ',';