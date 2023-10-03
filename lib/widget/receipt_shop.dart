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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'ข้อมูลชำระเงิน',
          style: TextStyle(color: Colors.indigo),
        ),
      ),
      body: Stack(
        children: <Widget>[
          paymentmodels.isNotEmpty ? showPayment() : buildNoneAvatarImage()
        ],
      ),
    );
  }

  Widget buildNoneAvatarImage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Text(
            'ยังไม่มีข้อมูลการขำระเงิน',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget showContent() {
    return status ? showPayment() : buildNoneAvatarImage();
  }

  Widget showPayment() {
    return ListView.builder(
      itemCount: paymentmodels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Card(
            color: Color.fromARGB(255, 238, 244, 248),
            child: Container(
              padding: EdgeInsets.all(4.0),
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.6,
              child: paymentmodels[index].imageSlip == null
                  ? buildNoneAvatarImage()
                  : Image.network(
                      '${MyConstant().domain}${paymentmodels[index].imageSlip}'),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(10.0),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          'เวลาชำระเงิน  \n➤  ${paymentmodels[index].slipDateTime} ',
                          style: MyStyle().mainh2Title,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    // Row(
                    //   children: [
                    //     Text(
                    //       'รหัสพนักงาน  \n➤  ${paymentmodels[index].empId} ',
                    //       style: MyStyle().mainh2Title,
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: [
                        Text(
                          'รหัสสมาชิก  \n➤  ${paymentmodels[index].userId} ',
                          style: MyStyle().mainh2Title,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          'ชื่อสมาชิก  \n➤  ${paymentmodels[index].userName} ',
                          style: MyStyle().mainh2Title,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          'รหัสคำสั่งซื้อ  \n➤  ${paymentmodels[index].orderId} ',
                          style: MyStyle().mainh2Title,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
