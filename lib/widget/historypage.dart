import 'dart:convert';

import 'package:application_drinking_water_shop/model/order_model.dart';
import 'package:application_drinking_water_shop/screen/follow_delivery_map.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';

import '../utility/dialog.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String? user_id;
  bool statusAvatar = true;
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
    return statusAvatar ? buildNonOrder() : buildContant();
  }

  Widget buildContant() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: orderModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    if (orderModels[index].status == 'shopprocess') {
                      normalDialog2(context, 'ไม่สามารถยกเลิกการสั่งซื้อ',
                          'เนื่องจากร้านได้ยืนยันการสั่งซื้อของคุณแล้ว กรุณาติดต่อทางร้านค่ะ!');
                    } else if (orderModels[index].status == 'RiderHandle') {
                      normalDialog2(context, 'ไม่สามารถยกเลิกการสั่งซื้อ',
                          'เนื่องจากกำลังจัดสั่งรายน้ำดื่มให้คุณ กรุณาติดต่อทางร้านค่ะ!');
                    } else if (orderModels[index].status == 'Finish') {
                      normalDialog2(context, 'รายการสั่งซื้อของท่านสำเร็จแล้ว!',
                          'กรุณาติดต่อทางร้านค่ะ');
                    } else if (orderModels[index].status == 'userorder') {
                      confirmDeleteCancleOrder(index);
                    }
                  },
                  child: Text(
                    'ยกเลิกการสั่งซื้อ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (orderModels[index].status != 'Finish') {
                      if (orderModels[index].empId != 'none') {
                        MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => FollowTrackingDelivery(
                            orderModel: orderModels[index],
                          ),
                        );
                        Navigator.push(context, route).then((value) async {});
                      } else {
                        normalDialog3(
                            context,
                            'รายการของท่านยังไม่ได้ทำการจัดส่ง',
                            'กรุณารอพนักงานจัดส่งท่านสามารถดูรายการต่อไปนี้ได้');
                      }
                    } else {
                      normalDialog3(context, 'ไม่สามารถเปิดพิกัดได้ค่ะ',
                          'เนื่องจากรายการของท่านสำเร็จแล้ว ค่ะ');
                    }
                    // print("${orderModels[index].riderId}");
                  },
                  child: Text(
                    'ติดตามการจัดส่ง',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            buildStepIndicator(statusInts[index]),
            MyStyle().mySixedBox(),

            buildDatatimeOrder(index),
            buildDistance(index),
            buildTransport(index),
            buildHead(),
            buildLisviewMenuWater(index),
            MyStyle().mySixedBox(),
            buildTotal(index),
            SizedBox(
              height: 30,
            )
            // buildBrandWater(index),
          ],
        ),
      ),
    );
  }

  Future refresh() async {
    setState(() {
      readOrderFormIdUser();
    });
  }

  Future<Null> confirmDeleteCancleOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle()
            .showTitleH2('คุณต้องการจะยกเลิกรายการสั่งซื้อน้ำดื่มใช่ไหม ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                child: Text(
                  'ตกลง',
                  style: MyStyle().mainDackTitle,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  cancleOrderUser(index);
                },
              ),
              TextButton(
                child: Text(
                  'ยกเลิก',
                  style: MyStyle().mainDackTitle,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> cancleOrderUser(int index) async {
    String order_id = orderModels[index].id!;
    String url =
        '${MyConstant().domain}/WaterShop/cancleOrderWhereorderId.php?isAdd=true&status=Cancle&orderId=$order_id';

    await Dio().get(url).then((value) {
      readOrderFormIdUser();
      normalDialogChack(
          context, 'ยกเลิกรายการสั่งซื้อสำเร็จ', 'รายการสั่งซื้อที่ $order_id');
    });
  }

  Widget buildStepIndicator(int index) => Column(
        children: [
          StepsIndicator(
            lineLength: 80,
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
                MyStyle().showTitleH44color('รวมทั้งสิ้น :'),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                orderModels[index].status == 'Cancle'
                    ? MyStyle().showTitleH3('ยกเลิก')
                    : MyStyle().showTitle('${totalInts[index].toString()} THB'),
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
            'วันเวลาที่สั่งซื้อ ${orderModels[index].createAt}'),
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
    if (orderModels.length != 0) {
      orderModels.clear();
    }

    if (user_id != null) {
      String url =
          '${MyConstant().domain}/WaterShop/getOrderWhereIdUser.php?isAdd=true&user_id=$user_id';

      Response response = await Dio().get(url);
      // print('response == $response');
      if (response.toString() != 'null') {
        var result = json.decode(response.data);
        for (var map in result) {
          OrderModel model = OrderModel.fromJson(map);
          List<String> menuWaters = changeAreey(model.brandName!);
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
            statusAvatar = false;
            orderModels.add(model);
            listMenuWaters.add(menuWaters);
            listPrices.add(prices);
            listAmounts.add(amounts);
            listSums.add(sums);
            totalInts.add(total);
            statusInts.add(status);
            // updateorderId();
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

  Future<Null> updateorderId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user_id = preferences.getString(MyConstant().keyId);
    String order_id = orderModels[0].id!;
    if (user_id != null && user_id.isNotEmpty) {
      String url =
          '${MyConstant().domain}/gas/updateorderIdfrompayment.php?isAdd=true&order_id=$order_id&user_id=$user_id';
      await Dio().get(url).then(
            (value) => print('order_id update success'),
          );
    }
  }
}
