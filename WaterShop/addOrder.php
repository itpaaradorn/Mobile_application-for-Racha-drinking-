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
				
		$orderDateTime = $_GET['orderDateTime'];
		$user_id = $_GET['user_id'];
		$user_name = $_GET['user_name'];
		$water_id = $_GET['water_id'];
		$water_brand_id = $_GET['water_brand_id'];
		$size = $_GET['size'];
		$distance = $_GET['distance'];
		$transport = $_GET['transport'];
		$water_brand_name = $_GET['water_brand_name'];
		$price = $_GET['price'];
		$amount = $_GET['amount'];
		$sum = $_GET['sum'];
		$riderId = $_GET['riderId'];
		$pamentStatus = $_GET['pamentStatus'];
		$status = $_GET['status'];
							
		$sql = "INSERT INTO `ordertable`(`orderId`, `orderDateTime`, `user_id`, `user_name`, `water_id`, `water_brand_id`, `size`, `distance`, `transport`, `water_brand_name`, `price`, `amount`, `sum`, `riderId`, `pamentStatus`, `status`) VALUES ('Null','$orderDateTime','$user_id','$user_name','$water_id','$water_brand_id','$size','$distance','$transport','$water_brand_name','$price','$amount','$sum','$riderId','$pamentStatus','$status')";

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