<head><title>overnight stay in a given region</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	if($stmt = $conn->prepare ("CALL ShowAverageStayRegion(?)")) {
	$region = $_POST['region'];
	$stmt->bind_param('s', $region);
         echo "<h2>";
         echo "overnight stay average for facitilies with overnight capactiy in ";
         echo $region;
         echo "</h2>";
	$dataPoints = array();

	if (!empty($region)) {
      if ($stmt->execute()) {
		$result = $stmt->get_result();
         foreach($result as $row) {
            if ($row["Error"] == NULL and count($row) == 1) {
               echo "ERROR: Region " .$region. " not found.";
               return;
            }
            array_push($dataPoints, array ( "label" => "mental health units", "y" => $row["mental_health_units_avg_stay"]));
            array_push($dataPoints, array ( "label" => "mental hospital", "y" => $row["mental_hospital_avg_stay"]));
         }
		 $result->free_result();
      } else {
        echo "Call to ShowAverageStayRegion failed<br>";
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
		text: "Average Stay"
	},
	axisY: {
		title: "Average Stay (days)"
	},
   axisX: {
		title: "Facility"
	},
	data: [{        
		type: "column",  
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