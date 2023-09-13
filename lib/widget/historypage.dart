import 'dart:convert';

import 'package:application_drinking_water_shop/model/hsitory_model.dart';
import 'package:application_drinking_water_shop/model/order_model.dart';
import 'package:application_drinking_water_shop/screen/follow_delivery_map.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';

import '../utility/dialog.dart';

class ListOrder {
  String orderName;
  List<HistoryModel> items;

  ListOrder({required this.orderName, required this.items});
}

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String? create_by;
  bool statusAvatar = true;
  bool statusorder = true;
  List<List<String>> listMenuWaters = [];
  List<List<String>> listSizes = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listSums = [];
  List<int> totalInts = [];
  List<int> statusInts = [];

  List<ListOrder> listOrder = [];
  List<HistoryModel> ordermodels = [];

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
        itemCount: listOrder.length,
        itemBuilder: (context, index) {
          var items = listOrder[index].items;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      if (items[0].status == 'shopprocess') {
                        normalDialog2(context, 'ไม่สามารถยกเลิกการสั่งซื้อ',
                            'เนื่องจากร้านได้ยืนยันการสั่งซื้อของคุณแล้ว กรุณาติดต่อทางร้านค่ะ!');
                      } else if (items[0].status == 'RiderHandle') {
                        normalDialog2(context, 'ไม่สามารถยกเลิกการสั่งซื้อ',
                            'เนื่องจากกำลังจัดสั่งรายน้ำดื่มให้คุณ กรุณาติดต่อทางร้านค่ะ!');
                      } else if (items[0].status == 'Finish') {
                        normalDialog2(
                            context,
                            'รายการสั่งซื้อของท่านสำเร็จแล้ว!',
                            'กรุณาติดต่อทางร้านค่ะ');
                      } else if (items[0].status == 'userorder') {
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
                      switch (items[0].status) {
                        case 'userorder':
                          normalDialog3(context, 'ไม่สามารถเปิดพิกัดได้ค่ะ',
                              'เนื่องจากรายการของท่านสำเร็จแล้ว ค่ะ');
                          break;
                        case 'shopprocess':
                          normalDialog3(
                              context,
                              'รายการของท่านยังไม่ได้ทำการจัดส่ง',
                              'กรุณารอพนักงานจัดส่งท่านสามารถดูรายการต่อไปนี้ได้');
                          break;
                        case 'RiderHandle':
                          MaterialPageRoute route = MaterialPageRoute(
                            builder: (context) => FollowTrackingDelivery(
                              orderModel: items[0],
                            ),
                          );
                          Navigator.push(context, route).then((value) async {});
                          break;
                        case 'Finish':
                          normalDialog2(
                            context,
                            'รายการสั่งซื้อของท่านสำเร็จแล้ว!',
                            'กรุณาติดต่อทางร้านค่ะ');
                          break;
                        case 'Cancel':
                          normalDialog2(
                            context,
                            'รายการสั่งซื้อของท่านยกเลิกแล้ว!',
                            'กรุณาติดต่อทางร้านค่ะ');
                          break;
                      }

                      // if (items[0].status != 'Finish') {
                      //   if (items[0].status != 'RiderHandle') {

                      //   } else {

                      //   }
                      // } else {

                      // }
                      // print("${orderModels[index].riderId}");
                    },
                    child: Text(
                      'ติดตามการจัดส่ง',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              buildStepIndicator(items[0].status),
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
          );
        },
      ),
    );
  }

  Future refresh() async {
    readOrderFormIdUser();
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
    String orderNumber = listOrder[index].items[0].orderNumber!;
    String url =
        '${MyConstant().domain}/WaterShop/cancleOrderWhereorderId.php?isAdd=true&status=Cancle&order_number=$orderNumber';

    await Dio().get(url).then((value) {
      readOrderFormIdUser();
      normalDialogChack(context, 'ยกเลิกรายการสั่งซื้อสำเร็จ',
          'รายการสั่งซื้อที่ $orderNumber');
    });
  }

  Widget buildStepIndicator(String? status) {
    int index = 0;
    switch (status) {
      case 'userorder':
        index = 0;
        break;
      case 'shopprocess':
        index = 1;
        break;
      case 'RiderHandle':
        index = 2;
        break;
      case 'Finish':
        index = 3;
        break;
      default:
    }

    return Column(
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
  }

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
                listOrder[index].items[0].status == 'Cancel'
                    ? MyStyle().showTitleH3('ยกเลิก')
                    : MyStyle().showTitle(
                        '${listOrder[index].items.fold(0, (previous, current) => previous + int.parse(current.sum ?? '0'))} THB'),
              ],
            ),
          ),
        ],
      );

  ListView buildLisviewMenuWater(int index) => ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: listOrder[index].items.length,
      itemBuilder: (context, index2) {
        HistoryModel items = listOrder[index].items[index2];

        return Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(items.brandName ?? ''),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(items.price ?? ''),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(items.amount ?? ''),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Text(items.sum ?? ''),
                ],
              ),
            ),
          ],
        );
      });

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
        MyStyle().showTitleH44color(
            'ค่าจัดส่ง ${listOrder[index].items[0].transport} บาท'),
      ],
    );
  }

  Row buildDistance(int index) {
    return Row(
      children: [
        MyStyle().showTitleH3(
            'ระยะทาง ${listOrder[index].items[0].distance} กิโลเมตร'),
      ],
    );
  }

  Row buildDatatimeOrder(int index) {
    return Row(
      children: [
        MyStyle().showTitleH44(
            'วันเวลาที่สั่งซื้อ ${listOrder[index].items[0].createAt}'),
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
    create_by = preferences.getString('id');
    // print('user_id == $create_by');
    readOrderFormIdUser();
  }

  Future<Null> readOrderFormIdUser() async {
    print('readOrderFormIdUser');

    if (ordermodels.isNotEmpty) {
      ordermodels.clear();
    }

    if (create_by != null) {
      String url =
          '${MyConstant().domain}/WaterShop/getOrderWhereIdUser.php?user_id=$create_by';

      print(url);

      Response response = await Dio().get(url);
      // print('response == $response');
      if (response.toString() != 'null') {
        var result = json.decode(response.data);

        prepareListOrder(result);
        statusAvatar = false;
        setState(() {});
        return;

        for (var map in result) {
          HistoryModel model = HistoryModel.fromJson(map);
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
            // orderModels.add(model);
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

  void prepareListOrder(result) {
    ordermodels.clear();

    if (result != null) {
      result?.forEach((elem) => ordermodels.add(HistoryModel.fromJson(elem)));

      /*
         listOrder = [
          {
            "orderName": "12345678",
            "items": [model1, model2],
         }
         ];
        */

      Map<String, List<HistoryModel>> items = {};

      ordermodels.forEach((elem) {
        if (items[elem.orderNumber] == null) {
          items[elem.orderNumber as String] = [];
        }

        items[elem.orderNumber as String]?.add(elem);
      });

      listOrder.clear();

      items.forEach((key, value) =>
          listOrder.add(ListOrder(orderName: key, items: value)));

      setState(() {});

      print('listOrder -> ${listOrder.length}');

      // for (var item in result) {
      // OrderModel model = OrderModel.fromJson(item);
      // print('OrderdateTime ==> ${model.orderDateTime}');

      // List<String> nameWater =
      //     MyAPI().createStringArray(model.brandName!);
      // List<String> amountgas = MyAPI().createStringArray(model.amount!);
      // List<String> pricewater = MyAPI().createStringArray(model.price!);
      // List<String> pricesums = MyAPI().createStringArray(model.sum!);
      // List<String> userid = MyAPI().createStringArray(model.createBy!);

      // int total = 0;
      // for (var item in pricesums) {
      //   total = total + int.parse(item);
      // }

      // setState(() {
      //   loadStatus = false;
      //   ordermodels.add(model);
      //   listnameWater.add(nameWater);
      //   listAmounts.add(amountgas);
      //   listPrices.add(pricewater);
      //   listSums.add(pricesums);
      //   totals.add(total);
      //   listusers.add(userid);
      // });
      // }
    } else {
      setState(() {
        listOrder.clear();
      });
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
    String order_id = listOrder[0].items[0].orderNumber!;
    if (user_id != null && user_id.isNotEmpty) {
      String url =
          '${MyConstant().domain}/gas/updateorderIdfrompayment.php?isAdd=true&order_id=$order_id&user_id=$user_id';
      await Dio().get(url).then(
            (value) => print('order_id update success'),
          );
    }
  }
}
