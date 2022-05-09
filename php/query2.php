<head><title>facility availability for each region</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	// collect the posted value in a variable called $item
	$fac = $_POST['facility_type'];
         echo "<h2>";
         echo $fac;
         echo " availability per region";
         echo "</h2>";
	$dataPoints = array();

	if (!empty($fac)) {
      if ($result = $conn->query("CALL ShowFacilityAvailability('".$fac."');")) {
         foreach($result as $row) {
            if ($row["Error"] == NULL and count($row) == 1) {
               echo "ERROR: Facility type " .$fac. " not found.";
               return;
            }
            array_push($dataPoints, array ( "label" => $row["region"], "y" => $row["available_units"]));
         }
        
      } else {
        echo "Call to ShowFacilityAvailability failed<br>";
      }
	} else {
	   echo "not set";
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
		text: "Facility Availability"
	},
	axisY: {
		title: "Number of Units"
	},
   axisX: {
		title: "Region"
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

