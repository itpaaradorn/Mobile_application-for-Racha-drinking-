import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../model/order_detail.dart';
import '../model/user_model.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';
import '../utility/dialog.dart';
import '../utility/sqlite_helper.dart';
import 'main_user.dart';

class ConfirmPayment extends StatefulWidget {
  @override
  State<ConfirmPayment> createState() => _ConfirmPaymentState();
}

class _ConfirmPaymentState extends State<ConfirmPayment> {
  List<OrderDetail> orderDetails = [];
  String? dateTimeString;
  File? file;
  bool status = true;
  int total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findCurrentTime();
    readOrderFormIdUser();
  }

  void findCurrentTime() {
    DateTime dateTime = DateTime.now();
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    setState(() {
      dateTimeString = dateFormat.format(dateTime);
    });
    // print('datetime ==> $dateTime');
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Payment'),
      ),
      body: Column(
        children: [
          MyStyle().mySixedBoxxxxxxx(),
          MyStyle().mySixedBoxxxxxxx(),
          headTitle(),
          timeDateTitle(),
          Spacer(),
          buildBillImage(),
          Spacer(),
          newButtonConfirm(),
          MyStyle().mySixedBox(),
          buildwarning(),
          Spacer(),
        ],
      ),
    );
  }

  Container buildwarning() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      padding: EdgeInsets.all(15.0),
      width: 300,
      child: Text(
        '*หมายเหตุ  กรุณาตรวจสอบรายการสั่งซื้อในตะกร้าก่อนกดยืนยันการชำระเงิน',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Container newButtonConfirm() {
    return Container(
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          if (file != null) {
            orderThread();
          } else {
            normalDialog(context, "กรุนาแนบใบเสร็จก่อนสั่งซื้อ");
          }
        },
        child: Text('ยืนยันการชำระเงินสั่งซื้อ'),
      ),
    );
  }

  Future<void> processUploadInsertData() async {
    String apisaveSlip = '${MyConstant().domain}/WaterShop/saveSlip.php';
    String nameSlip = 'slip${Random().nextInt(1000000)}.jpg';

    try {
      Map<String, dynamic> map = {};
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameSlip);
      FormData data = FormData.fromMap(map);
      await Dio().post(apisaveSlip, data: data).then((value) async {
        String imageSlip = '/WaterShop/Slip/$nameSlip';
        // print('value == $value');
        DateTime dateTime = DateTime.now();
        // print(dateTime.toString());
        String slipDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
        // ignore: unused_local_variable
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? userId = preferences.getString('id');
        String? userName = preferences.getString('Name');
        String path =
            '${MyConstant().domain}/WaterShop/addpayment.php?isAdd=true&slip_date_time=$slipDateTime&image_slip=$imageSlip&order_id=none&user_id=$userId&user_name=$userName&rider_id=none';
        await Dio().get(path).then((value) => print('upload Sucess'));
      });
    } catch (e) {}
  }

  Future<void> processTakeBill(ImageSource source) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildBillImage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () => processTakeBill(ImageSource.camera),
          icon: Icon(Icons.add_a_photo),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            width: 180,
            height: 180,
            child: file == null
                ? Image.asset('images/bill.png')
                : Image.file(file!),
          ),
        ),
        IconButton(
          onPressed: () => processTakeBill(ImageSource.gallery),
          icon: Icon(Icons.add_photo_alternate),
        ),
      ],
    );
  }

  Text timeDateTitle() {
    return Text(
      dateTimeString == null ? 'dd/MM/yy HH:mm' : dateTimeString!,
      style: MyStyle().mainh23Title,
    );
  }

  Text headTitle() {
    return Text(
      'ยืนยันใบเสร็จชำระเงิน',
      style: MyStyle().mainConfirmTitle,
    );
  }

  Future<Null> AddPayment() async {}

  String prepareDigit(int number) {
    return number.toString().length > 1 ? "$number" : "0$number";
  }

  Future<Null> orderThread() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user_id = preferences.getString('id');
    String? user_name = preferences.getString('Name');

    String? url = '${MyConstant().domain}/WaterShop/addOrderWater.php';

    DateTime now = DateTime.now();
    String orderNumber =
        "$user_id#${now.year}${prepareDigit(now.month)}${prepareDigit(now.day)}${prepareDigit(now.hour)}${prepareDigit(now.minute)}${prepareDigit(now.second)}";

    for (var i = 0; i < orderDetails.length; i++) {
      Map<String, String> _map = {
        "create_by": user_id.toString(),
        "emp_id": "none",
        "payment_status": "ชำระเงินล่วงหน้าแล้ว",
        "order_detail_id": orderDetails[i].id.toString(),
        "order_number": orderNumber,
      };

      Response response = await Dio().post(url, data: _map);
      print('response = ${response.statusCode}');
      print('response = ${response.data}');
    }

    notificationTosShop(user_name!);

    setState(() {
      status = true;
      orderDetails = [];
    });

    // await Dio().get(url).then((value) {
    //   if (value.toString() == 'true') {
    //     clearOrderSQLite();
    //     notificationTosShop(user_name!);
    //     processUploadInsertData();
    //   } else {
    //     normalDialog(context, 'ไม่สามารถสั่งซื้อได้กรุณาลองใหม่');
    //   }
    // });
  }

  Future<Null> clearOrderSQLite() async {
    await SQLiteHelper().deleteAllData().then(
      (value) {
        Toast.show("ทำรายการสั่งซื้อ เสร็จสิ้น",
            duration: Toast.lengthLong, gravity: Toast.bottom);
        readOrderFormIdUser();
      },
    );
  }

  Future<Null> notificationTosShop(String user_name) async {
    String? urlFindToken =
        '${MyConstant().domain}/WaterShop/getUserWhereId.php?isAdd=true&id=46';

    await Dio().get(urlFindToken).then((value) {
      var result = json.decode(value.data);
      print('result ==>> $result');
      for (var json in result) {
        UserModel model = UserModel.fromJson(json);
        String tokenShop = model.token!;
        print('tokenShop ==>> $tokenShop');
        String title = 'มีการสั่งซื้อจากuser$user_name';
        String body = 'กรุณากดยืนยันเพื่อแจ้งลูกค้า';

        String urlSendToken =
            '${MyConstant().domain}/WaterShop/apiNotification.php?isAdd=true&token=$tokenShop&title=$title&body=$body';
        sendNotificationToShop(urlSendToken);
      }
    });
  }

  Future<Null> sendNotificationToShop(String urlSendToken) async {
    await Dio().get(urlSendToken).then((value) => AwesomeDialog(
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
