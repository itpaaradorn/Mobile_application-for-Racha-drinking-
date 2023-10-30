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
		
        $slip_date_time = $_GET['slip_date_time'];
        $image_slip = $_GET['image_slip'];
        $order_id = $_GET['order_id'];
        $user_id = $_GET['user_id'];
        $user_name = $_GET['user_name'];
		$total = $_GET['total'];
        $emp_id = $_GET['emp_id'];
        		
		// $sql = "INSERT INTO `payment`(`pay_id`, `slip_date_time`, `image_slip`, `order_id`, `user_id`, `user_name`, `total`, `emp_id`) VALUES (Null,'$slip_date_time','$image_slip','$order_id','$user_id','$user_name','$total','$emp_id')";

		$sql = "INSERT INTO `payment`(`pay_id`, `slip_date_time`, `image_slip`, `order_id`, `user_id`, `user_name`, `total`, `emp_id`) VALUES (Null,'$slip_date_time','$image_slip','$order_id','$user_id','$user_name','$total','$emp_id')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Add Payment_EMP";
   
}
	mysqli_close($link);
?>