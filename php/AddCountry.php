<head>
  <title>Add Country Response</title>
</head>
<body>
  <?php
    include "open.php";
	  $country = $_POST['country'];
	  $region = $_POST['region'];
	  $psychiatrists = $_POST['psychiatrists'];
	  $population = $_POST['population'];
    $sqlInsertCountry = "INSERT INTO Country VALUES ('".$country."','".$region."','".$psychiatrists."','".$population."');";
	  echo "<h2>Inserted ".$country."</h2><br>";
    try {
      // Password check.
      $passCheck = $conn->query($sqlInsertCountry);
    } catch(Exception $e) {
      echo "ERROR: country ".$country." invalid ".$e;
    }
    
      //close the connection opened by open.php since we no longer need access to dbase
      $conn->close();

  ?>
</body>