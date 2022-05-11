<head><title>region with the highest suicide rate</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	    echo "<h2>";
        echo "region with the highest suicide rate";
        echo "</h2>";

	
      if ($result = $conn->query("CALL ShowRegionHighestSuicide();")) {
         foreach($result as $row) {
            echo "<h3>";
            echo $row["region"];
            echo ": ";
            echo $row["max_suicide_rate"];
            echo " per 100,000";
            echo "</h3>";
         }
        
      } else {
        echo "Call to ShowRegionHighestSuicide failed<br>";
      }

	$conn->close();

?>
</body>