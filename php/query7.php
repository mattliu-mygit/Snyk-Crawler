<head><title>most frequented facility</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	// collect the posted value in a variable called $item
         echo "<h2>";
         echo "most frequented facility for each country";
         echo "</h2>";
	$dataPoints = array();
        if ($result = $conn->query("CALL ShowMostFreq();")) {
            echo "<table border=\"2px solid black\">";
            echo "<tr><td>country</td><td>most visited facility</td></tr>";
            foreach($result as $row){
                  echo "<tr>";
                  echo "<td>".$row["country"]."</td>";
                  echo "<td>".$row["facility"]."</td>";
                  echo "</tr>";
            }
          
        } else {
          echo "Call to ShowMostFreq failed<br>";
        }
      
      $conn->close();
  
  ?>
  </body>