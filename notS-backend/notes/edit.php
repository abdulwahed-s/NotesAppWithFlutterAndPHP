<?php
include "../connect.php";

$notesid = superFilter("id");
$title = superFilter("title");
$content = superFilter("content");
$imagename = isset($_POST['imagename']) ? superFilter('imagename') : '';

if (isset($_FILES['file'])) {
    imgdel("../upload", $imagename);
    $imagename = imageUpload("file");
}

$stmt = $con->prepare("
    UPDATE `notes` SET `notes_title`= ?, `notes_content`= ?, `notes_img` = ? WHERE notes_id = ?
");

$stmt->execute(array($title, $content, $imagename, $notesid));

$count = $stmt->rowCount();

if ($count > 0) {
    echo json_encode(array("status" => "success"));
} else {
    echo json_encode(array("status" => "fail"));
}
?>