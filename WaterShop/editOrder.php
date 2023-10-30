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
	$order_id = $_GET['order_id'];

	$sql = "SELECT wt.id, wt.PathImage, wt.Price, wt.Size, wt.quantity, bw.brand_name, otd.order_table_detail, otd.amount, otd.distance, otd.transport, otd.payment_status, otd.create_by, otd.status
	FROM watertable wt LEFT JOIN brandwater bw
		ON wt.idbrand = bw.brand_id
	LEFT JOIN (
		SELECT ot.id as order_table_detail, od.water_id, od.amount, ot.distance, ot.transport, ot.payment_status, ot.create_by, ot.status
			FROM ordertable ot LEFT JOIN orderdetail od
				ON ot.id = od.order_id
			WHERE ot.id = $order_id
		   ) otd
		ON otd.water_id = wt.id;";

		$result = mysqli_query($link, $sql);

		
		if ($result) {
			while($row=mysqli_fetch_assoc($result)){
				$output[]=$row;
			}

			echo json_encode($output);
		}



		// $orderId = $_GET['orderId'];	
		// $orderDateTime = $_GET['orderDateTime'];
		// $user_id = $_GET['user_id'];
		// $user_name = $_GET['user_name'];
		// $water_id = $_GET['water_id'];
		// $water_brand_id = $_GET['water_brand_id'];
		// $size = $_GET['size'];
		// $distance = $_GET['distance'];
		// $transport = $_GET['transport'];
		// $water_brand_name = $_GET['water_brand_name'];
		// $price = $_GET['price'];
		// $amount = $_GET['amount'];
		// $sum = $_GET['sum'];
		// $riderId = $_GET['riderId'];
		// $pamentStatus = $_GET['pamentStatus'];
		// $status = $_GET['status'];
		
							
		// $sql = "UPDATE `ordertable` SET `orderId`='$orderId',`orderDateTime`='$orderDateTime',`user_id`='$user_id',`user_name`='$user_name',`water_id`='$water_id',`water_brand_id`='$water_brand_id',`size`='$size',`distance`='$distance',`transport`='$transport',`water_brand_name`='$water_brand_name',`price`='$price',`amount`='$amount',`sum`='$sum',`riderId`='$riderId',`pamentStatus`='$pamentStatus',`status`='$status' WHERE orderId = '$orderId'";

		// $result = mysqli_query($link, $sql);

		// if ($result) {
		// 	echo "true";
		// } else {
		// 	echo "false";
		// }
   
}

	mysqli_close($link);
?>