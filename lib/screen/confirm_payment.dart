import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:application_drinking_water_shop/screen/show_shop_cart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../model/cart_model.dart';
import '../model/user_model.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';
import '../utility/dialog.dart';
import '../utility/sqlite_helper.dart';

class ConfirmPayment extends StatefulWidget {
  @override
  State<ConfirmPayment> createState() => _ConfirmPaymentState();
}

class _ConfirmPaymentState extends State<ConfirmPayment> {
  List<CartModel> cartModels = [];
  String? dateTimeString;
  File? file;
  int total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findCurrentTime();
    readSQLite();
  }

  void findCurrentTime() {
    DateTime dateTime = DateTime.now();
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    setState(() {
      dateTimeString = dateFormat.format(dateTime);
    });
    // print('datetime ==> $dateTime');
  }

  Future<Null> readSQLite() async {
    var object = await SQLiteHelper().readAllDataFormSQLite();
    print('object length ==> ${object.length}');
    if (object.length != 0) {
      for (var model in object) {
        String? sumString = model.sum;
        int sumInt = int.parse(sumString!);
        setState(() {
          cartModels = object;
          total = total + sumInt;
        });
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: Text('Confirm Payment'),
      ),
      body: Column(
        children: [
          MyStyle().mySixedBoxxxxxxx(),MyStyle().mySixedBoxxxxxxx(),
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
            
          ),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      padding: EdgeInsets.only(left: 20.0),
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
          if (file == null) {
            normalDialog(context, 'กรุณาแนบใบเสร็จชำระเงินก่อนสั่งซื้อ');
          } else {
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => ShowCart(),
            );
            orderThread().then(
              (value) => Navigator.push(context, route),
            );
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
      map['file'] = await MultipartFile.fromFile(file!.path, filename: nameSlip);
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

  Future<Null> orderThread() async {
     DateTime dateTime = DateTime.now();
    // print(dateTime.toString());

    String orderDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    String distance = cartModels[0].distance!;
    String transport = cartModels[0].transport!;

    List<String> water_ids = [];
    List<String> water_brand_ids = [];
    List<String> sizes = [];
    List<String> water_brand_names = [];
    List<String> prices = [];
    List<String> amounts = [];
    List<String> sums = [];

    for (var model in cartModels) {
      water_ids.add(model.waterId!);
      water_brand_ids.add(model.brandId!);
      sizes.add(model.size!);
      water_brand_names.add(model.brandName!);
      prices.add(model.price!);
      amounts.add(model.amount!);
      sums.add(model.sum!);
    }
    String water_id = water_ids.toString();
    String water_brand_id = water_brand_ids.toString();
    String size = sizes.toString();
    String water_brand_name = water_brand_names.toString();
    String price = prices.toString();
    String amount = amounts.toString();
    String sum = sums.toString();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user_id = preferences.getString('id');
    String? user_name = preferences.getString('Name');

    print(
        'orderDateTime == $orderDateTime, distance == $distance, transport == $transport');
    print(
        'water_id == $water_id, water_brand_id == $water_brand_id, size == $size, water_brand_name == $water_brand_name, price == $price, amount == $amount, sum == $sum ');

    String? url =
        '${MyConstant().domain}/WaterShop/addOrder.php?isAdd=true&orderDateTime=$orderDateTime&user_id=$user_id&user_name=$user_name&water_id=$water_id&water_brand_id=$water_brand_id&size=$size&distance=$distance&transport=$transport&water_brand_name=$water_brand_name&price=$price&amount=$amount&sum=$sum&riderId=none&pamentStatus=confirmpayment&status=userorder';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        clearOrderSQLite();
        notificationTosShop(user_name!);
        processUploadInsertData();
      } else {
        normalDialog(context, 'ไม่สามารถสั่งซื้อได้กรุณาลองใหม่');
      }
    });
  }

  Future<Null> clearOrderSQLite() async {
    await SQLiteHelper().deleteAllData().then(
      (value) {
         Toast.show("ทำรายการสั่งซื้อ เสร็จสิ้น",
        duration: Toast.lengthLong, gravity: Toast.bottom);
        readSQLite();
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
    await Dio().get(urlSendToken).then((value) => normalDialogNoti(
        context, 'การสั่งซื้อส่งไปที่ร้านแล้ว กรุณารอร้านจัดส่งครับ '));
  }
}
