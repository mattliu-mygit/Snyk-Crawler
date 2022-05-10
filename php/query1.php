<head><title>country with the most facilities</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	    echo "<h2>";
        echo "country with the most facilities";
        echo "</h2>";

	
      if ($result = $conn->query("CALL ShowCountryGreatestFacilities();")) {
         foreach($result as $row) {
            echo "<h3>";
            echo $row["country"];
            echo ": ";
            echo $row["greatest_amount"];
            echo " facilities";
            echo "</h3>";
         }
        
      } else {
        echo "Call to ShowCountryGreatestFacilities failed<br>";
      }

	$conn->close();

?>
</body>