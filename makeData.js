const toJSON = require("csvtojson");
const createCsvWriter = require("csv-writer").createObjectCsvWriter;
const mh = "./db-dat/mh.csv";
const mhu = "./db-dat/mhu.csv";
const outPatient = "./db-dat/outpatient.csv";
const psychiatrists = "./db-dat/psychiatrists.csv";
const suicide_rates = "./db-dat/suicide_rates.csv";
const day_treatment = "./db-dat/day_treatment.csv";
const populations = "./db-dat/populations.csv";

const checkCountry = (countries, country) => {
  for (let c of countries) {
    if (c.Location === country) return false;
  }
  return true;
};

toJSON()
  .fromFile(populations)
  .then((populationJSONs) => {
    toJSON()
      .fromFile(mh)
      .then((mhJSONs) => {
        toJSON()
          .fromFile(outPatient)
          .then((outpatientJSONs) => {
            toJSON()
              .fromFile(mhu)
              .then((mhuJSONs) => {
                toJSON()
                  .fromFile(day_treatment)
                  .then((dayTreatmentJSONs) => {
                    toJSON()
                      .fromFile(psychiatrists)
                      .then((psychiatristsJSONs) => {
                        toJSON()
                          .fromFile(suicide_rates)
                          .then((suicideRatesJSONs) => {
                            const yearMap = [];
                            const patient_ledgers = [];
                            let countries = [...psychiatristsJSONs];

                            const totalObjs = [];
                            populationJSONs.forEach((pop) => {
                              let count = 0;
                              let tot = 0;
                              for (let prop in pop) {
                                if (count < 61) {
                                  tot += Number(pop[prop]);
                                } else if (count === 61) {
                                  totalObjs.push({
                                    country: pop[prop],
                                    average_population: tot / 61,
                                  });
                                }
                                count++;
                              }
                            });
                            countries = countries.map((c) => {
                              for (let t of totalObjs) {
                                if (t.country === c.Location) {
                                  return {
                                    ...c,
                                    population: Math.floor(
                                      t.average_population
                                    ),
                                  };
                                }
                              }
                              const newC = {
                                ...c,
                                population: Math.floor(
                                  Math.random() * 1000000000
                                ),
                              };
                              return newC;
                            });

                            const csvWriterCountry = createCsvWriter({
                              path: "./processed/country.csv",
                              header: [
                                { id: "Location", title: "name" },
                                { id: "ParentLocation", title: "region" },
                                { id: "Value", title: "psychiatrist_count" },
                                { id: "population", title: "population" },
                              ],
                            });

                            mhJSONs.forEach((mhJSON) => {
                              if (
                                mhJSON.Location &&
                                checkCountry(countries, mhJSON.Location)
                              )
                                countries.push({
                                  Location: mhJSON.Location,
                                  ParentLocation: mhJSON.ParentLocation,
                                  Value: (Math.random() * 5).toFixed(2),
                                  population: Math.floor(
                                    Math.random() * 10000000
                                  ),
                                });
                              yearMap.push({
                                type: "mental hospital",
                                year: mhJSON.Period,
                                country: mhJSON.Location,
                                avg_stay: Math.floor(Math.random() * 354),
                                cost: Math.floor(Math.random() * 50),
                                unit_count: mhJSON.FactValueNumeric,
                              });

                              mhJSON.ptsd_count = Math.floor(
                                Math.random() * 100
                              );
                              mhJSON.depression_count = Math.floor(
                                Math.random() * 100
                              );
                              mhJSON.insanity_count = Math.floor(
                                Math.random() * 100
                              );
                              patient_ledgers.push({
                                year: mhJSON.Period,
                                country: mhJSON.Location,
                                type: "mental hospital",
                                cost: Math.floor(Math.random() * 50),
                                diagnoses_count: Math.floor(
                                  Math.random() * 100
                                ),
                                patient_count: Math.floor(Math.random() * 75),
                              });
                            });

                            const csvWriterMH = createCsvWriter({
                              path: "./processed/mh.csv",
                              header: [
                                { id: "Period", title: "year" },
                                { id: "Location", title: "country" },
                                { id: "ptsd_count", title: "ptsd_count" },
                                {
                                  id: "depression_count",
                                  title: "depression_count",
                                },
                                {
                                  id: "insanity_count",
                                  title: "insanity_count",
                                },
                              ],
                            });
                            csvWriterMH
                              .writeRecords(mhJSONs)
                              .then(() =>
                                console.log(
                                  "The CSV file was written successfully"
                                )
                              );

                            outpatientJSONs.forEach((outpatientJSON) => {
                              yearMap.push({
                                type: "outpatient facility",
                                year: outpatientJSON.Period,
                                country: outpatientJSON.Location,
                                avg_stay: 0,
                                cost: Math.floor(Math.random() * 50),
                                unit_count: outpatientJSON.FactValueNumeric,
                              });

                              if (
                                outpatientJSON.Location &&
                                checkCountry(countries, outpatientJSON.Location)
                              )
                                countries.push({
                                  Location: outpatientJSON.Location,
                                  ParentLocation: outpatientJSON.ParentLocation,
                                  Value: (Math.random() * 5).toFixed(2),
                                  population: Math.floor(
                                    Math.random() * 10000000
                                  ),
                                });
                              outpatientJSON.mental_health_allocation =
                                Math.random().toFixed(2);
                              patient_ledgers.push({
                                year: outpatientJSON.Period,
                                country: outpatientJSON.Location,
                                type: "outpatient facility",
                                cost: Math.floor(Math.random() * 50),
                                diagnoses_count: Math.floor(
                                  Math.random() * 100
                                ),
                                patient_count: Math.floor(Math.random() * 75),
                              });
                            });
                            const csvWriterOutpatient = createCsvWriter({
                              path: "./processed/outpatient.csv",
                              header: [
                                { id: "Period", title: "year" },
                                { id: "Location", title: "country" },
                                {
                                  id: "mental_health_allocation",
                                  title: "mental_health_allocation",
                                },
                              ],
                            });
                            csvWriterOutpatient
                              .writeRecords(outpatientJSONs)
                              .then(() =>
                                console.log(
                                  "The CSV file was written successfully"
                                )
                              );

                            mhuJSONs.forEach((mhuJSON) => {
                              yearMap.push({
                                type: "mental health unit",
                                year: mhuJSON.Period,
                                country: mhuJSON.Location,
                                avg_stay: Math.floor(Math.random() * 354),
                                cost: Math.floor(Math.random() * 50),
                                unit_count: mhuJSON.FactValueNumeric,
                              });

                              if (
                                mhuJSON.Location &&
                                checkCountry(countries, mhuJSON.Location)
                              )
                                countries.push({
                                  Location: mhuJSON.Location,
                                  ParentLocation: mhuJSON.ParentLocation,
                                  Value: (Math.random() * 5).toFixed(2),
                                  population: Math.floor(
                                    Math.random() * 10000000
                                  ),
                                });
                              mhuJSON.rehabilitation_count = Math.floor(
                                Math.random() * 50 + 50
                              );
                              mhuJSON.mental_health_allocation = (
                                Math.random() * 0.5
                              ).toFixed(2);
                              mhuJSON.mental_health_prescription_count =
                                Math.floor(Math.random() * 10);
                              patient_ledgers.push({
                                type: "mental health unit",
                                year: mhuJSON.Period,
                                country: mhuJSON.Location,
                                cost: Math.floor(Math.random() * 50),
                                diagnoses_count: Math.floor(Math.random() * 50),
                                patient_count: Math.floor(Math.random() * 75),
                              });
                            });

                            const csvWriterMHU = createCsvWriter({
                              path: "./processed/mhu.csv",
                              header: [
                                { id: "Period", title: "year" },
                                { id: "Location", title: "country" },
                                {
                                  id: "rehabilitation_count",
                                  title: "rehabilitation_count",
                                },
                                {
                                  id: "mental_health_allocation",
                                  title: "mental_health_allocation",
                                },
                                {
                                  id: "mental_health_prescription_count",
                                  title: "mental_health_prescription_count",
                                },
                              ],
                            });
                            csvWriterMHU
                              .writeRecords(mhuJSONs)
                              .then(() =>
                                console.log(
                                  "The CSV file was written successfully"
                                )
                              );

                            dayTreatmentJSONs.forEach((dayTreatmentJSON) => {
                              yearMap.push({
                                type: "day treatment facility",
                                year: dayTreatmentJSON.Period,
                                country: dayTreatmentJSON.Location,
                                avg_stay: 0,
                                cost: Math.floor(Math.random() * 50),
                                unit_count: dayTreatmentJSON.FactValueNumeric,
                              });

                              if (
                                dayTreatmentJSON.Location &&
                                checkCountry(
                                  countries,
                                  dayTreatmentJSON.Location
                                )
                              )
                                countries.push({
                                  Location: dayTreatmentJSON.Location,
                                  ParentLocation:
                                    dayTreatmentJSON.ParentLocation,
                                  Value: (Math.random() * 5).toFixed(2),
                                  population: Math.floor(
                                    Math.random() * 10000000
                                  ),
                                });
                              dayTreatmentJSON.closing_hour =
                                16 + Math.floor(Math.random() * 8);
                              dayTreatmentJSON.non_drug_alc_count = (
                                Math.random() * 0.2
                              ).toFixed(2);
                              const drugAlcCount =
                                Math.random() * 0.3 +
                                parseFloat(dayTreatmentJSON.non_drug_alc_count);
                              dayTreatmentJSON.drug_alc_count =
                                drugAlcCount.toFixed(2);
                              patient_ledgers.push({
                                type: "day treatment facility",
                                year: dayTreatmentJSON.Period,
                                country: dayTreatmentJSON.Location,
                                cost: Math.floor(Math.random() * 50),
                                diagnoses_count: Math.floor(
                                  Math.random() * 100
                                ),
                                patient_count: Math.floor(Math.random() * 75),
                              });
                            });

                            const csvWriterDay = createCsvWriter({
                              path: "./processed/day_treatment.csv",
                              header: [
                                { id: "Period", title: "year" },
                                { id: "Location", title: "country" },
                                {
                                  id: "closing_hour",
                                  title: "closing_hour",
                                },
                                {
                                  id: "non_drug_alc_count",
                                  title: "non_drug_alc_count",
                                },
                                {
                                  id: "drug_alc_count",
                                  title: "drug_alc_count",
                                },
                              ],
                            });
                            csvWriterDay
                              .writeRecords(dayTreatmentJSONs)
                              .then(() =>
                                console.log(
                                  "The CSV file was written successfully"
                                )
                              );

                            const csvWriterFacility = createCsvWriter({
                              path: "./processed/facility.csv",
                              header: [
                                { id: "type", title: "type" },
                                { id: "year", title: "year" },
                                { id: "country", title: "country" },
                                { id: "avg_stay", title: "avg_stay" },
                                { id: "cost", title: "cost" },
                                { id: "unit_count", title: "unit_count" },
                              ],
                            });
                            csvWriterFacility
                              .writeRecords(yearMap)
                              .then(() =>
                                console.log(
                                  "The CSV file was written successfully"
                                )
                              );
                            const csvWriterPatientLedger = createCsvWriter({
                              path: "./processed/patient_ledger.csv",
                              header: [
                                { id: "type", title: "type" },
                                { id: "year", title: "year" },
                                { id: "country", title: "country" },
                                { id: "cost", title: "cost" },
                                {
                                  id: "diagnoses_count",
                                  title: "diagnoses_count",
                                },
                                { id: "patient_count", title: "patient_count" },
                              ],
                            });
                            suicideRatesJSONs.forEach((suicideRatesJSON) => {
                              if (
                                suicideRatesJSON.Location &&
                                checkCountry(
                                  countries,
                                  suicideRatesJSON.Location
                                )
                              )
                                countries.push({
                                  Location: suicideRatesJSON.Location,
                                  ParentLocation:
                                    suicideRatesJSON.ParentLocation,
                                  Value: (Math.random() * 5).toFixed(2),
                                  population: Math.floor(
                                    Math.random() * 10000000
                                  ),
                                });
                            });
                            const csvWriter = createCsvWriter({
                              path: "./processed/suicide.csv",
                              header: [
                                { id: "Period", title: "year" },
                                { id: "Location", title: "country" },
                                { id: "Dim1", title: "sex" },
                                {
                                  id: "FactValueNumeric",
                                  title: "age_standardized_suicide_rates",
                                },
                              ],
                            });
                            csvWriter
                              .writeRecords(suicideRatesJSONs)
                              .then(() =>
                                console.log(
                                  "The CSV file was written successfully"
                                )
                              );
                            csvWriterPatientLedger
                              .writeRecords(patient_ledgers)
                              .then(() =>
                                console.log(
                                  "The CSV file was written successfully"
                                )
                              );
                            csvWriterCountry
                              .writeRecords(countries)
                              .then(() =>
                                console.log(
                                  "The CSV file was written successfully"
                                )
                              );
                          });
                      });
                  });
              });
          });
      });
  });
