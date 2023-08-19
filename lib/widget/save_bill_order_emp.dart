import 'dart:io';

import 'package:application_drinking_water_shop/model/order_model.dart';
import 'package:flutter/material.dart';

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
    // user_id = orderModel.user_id;
    // user_name = orderModel.user_name;
    order_id = orderModel?.orderId;
    // slipDateTime = orderModel.orderDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการสั่งซื้อที่ ${order_id}'),
      ),
    );
  }
}
