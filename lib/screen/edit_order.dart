import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/order_model.dart';
import '../../utility/big_text.dart';
import '../../utility/dialog.dart';

class EditOrderEmp extends StatefulWidget {
  final OrderModel orderModel;
  const EditOrderEmp({super.key, required this.orderModel});

  @override
  State<EditOrderEmp> createState() => _EditOrderEmpState();
}

class _EditOrderEmpState extends State<EditOrderEmp> {
  late OrderModel orderModel;
  String? order_id, orderDateTime,
      user_id,
      user_name,
      waterId,
      waterBrandId,
      size,sum,
      distance,
      transport,
      waterBrandName,
      price,
      amount,
      riderId,
      pamentStatus,
      status;

  @override
  void initState() {
    super.initState();
    orderModel = widget.orderModel;
    waterBrandName = orderModel.waterBrandName;
    size = orderModel.size;
    price = orderModel.price;
    amount = orderModel.amount;
    transport = orderModel.transport;
    distance = orderModel.distance;
    waterId = orderModel.waterId;
    order_id = orderModel.orderId;
    status = orderModel.status;
    user_name = orderModel.userName;
    pamentStatus = orderModel.pamentStatus;
    sum = orderModel.sum;
    waterBrandId = orderModel.waterBrandId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Order_id: ${orderModel.orderId}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyStyle().mySixedBox(),MyStyle().mySixedBox(),
            BigText(text: "สถานะจัดส่ง"),
            MyStyle().mySixedBox(),
            Container(
              width: 300,
              child: DropdownButtonFormField(
                value: status,
                items: dropdownItems,
                onChanged: (String? value) {
                  setState(() {
                    status = value!;
                  });
                },
              ),
            ),
            MyStyle().mySixedBox(),MyStyle().mySixedBox(),
            BigText(text: "สถานะการชำระเงิน"),
            MyStyle().mySixedBox(),
            Container(
              width: 300,
              child: DropdownButtonFormField(
                value: pamentStatus,
                items: dropdownItemspay,
                onChanged: (String? value) {
                  setState(() {
                    pamentStatus = value!;
                  });
                },
              ),
            ),MyStyle().mySixedBox(),
            disTanceWater(),
            usernameOrder(),
            transportWater(),
            MyStyle().mySixedBox(),
            saveButton(),
          ],
        ),
      ),
    );
  }

  Widget usernameOrder() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              onChanged: (value) => user_name = value.trim(),
              initialValue: user_name,
              decoration: InputDecoration(
                labelText: 'ชื่อผู้จดส่ง',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget disTanceWater() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              onChanged: (value) => distance = value.trim(),
              initialValue: distance,
              decoration: InputDecoration(
                labelText: 'ระยะทาง',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget transportWater() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              onChanged: (value) => transport = value.trim(),
              initialValue: transport,
              decoration: InputDecoration(
                labelText: 'ค่าจัดส่ง',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget saveButton() {
    return Container(
      width: 200.0,
      child: ElevatedButton.icon(
        onPressed: () {
          if (size!.isEmpty || price!.isEmpty) {
            normalDialog(context, 'กรุณากรอกให้ครบทุกช่อง !');
          } else {
            confirmEdit();
          }
        },
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'Save',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> confirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle().showTitleH2('คุณต้องการเปลี่ยนแปลงรายการ\nสั่งซื้อที่ ${orderModel.orderId} ใช่ไหม ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  editproductMySQL();
                },
                child: Text(
                  'ตกลง',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // editproductMySQL();
                },
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<Null> editproductMySQL() async {
    DateTime dateTime = DateTime.now();
    String order_date_time = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString('id');
    String? userName = preferences.getString('Name');
    String url =
        '${MyConstant().domain}/WaterShop/editOrder.php?isAdd=true&orderId=$order_id&orderDateTime=$order_date_time&user_id=$userId&user_name=$user_name&water_id=$waterId&water_brand_id=$waterBrandId&size=$size&distance=$distance&transport=$transport&water_brand_name=$waterBrandName&price=$price&amount=$amount&sum=$sum&riderId=none&pamentStatus=$pamentStatus&status=$status';
    await Dio().get(url).then(
      (value) {
        Navigator.pop(context);
        print('Edit Order Success');
      },
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("สั่งซื้อ"), value: "userorder"),
      DropdownMenuItem(child: Text("รับออเดอร์"), value: "shopprocess"),
      DropdownMenuItem(child: Text("กำลังจัดส่ง"), value: "RiderHandle"),
      DropdownMenuItem(child: Text("สำเร็จ"), value: "Finish"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItemspay {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("เก็บเงินปลายทาง"), value: "payondelivery"),
      DropdownMenuItem(
          child: Text("ชำระเงินล่วงหน้า"), value: "confirmpayment"),
    ];
    return menuItems;
  }
}
