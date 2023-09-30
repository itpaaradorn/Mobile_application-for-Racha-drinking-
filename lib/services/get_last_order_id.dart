import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_constant.dart';

Future<Response> getLastOrderId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? user_id = preferences.getString('id');

  String url = "${MyConstant().domain}WaterShop/getLastOrderId.php?user_id=$user_id";
  
  // String url = "http://192.168.1.99/WaterShop/getLastOrderId.php?user_id=123";

  Response response = await Dio().get(url);

  return response;
}
