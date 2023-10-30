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
	$user_id = $_GET['user_id'];

	$query = "SELECT uo.order_table_id, uo.payment_status, uo.create_at, uo.amount, uo.sum, uo.distance, uo.transport, uo.Price, uo.Size, uo.brand_name, uo.Name, uo.user_id, ut.Name AS rider_name, uo.status, uo.brand_id, uo.water_id, ut.id AS rider_id, uo.user_phone FROM ( SELECT ot.id AS order_table_id, ot.payment_status, ot.create_at, od.amount, od.sum, ot.distance, ot.transport, wt.Price, wt.Size, bw.brand_name, ut.Name, ut.id AS user_id, ot.emp_id, ot.status, wt.id AS water_id, bw.brand_id, ut.Phone as user_phone FROM ordertable ot LEFT JOIN orderdetail od ON ot.id = od.order_id LEFT JOIN watertable wt ON od.water_id = wt.id LEFT JOIN brandwater bw ON wt.idbrand = bw.brand_id LEFT JOIN usertable ut ON od.create_by = ut.id WHERE ut.id = $user_id ) AS uo LEFT JOIN usertable ut ON uo.emp_id = ut.id ORDER BY uo.create_at DESC;";
	$result = mysqli_query($link, $query);

	if ($result) {
		while($row = mysqli_fetch_assoc($result)){
			$output[] = $row;
		}	// while
		
		echo json_encode($output);
	} //if

	} else echo "Welcome WaterShop";	// if2
   


	mysqli_close($link);
?>