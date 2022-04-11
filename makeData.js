const toJSON = require("csvtojson");
const createCsvWriter = require("csv-writer").createObjectCsvWriter;
const mh = "./db-dat/mh.csv";
const mhu = "./db-dat/mhu.csv";
const outPatient = "./db-dat/outpatient.csv";
const psychiatrists = "./db-dat/psychiatrists.csv";
const suicide_rates = "./db-dat/suicide_rates.csv";
const day_treatment = "./db-dat/day_treatment.csv";

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
                /**
                 * What are we doing here?
                 * 1. We are storing all facilities in a Facilities parent table in an array yearMap
                 * 2. We are creating individual tables for each facility type
                 * 3. We are creating a table for the overarching facility type using the final processed yearMap
                 */
                const yearMap = [];
                mhJSONs.forEach((mhJSON) => {
                  yearMap.push({
                    type: "mental hospital",
                    year: mhJSON.Period,
                    country: mhJSON.Location,
                    avg_stay: Math.floor(Math.random() * 354),
                    cost: Math.floor(Math.random() * 50),
                    unit_count: mhJSON.FactValueNumeric,
                  });
                  mhJSON.ptsd_count = Math.floor(Math.random() * 100);
                  mhJSON.depression_count = Math.floor(Math.random() * 100);
                  mhJSON.insanity_count = Math.floor(Math.random() * 100);
                });

                const csvWriterMH = createCsvWriter({
                  path: "./processed/mh.csv",
                  header: [
                    { id: "Period", title: "year" },
                    { id: "Location", title: "country" },
                    { id: "ptsd_count", title: "ptsd_count" },
                    { id: "depression_count", title: "depression_count" },
                    { id: "insanity_count", title: "insanity_count" },
                  ],
                });
                csvWriterMH
                  .writeRecords(mhJSONs)
                  .then(() =>
                    console.log("The CSV file was written successfully")
                  );

                outpatientJSONs.forEach((outpatientJSON) => {
                  yearMap.push({
                    type: "outpatient facility",
                    year: outpatientJSON.Period,
                    country: outpatientJSON.Location,
                    avg_stay: Math.floor(Math.random() * 354),
                    cost: Math.floor(Math.random() * 50),
                    unit_count: outpatientJSON.FactValueNumeric,
                  });
                  outpatientJSON.mental_health_allocation =
                    Math.random().toFixed(2);
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
                    console.log("The CSV file was written successfully")
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
                  mhuJSON.rehabilitation_count = Math.floor(
                    Math.random() * 100
                  );
                  mhuJSON.mental_health_allocation = (
                    Math.random() * 0.5
                  ).toFixed(2);
                  mhuJSON.mental_health_prescription_count = Math.floor(
                    Math.random() * 10
                  );
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
                    console.log("The CSV file was written successfully")
                  );

                dayTreatmentJSONs.forEach((dayTreatmentJSON) => {
                  yearMap.push({
                    type: "day treatment facility",
                    year: dayTreatmentJSON.Period,
                    country: dayTreatmentJSON.Location,
                    avg_stay: Math.floor(Math.random() * 354),
                    cost: Math.floor(Math.random() * 50),
                    unit_count: dayTreatmentJSON.FactValueNumeric,
                  });
                  dayTreatmentJSON.closing_hour =
                    16 + Math.floor(Math.random() * 8);
                  dayTreatmentJSON.non_drug_alc_count = (
                    Math.random() * 0.2
                  ).toFixed(2);
                  dayTreatmentJSON.drug_alc_count = (
                    Math.random() * 0.3 +
                    dayTreatmentJSON.non_drug_and_alcohol_count
                  ).toFixed(2);
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
                    console.log("The CSV file was written successfully")
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
                    console.log("The CSV file was written successfully")
                  );
              });
          });
      });
  });

toJSON()
  .fromFile(psychiatrists)
  .then((psychiatristsJSONs) => {
    const csvWriter = createCsvWriter({
      path: "./processed/country.csv",
      header: [
        { id: "Location", title: "name" },
        { id: "ParentLocation", title: "region" },
        { id: "Value", title: "psychiatrist_count" },
      ],
    });
    csvWriter
      .writeRecords(psychiatristsJSONs)
      .then(() => console.log("The CSV file was written successfully"));
  });

toJSON()
  .fromFile(suicide_rates)
  .then((suicideRatesJSONs) => {
    const csvWriter = createCsvWriter({
      path: "./processed/suicide.csv",
      header: [
        { id: "Period", title: "year" },
        { id: "Location", title: "country" },
        { id: "Dim1", title: "sex" },
        { id: "FactValueNumeric", title: "age_standardized_suicide_rates" },
      ],
    });
    csvWriter
      .writeRecords(suicideRatesJSONs)
      .then(() => console.log("The CSV file was written successfully"));
  });
