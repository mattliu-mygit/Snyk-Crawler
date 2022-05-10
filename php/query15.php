<head><title>countries with highest suicide rates</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	// collect the posted value in a variable called $item
	$num = $_POST['num'];
         echo "<h2>";
         echo "top ";
         echo $num;
         echo " countries with the highest suicide rates in 2016";
         echo "</h2>";
	$dataPoints = array();

	if (!empty($num)) {
      if ($result = $conn->query("CALL ShowTopCountrySuicides('".$num."');")) {
         foreach($result as $row) {
            if ($row["Error"] == NULL and count($row) == 1) {
               echo "ERROR: Number " .$num. " is invalid.";
               return;
            }
            array_push($dataPoints, array ( "label" => $row["country"], "y" => $row["average_number_of_suicides"]));
         }
        
      } else {
        echo "Call to ShowTopCountrySuicides failed<br>";
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
		text: "Suicide Rates for Countries in 2016"
	},
	axisY: {
		title: "Number of Suicides"
	},
   axisX: {
        interval: 1,
        labelAngle: 300,
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