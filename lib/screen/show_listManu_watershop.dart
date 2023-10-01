import 'dart:convert';

import 'package:application_drinking_water_shop/model/customer_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../configs/api.dart';
import '../model/brand_model.dart';
import '../model/cart_model.dart';
import '../model/user_model.dart';
import '../model/water_model.dart';
import '../services/add_order.dart';
import '../services/get_last_order_id.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';

class listManuAddOrderWater extends StatefulWidget {
  final CustomerModel? customerModel;
  final bool isAdmin;

  const listManuAddOrderWater(
      {super.key, this.customerModel, this.isAdmin = false});

  @override
  State<listManuAddOrderWater> createState() => _listManuAddOrderWaterState();
}

class _listManuAddOrderWaterState extends State<listManuAddOrderWater> {
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
    // brandModel = widget.brandWaterModel;
    readWaterMenu();
    readDataAdmin();
    // findLocation();
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

  Future<Null> readWaterMenu() async {
    // idbrand = brandModel!.brandId;
    // ignore: unused_local_variable
    String? url =
        '${MyConstant().domain}/WaterShop/getWaterWhereBrandAdmin.php';
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

  Future<Null> addOrderToCart(int index) async {
    Response resp = await getLastOrderId(status: "admincart", userId: widget.customerModel?.id);
    dynamic order_id = resp.data.toString().trim().replaceAll('"', '');
    String? user_id;

    if (widget.isAdmin) {
      user_id = widget.customerModel?.id;
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      user_id = preferences.getString('id');
    }

    if (order_id == "null") {
      resp = await addOrderWaterApi(
        status: widget.isAdmin ? "admincart" : "usercart",
        lat1: double.parse(widget.customerModel?.lat ?? '0'),
        lng1: double.parse(widget.customerModel?.lng ?? '0'),
        userModel: userModel,
        user_id: user_id ?? "",
      );
      order_id = resp.data;
    }

    resp = await addOrderDetailApi(
      order_id: order_id,
      amount: amount,
      brandModel: BrandWaterModel.fromJson(waterModels[index].toJson()),
      index: index,
      waterModels: waterModels,
      user_id: user_id ?? "",
    );
    print(resp.data);
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MyStyle().showTitleB('ListManuWater'),
    );
  }
}
