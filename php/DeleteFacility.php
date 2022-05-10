<head>
  <title>Delete Facility Response</title>
</head>
<body>
  <?php
    include "open.php";
    $sqlDeleteFacility = $conn->prepare("DELETE FROM Facility WHERE country=? AND year=? AND facility_type=?;");
    $sqlDeleteFacility->bind_param("sss", $country, $year, $type);
    $sqlDeleteLedger = $conn->prepare("DELETE FROM Patient_Ledger WHERE country=? AND year=? AND facility_type=?;");
    $sqlDeleteLedger->bind_param("sss", $country, $year, $type);
    $sqlDeleteSpecFacility;
    try{
      $country = $_POST['country'];
      $type = $_POST['type'];
      $year = $_POST['year'];
      if (is_null($country) || strlen($country) == 0) {
        throw new Exception("Country name cannot be empty");
      }
      if (is_null($type) || strlen($type) == 0) {
        throw new Exception("Facility type name cannot be empty");
      }
      if (!is_numeric($year) || !is_int(intval($year))) {
        throw new Exception("Year must be an int");
      }
      if ($type == "mental hospital") {
        $sqlDeleteSpecFacility = $conn->prepare("DELETE FROM Mental_Hospital WHERE country=? AND year=?;");
        $sqlDeleteSpecFacility->bind_param("ss", $country, $year);
      } else if ($type == "outpatient facility") {
        $sqlDeleteSpecFacility = $conn->prepare("DELETE FROM Outpatient WHERE country=? AND year=?;");
        $sqlDeleteSpecFacility->bind_param("ss", $country, $year);
      } else if ($type == "mental health unit") {
        $sqlDeleteSpecFacility = $conn->prepare("DELETE FROM General_Hospital WHERE country=? AND year=?;");
        $sqlDeleteSpecFacility->bind_param("ss", $country, $year);
      } else if ($type == "day treatment facility") {
        $sqlDeleteSpecFacility = $conn->prepare("DELETE FROM Day_Treatment WHERE country=? AND year=?;");
        $sqlDeleteSpecFacility->bind_param("ss", $country, $year);
      }
      
      $sqlDeleteSpecFacility->execute();
      $sqlDeleteLedger->execute();
      $sqlDeleteFacility->execute();
      echo "<h2>Successfully Deleted ".$type.", ".$country.", ".$year." Facility, Patient Ledger, and the specific facility type tuple</h2><br>";
      $sqlDeleteSpecFacility->close();
    } catch(Exception $e) {
      echo "ERROR: ".$e;
    }
      
    //close the connection opened by open.php since we no longer need access to dbase
    $sqlDeleteFacility->close();
    $sqlDeleteLedger->close();
    $conn->close();
  ?>
</body>