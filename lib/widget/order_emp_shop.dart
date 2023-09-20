import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/order_model.dart';
import '../model/user_model.dart';
import '../screen/add_order.dart';
import '../screen/employee/follow_map_emp.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';
import '../utility/dialog.dart';

class ListOrder {
  String orderName;
  List<OrderModel> items;

  ListOrder({required this.orderName, required this.items});
}

class OrderConfirmEmp extends StatefulWidget {
  const OrderConfirmEmp({super.key});

  @override
  State<OrderConfirmEmp> createState() => _OrderConfirmEmpState();
}

class _OrderConfirmEmpState extends State<OrderConfirmEmp> {
  bool loadStatus = true; // Process load JSON
  bool status = true;
  final number = "0611675623";
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
    // TODO: implement initState
    super.initState();
    findOrderShop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        listOrder.isNotEmpty ? showListOrderWater() : buildNoneOrder(),
        addMenuButton(),
      ],
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
                    // MaterialPageRoute route = MaterialPageRoute(
                    //   builder: (context) => AddOrderEmpAndShop(),
                    // );
                    // Navigator.push(context, route)
                    //     .then((value) => findOrderShop());
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );

  // Future<Null> findOrderShop() async {
  //   if (listOrder.length != 0) {
  //     listOrder.clear();
  //   }

  //   String path =
  //       '${MyConstant().domain}/WaterShop/getOrderWhereIdShop.php?status=shopprocess';
  //   await Dio().get(path).then((value) {
  //     // print('value ==> $value');
  //     var result = jsonDecode(value.data);
  //     // print('result ==> $result');

  //     if (result != null) {
  //       result?.forEach((elem) => ordermodels.add(OrderModel.fromJson(elem)));

  //       /*
  //        listOrder = [
  //         {
  //           "orderName": "12345678",
  //           "items": [model1, model2],
  //        }
  //        ];
  //       */

  //       Map<String, List<OrderModel>> items = {};

  //       ordermodels.forEach((elem) {
  //         if (items[elem.orderNumber] == null) {
  //           items[elem.orderNumber as String] = [];
  //         }

  //         items[elem.orderNumber as String]?.add(elem);
  //       });

  //       items.forEach((key, value) =>
  //           listOrder.add(ListOrder(orderName: key, items: value)));

  //       print('\nlistOrder: $listOrder\n\n');

  //       setState(() {});
  //     } else {
  //       setState(() {
  //         status = true;
  //       });
  //     }
  //   });
  // }

  Future<Null> findOrderShop() async {
    String userOrderPath =
        '${MyConstant().domain}/WaterShop/getOrderWhereIdShop.php?status=shopprocess';
    var userOrder = await Dio().get(userOrderPath);
    var userOrderResult = jsonDecode(userOrder.data);

    String cancelPath =
        '${MyConstant().domain}/WaterShop/getOrderWhereIdShop.php?status=';
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
        if (items[elem.orderNumber] == null) {
          items[elem.orderNumber as String] = [];
        }

        items[elem.orderNumber as String]?.add(elem);
      });

      listOrder.clear();

      items.forEach((key, value) =>
          listOrder.add(ListOrder(orderName: key, items: value)));

      setState(() {});
    } else {
      setState(() {
        listOrder.clear();
        status = true;
      });
    }
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
                        'คำสั่งซื้อ : ${listOrder[i].items[0].orderNumber}'),
                    MyStyle().showTitleH33(
                        'เวลาสั่งซื้อ : ${listOrder[i].items[0].createAt}'),
                    MyStyle().showTitleH33(
                        'สถานะการชำระเงิน : ${listOrder[i].items[0].paymentStatus}'),
                    MyStyle().showTitleH33('สถานะการจัดส่ง : รอพนักงานจัดส่ง'),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (listOrder[i].items[0].status != 'Cancel') ...[
                          ElevatedButton(
                            onPressed: () {
                              // MaterialPageRoute route = MaterialPageRoute(
                              //   builder: (context) => EditOrderEmp(
                              //     orderModel: ordermodels[i],
                              //   ),
                              // );
                              // Navigator.push(context, route).then(
                              //   (value) => findOrderShop(),
                              // );
                            },
                            child: Text("แก้ไข"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              confirmDeleteCancleOrder(i);
                            },
                            child: Text("ลบ"),
                          ),
                          // ElevatedButton(
                          //   style: ButtonStyle(
                          //     backgroundColor: MaterialStateProperty.all<Color>(
                          //         Colors.green),
                          //   ),
                          //   onPressed: () {
                          //     MaterialPageRoute route = MaterialPageRoute(
                          //       builder: (context) => FollowMapCustomer(
                          //         orderModel: ordermodels[i],
                          //       ),
                          //     );
                          //     Navigator.push(context, route);
                          //   },
                          //   child: Icon(Icons.navigation),
                          // ),
                          ElevatedButton.icon(
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.green),
                            ),
                            onPressed: () {
                              updateStatusConfirmOrder(i);
                            },
                            icon: Icon(
                              Icons.notification_add,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            label: Text(
                              'กำลังจัดส่ง',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
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

  Future<Null> confirmDeleteCancleOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle().showTitleH2(
            'คุณต้องการยกเลิกรายการ สั่งซื้อน้ำดื่มที่ ${ordermodels[index].orderNumber} ใช่ไหม ?'),
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

  // Future<Null> updateStatusConfirmOrder(int index) async {
  //   String? orderNumber = ordermodels[index].orderNumber;
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String? emp_id = preferences.getString('id');

  //   String path =
  //       '${MyConstant().domain}/WaterShop/editStatusWhereuser_id_RiderHandle.php?isAdd=true&status=RiderHandle&emp_id=$emp_id&order_number=$orderNumber';

  //   await Dio().get(path).then(
  //     (value) {
  //       if (value.toString() == 'true') {
  //         notificationtoShop(index);
  //       }
  //     },
  //   );
  // }

  Future<Null> updateStatusConfirmOrder(int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? emp_id = preferences.getString('id');
    String orderNumber = '${listOrder[index].items[0].orderNumber}';
    String path =
        '${MyConstant().domain}/WaterShop/editStatusWhereuser_id_RiderHandle.php?';
    print(path);

    await Dio().put(path, data: {
      'status': 'RiderHandle',
      'emp_id': '$emp_id',
      'order_number': orderNumber
    }).then(
      (value) {
        if (value.toString() == 'true') {
          notificationtoShop(index);
          refresh();
        }
      },
    );
  }

  // Future<Null> cancleOrderUser(int index) async {
  //   String? orderNumber = ordermodels[index].orderNumber;
  //   String url =
  //       '${MyConstant().domain}/WaterShop/cancleOrderWhereorderId.php?isAdd=true&status=Cancle&order_number=$orderNumber';

  //   await Dio().get(url).then((value) {
  //     findOrderShop();
  //     notificationCancleShop(index);
  //     normalDialogChack(context, 'ยกเลิกรายการสั่งซื้อสำเร็จ',
  //         'รายการสั่งซื้อที่ $orderNumber');
  //   });
  // }

  Future<Null> cancleOrderUser(int index) async {
    String orderNumber = '${listOrder[index].items[0].orderNumber}';
    String path = '${MyConstant().domain}WaterShop/editStatusWhereuser_id.php';
    print(orderNumber);
    print(path);

    await Dio().put(path,
        data: {'status': 'Cancel', 'order_number': orderNumber}).then(
      (value) {
        if (value.toString() == 'true') {
          notificationCancleShop(index);
          refresh();
          // normalDialogChack(context, 'ยกเลิกรายการสั่งซื้อสำเร็จ',
          //     'รายการสั่งซื้อที่ $orderNumber');

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
        // sendNotificationToShop(urlSendToken);
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
        String title = 'คุณ ${model.name} พนักงานกำลังจัดส่งสินค้าให้คุณแล้ว';
        String body = 'กรุณารอรับสินค้าและตรวจสอบการสั่งซื้อ';

        String urlSendToken =
            '${MyConstant().domain}/waterShop/apiNotification.php?isAdd=true&token=$tokenUser&title=$title&body=$body';
        sendNotificationToShop(urlSendToken);
      }
    });
  }

  Future<Null> sendNotificationToShop(String urlSendToken) async {
    await Dio().get(urlSendToken).then(
          (value) =>
              // normalDialog(context, 'ส่งข้อความแจ้งเตือนไปยังลูกค้าแล้วค่ะ'),

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
          )..show(),
        );
  }
}
