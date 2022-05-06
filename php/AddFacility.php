<head>
  <title>Add Country Response</title>
</head>
<body>
  <?php
    include "open.php";
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
    $sqlInsertFacility = "INSERT INTO Facility VALUES ('".$type."','".$year."','".$country."','".$stay."','".$cost."','".$count."');";
    $sqlInsertLedger = "INSERT INTO Patient_Ledger VALUES ('".$type."','".$year."','".$country."','".$patient_cost."','".$diagnoses."','".$patient_count."');";
    $sqlInsertSpecFacility = "";
    try {
      if ($type == "mental hospital") {
        $ptsd_count = $_POST['ptsd_count'];
        $depression_count = $_POST['depression_count'];
        $insanity_count = $_POST['insanity_count'];
        $sqlInsertSpecFacility = "INSERT INTO Mental_Hospital VALUES ('".$year."','".$country."','".$ptsd_count."','".$depression_count."','".$insanity_count."');";
      } else if ($type == "outpatient facility") {
        $allocation = $_POST['allocation1'];
        $sqlInsertSpecFacility = "INSERT INTO Outpatient VALUES ('".$year."','".$country."','".$allocation."');";
      } else if ($type == "mental health unit") {
        $allocation = $_POST['allocation2'];
        $rehab = $_POST['rehab'];
        $prescription = $_POST['prescription'];
        $sqlInsertSpecFacility = "INSERT INTO General_Hospital VALUES ('".$year."','".$country."','".$rehab."','".$allocation."','".$prescription."');";
      } else if ($type == "day treatment facility") {
        $closing = $_POST['closing'];
        $da = $_POST['da'];
        $nda = $_POST['nda'];
        $sqlInsertSpecFacility = "INSERT INTO Day_Treatment VALUES ('".$year."','".$country."','".$closing."','".$nda."','".$da."');";
      } else {
        throw new Exception("Invalid facility type");
      }
    } catch(Exception $e) {
      echo "ERROR: type ".$type." invalid ".$e;
    }
	  echo "<h2>Inserted ".$type."</h2><br>";
    try {
      // Password check.
      $passCheck = $conn->query($sqlInsertFacility);
      $passCheck = $conn->query($sqlInsertSpecFacility);
      $passCheck = $conn->query($sqlInsertLedger);
    } catch(Exception $e) {
      echo "ERROR: type ".$type." invalid ".$e;
    }
    
      //close the connection opened by open.php since we no longer need access to dbase
      $conn->close();

  ?>
</body>