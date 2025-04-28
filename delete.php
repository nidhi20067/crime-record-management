<?php
$pdo = new PDO('mysql:host=localhost;dbname=Projd', 'root', '');

// Delete from Cases first (because of foreign key constraint)
$stmt = $pdo->prepare("DELETE FROM Cases WHERE Crime_ID = ?");
$stmt->execute([$_POST['crime_id']]);

// Then delete from Crime
$stmt = $pdo->prepare("DELETE FROM Crime WHERE Crime_ID = ?");
$stmt->execute([$_POST['crime_id']]);
?>
