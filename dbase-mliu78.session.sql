DROP TABLE IF EXISTS Country;
CREATE TABLE Country (
  name varchar(70),
  region varchar(50),
  psychiatrist_count float,
  population int,
  PRIMARY KEY(name)
);
LOAD DATA LOCAL INFILE '../../web-security-project-crawler/Snyk-Crawler/processed/country.csv' INTO TABLE Country FIELDS TERMINATED BY ',';
show WARNINGS;
SELECT *
FROM Country;