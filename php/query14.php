<head><title>resource allocation in a country</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	// collect the posted value in a variable called $item
	$country = $_POST['country'];
         echo "<h2>";
         echo "resource allocation from greatest to least for ";
         echo $country;
         echo "</h2>";
	$dataPoints = array();

	if (!empty($country)) {
      if ($result = $conn->query("CALL ShowCountryResourceAllocation('".$country."');")) {
         foreach($result as $row) {
            if ($row["Error"] == NULL and count($row) == 1) {
               echo "ERROR: Country " .$country. " not found.";
               return;
            }
            array_push($dataPoints, array ( "label" => $row["facility"], "y" => $row["cost"]));
         }
        
      } else {
        echo "Call to ShowCountryResourceAllocation failed<br>";
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
		text: "Country Resource Allocation"
	},
	axisY: {
		title: "Cost (USD)"
	},
   axisX: {
		title: "Facility Type"
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