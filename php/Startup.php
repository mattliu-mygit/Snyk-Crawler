<head>
  <title>Startup</title>
</head>
<body>
  <?php
    include "open.php";
    try {
      $sql = file_get_contents('../processed/startup.sql');
      $passCheck = $conn->multi_query($sql);
      echo "Startup complete";
    } catch(Exception $e) {
      echo "ERROR: startup invalid ".$e;
    }
    
      //close the connection opened by open.php since we no longer need access to dbase
      $conn->close();

  ?>
</body>