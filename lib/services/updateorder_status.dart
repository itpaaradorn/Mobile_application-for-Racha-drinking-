import 'package:dio/dio.dart';

Future<Response> updateOrderStatus({
  required String order_id,
  required String emp_id,
  String status = "userorder",
  required String payment_status,
}) async {
  String url = "http://192.168.1.99/WaterShop/updateOrderStatus.php";

  Map<String, dynamic> data = {
    "order_id": order_id,
    "emp_id": emp_id,
    "status": status,
    "payment_status": payment_status,
  };

  Response resp = await Dio().put(url, data: data);
  return resp;
}
