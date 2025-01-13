<?php
include "../connect.php";

$username = superFilter("username");
$email = superFilter("email");
$password = superFilter("password");

$stmt = $con->prepare("
INSERT INTO `users`(`username`, `email`, `password`) VALUES (?,?,?)
");

$stmt->execute(array($username, $email, $password));

$count = $stmt->rowCount();

if ($count > 0) {
    // Get the ID of the newly inserted user
    $userId = $con->lastInsertId();

    // Prepare the data to send back in the response
    $data = array(
        "id" => $userId,
        "username" => $username,
        "email" => $email,
        // "password" => $password, // Optional: Typically, you wouldn't include the password in the response.
    );

    echo json_encode(array("status" => "success", "data" => $data));
} else {
    echo json_encode(array("status" => "fail"));
}
