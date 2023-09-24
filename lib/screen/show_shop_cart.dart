import 'dart:convert';

import 'package:application_drinking_water_shop/model/water_model.dart';
import 'package:application_drinking_water_shop/screen/payment.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/dialog.dart';
import 'package:application_drinking_water_shop/utility/sqlite_helper.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../model/order_detail.dart';
import '../model/user_model.dart';
import 'main_user.dart';

class ShowCart extends StatefulWidget {
  const ShowCart({super.key});

  @override
  State<ShowCart> createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<OrderDetail> orderDetails = [];

  WaterModel? waterModel;
  String? water_id, user_id, amount, quantity;
  int total = 0;
  bool status = true;
  bool? loadStatus = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // readSQLite();
    readOrderFormIdUser();
  }

  // Future<Null> readSQLite() async {
  //   var object = await SQLiteHelper().readAllDataFormSQLite();
  //   print('object length == ${object.length}');

  //   if (object.length != 0) {
  //     for (var model in object) {
  //       String sumString = model.sum!;
  //       int sumInt = int.parse(sumString);
  //       setState(() {
  //         ststus = false;
  //         cartModels = object;
  //         total = total + sumInt;
  //       });
  //     }
  //   } else {
  //     setState(() {
  //       ststus = true;
  //     });
  //   }
  // }

  Future<Null> readOrderFormIdUser() async {
    if (orderDetails.length != 0) {
      orderDetails.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? create_by = preferences.getString('id');
    // print('idShop =>>> $idShop');

    String url =
        '${MyConstant().domain}/WaterShop/getOrderDetail_WhereIdUser.php?create_by=$create_by';
    await Dio().get(url).then((value) {
      setState(() {
        status = false;
      });

      if (value.toString() != 'null') {
        // print('value =>> $value');
        var result = json.decode(value.data);
        print('result ==>> $result');

        for (var map in result) {
          OrderDetail orderdetail = OrderDetail.fromJson(map);
          String sumString = orderdetail.sum!;

          int sumInt = int.parse(sumString);

          setState(() {
            orderDetails.add(orderdetail);
            total = total + sumInt;
          });
        }
      } else {
        setState(() {
          status = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return status
        ? Center(
            child: Text('ตะกร้าว่างเปล่า'),
          )
        : buildContent();
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildmaintitleshop(),
            Divider(
              color: Colors.black26,
              height: 30,
              thickness: 5,
            ),
            buildHeadTitle(),
            buildListWater(),
            Divider(
              height: 50,
              thickness: 10,
            ),
            buildTotal(),
            MyStyle().mySixedBox(),
            buildPaymentButton(),
            buildAddOrderButton(),
          ],
        ),
      ),
    );
  }

  

  Widget buildOrderButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 110,
          child: ElevatedButton.icon(
            onPressed: () {
              // orderThread();
            },
            icon: Icon(Icons.add_shopping_cart_sharp),
            label: Text('สั่งซื้อ'),
          ),
        ),
      ],
    );
  }

  Widget buildPaymentButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10, right: 10),
          width: 160,
          child: ElevatedButton.icon(
            onPressed: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => Bank(),
              );
              Navigator.push(context, route);
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
            ),
            label: Text(
              'ชำระเงินล่วงหน้า',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.add_shopping_cart_sharp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAddOrderButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10, right: 10),
          width: 160,
          child: ElevatedButton.icon(
            onPressed: () {
              orderThread();
            },
            label: Text(
              'สั่งซื้อปลายทาง',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.add_shopping_cart_sharp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTotal() => Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyStyle().showTitleH2('ยอดรวมทั้งสิ้น =  '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3(total.toString()),
          ),
        ],
      );

  Widget buildmaintitleshop() {
    return Container(
      margin: EdgeInsets.only(top: 1, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              MyStyle().showTitle('รายการในตะกร้า'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MyStyle().showTitleH44(
                  'ระยะทาง : ${orderDetails[0].distance} กิโลเมตร'),
              MyStyle()
                  .showTitleH3('ค่าจัดส่ง : ${orderDetails[0].transport} บาท'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeadTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH2('จำนวน'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH2('ยี่ห้อ'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH2('ขนาด'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH2('ผลรวม'),
          ),
        ],
      ),
    );
  }

  Widget buildListWater() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: orderDetails.length,
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10, bottom: 20),
            padding: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(
                    '${orderDetails[index].amount}x',
                    style: MyStyle().mainhATitle,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    orderDetails[index].brandName!,
                    style: MyStyle().mainh23Title,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${orderDetails[index].size}ฺ ml.',
                    style: MyStyle().mainh23Title,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ' ${orderDetails[index].sum}ฺ THB',
                    style: MyStyle().mainh23Title,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    color: Colors.red,
                    icon: Icon(Icons.delete_forever),
                    onPressed: () => deleteOrderCart(orderDetails[index]),
                  ),
                )
              ],
            ),
          );
        },
      );

  Future<Null> deleteOrderCart(OrderDetail orderdetail) async {
    // String? url =
    //     'http://192.168.1.99/WaterShop/deleteOrderDetail.php?id=${orderdetail.id}';

    String url = 'http://192.168.1.99/WaterShop/deleteOrderDetail.php';

    Response resp = await Dio().delete(url, data: {'id': orderdetail.id});

    print(resp.statusCode);
    print(resp.statusMessage);

    if (resp.statusCode == 200) {
      readOrderFormIdUser();
    }
  }

  String prepareDigit(int number) {
    return number.toString().length > 1 ? "$number" : "0$number";
  }

  Future<Null> orderThread() async {
    // DateTime dateTime = DateTime.now();
    // // print(dateTime.toString());

    // String orderDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    // String distance = orderDetails[0].distance!;
    // String transport = orderDetails[0].transport!;

    // List<String> water_ids = [];
    // List<String> water_brand_ids = [];
    // List<String> sizes = [];
    // List<String> water_brand_names = [];
    // List<String> prices = [];
    // List<String> amounts = [];
    // List<String> sums = [];

    // for (var model in orderDetails) {
    //   water_ids.add(model.waterId!);
    //   water_brand_ids.add(model.idbrand!);
    //   sizes.add(model.size!);
    //   water_brand_names.add(model.brandName!);
    //   prices.add(model.price!);
    //   amounts.add(model.amount!);
    //   sums.add(model.sum!);
    // }
    // String water_id = water_ids.toString();
    // String water_brand_id = water_brand_ids.toString();
    // String size = sizes.toString();
    // String water_brand_name = water_brand_names.toString();
    // String price = prices.toString();
    // String amount = amounts.toString();
    // String sum = sums.toString();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user_id = preferences.getString('id');
    String? user_name = preferences.getString('Name');

    //   print(
    //       'orderDateTime == $orderDateTime, distance == $distance, transport == $transport');
    //   print(
    //       'water_id == $water_id, water_brand_id == $water_brand_id, size == $size, water_brand_name == $water_brand_name, price == $price, amount == $amount, sum == $sum ');

    DateTime now = DateTime.now();

    String orderNumber = "$user_id#${now.year}${prepareDigit(now.month)}${prepareDigit(now.day)}${prepareDigit(now.hour)}${prepareDigit(now.minute)}${prepareDigit(now.second)}";

    String? url = 'http://192.168.1.99/WaterShop/addOrderWater.php';

    for (var i = 0; i < orderDetails.length; i++) {
      Map<String, String> _map = {
        "create_by": user_id.toString(),
        "emp_id": "none",
        "payment_status": "เก็บเงินปลายทาง",
        "order_detail_id": orderDetails[i].id.toString(),
        "order_number": orderNumber,
      };

      Response response = await Dio().post(url, data: _map);
      print('response = ${response.statusCode}');
      print('response = ${response.data}');
    }
    notificationToShop(user_name!);

    setState(() {
      status = true;
      orderDetails = [];
    });

    // await Dio().get(url).then((value) {
    //   if (value.toString() == 'true') {
    //     clearOrderSQLite();
    //     notificationToShop(user_name!);
    //   } else {
    //     normalDialog(context, 'ไม่สามารถ สั่งซื้อได้ กรุณาลองใหม่');
    //   }
    // });
  }

  Future<Null> clearOrderSQLite() async {
    Toast.show("ทำรายการสั่งซื้อ เสร็จสิ้น",
        duration: Toast.lengthLong, gravity: Toast.bottom);
    await SQLiteHelper().deleteAllData().then((value) {
      // readSQLite();
    });
  }

  Future<Null> notificationToShop(String user_name) async {
    String? urlFindToken =
        '${MyConstant().domain}/WaterShop/getUserWhereId.php?isAdd=true&id=46';

    await Dio().get(urlFindToken).then((value) {
      var result = json.decode(value.data);
      // print('result ==>> $result');
      for (var json in result) {
        UserModel model = UserModel.fromJson(json);
        String tokenShop = model.token!;
        // print('tokenShop ==>> $tokenShop');
        String title = 'มีการสั่งซื้อจาก คุณ $user_name';
        String body = 'กรุณากดยืนยันเพื่อแจ้งลูกค้า';

        String urlSendToken =
            '${MyConstant().domain}/WaterShop/apiNotification.php?isAdd=true&token=$tokenShop&title=$title&body=$body';
        sendNotificationToShop(urlSendToken);
      }
    });
  }

 
  Future<Null> sendNotificationToShop(String urlSendToken) async {
    await Dio().get(urlSendToken).then((value) =>AwesomeDialog(
          context: context,
          animType: AnimType.bottomSlide,
          dialogType: DialogType.success,
          body: Center(
            child: Text(
              'การสั่งซื้อส่งไปที่ร้านแล้ว กรุณารอร้านจัดส่งค่ะ ',
              style: TextStyle(fontStyle: FontStyle.normal),
            ),
          ),
          title: 'This is Ignored',
          desc: 'This is also Ignored',
          btnOkOnPress: () {
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => MainUser(),
            );
            Navigator.push(context, route);
          },
        ).show());
  }
}
