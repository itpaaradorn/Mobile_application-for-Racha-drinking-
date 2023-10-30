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
}else {
	if ($_SERVER['REQUEST_METHOD'] == 'DELETE') {

		$id_arr = json_decode(file_get_contents("php://input"), true);
		$order_id = array_values($id_arr)[0];
		$water_id = array_values($id_arr)[1];

		$sql = "DELETE FROM orderdetail WHERE order_id = $order_id AND water_id = $water_id";
		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "True";
		} else {
			echo "False";
		}

	} else {
		echo "Welcome WaterShop";
	}
   
}
	
	mysqli_close($link);
?>