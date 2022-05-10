<head><title>country with greatest number of facilities</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	
      if ($result = $conn->query("CALL ShowCountryGreatestFacilities()") {
         foreach($result as $row) {
             echo $row;
         }
        
      } else {
        echo "Call to ShowFacilityAvailability failed<br>";
      }
	$conn->close();

?>
</body>