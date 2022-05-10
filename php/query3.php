<head><title>country with the most psychiatrists in a given region</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	// collect the posted value in a variable called $item
	$region = $_POST['region'];
         echo "<h2>";
         echo "country with the most psychiatrists in ";
         echo $region;
         echo "</h2>";

	if (!empty($region)) {
      if ($result = $conn->query("CALL ShowMaxPsychiatrists('".$region."');")) {
         foreach($result as $row) {
            if ($row["Error"] == NULL and count($row) == 1) {
               echo "ERROR: Region " .$region. " not found.";
               return;
            }
            echo "<h3>";
            echo $row["name"];
            echo "</h3>";
         }
        
      } else {
        echo "Call to ShowMaxPsychiatrists failed<br>";
      }
	} else {
	   echo "not set";
	}
	$conn->close();

?>
</body>