import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_constant.dart';

Future<Response> getLastOrderId(
    {String? userId, String status = "usercart"}) async {
  String? user_id;

  if (userId == null) {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    user_id = preferences.getString('id');
  } else {
    user_id = userId;
  }

  String url =
      "${MyConstant().domain}WaterShop/getLastOrderId.php?user_id=$user_id&status=$status";
  print(url);

  // String url = "http://192.168.1.99/WaterShop/getLastOrderId.php?user_id=123";

  Response response = await Dio().get(url);

  return response;
}
