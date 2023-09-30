import 'package:application_drinking_water_shop/model/order_detail.dart';
import 'package:dio/dio.dart';

import '../utility/my_constant.dart';

Future<Response> deleteOrderCardApi({required OrderDetail orderdetail}) async {
  String url = '${MyConstant().domain}/WaterShop/deleteOrderDetail.php';

  Map<String, dynamic> data = {
    'order_id': orderdetail.id,
    'water_id': orderdetail.waterId,
  };

  Response resp = await Dio().delete(url, data: data);
  return resp;
}
