<?php
$host = "127.0.0.1";
$user = "root";
$pass = "Password@123";
$dbname = "projd";

$conn = new mysqli($host, $user, $pass, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$Crime_ID = $_POST['Crime_ID'];
$Crime_Type = $_POST['Crime_Type'];
$Crime_Date_Time = $_POST['Crime_Date_Time'];
$Crime_Location = $_POST['Crime_Location'];
$Description = $_POST['Description'];
$Status = $_POST['Status'];

$stmt = $conn->prepare("INSERT INTO Crime (Crime_ID, Crime_Type, Crime_Date_Time, Crime_Location, Description, Status) VALUES (?, ?, ?, ?, ?, ?)");
$stmt->bind_param("isssss", $Crime_ID, $Crime_Type, $Crime_Date_Time, $Crime_Location, $Description, $Status);

if ($stmt->execute()) {
    echo "New crime added successfully!";
} else {
    echo "Error: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>
<?php
$pdo = new PDO('mysql:host=localhost;dbname=Projd', 'root', '');

$stmt = $pdo->prepare("INSERT INTO Crime (Crime_Type, Crime_Location, Crime_Date_Time, Description, Status) VALUES (?, ?, ?, ?, ?)");
$stmt->execute([
  $_POST['crime_type'],
  $_POST['crime_location'],
  $_POST['crime_datetime'],
  $_POST['description'],
  $_POST['status']
]);

$crimeId = $pdo->lastInsertId();

// Also insert into Cases table
$stmt = $pdo->prepare("INSERT INTO Cases (Crime_ID, Assigned_Officer, Case_Status) VALUES (?, ?, ?)");
$stmt->execute([
  $crimeId,
  $_POST['officer_id'],
  $_POST['status']
]);
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

?>
