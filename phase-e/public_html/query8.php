<head><title>total mental health allocation for countries</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	// collect the posted value in a variable called $item
	$num = $_POST['num'];
         echo "<h2>";
         echo "total mental health allocation for countries with allocations greater than ";
         echo $num;
         echo " (USD)";
         echo "</h2>";
	$dataPoints = array();

	if (!empty($num)) {
        if ($result = $conn->query("CALL ShowTotalAllocation('".$num."');")) {
           foreach($result as $row) {
              if ($row["Error"] == NULL and count($row) == 1) {
                 echo "ERROR: There are no countries with a total mental health allocation above " .$num."";
                 return;
              }
              array_push($dataPoints, array ( "label" => $row["country"], "y" => $row["mental_health_allocation"]));
           }
          
        } else {
          echo "Call to ShowTotalAllocation failed<br>";
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
          text: "Total Mental Health Allocation of Countries Above a Threshold"
      },
      axisY: {
          title: "Total Mental Health Allocation"
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