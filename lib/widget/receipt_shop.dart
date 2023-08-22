import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../model/payment_model.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';

class ReceiptShop extends StatefulWidget {
  @override
  State<ReceiptShop> createState() => _ReceiptShopState();
}

class _ReceiptShopState extends State<ReceiptShop> {
  bool loadStatus = true;
  bool status = true;

  List<PaymentModels> paymentmodels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readPayment();
  }

  Future<Null> readPayment() async {
    if (paymentmodels.length != 0) {
      paymentmodels.clear();
    }

    String url = '${MyConstant().domain}/WaterShop/getpayment.php?isAdd=true';

    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });
      // print('value ==> $value');
      if (value.toString() != 'true') {
        var result = json.decode(value.data);
        // print('result ==> $result');

        for (var item in result) {
          // print('item ==> $item');
          PaymentModels model = PaymentModels.fromJson(item);
          // print('brand gas ==>> ${model.address}');

          setState(() {
            paymentmodels.add(model);
          });
        }
      } else {
        status = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('ข้อมูลชำระเงิน'),),
      body: Stack(
        children: <Widget>[
          loadStatus ? MyStyle().showProgress() : showContent(),
        ],
      ),
    );
  }

  Widget buildNoneAvatarImage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            child: Image.asset('images/nomoney.png'),
          ),
          Text(
            'ยังไม่มีข้อมูลการขำระเงิน',
            style: TextStyle(fontSize: 28),
          ),
        ],
      ),
    );
  }

  Widget showContent() {
    return status
        ? showPayment()
        : Center(
            child: Text('ยังไม่มีข้อมูลชำระเงิน'),
          );
  }

  Widget showPayment() {
    return ListView.builder(
      itemCount: paymentmodels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Card(
            color: Color.fromARGB(255, 238, 244, 248),
            child: Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              child: paymentmodels[index].imageSlip == null
                  ? buildNoneAvatarImage()
                  : Image.network(
                      '${MyConstant().domain}${paymentmodels[index].imageSlip}'),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.4,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'เวลาสั่งซื้อ : ${paymentmodels[index].slipDateTime} ',
                    style: MyStyle().mainh2Title,
                  ),
                  Text(
                    'รหัสพนักงาน : ${paymentmodels[index].riderId} ',
                    style: MyStyle().mainh2Title,
                  ),
                  Text(
                    'รหัสสมาชิก : ${paymentmodels[index].userId} ',
                    style: MyStyle().mainh2Title,
                  ),
                  Text(
                    'ชื่อสมาชิก : ${paymentmodels[index].userName} ',
                    style: MyStyle().mainh2Title,
                  ),
                  Text(
                    'รหัสคำสั่งซื้อ : ${paymentmodels[index].orderId} ',
                    style: MyStyle().mainh2Title,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
