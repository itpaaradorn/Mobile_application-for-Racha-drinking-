<?php
header("content-type:text/javascript;charset=utf-8");
error_reporting(0);
error_reporting(E_ERROR | E_PARSE);
$link = mysqli_connect('localhost', 'root', '', "WaterShop");

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
				
		$Name = $_GET['Name'];
		$User = $_GET['User'];
		$Password = $_GET['Password'];
		$ChooseType = $_GET['ChooseType'];
		$Phone = $_GET['Phone'];
		$Address = $_GET['Address'];
		$UrlPicture = $_GET['UrlPicture'];
		$Lat = $_GET['Lat'];
		$Lng = $_GET['Lng'];


		$sql = "INSERT INTO `usertable`(`id`, `ChooseType`, `Name`, `User`, `Password`, `Address`, `Phone`, `UrlPicture`, `Lat`, `Lng`, `Token`) VALUES (Null,'$ChooseType','$Name','$User','$Password','$Address','$Phone','$UrlPicture','$Lat','$Lng','')";
							
		// $sql = "INSERT INTO `userTABLE`(`id`, `ChooseType`, `Name`, `User`, `Password`, `NameShop`, `Address`, `Phone`, `Urlpicture`, `Lat`, `Lng`, `Token`) VALUES (Null, '$ChooseType', '$Name','$User','$Password','','$Address','$Phone','$Urlpicture','$Lat','$Lng','')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Whaasfgdhsfjdgster Shop";
   
}
	mysqli_close($link);
?>