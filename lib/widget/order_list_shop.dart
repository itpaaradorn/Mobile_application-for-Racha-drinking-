import 'dart:convert';

import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../configs/api.dart';
import '../model/order_model.dart';
import '../utility/my_constant.dart';
import '../utility/dialog.dart';

class OrderListShop extends StatefulWidget {
  @override
  State<OrderListShop> createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  UserModel? userModel;
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
    showContent();
  }

  Future<Null> findOrderShop() async {
    if (ordermodels.length != 0) {
      ordermodels.clear();
    }

    String path =
        '${MyConstant().domain}/WaterShop/getOrderWhereIdShop.php?isAdd=true';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('รายการน้ำดื่มที่ลูกค้าสั่ง'),),
      body: Stack(
        children: <Widget>[
          loadStatus ? buildNoneOrder() : showContent(),
        ],
      ),
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

  Future refresh() async {
    setState(() {
      findOrderShop();
    });
  }

  Widget showListOrderWater() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        shrinkWrap: true,
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
                MyStyle().showTitleH33('สถานะการจัดส่ง : รอยืนยัน'),
                MyStyle().mySixedBox(),
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
                ),
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
                              'รวมทั้งหมด :',
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
                            ordermodels[index].status == 'Cancle'
                                ? MyStyle().showTitleH3('ยกเลิก')
                                : Text(
                                    '${totals[index].toString()} บาท',style: MyStyle().mainhATitle,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                MyStyle().mySixedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.red),
                      ),
                      onPressed: () {
                        confirmDeleteCancleOrder(index);
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Cancle Order',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.blue),
                      ),
                      onPressed: () {
                        updateStatusConfirmOrder(index).then((value) {
                          normalDialog(
                              context, 'ส่งรายการน้ำดื่มไปยังพนักงานแล้วครับ');
                          Navigator.pop(context);
                          setState(() {
                            findOrderShop();
                          });
                        });
                      },
                      icon: Icon(
                        Icons.check_circle,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      label: Text(
                        'Confirm Order',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> confirmDeleteCancleOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle().showTitleH2('คุณต้องการยกเลิกรายการ สั่งซื้อน้ำดื่ม\nที่ ${ordermodels[index].orderId} ใช่ไหม ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                child: Text(
                  ' ตกลง ',
                  style: MyStyle().mainDackTitle,
                ),
                onPressed: () async {
                  cancleOrderUser(index);
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  ' ยกเลิก ',
                  style: MyStyle().mainDackTitle,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
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

  Future<Null> updateStatusConfirmOrder(int index) async {
    String order_id = ordermodels[index].orderId!;
    String path =
        '${MyConstant().domain}/WaterShop/editStatusWhereuser_id.php?isAdd=true&status=shopprocess&orderId=$order_id';

    await Dio().get(path).then(
      (value) {
        if (value.toString() == 'true') {
          notificationtoShop(index);
          normalDialog(context, 'ส่งรายการน้ำดื่มไปยังพนักงานแล้วครับ');
        }
      },
    );
  }

  Future<Null> cancleOrderUser(int index) async {
    String? order_id = ordermodels[index].orderId;
    String url =
        '${MyConstant().domain}/WaterShop/cancleOrderWhereorderId.php?isAdd=true&status=Cancle&orderId=$order_id';

    await Dio().get(url).then((value) {
      notificationCancleShop(index);
      findOrderShop();
      normalDialogChack(
          context, 'ยกเลิกรายการสั่งซื้อสำเร็จ', 'รายการสั่งซื้อที่ $order_id');
    });
  }

  Future<Null> notificationCancleShop(int index) async {
    String id = ordermodels[index].userId!;
    String urlFindToken =
        '${MyConstant().domain}WaterShop/getUserWhereId.php?isAdd=true&id=$id';

    await Dio().get(urlFindToken).then((value) {
      var result = json.decode(value.data);
      print('result == $result');
      for (var json in result) {
        UserModel model = UserModel.fromJson(json);
        String tokenUser = model.token!;
        print('tokenShop ==>> $tokenUser');
        String title = 'คุณ ${model.name} ขออภัยในความไม่สะดวก';
        String body =
            'ทางร้านได้ยกเลิกคำสั่งซื้อของคุณกรุณาติดต่อร้าน ขอบคุณค่ะ';

        String urlSendToken =
            '${MyConstant().domain}/waterShop/apiNotification.php?isAdd=true&token=$tokenUser&title=$title&body=$body';
        sendNotificationToShop(urlSendToken);
      }
    });
  }

  Future<Null> notificationtoShop(int index) async {
    String id = ordermodels[index].userId!;
    String urlFindToken =
        '${MyConstant().domain}WaterShop/getUserWhereId.php?isAdd=true&id=$id';

    await Dio().get(urlFindToken).then((value) {
      var result = json.decode(value.data);
      // print('result == $result');
      for (var json in result) {
        UserModel model = UserModel.fromJson(json);
        String tokenUser = model.token!;
        // print('tokenShop ==>> $tokenUser');
        String title =
            'คุณ ${model.name} ทางร้านได้ยืนยันการสั่งซื้อของคุณแล้ว';
        String body = 'กรุณารอรับสินค้าและตรวจสอบการสั่งซื้อ';

        String urlSendToken =
            '${MyConstant().domain}/waterShop/apiNotification.php?isAdd=true&token=$tokenUser&title=$title&body=$body';
        sendNotificationToShop(urlSendToken);
      }
    });
  }

  Future<Null> sendNotificationToShop(String urlSendToken) async {
    await Dio().get(urlSendToken).then(
          (value) => print('notification Success'),
        );
  }
}
