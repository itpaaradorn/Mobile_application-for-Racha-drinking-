import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListShop extends StatefulWidget {

  @override
  State<OrderListShop> createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {


  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    
  }

  



  @override
  Widget build(BuildContext context) {
    return Text(
      "แสงดงรายการสั่งชื่อ น้ำดื่ม"
    );
  }
}