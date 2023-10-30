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


if ($_SERVER['REQUEST_METHOD'] === 'PUT') {

	$value = json_decode(file_get_contents("php://input"), true);
			
		$order_id = $value['order_id'];		
		$status = $value['status'];
		$emp_id = $value['emp_id'];

		$sql = "UPDATE `ordertable` SET `status` = '$status',`emp_id` = '$emp_id' WHERE id = '$order_id'";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "update status where orderId";
   
	mysqli_close($link);
?>