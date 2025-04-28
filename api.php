<?php
header('Content-Type: application/json');

$host = "127.0.0.1";
$user = "root";
$pass = "Password@123";
$dbname = "projd";

$conn = new mysqli($host, $user, $pass, $dbname);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Fetch all required data

// Crimes
$crimes = $conn->query("
SELECT c.Crime_ID, c.Crime_Type, c.Crime_Location, c.Crime_Date_Time, c.Status,
       p.Name AS Officer_Name, po.Officer_Rank
FROM Crime c
JOIN Cases cs ON c.Crime_ID = cs.Crime_ID
JOIN Police_Officer po ON cs.Assigned_Officer = po.Officer_ID
JOIN Person p ON po.Officer_ID = p.Person_ID
")->fetch_all(MYSQLI_ASSOC);

// Criminals
$criminals = $conn->query("
SELECT p.Name AS Criminal_Name, c.Crime_Type, c.Crime_Location, cr.Arrest_Status
FROM Criminal cr
JOIN Person p ON cr.Criminal_ID = p.Person_ID
JOIN Crime c ON cr.Crime_ID = c.Crime_ID
")->fetch_all(MYSQLI_ASSOC);

// Victims
$victims = $conn->query("
SELECT p.Name, v.Injuries, v.Compensation_Status, c.Crime_Type
FROM Victim v
JOIN Person p ON v.Victim_ID = p.Person_ID
JOIN Crime c ON v.Crime_ID = c.Crime_ID
")->fetch_all(MYSQLI_ASSOC);

// Evidence
$evidence = $conn->query("
SELECT e.Description, e.Storage_Location, c.Crime_Type, p.Name AS Collected_By
FROM Evidence e
JOIN Crime c ON e.Crime_ID = c.Crime_ID
JOIN Police_Officer po ON e.Collected_By = po.Officer_ID
JOIN Person p ON po.Officer_ID = p.Person_ID
")->fetch_all(MYSQLI_ASSOC);

// Under Investigation
$under_investigation = $conn->query("
SELECT Crime_ID, Crime_Type, Crime_Date_Time, Status
FROM Crime
WHERE Status = 'Under Investigation'
")->fetch_all(MYSQLI_ASSOC);

echo json_encode([
    "crimes" => $crimes,
    "criminals" => $criminals,
    "victims" => $victims,
    "evidence" => $evidence,
    "under_investigation" => $under_investigation
]);

$conn->close();
?>
<?php
$pdo = new PDO('mysql:host=localhost;dbname=Projd', 'root', '');

$stmt = $pdo->query("
SELECT c.Crime_ID, c.Crime_Type, c.Crime_Location, c.Crime_Date_Time, c.Status,
       p.Name AS Officer_Name, po.Officer_Rank
FROM Crime c
JOIN Cases cs ON c.Crime_ID = cs.Crime_ID
JOIN Police_Officer po ON cs.Assigned_Officer = po.Officer_ID
JOIN Person p ON po.Officer_ID = p.Person_ID
");

echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
?>
