import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/api.dart';
import '../model/order_model.dart';
import '../model/user_model.dart';
import '../screen/employee/follow_map_emp.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';
import '../utility/dialog.dart';

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
    if (ordermodels.length != 0) {
      ordermodels.clear();
    }

    String path =
        '${MyConstant().domain}/WaterShop/getOrderwherestatus_Shopprocess.php?isAdd=true';
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
      } else {
        setState(() {
          status = true;
        });
      }
    });
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
                MyStyle().showTitleH33('สถานะ : รอพนักงานจัดส่ง'),
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
                      onPressed: () {
                        // MaterialPageRoute route = MaterialPageRoute(
                        //   builder: (context) => EditOrderEmp(
                        //     orderModel: orderModels[index],
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
                        confirmDeleteCancleOrder(index);
                      },
                      child: Text("ลบ"),
                    ),
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
                            MaterialStatePropertyAll<Color>(Colors.green),
                      ),
                      onPressed: () {
                        updateStatusConfirmOrder(index).then((value) {
                          normalDialog2(context, "กำลังจัดส่ง", "อัพเดทสถานะจัดส่ง");
                          Navigator.pop(context);
                          setState(() {
                            findOrderShop();
                          });
                        });
                      },
                      icon: Icon(
                        Icons.notification_add,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      label: Text(
                        'กำลังจัดส่ง',
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
        title: Text(
          'คุณต้องการยกเลิกรายการ สั่งซื้อน้ำดื่มที่ ${ordermodels[index].orderId} ใช่ไหม ?',
          style: MyStyle().mainDackTitle,
        ),
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

  Future<Null> updateStatusConfirmOrder(int index) async {
    String? orderId = ordermodels[index].orderId;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? emp_id = preferences.getString('id');

    String path =
        '${MyConstant().domain}/WaterShop/editStatusWhereuser_id_RiderHandle.php?isAdd=true&status=RiderHandle&riderId=$emp_id&orderId=$orderId';

    await Dio().get(path).then(
      (value) {
        if (value.toString() == 'true') {
          notificationtoShop(index);
        }
      },
    );
  }

  Future<Null> cancleOrderUser(int index) async {
    String? order_id = ordermodels[index].orderId;
    String url =
        '${MyConstant().domain}/WaterShop/cancleOrderWhereorderId.php?isAdd=true&status=Cancle&orderId=$order_id';

    await Dio().get(url).then((value) {
      findOrderShop();
      normalDialog2(
          context, 'ยกเลิกรายการสั่งซื้อสำเร็จ', 'รายการสั่งซื้อที่ $order_id');
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
          (value) =>
              normalDialog(context, 'ส่งข้อความแจ้งเตือนไปยังลูกค้าแล้วค่ะ'),
        );
  }
}
