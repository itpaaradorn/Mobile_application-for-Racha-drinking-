import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Response> getCartApi({String status = "usercart"}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? user_id = preferences.getString('id');

  String url =
      '${MyConstant().domain}/WaterShop/getOrderDetail_WhereIdUser.php?user_id=$user_id&status=usercart';
  print(url);

  Response resp = await Dio().get(url);
  return resp;
}
