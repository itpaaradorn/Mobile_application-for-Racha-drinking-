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
	
				
		$create_by = $_GET['user_id'];
		$status = $_GET['status'];

		$result = mysqli_query($link, "SELECT ot.id, ot.create_by, ot.emp_id, od.water_id, od.amount, od.sum, ot.distance, ot.transport, wt.Price, wt.Size, wt.idbrand, wt.quantity, bw.brand_name, ot.payment_status FROM ordertable ot LEFT JOIN orderdetail od ON ot.id = od.order_id LEFT JOIN watertable wt ON od.water_id = wt.id LEFT JOIN brandwater bw ON wt.idbrand = bw.brand_id WHERE ot.create_by = $create_by AND ot.status = '$status' AND od.status = 'show' ORDER BY wt.id;");

		if ($result) {

			while($row=mysqli_fetch_assoc($result)){
			$output[]=$row;

			}	// while

			echo json_encode($output);

		} //if

	} else echo "Welcome getOrderDetail_wheredID";	// if2
   


	mysqli_close($link);
?>