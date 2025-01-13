<?php
define('mb', 1048576);

function superFilter($req) {
    return htmlspecialchars(strip_tags($_POST[$req]));
}

function imageUpload($imagereq) {
    global $imgerr;
    $imagename = rand(1, 10000) . $_FILES[$imagereq]['name'];
    $imagetmp = $_FILES[$imagereq]['tmp_name'];
    $imagesize = $_FILES[$imagereq]['size'];
    $allowExt = array("jpg", "gif", "png");
    $strtoarr = explode('.', $imagename);
    $ext = end($strtoarr);

    if (!empty($imagename) && !in_array($ext, $allowExt)) {
        $imgerr[] = 'notsupported';
    }

    if ($imagesize > 10 * mb) {
        $imgerr[] = 'size';
    }

    if (empty($imgerr)) {
        move_uploaded_file($imagetmp, "../upload/" . $imagename);
        return $imagename;
    } else {
        return "fail";
    }
}

function imgdel($dir, $imgname) {
    if (!empty($imgname) && file_exists($dir . "/" . $imgname) && !is_dir($dir . "/" . $imgname)) {
        unlink($dir . "/" . $imgname);
    }
}

    function checkAuthenticate(){
        if (isset($_SERVER['PHP_AUTH_USER'])  && isset($_SERVER['PHP_AUTH_PW'])) {
    
            if ($_SERVER['PHP_AUTH_USER'] != "rey" ||  $_SERVER['PHP_AUTH_PW'] != "ils-fr-12"){
                header('WWW-Authenticate: Basic realm="My Realm"');
                header('HTTP/1.0 401 Unauthorized');
                echo 'Page Not Found';
                exit;
            }
        } else {
            exit;
        };};
    