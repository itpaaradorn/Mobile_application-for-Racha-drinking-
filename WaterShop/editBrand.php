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
			
		$brand_id = $_GET['brand_id'];	
		$brand_name = $_GET['brand_name'];
		$brand_image = $_GET['brand_image'];

		
							
		$sql = "UPDATE `brandwater` SET `brand_id`='$brand_id',`brand_name`='$brand_name',`brand_image`='$brand_image' WHERE brand_id = '$brand_id'";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome watershop";
   
}

	mysqli_close($link);
?>