import 'package:flutter/material.dart';

class OrderConfirmShop extends StatefulWidget {
  const OrderConfirmShop({super.key});

  @override
  State<OrderConfirmShop> createState() => _OrderConfirmShopState();
}

class _OrderConfirmShopState extends State<OrderConfirmShop> {
  @override
  Widget build(BuildContext context) {
    return Text('รายการน้ำดื่มที่จัดส่งแล้ว');
  }
}