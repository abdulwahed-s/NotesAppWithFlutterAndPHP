<?php
include "../connect.php";

$notesid = superFilter("id");
$imgname = superFilter("imgname");

$stmt = $con->prepare("
DELETE FROM `notes` WHERE `notes_id` = ?
");

$stmt->execute(array($notesid));

$count = $stmt->rowCount();

if ($count > 0) {
imgdel("../upload",$imgname);
    echo json_encode(array("status" => "success"));
} else {
    echo json_encode(array("status" => "fail"));
}
