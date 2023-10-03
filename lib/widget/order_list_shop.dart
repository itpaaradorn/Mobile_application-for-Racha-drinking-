import 'dart:convert';

import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/widget/select_customer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../model/order_model.dart';
import '../screen/add_order.dart';
import '../screen/edit_order.dart';
import '../utility/my_constant.dart';
import '../utility/dialog.dart';

class ListOrder {
  String orderName;
  List<OrderModel> items;

  ListOrder({required this.orderName, required this.items});
}

class OrderListShop extends StatefulWidget {
  @override
  State<OrderListShop> createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  UserModel? userModel;
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
    // showContent();
  }

  Future<Null> findOrderShop() async {
    String userOrderPath =
        '${MyConstant().domain}/WaterShop/getOrderWhereIdShop.php?status=userorder';
    var userOrder = await Dio().get(userOrderPath);
    var userOrderResult = jsonDecode(userOrder.data);

    String cancelPath =
        '${MyConstant().domain}/WaterShop/getOrderWhereIdShop.php?status=Cancel';
    var cancel = await Dio().get(cancelPath);
    var cancelResult = jsonDecode(cancel.data);

    print('userOrderResult -> ${userOrderResult?.length}');
    print('cancelResult -> ${cancelResult?.length}\n\n');

    if (userOrderResult == null) {
      prepareListOrder(cancelResult);
    } else if (cancelResult == null) {
      prepareListOrder(userOrderResult);
    } else {
      prepareListOrder([...userOrderResult, ...cancelResult]);
    }
  }

  void prepareListOrder(result) {
    ordermodels.clear();

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
        status = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'รายการน้ำดื่มที่ลูกค้าสั่ง',
          style: TextStyle(color: Colors.indigo),
        ),
      ),
      body: Stack(
        children: <Widget>[
          listOrder.isNotEmpty ? showListOrderWater() : buildNoneOrder(),
          addMenuButton()
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
         
          MyStyle().mySixedBox(),
          Text(
            'ยังไม่มีข้อมูลการสั่งน้ำดื่ม',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Future refresh() async {
    Future.delayed(const Duration(seconds: 1), () => findOrderShop());
  }

  Widget showListOrderWater() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
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
                    MyStyle().showTitleH33('สถานะการจัดส่ง : รอยืนยัน ✐'),
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
                                    items[j].price ?? '',
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
                                listOrder[i].items[0].status == 'Cancel'
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
                    MyStyle().mySixedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (listOrder[i].items[0].status != 'Cancel') ...[
                          ElevatedButton.icon(
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.red),
                            ),
                            onPressed: () {
                              confirmDeleteCancleOrder(i);
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
                              updateStatusConfirmOrder(i);
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
                          ElevatedButton.icon(
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.blue),
                            ),
                            onPressed: () {
                              MaterialPageRoute route = MaterialPageRoute(
                                builder: (context) => EditOrderEmp(
                                  orderModel: ordermodels[i],
                                ),
                              );
                              Navigator.push(context, route).then(
                                (value) => findOrderShop(),
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget addMenuButton() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      // builder: (context) => addOrderShop(),
                      builder: (context) => SelectCustomerPage(),
                    );
                    Navigator.push(context, route)
                        .then((value) => findOrderShop());
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );

  Future<Null> confirmDeleteCancleOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle().showTitleH2(
            'คุณต้องการยกเลิกรายการ สั่งซื้อน้ำดื่ม\nที่ ${ordermodels[index].orderNumber} ใช่ไหม ?'),
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
    String order_id = '${listOrder[index].items[0].orderTableId}';
    String path = '${MyConstant().domain}WaterShop/editStatusWhereuser_id.php';
    print(path);

    await Dio().put(path, data: {
      'status': 'shopprocess',
      'order_id': order_id,
    }).then(
      (value) {
        if (value.toString() == 'true') {
          notificationtoShop(index);
          refresh();
          AwesomeDialog(
            context: context,
            animType: AnimType.bottomSlide,
            dialogType: DialogType.success,
            body: Center(
              child: Text(
                'ส่งข้อความแจ้งเตือนไปยังลูกค้าแล้วค่ะ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: () {},
          ).show();
        }
      },
    );
  }

  Future<Null> cancleOrderUser(int index) async {
    String order_id = '${listOrder[index].items[0].orderTableId}';
    String path = '${MyConstant().domain}WaterShop/editStatusWhereuser_id.php';

    // print(orderNumber);
    // print(path);

    await Dio()
        .put(path, data: {'status': 'Cancel', 'order_id': order_id}).then(
      (value) {
        if (value.toString() == 'true') {
          notificationCancleShop(index);
          refresh();

          AwesomeDialog(
            context: context,
            animType: AnimType.bottomSlide,
            dialogType: DialogType.noHeader,
            body: Center(
              child: Text(
                'ยกเลิกรายการสั่งซื้อสำเร็จ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: () {},
          ).show();
        }
      },
    );
  }

  Future<Null> notificationCancleShop(int index) async {
    String id = listOrder[index].items[0].userId!;
    String urlFindToken =
        '${MyConstant().domain}WaterShop/getUserWhereId.php?isAdd=true&id=$id';

    await Dio().get(urlFindToken).then((value) {
      var result = json.decode(value.data);
      // print('result == $result');
      for (var json in result) {
        UserModel model = UserModel.fromJson(json);
        String tokenUser = model.token!;
        // print('tokenShop ==>> $tokenUser');
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
    String id = listOrder[index].items[0].userId!;
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
