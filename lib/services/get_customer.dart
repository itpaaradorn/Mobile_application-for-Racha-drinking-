import 'package:dio/dio.dart';

Future<Response> getCustomer() async {
  String url = "http://192.168.1.99/WaterShop/getCustomer.php";
  return await Dio().get(url);
}
