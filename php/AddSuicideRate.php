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
    $sqlInsertSuicideRate = "INSERT INTO Suicide_Rates VALUES ('".$year."','".$country."','".$sex."','".$rates."');";
	  echo "<h2>Inserted ".$sex."</h2><br>";
    try {
      // Password check.
      $passCheck = $conn->query($sqlInsertSuicideRate);
    } catch(Exception $e) {
      echo "ERROR: rate ".$sex." invalid ".$e;
    }
    
      //close the connection opened by open.php since we no longer need access to dbase
      $conn->close();

  ?>
</body>