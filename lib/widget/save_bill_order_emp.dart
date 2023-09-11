import 'dart:io';
import 'dart:math';

import 'package:application_drinking_water_shop/model/order_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/dialog.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';

class SaveBillOrderEmp extends StatefulWidget {
  final OrderModel orderModel;
  const SaveBillOrderEmp({super.key, required this.orderModel});

  @override
  State<SaveBillOrderEmp> createState() => _SaveBillOrderEmpState();
}

class _SaveBillOrderEmpState extends State<SaveBillOrderEmp> {
  OrderModel? orderModel;
  File? file;
  String? order_id, user_id, user_name, total, slipDateTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderModel = widget.orderModel;
    user_id = orderModel!.createBy;
    user_name = orderModel!.createBy;
    order_id = orderModel!.id;
    slipDateTime = orderModel!.createAt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('รายการสั่งซื้อที่ ${order_id}')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyStyle().mySixedBox(),
            headTitle(),
            MyStyle().mySixedBox(),
            buildBillImage(),
            MyStyle().mySixedBox(),
            slipDate(),
            orderId(),
            userIdGas(),
            userNameGas(),
            totalOrder(),
            MyStyle().mySixedBox(),
            newButtonConfirm(),
            MyStyle().mySixedBox(),
          ],
        ),
      ),
    );
  }

  Text headTitle() {
    return Text(
      'บันทึกชำระเงินปลายทาง',
      style: MyStyle().mainConfirmTitle,
    );
  }
  Widget slipDate() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => slipDateTime = value.trim(),
              initialValue: slipDateTime,
              decoration: InputDecoration(
                labelText: 'เวลาสั่งซื้อ',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

      Widget orderId() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => order_id = value.trim(),
              initialValue: order_id,
              decoration: InputDecoration(
                labelText: 'รหัสคำสั่งซื้อ',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

      Widget userIdGas() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => user_id = value.trim(),
              initialValue: user_id,
              decoration: InputDecoration(
                labelText: 'รหัสลูกค้า',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

       Widget userNameGas() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => user_name = value.trim(),
              initialValue: user_name,
              decoration: InputDecoration(
                labelText: 'ชื่อลูกค้า',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget totalOrder() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => total = value.trim(),
              initialValue: total,
              decoration: InputDecoration(
                labelText: 'รวมทั้งสิ้น',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

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
                ? Image.asset('images/nowater.png')
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

   Container newButtonConfirm() {
    return Container(
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          if (file == null) {
            normalDialog(context, 'กรุณาแนบใบเสร็จชำระเงินก่อนสั่งซื้อค่ะ');
          } else if (total == null) {
            normalDialog(context, 'กรุณาป้อนจำนวนเงินทั้งหมด');
          } else {
            processUploadInsertData();
            Navigator.pop(context);
          }
        },
        child: Text('ยืนยันการชำระเงิน'),
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
        print('value == $value');
        // DateTime dateTime = DateTime.now();
        // // print(dateTime.toString());
        // String slipDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? rider_id = preferences.getString('id');
        String path =
            '${MyConstant().domain}/WaterShop/addpayment.php?isAdd=true&slip_date_time=$slipDateTime&image_slip=$imageSlip&order_id=$order_id&user_id=$user_id&user_name=$user_name&total=$total&rider_id=$rider_id';
        await Dio().get(path).then((value) => print('upload Sucess'));
      });
    } catch (e) {}
  }















}



