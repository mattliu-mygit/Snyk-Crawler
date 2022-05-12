<head><title>country with the most facilities</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

   if($stmt = $conn->prepare ("CALL ShowCountryGreatestFacilities()")) {
	    echo "<h2>";
        echo "country with the most facilities";
        echo "</h2>";

	
      if ($stmt->execute()) {
         $result = $stmt->get_result();
         foreach($result as $row) {
            echo "<h3>";
            echo $row["country"];
            echo ": ";
            echo $row["greatest_amount"];
            echo " facilities";
            echo "</h3>";
         }
         $result->free_result();
      } else {
        echo "Call to ShowCountryGreatestFacilities failed<br>";
      }
      $stmt->close();
   }
	$conn->close();

?>
</body>