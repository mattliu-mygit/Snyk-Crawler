<head><title>facility with least suicides</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	    echo "<h2>";
        echo "spending more on what facility will lead to a lower suicide rate";
        echo "</h2>";

	
      if ($result = $conn->query("CALL ShowFacilityLowestSuicide();")) {
         foreach($result as $row) {
            echo "<h3>";
            echo $row["facility_type"];
            echo ": ";
            echo $row["lowest_suicide_rate"];
            echo " suicides per 100,000";
            echo "</h3>";
         }
        
      } else {
        echo "Call to ShowFacilityLowestSuicide failed<br>";
      }

	$conn->close();

?>
</body>