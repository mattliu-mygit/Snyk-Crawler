<head>
  <title>Delete Country Response</title>
</head>
<body>
  <?php
    include "open.php";
    $sqlDeleteCountry = $conn->prepare("DELETE FROM Country WHERE name=?;");
    $sqlDeleteCountry->bind_param("s", $country);
	  $country = $_POST['country'];
    try {
      if (is_null($country) || strlen($country) == 0) {
        throw new Exception("Country name cannot be empty");
      }
      try {
        $sqlDeleteCountry->execute();
        echo "<h2>Successfully Deleted ".$country."</h2><br>";
      } catch(Exception $e) {
        echo "<h2>Invalid Deletion SQL</h2> <p>ERROR:".$e."</p>";
      }
    } catch(Exception $e) {
      echo "<h2>Invalid Deletion Parameters</h2> <p>ERROR: ".$e."</p>";
    }
      //close the connection opened by open.php since we no longer need access to dbase
      $sqlDeleteCountry->close();
      $conn->close();

  ?>
</body>