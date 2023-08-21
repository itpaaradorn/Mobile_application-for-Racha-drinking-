import 'dart:convert';

import 'package:application_drinking_water_shop/model/order_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../configs/api.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';

class OrderProcessShop extends StatefulWidget {
  const OrderProcessShop({super.key});

  @override
  State<OrderProcessShop> createState() => _OrderProcessShopState();
}

class _OrderProcessShopState extends State<OrderProcessShop> {
  bool loadStatus = true; // Process load JSON
  bool status = true;

  List<OrderModel> ordermodels = [];
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
    return Stack(
      children: <Widget>[
        loadStatus ? buildNoneOrder() : showContent(),
      ],
    );
  }

  Widget showContent() {
    return status ? showListOrderWater() : buildNoneOrder();
  }

  Center buildNoneOrder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            child: Image.asset('images/nowater.png'),
          ),
          MyStyle().mySixedBox(),
          Text(
            'ยังไม่มีข้อมูลการสั่งน้ำดื่ม',
            style: TextStyle(fontSize: 28),
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
        '${MyConstant().domain}/WaterShop/getOrderwherestatus_RiderHandle.php?isAdd=true';
    await Dio().get(path).then((value) {
      // print('value ==> $value');
      var result = jsonDecode(value.data);
      // print('result ==> $result');
      if (result != null) {
        for (var item in result) {
          OrderModel model = OrderModel.fromJson(item);
          // print('OrderdateTime ==> ${model.orderDateTime}');

          List<String> nameWater =
              MyAPI().createStringArray(model.waterBrandName!);
          List<String> amountgas = MyAPI().createStringArray(model.amount!);
          List<String> pricewater = MyAPI().createStringArray(model.price!);
          List<String> pricesums = MyAPI().createStringArray(model.sum!);
          List<String> userid = MyAPI().createStringArray(model.userId!);

          int total = 0;
          for (var item in pricesums) {
            total = total + int.parse(item);
          }

          setState(() {
            loadStatus = false;
            ordermodels.add(model);
            listnameWater.add(nameWater);
            listAmounts.add(amountgas);
            listPrices.add(pricewater);
            listSums.add(pricesums);
            totals.add(total);
            listusers.add(userid);
          });
        }
      }
    });
  }


    Widget showListOrderWater() {
    return ListView.builder(
      itemCount: ordermodels.length,
      itemBuilder: (context, index) => Card(
        color: index % 2 == 0 ? Colors.grey.shade100 : Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyStyle().showTitleH2('คุณ ${ordermodels[index].userName}'),
              MyStyle()
                  .showTitleH33('คำสั่งซื้อ : ${ordermodels[index].orderId}'),
              MyStyle().showTitleH33(
                  'เวลาสั่งซื้อ : ${ordermodels[index].orderDateTime}'),
              MyStyle().showTitleH33(
                  'สถานะการชำระเงิน : ${ordermodels[index].pamentStatus}'),
              MyStyle()
                  .showTitleH33('รหัสผู้จัดส่ง : ${ordermodels[index].riderId}'),
              MyStyle().showTitleH33('สถานะการจัดส่ง : กำลังจัดส่ง'),
              MyStyle().mySixedBox05(),
              buildTitle(),
              ListView.builder(
                itemCount: listnameWater[index].length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index2) => Container(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${listAmounts[index][index2]}x',
                          style: MyStyle().mainh3Title,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          listnameWater[index][index2],
                          style: MyStyle().mainh3Title,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          listPrices[index][index2],
                          style: MyStyle().mainh3Title,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          listSums[index][index2],
                          style: MyStyle().mainh3Title,
                        ),
                      ),
                    ],
                  ),
                ),
              ),MyStyle().mySixedBox(),
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
                            'รวมทั้งหมด :  ',
                            style: MyStyle().mainh1Title,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${totals[index].toString()} THB',
                        style: MyStyle().mainhATitle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildTitle() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(color: Color.fromARGB(255, 11, 91, 128)),
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
              'ราคา',
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
