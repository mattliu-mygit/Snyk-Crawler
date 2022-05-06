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
    try {
      if ($type == "mental hospital") {
        $sqlInsertSpecFacility = $conn->prepare("INSERT INTO Mental_Hospital VALUES (?,?,?,?,?)");
        $sqlInsertSpecFacility->bind_param("sssss", $year, $country, $ptsd_count, $depression_count, $insanity_count);
        $ptsd_count = $_POST['ptsd_count'];
        $depression_count = $_POST['depression_count'];
        $insanity_count = $_POST['insanity_count'];
      } else if ($type == "outpatient facility") {
        $sqlInsertSpecFacility = $conn->prepare("INSERT INTO Outpatient VALUES (?,?,?)");
        $sqlInsertSpecFacility->bind_param("sss", $year, $country, $allocation);
        $allocation = $_POST['allocation1'];
      } else if ($type == "mental health unit") {
        $sqlInsertSpecFacility = $conn->prepare("INSERT INTO General_Hospital VALUES (?,?,?,?,?)");
        $sqlInsertSpecFacility->bind_param("sssss", $year, $country, $rehab, $allocation, $prescription);
        $allocation = $_POST['allocation2'];
        $rehab = $_POST['rehab'];
        $prescription = $_POST['prescription'];
      } else if ($type == "day treatment facility") {
        $sqlInsertSpecFacility = $conn->prepare("INSERT INTO General_Hospital VALUES (?,?,?,?,?)");
        $sqlInsertSpecFacility->bind_param("sssss", $year, $country, $closing, $nda, $da);
        $closing = $_POST['closing'];
        $da = $_POST['da'];
        $nda = $_POST['nda'];
      } else {
        throw new Exception("Invalid facility type");
      }
    } catch(Exception $e) {
      echo "ERROR: type ".$type." invalid ".$e;
    }
	  echo "<h2>Inserted ".$type."</h2><br>";
    try {
      $sqlInsertFacility->execute();
      $sqlInsertSpecFacility->execute();
      $sqlInsertLedger->execute();
    } catch(Exception $e) {
      echo "ERROR: type ".$type." invalid ".$e;
    }
    
      //close the connection opened by open.php since we no longer need access to dbase
      $sqlInsertFacility->close();
      $sqlInsertLedger->close();
      $sqlInsertSpecFacility->close();
      $conn->close();

  ?>
</body>