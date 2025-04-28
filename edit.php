<?php
$pdo = new PDO('mysql:host=localhost;dbname=Projd', 'root', '');

$stmt = $pdo->prepare("UPDATE Crime SET Crime_Type = ?, Crime_Location = ?, Crime_Date_Time = ?, Status = ? WHERE Crime_ID = ?");
$stmt->execute([
  $_POST['crime_type'],
  $_POST['crime_location'],
  $_POST['crime_datetime'],
  $_POST['status'],
  $_POST['crime_id']
]);

// Update Cases status too
$stmt = $pdo->prepare("UPDATE Cases SET Case_Status = ? WHERE Crime_ID = ?");
$stmt->execute([
  $_POST['status'],
  $_POST['crime_id']
]);
?>
