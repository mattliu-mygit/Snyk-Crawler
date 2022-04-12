To make this work:

For DB Project:
1. Install Node.js
2. Run "npm i" in project
3. Run "node crawlSnyk.js" in project root

The script that is run will take the data from db-dat, process it, and convert it into db project data in the processed folder.

For Web Security Project:
To run lookup:
./lookup [input csv path] [all fields that need to be extracted] --output [output csv file's path]

1. Multiple fields can be input
2. Output file must be csv file. If the output file is not given, an output file name will be randomly generated.