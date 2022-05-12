<head><title>country with the most psychiatrists in a given region</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	if($stmt = $conn->prepare ("CALL ShowMaxPsychiatrists(?)")) {
	$region = $_POST['region'];
   $stmt->bind_param('s', $region);
         echo "<h2>";
         echo "country with the most psychiatrists in ";
         echo $region;
         echo "</h2>";

	if (!empty($region)) {
      if ($stmt->execute()) {
         $result = $stmt->get_result();
         foreach($result as $row) {
            if ($row["Error"] == NULL and count($row) == 1) {
               echo "ERROR: Region " .$region. " not found.";
               return;
            }
            echo "<h3>";
            echo $row["name"];
            echo "</h3>";
         }
         $result->free_result();
      } else {
        echo "Call to ShowMaxPsychiatrists failed<br>";
      }
      $stmt->close();
	} else {
	   echo "not set";
	}
   }
	$conn->close();

?>
</body>