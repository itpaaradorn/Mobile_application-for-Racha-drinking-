import 'package:application_drinking_water_shop/configs/api.dart';
import 'package:application_drinking_water_shop/model/brand_model.dart';
import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/model/water_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

Future<Response> addOrderWaterApi({
  String payment_status = "",
  required String status,
  required UserModel? userModel,
  required double lat1,
  required double lng1,
  required String user_id,
}) async {
  String? url = '${MyConstant().domain}/WaterShop/addOrderWater.php';

  DateTime now = DateTime.now();

  double lat2 = double.parse(userModel!.lat!);
  double lng2 = double.parse(userModel!.lng!);
  print(lat2);
  print(lat2);
  // return Response(
  //     requestOptions: RequestOptions(
  //   method: 'GET',
  // ));

  print("${lat1}, ${lat2}");
  print("${lng1}, ${lng2}");


  double? distance = MyAPI().calculateDistance(lat1!, lng1!, lat2!, lng2!);
  print('distance -> $distance');

  var myFormat = NumberFormat('##0.0#', 'en_US');
  String distanceString = myFormat.format(distance);

  int transport = MyAPI().calculateTransport(distance);

  Map<String, dynamic> _map = {
    "create_by": user_id,
    "emp_id": "none",
    "payment_status": payment_status, // เก็บเงินปลายทาง
    "status": status,
    'distance': distanceString,
    'transport': transport
  };

  Response response = await Dio().post(url, data: _map);
  print('response = ${response.statusCode}');
  print('response = ${response.data}');

  return response;
}

Future<Response> addOrderDetailApi({
  required String order_id,
  required BrandWaterModel? brandModel,
  required List<WaterModel> waterModels,
  required int index,
  required int amount,
  required String user_id,
}) async {
  String? brand_id = brandModel!.brandId;
  String? brand_name = brandModel!.brandName;
  String? water_id = waterModels[index].id!;
  String? price = waterModels[index].price!;
  String? size = waterModels[index].size!;

  int priceInt = int.parse(price);
  int sumInt = priceInt * amount;

  var formData = FormData.fromMap({
    "order_id": order_id,
    'water_id': water_id,
    'amount': amount,
    'sum': sumInt,
    'create_by': user_id,
  });

  String? url = '${MyConstant().domain}/WaterShop/addOrderDetail.php';
  Response response = await Dio().post(url, data: formData);
  print(response.statusCode);
  Toast.show("เพิ่มตะกร้าเรียบร้อยแล้ว",
      duration: Toast.lengthLong, gravity: Toast.bottom);

  return response;
}
