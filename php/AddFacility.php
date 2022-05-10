<head>
  <title>Add Country Response</title>
</head>
<body>
  <?php
    include "open.php";
    $sqlInsertFacility = $conn->prepare("INSERT INTO Facility VALUES (?,?,?,?,?,?)");
    $sqlInsertFacility->bind_param("ssssss", $type, $year, $country, $stay, $cost, $count);
    $sqlInsertLedger = $conn->prepare("INSERT INTO Patient_Ledger VALUES (?,?,?,?,?,?)");
    $sqlInsertLedger->bind_param("ssssss", $type, $year, $country, $patient_cost, $diagnoses, $patient_count);
    try{
      $country = $_POST['country'];
      $type = $_POST['type'];
      $year = $_POST['year'];
      $stay = $_POST['stay'];
      $cost = $_POST['cost'];
      $stay = $_POST['stay'];
      $count = $_POST['count'];
      $patient_count = $_POST['patient_count'];
      $patient_cost = $_POST['patient_cost'];
      $diagnoses = $_POST['diagnoses'];
      $sqlInsertSpecFacility;
      $specTable = "";
      if (is_null($country) || strlen($country) == 0) {
        throw new Exception("Country name cannot be empty");
      }
      if (is_null($type) || strlen($type) == 0) {
        throw new Exception("Facility type name cannot be empty");
      }
      if (!is_numeric($year) || !is_int(intval($year))) {
        throw new Exception("Year must be an int");
      }
      if (!is_numeric($stay) || !is_int(intval($stay))) {
        throw new Exception(" Patient stay must be an int");
      }
      if (!is_numeric($cost) || !is_int(intval($cost))) {
        throw new Exception(" facility cost must be an int");
      }
      if (!is_numeric($count) || !is_float(floatval($count))) {
        throw new Exception("Unit count must be a float");
      }
      if (!is_numeric($patient_cost) || !is_int(intval($patient_cost))) {
        throw new Exception(" patient cost must be an int");
      }
      if (!is_numeric($patient_count) || !is_int(intval($patient_count))) {
        throw new Exception(" patient count must be an int");
      }
      if (!is_numeric($diagnoses) || !is_int(intval($diagnoses))) {
        throw new Exception(" diagnoses count must be an int");
      }
      if ($type == "mental hospital") {
        $ptsd_count = $_POST['ptsd_count'];
        $depression_count = $_POST['depression_count'];
        $insanity_count = $_POST['insanity_count'];
        if (!is_numeric($ptsd_count) || !is_int(intval($ptsd_count))) {
          throw new Exception("PTSD patient count must be an int");
        }
        if (!is_numeric($depression_count) || !is_int(intval($depression_count))) {
          throw new Exception("Depression patient count must be an int");
        }
        if (!is_numeric($insanity_count) || !is_int(intval($insanity_count))) {
          throw new Exception("Insanity patient count must be an int");
        }
        $sqlInsertSpecFacility = $conn->prepare("INSERT INTO Mental_Hospital VALUES (?,?,?,?,?)");
        $sqlInsertSpecFacility->bind_param("sssss", $year, $country, $ptsd_count, $depression_count, $insanity_count);
        $specTable = "<tr><th> Year </th><th> Country </th> <th> PTSD Diagnosis Percentage </th> <th> Depression Diagnosis Percentage </th> <th> Insanity Diagnosis Percentage </th></tr>
        <tr><td>".$year."</td><td>".$country."</td><td>".$ptsd_count."</td><td>".$depression_count."</td><td>".$insanity_count."</td></tr>";
      } else if ($type == "outpatient facility") {
        $allocation = $_POST['allocation1'];
        if (!is_numeric($allocation) || !is_float(floatval($allocation))) {
          throw new Exception("Facility fund allocation must be a float");
        }
        $sqlInsertSpecFacility = $conn->prepare("INSERT INTO Outpatient VALUES (?,?,?)");
        $sqlInsertSpecFacility->bind_param("sss", $year, $country, $allocation);
        $specTable = "<tr><th> Year </th><th> Country </th> <th>  Allocation to Mental Health ($ Millions) </th></tr>
        <tr><td>".$year."</td><td>".$country."</td><td>".$allocation."</td></tr>";
      } else if ($type == "mental health unit") {
        $allocation = $_POST['allocation2'];
        $rehab = $_POST['rehab'];
        $prescription = $_POST['prescription'];
        if (!is_numeric($allocation) || !is_float(floatval($allocation))) {
          throw new Exception("Facility fund allocation must be a float");
        }
        if (!is_numeric($prescription) || !is_int(intval($prescription))) {
          throw new Exception("Facility fund allocation must be a int");
        }
        if (!is_numeric($rehab) || !is_int(intval($rehab))) {
          throw new Exception("Facility fund allocation must be a int");
        }
        $sqlInsertSpecFacility = $conn->prepare("INSERT INTO General_Hospital VALUES (?,?,?,?,?)");
        $sqlInsertSpecFacility->bind_param("sssss", $year, $country, $rehab, $allocation, $prescription);
        $specTable = "<tr><th> Year </th><th> Country </th> <th>  Rehab Patients (Millions) </th>  <th>  Allocation to Mental Health ($ Millions) </th><th> Total Prescription Count (Millions) </th></tr>
        <tr><td>".$year."</td><td>".$country."</td><td>".$rehab."</td><td>".$allocation."</td><td>".$prescription."</td></tr>";
      } else if ($type == "day treatment facility") {
        $closing = $_POST['closing'];
        $da = $_POST['da'];
        $nda = $_POST['nda'];
        if (!is_numeric($da) || !is_float(floatval($da))) {
          throw new Exception("Drug/Alcohol Count must be a float");
        }
        if (!is_numeric($closing) || !is_int(intval($closing))) {
          throw new Exception("Average closing time must be a int");
        }
        if (!is_numeric($nda) || !is_float(floatval($nda))) {
          throw new Exception("Non Drug/Alcohol Count must be a float");
        }
        $sqlInsertSpecFacility = $conn->prepare("INSERT INTO Day_Treatment VALUES (?,?,?,?,?)");
        $sqlInsertSpecFacility->bind_param("sssss", $year, $country, $closing, $nda, $da);
        $specTable = "<tr><th> Year </th><th> Country </th> <th> Average Closing Time </th> <th> Drug/Alcohol Prescription Percentage </th><th> Non-Drug/Alcohol Prescription Percentage </th></tr>
        <tr><td>".$year."</td><td>".$country."</td><td>".$closing."</td><td>".$da."</td><td>".$nda."</td></tr>";
      }
      
      $sqlInsertFacility->execute();
      $sqlInsertSpecFacility->execute();
      $sqlInsertLedger->execute();
      echo "<h2>Successfully Inserted</h2><br>";
      echo "<h3>Facility</h3><br>";
      echo "<table border=\"1px solid black\">";
      echo "<tr><th> Facility Type </th> <th> Year </th> <th> Country </th> <th> Patient  Stay Duration (Days) </th> <th> Cost ($10 Million) </th> <th> Facility Unit Count (Thousands) </th></tr>";
      echo "<tr><td>".$type."</td><td>".$year."</td><td>".$country."</td><td>".$stay."</td><td>".$cost."</td><td>".$count."</td></tr></table>";
      echo "<h3>Patient Ledger</h3><br>";
      echo "<table border=\"1px solid black\">";
      echo "<tr><th> Facility Type </th> <th> Year </th> <th> Country </th> <th>  Patient Cost ($1000) </th> <th>  Diagnosis County (Million) </th> <th>  Patient Count (Millions) </th></tr>";
      echo "<tr><td>".$type."</td><td>".$year."</td><td>".$country."</td><td>".$patient_cost."</td><td>".$diagnoses."</td><td>".$patient_count."</td></tr></table>";
      echo "<h3>".$type."</h3><br>";
      echo "<table border=\"1px solid black\">";
      echo $specTable."</table>";
      $sqlInsertSpecFacility->close();
    } catch(Exception $e) {
      echo "ERROR: ".$e;
    }
      
    //close the connection opened by open.php since we no longer need access to dbase
    $sqlInsertFacility->close();
    $sqlInsertLedger->close();
    $conn->close();
  ?>
</body>