<head>
  <title>Startup</title>
</head>
<body>
  <?php
    include "open.php";
    try {
      $sql = file_get_contents('../processed/startup.sql');
      // echo $sql;
      $result = $conn->multi_query($sql); 
      echo $result;
      // $conn->close();
      // include "open.php";     
      // $conn->multi_query("LOAD DATA LOCAL INFILE './country.csv' INTO TABLE Country FIELDS TERMINATED BY ',';LOAD DATA LOCAL INFILE './suicide.csv' INTO TABLE Suicide_Rates FIELDS TERMINATED BY ',';LOAD DATA LOCAL INFILE './facility.csv' INTO TABLE Facility FIELDS TERMINATED BY ',';");
      echo "Startup complete";
    } catch(Exception $e) {
      echo "ERROR: startup invalid ".$e;
    }
    
      //close the connection opened by open.php since we no longer need access to dbase
      $conn->close();

  ?>
</body>