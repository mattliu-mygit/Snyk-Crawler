<head>
  <title>Add Country Response</title>
</head>
<body>
  <?php
    include "open.php";
    $sqlInsertCountry = $conn->prepare("INSERT INTO Country VALUES (?,?,?,?)");
    $sqlInsertCountry->bind_param("ssss", $country, $region, $psychiatrists, $population);
	  $country = $_POST['country'];
	  $region = $_POST['region'];
	  $psychiatrists = $_POST['psychiatrists'];
	  $population = $_POST['population'];
    try {
      if (is_null($country) || strlen($country) == 0) {
        throw new Exception("Country name cannot be empty");
      }
      if (is_null($region) || strlen($region) == 0) {
        throw new Exception("Region name cannot be empty");
      }
      if (!is_numeric($population) || !is_double(doubleval($population))) {
        throw new Exception("Population must be an double");
      }
      if (!is_numeric($psychiatrists) || !is_double(doubleval($psychiatrists))) {
        throw new Exception("Population must be an double");
      }
      try {
        $sqlInsertCountry->execute();
        echo "<h2>Successfully Inserted</h2><br>";
        echo "<table border=\"1px solid black\">";
        echo "<tr><th> Country </th> <th> Region </th> <th> Psychiatrists </th> <th> Population </th></tr>";
        echo "<tr><td>".$country."</td><td>".$region."</td><td>".$psychiatrists."</td><td>".$population."</td></tr>";
      } catch(Exception $e) {
        echo "<h2>Invalid Insertion SQL</h2> <p>ERROR:".$e."</p>";
      }
    } catch(Exception $e) {
      echo "<h2>Invalid Insertion Parameters</h2> <p>ERROR: ".$e."</p>";
    }
      //close the connection opened by open.php since we no longer need access to dbase
      $sqlInsertCountry->close();
      $conn->close();

  ?>
</body>