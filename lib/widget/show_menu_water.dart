import 'dart:convert';

import 'package:application_drinking_water_shop/model/brand_model.dart';
import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/model/water_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart';

import '../utility/my_api.dart';

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

  Future<Null> findLocation() async {
    var currentLocation = await Location.instance.getLocation();
    lat1 = currentLocation.latitude;
    lng1 = currentLocation.longitude;
    print('lat1 ==> $lat1 , lng1 ==> $lng1');
  }

  Future<Null> addOrderToCart(int index) async {
    String? brand_id = brandModel!.brandId;
    String? brand_name = brandModel!.brandName;
    String? water_id = waterModels[index].id!;
    String? price = waterModels[index].price!;
    

    int priceInt = int.parse(price);
    int sumInt = priceInt * amount;
    

    lat2 = double.parse(userModel!.lat!);
    lng2 = double.parse(userModel!.lng!);
    double? distance = MyAPI().calculate2Distance(lat1!, lng1!, lat2!, lng2!);

    print(
        'water_id == $water_id,brand_id == $brand_id, brand_name == $brand_name, price == $price, amount == $amount, sum == $sumInt, distance == $distance  ');
  }
}
