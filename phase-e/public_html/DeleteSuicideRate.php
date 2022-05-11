<head>
  <title>Delete Suicide Rate Response</title>
</head>
<body>
  <?php
    include "open.php";
    $sqlDeleteSuicideRate = $conn->prepare("DELETE FROM Suicide_Rates WHERE country=? AND year=? AND sex=?;");
    $sqlDeleteSuicideRate->bind_param("sss", $country, $year, $sex);
	  $country = $_POST['country'];
	  $year = $_POST['year'];
	  $sex = $_POST['sex'];
    try {
      if (is_null($country) || strlen($country) == 0) {
        throw new Exception("Country name cannot be empty");
      }
      if (!is_numeric($year) || !is_int(intval($year))) {
        throw new Exception("Year must be an int");
      }
      if (is_null($sex) || strlen($sex) == 0) {
        throw new Exception("Sex cannot be empty");
      }
      try {
        $sqlDeleteSuicideRate->execute();
        echo "<h2>Successfully Deleted ".$country.", ".$year.", ".$sex."</h2><br>";
      } catch(Exception $e) {
        echo "<h2>Invalid Deletion SQL</h2> <p>ERROR:".$e."</p>";
      }
    } catch(Exception $e) {
      echo "<h2>Invalid Deletion Parameters</h2> <p>ERROR: ".$e."</p>";
    }
      //close the connection opened by open.php since we no longer need access to dbase
      $sqlDeleteSuicideRate->close();
      $conn->close();

  ?>
</body>