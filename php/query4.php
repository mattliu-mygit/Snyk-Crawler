<head><title>male and female suicide rates in a given year</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	// collect the posted value in a variable called $item
	$year = $_POST['year'];
         echo "<h2>";
         echo "number of male and female suicide in ";
         echo $year;
         echo " for each country";
         echo "</h2>";
	$dataPoints = array();

	if (!empty($year)) {
      if ($result = $conn->query("CALL ShowMaleFemaleSuicideRates('".$year."');")) {
         foreach($result as $row) {
            if ($row["Error"] == NULL and count($row) == 1) {
               echo "ERROR: Year " .$year. " not found.";
               return;
            }
            array_push($dataPoints, array(array ( "label" => $row["country"], "y" => $row["number_of_male_suicides"]), array ( "label" => $row["country"], "y" => $row["number_of_female_suicides"])));
						// print_r($dataPoints);
         }
        
      } else {
        echo "Call to ShowMaleFemaleSuicideRates failed<br>";
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
	$transformed = new Array();
	for (var i = 0; i < $dataPoints.length; i++) {
		array_push($transformed, {       
			type: "stackedColumn",  
			dataPoints: <?php echo json_encode($dataPoints[i], JSON_NUMERIC_CHECK); ?>
		});
	}
	
	// for (var i = 0; i < $dataPoints.length; i++) {
	// 	echo $transformed[i]["type"];
	// }

var chart = new CanvasJS.Chart("chartContainer", {
	animationEnabled: true,
	theme: "light2", // "light1", "light2", "dark1", "dark2"
	title:{
		text: "Number of Suicides for Males and Females in Each Country"
	},
	axisY: {
		title: "Number of Suicides"
	},
   axisX: {
	   	interval: 1,
		labelAngle: 280,
		title: "Country"
	},
	data: transformed
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