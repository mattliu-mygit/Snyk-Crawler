<head><title>patient count for all facilities</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	if($stmt = $conn->prepare ("CALL ShowTotalPatientsFacility(?)")) {
	$num = $_POST['num'];
	$stmt->bind_param('i', $num);
         echo "<h2>";
         echo "total patient count for countries with less than ";
         echo $num;
         echo " patients";
         echo "</h2>";
	$dataPoints = array();

	if (!empty($num)) {
      if ($stmt->execute()) {
		$result = $stmt->get_result();
         foreach($result as $row) {
            if ($row["Error"] == NULL and count($row) == 1) {
               echo "ERROR: There are no countries with a total patient count for all facilities below " .$num."";
               return;
            }
            array_push($dataPoints, array ( "label" => $row["country"], "y" => $row["count"]));
         }
		 $result->free_result();
      } else {
        echo "Call to ShowTotalPatientsFacility failed<br>";
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
		text: "Total Patient Count of All Facilities for Countries"
	},
	axisY: {
		title: "Total Patients"
	},
   axisX: {
        interval: 1,
        labelAngle: 290,
		title: "Country"
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