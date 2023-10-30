<?php
header("content-type:text/javascript;charset=utf-8");
error_reporting(0);
error_reporting(E_ERROR | E_PARSE);
$link = mysqli_connect('localhost', 'root', '', "watershop");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}


if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
			
		$id = $_GET['id'];		
		$UrlPicture = $_GET['UrlPicture'];
		$Name = $_GET['Name'];
		$User = $_GET['User'];
		$Password = $_GET['Password'];
		$Phone = $_GET['Phone'];
		$Address = $_GET['Address'];
		$Lat = $_GET['Lat'];
		$Lng = $_GET['Lng'];
		
		
							
		$sql = "UPDATE `userTABLE` SET `UrlPicture` = '$UrlPicture', `Name` = '$Name', `User` = '$User', `Password` = '$Password', `Address` = '$Address', `Phone` = '$Phone', `Lat` = '$Lat', `Lng` = '$Lng' WHERE id = '$id'";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome editProfilelocation";
   
}

	mysqli_close($link);
?>