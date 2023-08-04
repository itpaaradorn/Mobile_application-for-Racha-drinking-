import 'dart:convert';

import 'package:application_drinking_water_shop/model/order_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';

class ShowStatusWaterOrder extends StatefulWidget {
  const ShowStatusWaterOrder({super.key});

  @override
  State<ShowStatusWaterOrder> createState() => _ShowStatusWaterOrderState();
}

class _ShowStatusWaterOrderState extends State<ShowStatusWaterOrder> {
  String? user_id;
  bool statusorder = true;
  List<OrderModel> orderModels = [];
  List<List<String>> listMenuWaters = [];
  List<List<String>> listSizes = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listSums = [];
  List<int> totalInts = [];
  List<int> statusInts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  @override
  Widget build(BuildContext context) {
    return statusorder ? buildNonOrder() : buildContant();
  }

  Widget buildContant() => ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: orderModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            MyStyle().mySixedBox(),
            buildDatatimeOrder(index),
            buildDistance(index),
            buildTransport(index),
            buildHead(),
            buildLisviewMenuWater(index),
            MyStyle().mySixedBox(),
            buildTotal(index),
            MyStyle().mySixedBox(),
            buildStepIndicator(statusInts[index]),
            MyStyle().mySixedBox(),
            MyStyle().mySixedBox(),
            // buildBrandWater(index),
          ],
        ),
      );

  Widget buildStepIndicator(int index) => Column(
        children: [
          StepsIndicator(lineLength: 80,
            selectedStep: index,
            nbSteps: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('สั่งซื้อ'),
              Text('กำลังเตรียมน้ำดื่ม'),
              Text('กำลังจัดส่ง'),
              Text('รายการสำเร็จ'),
            ],
          ),
        ],
      );

  Widget buildTotal(int index) => Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: [
                MyStyle().showTitleH44color('รวมราคารายการน้ำดื่ม  '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                MyStyle().showTitleHDack(totalInts[index].toString()),
              ],
            ),
          ),
        ],
      );

  ListView buildLisviewMenuWater(int index) => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: listMenuWaters[index].length,
        itemBuilder: (context, index2) => Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(listMenuWaters[index][index2]),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(listPrices[index][index2]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(listAmounts[index][index2]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Text(listSums[index][index2]),
                ],
              ),
            ),
          ],
        ),
      );

  Container buildHead() {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 3,
            child: MyStyle().showTitleHDack('รายการน้ำดื่ม'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleHDack('ราคา'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleHDack('จำนวน'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleHDack('รวม'),
          ),
        ],
      ),
    );
  }

  Row buildTransport(int index) {
    return Row(
      children: [
        MyStyle()
            .showTitleH44color('ค่าจัดส่ง ${orderModels[index].transport} บาท'),
      ],
    );
  }

  Row buildDistance(int index) {
    return Row(
      children: [
        MyStyle()
            .showTitleH3('ระยะทาง ${orderModels[index].distance} กิโลเมตร'),
      ],
    );
  }

  Row buildDatatimeOrder(int index) {
    return Row(
      children: [
        MyStyle().showTitleH44(
            'วันเวลาที่สั่งซื้อ ${orderModels[index].orderDateTime}'),
      ],
    );
  }

  // Row buildBrandWater(int index) {
  //   return Row(
  //     children: [
  //       MyStyle().showTitleH2(
  //           'รายการน้ำดื่ม ${orderModels[index].waterBrandName!} '),
  //     ],
  //   );
  // }

  Center buildNonOrder() =>
      const Center(child: Text('ยังไม่มีข้อมูลการสั่งน้ำดื่ม'));

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    user_id = preferences.getString('id');
    print('user_id == $user_id');
    readOrderFormIdUser();
  }

  Future<Null> readOrderFormIdUser() async {
    if (user_id != null) {
      String url =
          '${MyConstant().domain}/WaterShop/getOrderWhereIdUser.php?isAdd=true&user_id=$user_id';

      Response response = await Dio().get(url);
      // print('response == $response');
      if (response.toString() != 'null') {
        var result = json.decode(response.data);
        for (var map in result) {
          OrderModel model = OrderModel.fromJson(map);
          List<String> menuWaters = changeAreey(model.waterBrandName!);
          List<String> prices = changeAreey(model.price!);
          List<String> amounts = changeAreey(model.amount!);
          List<String> sums = changeAreey(model.sum!);
          // print('menuWaters ===>> $menuWaters');

          int status = 0;
          switch (model.status) {
            case 'userorder':
              status = 0;
              break;
            case 'shopprocess':
              status = 1;
              break;
            case 'RiderHandle':
              status = 2;
              break;
            case 'Finish':
              status = 3;
              break;
            default:
          }

          int total = 0;
          for (var string in sums) {
            total = total + int.parse(string.trim());
            print('toast == $total');
          }

          setState(() {
            statusorder = false;
            orderModels.add(model);
            listMenuWaters.add(menuWaters);
            listPrices.add(prices);
            listAmounts.add(amounts);
            listSums.add(sums);
            totalInts.add(total);
            statusInts.add(status);
          });
        }
      }
    }
  }

  List<String> changeAreey(String string) {
    List<String> list = [];
    String myString = string.substring(1, string.length - 1);
    print('myString == $myString');
    list = myString.split(',');
    int index = 0;
    for (var string in list) {
      list[index] = string.trim();
      index++;
    }
    return list;
  }
}
