import 'package:dio/dio.dart';

import '../utility/my_constant.dart';

Future<Response> getCustomer() async {
  String url = "${MyConstant().domain}WaterShop/getCustomer.php";
  return await Dio().get(url);
}
