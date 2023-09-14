import 'dart:convert';

import 'package:application_drinking_water_shop/widget/save_bill_order_emp.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/api.dart';
import '../model/order_model.dart';
import '../model/user_model.dart';
import '../screen/employee/follow_map_emp.dart';
import '../utility/dialog.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';

class ListOrder {
  String orderName;
  List<OrderModel> items;

  ListOrder({required this.orderName, required this.items});
}

class OrderProcessEmp extends StatefulWidget {
  const OrderProcessEmp({super.key});

  @override
  State<OrderProcessEmp> createState() => _OrderProcessEmpState();
}

class _OrderProcessEmpState extends State<OrderProcessEmp> {
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

  Future<Null> findOrderShop() async {
    String userOrderPath =
        '${MyConstant().domain}/WaterShop/getOrderWhereIdShop.php?status=RiderHandle';
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

      // print('listOrder -> ${listOrder.length}');
    } else {
      setState(() {
        listOrder.clear();
        status = true;
      });
    }
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
                    'คำสั่งซื้อ : ${listOrder[i].items[0].orderNumber}'),
                MyStyle().showTitleH33(
                    'เวลาสั่งซื้อ : ${listOrder[i].items[0].createAt}'),
                MyStyle().showTitleH33(
                    'สถานะการชำระเงิน : ${listOrder[i].items[0].paymentStatus}'),
                MyStyle().showTitleH33('สถานะการจัดส่ง : กำลังจัดส่ง'),
                MyStyle().showTitleH33(
                    'ค่าจัดส่งที่ต้องเก็บ : ${listOrder[i].items[0].transport} THB'),
                MyStyle().showTitleH33(
                    'ผู้จัดส่ง : ${listOrder[i].items[0].riderName} '),
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
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        onPressed: () {
                          MaterialPageRoute route = MaterialPageRoute(
                            builder: (context) => FollowMapCustomer(
                              orderModel: ordermodels[i],
                            ),
                          );
                          Navigator.push(context, route);
                        },
                        child: Icon(Icons.navigation),
                      ),
                      ElevatedButton.icon(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.blue),
                        ),
                        onPressed: () {
                          if (listOrder[i].items[0].paymentStatus ==
                              'เก็บเงินปลายทาง') {
                            MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => SaveBillOrderEmp(
                                orderModel: ordermodels[i],
                              ),
                            );
                            Navigator.push(context, route).then(
                              (value) {
                                updateStatusConfirmOrder_payment(i)
                                    .then((value) {
                                  findOrderShop();
                                });
                              },
                            );
                          } else {
                            updateStatusConfirmOrder(i).then((value) {
                              findOrderShop();
                            });
                          }
                        },
                        icon: Icon(
                          Icons.fact_check,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        label: Text(
                          'จัดส่งสำเร็จ',
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
      },
    );
  }

  // Widget showListOrderWater() {
  //   return ListView.builder(
  //     itemCount: ordermodels.length,
  //     itemBuilder: (context, index) => Card(
  //       color: index % 2 == 0 ? Colors.grey.shade100 : Colors.grey.shade100,
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             MyStyle().showTitleH2('คุณ ${ordermodels[index].name}'),
  //             MyStyle()
  //                 .showTitleH33('คำสั่งซื้อ : ${ordermodels[index].orderNumber}'),
  //             MyStyle().showTitleH33(
  //                 'เวลาสั่งซื้อ : ${ordermodels[index].createAt}'),
  //             MyStyle().showTitleH33('สถานะ : รอพนักงานจัดส่ง'),
  //             MyStyle().showTitleH33(
  //                 'สถานะการชำระเงิน : ${ordermodels[index].paymentStatus}'),
  //             MyStyle().showTitleH33(
  //                 'ค่าจัดส่งที่ต้องเก็บ : ${ordermodels[index].transport} THB'),
  //             MyStyle()
  //                 .showTitleH33('ผู้จัดส่ง : ${ordermodels[index].riderName} '),
  //             MyStyle().mySixedBox(),
  //             buildTitle(),
  //             ListView.builder(
  //               itemCount: listnameWater[index].length,
  //               shrinkWrap: true,
  //               physics: ScrollPhysics(),
  //               itemBuilder: (context, index2) => Container(
  //                 padding: EdgeInsets.all(5.0),
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                       flex: 2,
  //                       child: Text(
  //                         '${listAmounts[index][index2]}x',
  //                         style: MyStyle().mainh3Title,
  //                       ),
  //                     ),
  //                     Expanded(
  //                       flex: 1,
  //                       child: Text(
  //                         listnameWater[index][index2],
  //                         style: MyStyle().mainh3Title,
  //                       ),
  //                     ),
  //                     Expanded(
  //                       flex: 1,
  //                       child: Text(
  //                         listPrices[index][index2],
  //                         style: MyStyle().mainh3Title,
  //                       ),
  //                     ),
  //                     Expanded(
  //                       flex: 1,
  //                       child: Text(
  //                         listSums[index][index2],
  //                         style: MyStyle().mainh3Title,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               padding: EdgeInsets.all(4.0),
  //               child: Row(
  //                 children: [
  //                   Expanded(
  //                     flex: 6,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         Text(
  //                           'รวมทั้งหมด : ',
  //                           style: MyStyle().mainh1Title,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Expanded(
  //                     flex: 2,
  //                     child: Text(
  //                       '${totals[index].toString()} บาท',
  //                       style: MyStyle().mainhATitle,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             MyStyle().mySixedBox(),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 ElevatedButton(
  //                   style: ButtonStyle(
  //                     backgroundColor:
  //                         MaterialStateProperty.all<Color>(Colors.green),
  //                   ),
  //                   onPressed: () {
  //                     MaterialPageRoute route = MaterialPageRoute(
  //                       builder: (context) => FollowMapCustomer(
  //                         orderModel: ordermodels[index],
  //                       ),
  //                     );
  //                     Navigator.push(context, route);
  //                   },
  //                   child: Icon(Icons.navigation),
  //                 ),
  //                 ElevatedButton.icon(
  //                   style: const ButtonStyle(
  //                     backgroundColor:
  //                         MaterialStatePropertyAll<Color>(Colors.blue),
  //                   ),
  //                   onPressed: () {
  //                     if (ordermodels[index].paymentStatus.toString() ==
  //                         'payondelivery') {
  //                       MaterialPageRoute route = MaterialPageRoute(
  //                         builder: (context) => SaveBillOrderEmp(
  //                             orderModel: ordermodels[index],
  //                             ),
  //                       );
  //                       Navigator.push(context, route).then(
  //                         (value) {
  //                           updateStatusConfirmOrder(index).then((value) {
  //                             findOrderShop();
  //                           });
  //                         },
  //                       );
  //                     } else {
  //                       updateStatusConfirmOrder(index).then((value) {
  //                         findOrderShop();
  //                       });
  //                     }
  //                   },
  //                   icon: Icon(
  //                     Icons.fact_check,
  //                     color: Color.fromARGB(255, 255, 255, 255),
  //                   ),
  //                   label: Text(
  //                     'จัดส่งสำเร็จ',
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
    String orderNumber = '${listOrder[index].items[0].orderNumber}';
    String path = '${MyConstant().domain}WaterShop/editStatusWhereuser_id.php';
    print(path);

    await Dio().put(path,
        data: {'status': 'Finish', 'order_number': orderNumber}).then(
      (value) {
        if (value.toString() == 'true') {
          notificationtoShop(index);
          
        }
      },
    );
  }

  Future<Null> updateStatusConfirmOrder_payment(int index) async {
    String orderNumber = '${listOrder[index].items[0].orderNumber}';
    String path = '${MyConstant().domain}WaterShop/editStatusWhereuser_id.php';
    print(path);

    await Dio().put(path,
        data: {'status': 'Finish', 'order_number': orderNumber}).then(
      (value) {
        if (value.toString() == 'true') {
          // notificationtoShop(index);
         AwesomeDialog(
            context: context,
            animType: AnimType.bottomSlide,
            dialogType: DialogType.success,
            body: Center(
              child: Text(
                'ทำการจัดส่งสินค้าเสร็จสิ้น',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: () {},
          )..show();
        }
      },
    );
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
        String title = 'คุณ ${model.name}การจัดส่งสินค้าสำเร็จ';
        String body = 'กรุณาตรวจสอบการสั่งซื้อ';

        String urlSendToken =
            '${MyConstant().domain}/waterShop/apiNotification.php?isAdd=true&token=$tokenUser&title=$title&body=$body';
        sendNotificationToShop(urlSendToken);
      }
    });
  }

  Future<Null> sendNotificationToShop(String urlSendToken) async {
    await Dio().get(urlSendToken).then(
          (value) => AwesomeDialog(
            context: context,
            animType: AnimType.bottomSlide,
            dialogType: DialogType.success,
            body: Center(
              child: Text(
                'ทำการจัดส่งสินค้าเสร็จสิ้น',
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
