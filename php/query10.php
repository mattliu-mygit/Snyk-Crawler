<head><title>percentage patient rehabilitation</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	if($stmt = $conn->prepare ("CALL ShowPatientRehabilitation(?)")) {
	$country = $_POST['country'];
   $stmt->bind_param('s', $country);
         echo "<h2>";
         echo "percentage rehabilitation of patients at general hospitals for  ";
         echo $country;
         echo "</h2>";
	$dataPoints = array();

	if (!empty($country)) {
      if ($stmt->execute()) {
         $result = $stmt->get_result();
         foreach($result as $row) {
            if ($row["Error"] == NULL and count($row) == 1) {
               echo "ERROR: Country " .$country. " not found.";
               return;
            }
            array_push($dataPoints, array ( "label" => "rehabilitated", "y" => $row["percentage_rehabilitated"]));
            array_push($dataPoints, array ( "label" => "not rehabilitated", "y" => $row["percentage_not_rehabilitated"]));
         }
         echo "<h3>";
         echo "total diagnoses: ";
         echo $row["total_patients"];
         echo "</h3>";
         $result->free_result();
      } else {
        echo "Call to ShowPatientRehabilitation failed<br>";
      }
      $stmt->close();
	} else {
	   echo "not set";
	}
   }
	$conn->close();

?>
</body>

<html>
<head>  
<script>
window.onload = function () {

var chart = new CanvasJS.Chart("chartContainer", {
	animationEnabled: true,
	theme: "light2", // "light1", "light2", "dark1", "dark2"
	title:{
		text: "Percentage of Patients Rehabilitated"
	},
	data: [{        
		type: "pie",  
		dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
	}]
});
chart.render();

}
</script>
</head>
<body>
<div id="chartContainer" style="height: 300px; width: 100%;"></div>
<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
</body>
</html>