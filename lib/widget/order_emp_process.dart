import 'dart:convert';

import 'package:application_drinking_water_shop/widget/save_bill_order_emp.dart';
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
    // if (ordermodels.length != 0) {
    //   ordermodels.clear();
    // }

    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String? riderId = preferences.getString(MyConstant().keyId);

    // String path =
    //     '${MyConstant().domain}/WaterShop/getOrderRiderHandle.php?isAdd=true&riderId=$riderId';
    // await Dio().get(path).then((value) {
    //   // print('value ==> $value');
    //   var result = jsonDecode(value.data);
    //   // print('result ==> $result');
    //   if (result != null) {
    //     for (var item in result) {
    //       OrderModel model = OrderModel.fromJson(item);
    //       // print('OrderdateTime ==> ${model.orderDateTime}');

    //       // List<String> nameWater =
    //       //     MyAPI().createStringArray(model.brandName!);
    //       // List<String> amountgas = MyAPI().createStringArray(model.amount!);
    //       // List<String> pricewater = MyAPI().createStringArray(model.price!);
    //       // List<String> pricesums = MyAPI().createStringArray(model.sum!);
    //       // List<String> userid = MyAPI().createStringArray(model.userId!);

    //       int total = 0;
    //       for (var item in pricesums) {
    //         total = total + int.parse(item);
    //       }

    //       setState(() {
    //         loadStatus = false;
    //         ordermodels.add(model);
    //         listnameWater.add(nameWater);
    //         listAmounts.add(amountgas);
    //         listPrices.add(pricewater);
    //         listSums.add(pricesums);
    //         totals.add(total);
    //         listusers.add(userid);
    //         loadStatus = false;
    //       });
    //     }
    //   } else {
    //     setState(() {
    //       status = true;
    //     });
    //   }
    // });
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
              MyStyle().showTitleH2('คุณ ${ordermodels[index].name}'),
              MyStyle()
                  .showTitleH33('คำสั่งซื้อ : ${ordermodels[index].orderNumber}'),
              MyStyle().showTitleH33(
                  'เวลาสั่งซื้อ : ${ordermodels[index].createAt}'),
              MyStyle().showTitleH33('สถานะ : รอพนักงานจัดส่ง'),
              MyStyle().showTitleH33(
                  'สถานะการชำระเงิน : ${ordermodels[index].paymentStatus}'),
              MyStyle().showTitleH33(
                  'ค่าจัดส่งที่ต้องเก็บ : ${ordermodels[index].transport} THB'),
              MyStyle()
                  .showTitleH33('ผู้จัดส่ง : ${ordermodels[index].riderName} '),
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
                            'รวมทั้งหมด : ',
                            style: MyStyle().mainh1Title,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${totals[index].toString()} บาท',
                        style: MyStyle().mainhATitle,
                      ),
                    ),
                  ],
                ),
              ),
              MyStyle().mySixedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () {
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => FollowMapCustomer(
                          orderModel: ordermodels[index],
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
                      if (ordermodels[index].paymentStatus.toString() ==
                          'payondelivery') {
                        MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => SaveBillOrderEmp(
                              orderModel: ordermodels[index],
                              ),
                        );
                        Navigator.push(context, route).then(
                          (value) {
                            updateStatusConfirmOrder(index).then((value) {
                              findOrderShop();
                            });
                          },
                        );
                      } else {
                        updateStatusConfirmOrder(index).then((value) {
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
    String? orderNumber = ordermodels[index].orderNumber;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? emp_id = preferences.getString('id');

    String path =
        '${MyConstant().domain}/WaterShop/editStatusWhereuser_id_Finish.php?isAdd=true&status=Finish&emp_id=$emp_id&order_namber=$orderNumber';

    await Dio().get(path).then(
      (value) {
        if (value.toString() == 'true') {
          notificationtoShop(index);
        }
      },
    );
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
            'คุณ ${model.name}การจัดส่งสินค้าสำเร็จ';
        String body = 'กรุณาตรวจสอบการสั่งซื้อ';

        String urlSendToken =
            '${MyConstant().domain}/waterShop/apiNotification.php?isAdd=true&token=$tokenUser&title=$title&body=$body';
        sendNotificationToShop(urlSendToken);
      }
    });
  }

  Future<Null> sendNotificationToShop(String urlSendToken) async {
    await Dio().get(urlSendToken).then(
          (value) => normalDialog(
              context, 'ส่งข้อความแจ้งเตือนไปยังลูกค้าแล้วค่ะ'),
        );
  }
}
