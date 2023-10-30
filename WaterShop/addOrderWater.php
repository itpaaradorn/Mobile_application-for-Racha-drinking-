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

if (isset($_POST)) {

		// foreach (json_decode(file_get_contents("php://input"), true) as $key => $value) {
				$value = json_decode(file_get_contents("php://input"), true);

				$create_by = $value['create_by'];
				$emp_id = $value['emp_id'];
				$payment_status = $value['payment_status'];
				$status = $value['status'];
				$distance = $value['distance'];
				$transport = $value['transport'];
				
				$sql = "INSERT INTO `ordertable`(`distance`, `transport`, `create_at`, `create_by`, `emp_id`, `payment_status`, `status`) VALUES ('$distance','$transport', now(),'$create_by','$emp_id','$payment_status','$status')";

				// $result = mysqli_query($link, $sql);
			// }	

							
		// $sql = "INSERT INTO `ordertable`(`create_at`, `create_by`, `emp_id`, `payment_status`, `status`) VALUES (now(),'$create_by','$emp_id','$payment_status','userorder')";

		// $result = mysqli_query($link, $sql);

		 if (mysqli_query($link, $sql)) {
			  $last_id = mysqli_insert_id($link);
			  echo $last_id;
			}
		 else {
		 	echo "false";
		}

	} else echo "Welcome Whaasfgdhsfjdgster Shop";
   

	mysqli_close($link);
?>