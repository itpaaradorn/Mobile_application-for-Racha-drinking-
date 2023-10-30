import 'dart:convert';

import 'package:application_drinking_water_shop/model/order_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../configs/api.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';

class ListOrder {
  String orderName;
  List<OrderModel> items;

  ListOrder({required this.orderName, required this.items});
}

class OrderProcessShop extends StatefulWidget {
  const OrderProcessShop({super.key});

  @override
  State<OrderProcessShop> createState() => _OrderProcessShopState();
}

class _OrderProcessShopState extends State<OrderProcessShop> {
  bool loadStatus = true; // Process load JSON
  bool status = true;

  List<OrderModel> ordermodels = [];
  List<ListOrder> listOrder = [];
  List<List<String>> listnameWater = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listPrices = [];
  List<List<String>> listSums = [];
  List<int> totals = [];
  List<List<String>> listusers = [];

  @override
  void initState() {
    super.initState();
    findOrderShop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'รายการน้ำดื่มกำลังดำเนินการ',
          style: TextStyle(color: Colors.indigo),
        ),
      ),
      body: Stack(
        children: <Widget>[
          listOrder.isNotEmpty ? showListOrderWater() : buildNoneOrder(),
        ],
      ),
    );
  }

  // Widget showContent() {
  //   return status ? showListOrderWater() : buildNoneOrder();
  // }

  Center buildNoneOrder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   height: 100,
          //   width: 100,
          //   child: Image.asset('images/nowater.png'),
          // ),
          MyStyle().mySixedBox(),
          Text(
            'ยังไม่มีข้อมูลการสั่งน้ำดื่ม',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Future<Null> findOrderShop() async {
    if (ordermodels.length != 0) {
      ordermodels.clear();
    }

    String path =
        '${MyConstant().domain}/WaterShop/getOrderWhereIdShop.php?status=RiderHandle';
    await Dio().get(path).then((value) {
      // print('value ==> $value');
      var result = jsonDecode(value.data);
      // print('result ==> $result');

      if (result != null) {
        result?.forEach((elem) => ordermodels.add(OrderModel.fromJson(elem)));

        /*
         listOrder = [
          {
            "orderName": "12345678",
            "items": [model1, model2],
         }
         ];
        */

        Map<String, List<OrderModel>> items = {};

        ordermodels.forEach((elem) {
          if (items[elem.orderTableId] == null) {
            items[elem.orderTableId as String] = [];
          }

          items[elem.orderTableId as String]?.add(elem);
        });

        items.forEach((key, value) =>
            listOrder.add(ListOrder(orderName: key, items: value)));

        print('\nlistOrder: $listOrder\n\n');

        setState(() {});
      } else {
        setState(() {
          status = true;
        });
      }
    });
  }

  Widget showListOrderWater() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listOrder.length,
      itemBuilder: (context, i) {
        return Card(
          color: i % 2 == 0 ? Colors.grey.shade100 : Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyStyle().showTitleH2('คุณ ${listOrder[i].items[0].name}'),
                MyStyle().showTitleH33(
                    'คำสั่งซื้อ : ${listOrder[i].items[0].orderTableId}'),
                MyStyle().showTitleH33(
                    'เวลาสั่งซื้อ : ${listOrder[i].items[0].createAt}'),
                MyStyle().showTitleH33(
                    'สถานะการชำระเงิน : ${listOrder[i].items[0].paymentStatus}'),
                MyStyle().showTitleH33('สถานะการจัดส่ง : กำลังจัดส่ง ✈'),
                MyStyle().mySixedBox(),
                buildTitle(),
                ListView.builder(
                    itemCount: listOrder[i].items.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, j) {
                      List<OrderModel> items = listOrder[i].items;

                      return Container(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${items[j].amount}x',
                                style: MyStyle().mainh3Title,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                items[j].brandName ?? '',
                                style: MyStyle().mainh3Title,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${items[j].size} ml',
                                style: MyStyle().mainh3Title,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                items[j].sum ?? '',
                                style: MyStyle().mainh3Title,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                Container(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'รวมทั้งสิ้น :',
                              style: MyStyle().mainh1Title,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            listOrder[i].items[0].status == 'Cancle'
                                ? MyStyle().showTitleH3('ยกเลิก')
                                : Text(
                                    '${listOrder[i].items.fold(0, (previous, current) => previous + int.parse(current.sum ?? '0'))} บาท',
                                    style: MyStyle().mainhATitle,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container buildTitle() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(color: Color.fromARGB(255, 76, 164, 206)),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(
                'จำนวน',
                style: MyStyle().mainh4Title,
              )),
          Expanded(
            flex: 1,
            child: Text(
              'ยี่ห้อ',
              style: MyStyle().mainh4Title,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'ขนาด',
              style: MyStyle().mainh4Title,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'รวม',
              style: MyStyle().mainh4Title,
            ),
          ),
        ],
      ),
    );
  }
}
