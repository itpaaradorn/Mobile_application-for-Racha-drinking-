import 'dart:io';
import 'dart:math';

import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/app_text_field.dart';
import '../utility/dialog.dart';
import '../utility/my_constant.dart';

class AddOrderEmpAndShop extends StatefulWidget {
  const AddOrderEmpAndShop({Key? key}) : super(key: key);

  @override
  State<AddOrderEmpAndShop> createState() => __AddOrderEmpAndShopState();
}

class __AddOrderEmpAndShopState extends State<AddOrderEmpAndShop> {
  File? file;

  String? brand_name;
  var sizecontroller = TextEditingController();
  var usernamecontroller = TextEditingController();
  var quantitycontroller = TextEditingController();
  var pricecontroller = TextEditingController();
  String selectedValue = "Sing";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AddOrder Page",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            Container(
              width: 300,
              child: DropdownButtonFormField(
                value: selectedValue,
                items: dropdownItems,
                onChanged: (String? value) {
                  setState(() {
                    brand_name = value!;
                  });
                },
              ),
            ),
            MyStyle().mySixedBox(),
            AppTextField(
                textController: usernamecontroller,
                hintText: "ชื่อ",
                icon: Icons.add),
            MyStyle().mySixedBox(),
            AppTextField(
                textController: sizecontroller,
                hintText: "ขนาด",
                icon: Icons.add),
            MyStyle().mySixedBox(),
            AppTextField(
                textController: quantitycontroller,
                hintText: "จำนวน",
                icon: Icons.add),
            MyStyle().mySixedBox(),
            AppTextField(
                textController: pricecontroller,
                hintText: "รวม",
                icon: Icons.add),
            SizedBox(
              height: 30,
            ),
            saveButton(),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Namthip"), value: "Namthip"),
      DropdownMenuItem(child: Text("Crystal"), value: "Crystal"),
      DropdownMenuItem(child: Text("Sing"), value: "Sing"),
      DropdownMenuItem(child: Text("Nestle"), value: "Nestle"),
    ];
    return menuItems;
  }

  Widget saveButton() {
    return Container(
      width: 200.0,
      child: ElevatedButton.icon(
        onPressed: () {
          orderThread();
        },
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'Save Gategory',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> orderThread() async {
    var price = pricecontroller.text;
    var quantity = quantitycontroller.text;
    var size = sizecontroller.text;
    var sum = pricecontroller.text;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user_id = preferences.getString('id');
    String? user_name = preferences.getString('Name');
    DateTime dateTime = DateTime.now();
    // print(dateTime.toString());
    String order_date_time = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    String url =
        '${MyConstant().domain}/WaterShop/addOrder.php?isAdd=true&orderDateTime=$order_date_time&user_id=$user_id&user_name=$user_name&water_id=none&size=[$size]&distance=0&transport=0&water_brand_name=[$brand_name]&price=$price&amount=[$quantity]&sum=[$sum]&riderId=none&pamentStatus=payondelivery&status=userorder';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
        normalDialog(context, 'เพิ่มการสั่งซื้อสำเร็จ');
      } else {
        normalDialog(context, 'ไม่สามารถสั่งซื้อได้กรุณาลองใหม่');
      }
    });
  }
}
