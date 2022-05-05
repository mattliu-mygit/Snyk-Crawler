<head>
  <title>Cleanup</title>
</head>
<body>
  <?php
    include "open.php";
    try {
      $sql = file_get_contents('../processed/cleanup.sql');
      $passCheck = $conn->multi_query($sql);
      echo "Cleanup complete";
    } catch(Exception $e) {
      echo "ERROR: cleanup invalid ".$e;
    }
    
      //close the connection opened by open.php since we no longer need access to dbase
      $conn->close();

  ?>
</body>