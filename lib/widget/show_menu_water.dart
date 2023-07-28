import 'dart:convert';

import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/model/water_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ShowMenuWater extends StatefulWidget {
  final UserModel userModel;
  const ShowMenuWater({super.key, required this.userModel});

  @override
  State<ShowMenuWater> createState() => _ShowMenuWaterState();
}

class _ShowMenuWaterState extends State<ShowMenuWater> {
  UserModel? userModel;
  String? idShop;
  List<WaterModel> waterModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    readWaterMenu();
  }

  Future<Null> readWaterMenu() async {
    idShop = userModel!.id;
    // ignore: unused_local_variable
    String? url =
        '${MyConstant().domain}/WaterShop/getWaterWheredShop.php?isAdd=true&idShop=$idShop';
    Response response = await Dio().get(url);
    print('res ==>> $response');

    var result = json.decode(response.data);
    print('result ==> $result');

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
            itemBuilder: (context, index) => Row(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.4,
                  child: Image.network(
                      '${MyConstant().domain}${waterModels[index].pathImage}'),
                ),
                Text(waterModels[index].nameWater!),
              ],
            ),
          );
  }
}
