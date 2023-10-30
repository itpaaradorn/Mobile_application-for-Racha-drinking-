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
		$order_id = $_POST['order_id'];
		$water_id = $_POST['water_id'];
		$amount = $_POST['amount'];
		$sum = $_POST['sum'];
		$create_by = $_POST['create_by'];

		$sql = "SELECT * FROM orderdetail WHERE order_id = $order_id AND water_id = $water_id;";
		// $sql = "SELECT * FROM orderdetail WHERE order_id = $order_id AND water_id = 1;";
		$result = mysqli_query($link, $sql);

		if ($result) {
			while($row = mysqli_fetch_assoc($result)){
				$output[] = $row;
			}
			// echo json_encode($output);
		}

		if($output[0]['order_id']) {
			$amount = $_POST['amount'] + $output[0]['amount'];
			$sum = $_POST['sum'] + $output[0]['sum'];

			$sql = "UPDATE orderdetail SET amount = $amount, sum = $sum WHERE order_id = $order_id AND water_id = $water_id";
			mysqli_query($link, $sql);
			echo "true";
		} else {
			$sql = "INSERT INTO `orderdetail`(`order_id`, `water_id`, `amount`, `sum`, `create_at`, `create_by`,`status`) VALUES ('$order_id', '$water_id','$amount','$sum',now(),'$create_by','show')";

			if (mysqli_query($link, $sql)) {
				$last_id = mysqli_insert_id($link);
				echo $last_id;
			} else {
				echo "false";
			}
		}

		
							
		

		// if ($result) {
		// 	echo "true";
		// } else {
		// 	echo "false";
		// }

	} else echo "Welcome Whaasfgdhsfjdgster Shop";
   

	mysqli_close($link);
?>