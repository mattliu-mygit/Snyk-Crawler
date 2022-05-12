<head><title>region with the highest suicide rate</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';
   if($stmt = $conn->prepare ("CALL ShowRegionHighestSuicide()")) {
	    echo "<h2>";
        echo "region with the highest suicide rate";
        echo "</h2>";

	
      if ($stmt->execute()) {
         $result = $stmt->get_result();
         foreach($result as $row) {
            echo "<h3>";
            echo $row["region"];
            echo ": ";
            echo $row["max_suicide_rate"];
            echo " per 100,000";
            echo "</h3>";
         }
         $result->free_result();
      } else {
        echo "Call to ShowRegionHighestSuicide failed<br>";
      }
      $stmt->close();
   }
	$conn->close();

?>
</body>