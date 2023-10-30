
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
		$status = $_GET['status'];

		$query = "SELECT MAX(id) as id FROM ordertable WHERE create_by = $user_id AND status = '$status';";

		$result = mysqli_query($link, $query);

		if ($result) {
			while($row=mysqli_fetch_assoc($result)){
			$output[] = $row;

			}	// while

			echo json_encode($output[0]['id']);
		} //if

	} else echo "Welcome WaterShop";	// if2
   


	mysqli_close($link);
?>