import 'dart:convert';

import 'package:application_drinking_water_shop/model/brand_model.dart';
import 'package:application_drinking_water_shop/model/cart_model.dart';
import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/model/water_model.dart';
import 'package:application_drinking_water_shop/services/add_order.dart';
import 'package:application_drinking_water_shop/services/get_last_order_id.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/sqlite_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../configs/api.dart';
import '../utility/dialog.dart';

class ShowMenuWater extends StatefulWidget {
  final BrandWaterModel brandWaterModel;
  const ShowMenuWater({super.key, required this.brandWaterModel});

  @override
  State<ShowMenuWater> createState() => _ShowMenuWaterState();
}

class _ShowMenuWaterState extends State<ShowMenuWater> {
  UserModel? userModel;
  BrandWaterModel? brandModel;
  String? idShop, idbrand;
  List<WaterModel> waterModels = [];
  int amount = 1;
  double? lat1, lng1, lat2, lng2;

  Location location = Location();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    brandModel = widget.brandWaterModel;
    readWaterMenu();
    readDataAdmin();
    findLocation();
  }

  // Future<Null> findLocation() async {
  //   location.onLocationChanged.listen((event) {
  //     lat1 = event.latitude;
  //     lng1 = event.longitude;
  //     print('lat1 = $lat1, lng1 = $lng1');
  //   });
  // }

  Future<Null> readWaterMenu() async {
    idbrand = brandModel!.brandId;
    // ignore: unused_local_variable
    String? url =
        '${MyConstant().domain}/WaterShop/getWaterWhereIdBrand.php?isAdd=true&idbrand=$idbrand';
    Response response = await Dio().get(url);
    // print('res ==>> $response');

    var result = json.decode(response.data);
    // print('result ==> $result');

    for (var map in result) {
      WaterModel waterModel = WaterModel.fromJson(map);
      setState(() {
        waterModels.add(waterModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return waterModels.length == 0
        ? MyStyle().showProgress()
        : ListView.builder(
            itemCount: waterModels.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                print('You click index =$index');
                amount = 1;
                comfirmOrder(index);
              },
              child: Row(
                children: [
                  showWaterImage(context, index),
                  Container(
                    // padding: EdgeInsets.all(50.0),
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.4,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyStyle().mySixedBox(),
                          MyStyle().mySixedBox(),
                          MyStyle().mySixedBox(),
                          Text(
                            'ขนาด ${waterModels[index].size!} ml',
                            style: MyStyle().mainSize,
                          ),
                          MyStyle().mySixedBox(),
                          Text(
                            'ราคา ${waterModels[index].price!} บาท',
                            style: MyStyle().mainH3Title,
                          ),
                          MyStyle().mySixedBox(),
                          Text(
                            'จำนวน ${waterModels[index].quantity!} ขวด/แพ็ค',
                            style: MyStyle().mainDackTitle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Container showWaterImage(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(right: 8.0, left: 8.0, top: 15.0),
      width: MediaQuery.of(context).size.width * 0.5 - 16,
      height: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
            image: NetworkImage(
                '${MyConstant().domain}${waterModels[index].pathImage}'),
            fit: BoxFit.cover),
      ),
    );
  }

  Future<Null> comfirmOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'รหัส: ${waterModels[index].id} ขนาด ${waterModels[index].size} ml',
                style: MyStyle().mainhPTitle,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200,
                height: 160,
                child: Image.network(
                  '${MyConstant().domain}${waterModels[index].pathImage}',
                ),
              ),
              MyStyle().mySixedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      size: 38,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        amount++;
                      });
                    },
                  ),
                  Text(
                    amount.toString(),
                    style: MyStyle().mainTitleBig,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      size: 38,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      if (amount > 1) {
                        setState(() {
                          amount--;
                        });
                      }
                    },
                  ),
                ],
              ),
              MyStyle().mySixedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 90,
                    child: ElevatedButton(
                      child: Text('ใส่ตะกร้า'),
                      onPressed: () {
                        Navigator.pop(context);
                        // print(
                        //     'Order ${waterModels[index].size} amount==> $amount');

                        addOrderToCart(index);
                      },
                    ),
                  ),
                  Container(
                    width: 90,
                    child: ElevatedButton(
                        child: Text('ยกเลิก'),
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> readDataAdmin() async {
    String url =
        '${MyConstant().domain}/WaterShop/readUserModelWhereChooseTpy.php?isAdd=true&ChooseType=Admin';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      // print('value == $value');

      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
          lat2 = double.parse('${userModel!.lat}');
          lng2 = double.parse('${userModel!.lng}');
        });
        // print(" useradmin ===> ${userModel!.id}");
      }
    });
  }

  Future<Null> findLocation() async {
    // var currentLocation = await Location.instance.getLocation();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user_id = preferences.getString('id');

    String url =
        "${MyConstant().domain}WaterShop/getUserWhereId.php?isAdd=true&id=$user_id";
    Response resp = await Dio().get(url);

    if (resp.statusCode == 200) {
      lat1 = double.parse(jsonDecode(resp.data)[0]['Lat']);
      lng1 = double.parse(jsonDecode(resp.data)[0]['Lng']);
      ;
    }

    print(lat1);
    print(lng1);

    // lat1 = currentLocation.latitude;
    // lng1 = currentLocation.longitude;
    // print('lat1 ==> $lat1 , lng1 ==> $lng1');
  }

  Future<Null> addOrderToCart(int index) async {
    Response resp = await getLastOrderId();
    dynamic order_id = resp.data.toString().trim().replaceAll('"', '');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user_id = preferences.getString('id');

    if (order_id == "null") {
      resp = await addOrderWaterApi(
        status: "usercart",
        lat1: lat1 ?? 0,
        lng1: lng1 ?? 0,
        userModel: userModel,
        user_id: user_id ?? "",
      );
      order_id = resp.data;
    }

    resp = await addOrderDetailApi(
      order_id: order_id,
      amount: amount,
      brandModel: brandModel,
      index: index,
      waterModels: waterModels,
      user_id: user_id ?? "",
    );
    print(resp.data);

    // String? brand_id = brandModel!.brandId;
    // String? brand_name = brandModel!.brandName;
    // String? water_id = waterModels[index].id!;
    // String? price = waterModels[index].price!;
    // String? size = waterModels[index].size!;

    // int priceInt = int.parse(price);
    // int sumInt = priceInt * amount;

    // lat2 = double.parse(userModel!.lat!);
    // lng2 = double.parse(userModel!.lng!);
    // double? distance = MyAPI().calculateDistance(lat1!, lng1!, lat2!, lng2!);

    // var myFormat = NumberFormat('##0.0#', 'en_US');
    // String distanceString = myFormat.format(distance);

    // int transport = MyAPI().calculateTransport(distance);

    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String? user_id = preferences.getString('id');

    // print(
    //     'water_id == $water_id,brand_id == $brand_id, brand_name == $brand_name, price == $price, size == $size, amount == $amount, sum == $sumInt, distance == $distanceString, transport == $transport  ');
    // Map<String, dynamic> map = Map();
    // map['water_id'] = water_id;
    // map['brand_id'] = brand_id;
    // map['brand_name'] = brand_name;
    // map['price'] = price;
    // map['size'] = size;
    // map['amount'] = amount.toString();
    // map['sum'] = sumInt.toString();
    // map['distance'] = distanceString;
    // map['transport'] = transport.toString();

    // print('map == ${map.toString()}');

    // CartModel? cartModel = CartModel.fromJson(map);

    // var object = await SQLiteHelper().readAllDataFormSQLite();
    // print('object leht == ${object.length}');

    // if (object.length == 0) {
    // await SQLiteHelper().insertDataToSQLite(cartModel).then((value)  {
    //   print('insert Sucess');
    //   Toast.show("เพิ่มตะกร้าเรียบร้อยแล้ว", duration: Toast.lengthLong, gravity:  Toast.bottom);
    // });

    // var formData = FormData.fromMap({
    //   'water_id': water_id,
    //   'amount': amount,
    //   'sum': sumInt,
    //   'distance': distanceString,
    //   'transport': transport,
    //   'create_by': user_id,
    // });

    // String? url = '${MyConstant().domain}/WaterShop/addOrderDetail.php';
    // Response response = await Dio().post(url, data: formData);
    // print(response.statusCode);
    // Toast.show("เพิ่มตะกร้าเรียบร้อยแล้ว", duration: Toast.lengthLong, gravity:  Toast.bottom);
    // } else {
    //   String id_brandSQLite = object[0].brandId!;
    //   // print('brandSQLite ==>> $id_brandSQLite');
    //   if (brand_id != id_brandSQLite.isNotEmpty) {
    //     await SQLiteHelper().insertDataToSQLite(cartModel).then((value) {
    //       print('insert Sucess');
    //       Toast.show("เพิ่มตะกร้าเรียบร้อยแล้ว",
    //           duration: Toast.lengthLong, gravity: Toast.bottom);
    //     });
    //   } else {
    //     normalDialog(context, 'รายการสั่งซื้อผิดพลาด !');
    //   }
    // }
  }
}
