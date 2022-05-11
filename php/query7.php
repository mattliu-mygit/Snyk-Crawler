<head><title>most frequented facility</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	if($stmt = $conn->prepare ("CALL ShowMostFreq()")) {
         echo "<h2>";
         echo "most frequented facility for each country";
         echo "</h2>";
	$dataPoints = array();
        if ($stmt->execute()) {
            $result = $stmt->get_result();
            echo "<table border=\"2px solid black\">";
            echo "<tr><td>country</td><td>most visited facility</td></tr>";
            foreach($result as $row){
                  echo "<tr>";
                  echo "<td>".$row["country"]."</td>";
                  echo "<td>".$row["facility"]."</td>";
                  echo "</tr>";
            }
            $result->free_result();
        } else {
          echo "Call to ShowMostFreq failed<br>";
        }
        $stmt->close();
  }    
      $conn->close();
  
  ?>
  </body>