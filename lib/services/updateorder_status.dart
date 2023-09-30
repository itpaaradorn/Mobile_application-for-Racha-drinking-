import 'package:dio/dio.dart';

import '../utility/my_constant.dart';

Future<Response> updateOrderStatus({
  required String order_id,
  required String emp_id,
  String status = "userorder",
  required String payment_status,
}) async {
  String url = "${MyConstant().domain}/WaterShop/updateOrderStatus.php";

  Map<String, dynamic> data = {
    "order_id": order_id,
    "emp_id": emp_id,
    "status": status,
    "payment_status": payment_status,
  };

  Response resp = await Dio().put(url, data: data);
  return resp;
}
