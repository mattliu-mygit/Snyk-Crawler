<head><title>average patient spending</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	// collect the posted value in a variable called $item
    if ($stmt = $conn->prepare("CALL ShowAverageSpending()")) {
         echo "<h2>";
         echo "average patient spending on mental health for each country";
         echo "</h2>";
	$dataPoints = array();
        if ($stmt->execute()) {
            $result = $stmt->get_result();
           foreach($result as $row) {
              array_push($dataPoints, array ( "label" => $row["country"], "y" => $row["cost"]));
           }
           $result->free_result();
        } else {
          echo "Call to ShowAverageSpending failed<br>";
        }
        $stmt->close();
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
          text: "Average Patient Spending for Mental Health"
      },
      axisY: {
          title: "Total Patient Spending"
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