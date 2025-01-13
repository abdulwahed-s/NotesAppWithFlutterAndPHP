<?php
include "../connect.php";

$username = superFilter("username");
$password = superFilter("password");

$stmt = $con->prepare("
SELECT * FROM `users` WHERE `username` = ? AND `password` = ? 
");

$stmt->execute(array($username, $password));

$data = $stmt->fetch(PDO::FETCH_ASSOC);

$count = $stmt->rowCount();

if ($count > 0) {
    echo json_encode(array("status" => "success", "data" => $data));
} else {
    echo json_encode(array("status" => "fail"));
};
