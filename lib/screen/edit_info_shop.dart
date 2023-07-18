import 'package:flutter/material.dart';

class EditInfoShop extends StatefulWidget {
  const EditInfoShop({super.key});

  @override
  State<EditInfoShop> createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ปรับปรุง ละเอียดร้าน'),),
    );
  }
}