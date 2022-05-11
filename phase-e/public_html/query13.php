<head><title>facility with least suicides</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';
   if($stmt = $conn->prepare ("CALL ShowFacilityLowestSuicide()")) {
	    echo "<h2>";
        echo "spending more on what facility will lead to a lower suicide rate";
        echo "</h2>";

	
      if ($stmt->execute()) {
         $result = $stmt->get_result();
         foreach($result as $row) {
            echo "<h3>";
            echo $row["facility_type"];
            echo ": ";
            echo $row["lowest_suicide_rate"];
            echo " suicides per 100,000";
            echo "</h3>";
         }
         $result->free_result();
      } else {
        echo "Call to ShowFacilityLowestSuicide failed<br>";
      }
      $stmt->close();
   }
	$conn->close();

?>
</body>