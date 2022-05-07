<head>
  <title>Add Country Response</title>
</head>
<body>
  <?php
    include "open.php";
	  $country = $_POST['country'];
	  $year = $_POST['year'];
	  $sex = $_POST['sex'];
	  $rates = $_POST['rates'];
    $sqlInsertSuicideRate = $conn->prepare("INSERT INTO Suicide_Rates VALUES (?,?,?,?)");
    $sqlInsertSuicideRate->bind_param("ssss", $year, $country, $sex, $rates);
    $sqlFindCountry = $conn->prepare("SELECT * FROM Country WHERE name=?;");
    $sqlFindCountry->bind_param("s",$country);
    try{
      if (is_null($country) || strlen($country) == 0) {
        throw new Exception("Country name cannot be empty");
      }
      if (!is_numeric($year) || !is_int(intval($year))) {
        throw new Exception("Year must be an int");
      }
      if (is_null($sex) || strlen($sex) == 0) {
        throw new Exception("Sex cannot be empty");
      }
      if (!is_numeric($rates) || !is_float(intval($rates))) {
        throw new Exception("Suicide Rates must be a float");
      }
      $sqlInsertSuicideRate->execute();
      echo "<h2>Inserted Successfully! </h2><br>";
      echo "<table border=\"1px solid black\">";
      echo "<tr><th> Year </th> <th> Country </th> <th> Sex </th> <th> Suicide Rates </th></tr>";
      echo "<tr><td>".$year."</td><td>".$country."</td><td>".$sex."</td><td>".$rates."</td></tr>";
    } catch(Exception $e) {
      echo "ERROR: ".$e;
    }
    
    //close the connection opened by open.php since we no longer need access to dbase
    $sqlFindCountry->close();
    $sqlInsertSuicideRate->close();
    $conn->close();

  ?>
</body>