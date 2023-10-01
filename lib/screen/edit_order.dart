import 'dart:convert';

import 'package:application_drinking_water_shop/model/edit_order_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

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
  String? order_id,
      orderDateTime,
      user_id,
      user_name,
      waterId,
      waterBrandId,
      size,
      sum,
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
    waterBrandName = orderModel.brandName;
    size = orderModel.size;
    price = orderModel.price;
    amount = orderModel.amount;
    transport = orderModel.transport;
    distance = orderModel.distance;
    waterId = orderModel.waterId;
    order_id = orderModel.orderTableId;
    status = orderModel.status;
    user_name = orderModel.name;
    pamentStatus = orderModel.paymentStatus;
    sum = orderModel.sum;
    waterBrandId = orderModel.brandId;

    getEditOrder(orderModel.orderTableId ?? '');
  }

  List<EditOrderModel> listEditOrderModel = [];
  List<EditOrderModel> oldListEditOrderModel = [];
  EditOrderModel? masterDate;

  getEditOrder(String order_id) async {
    String url =
        '${MyConstant().domain}/WaterShop/editOrder.php?order_id=$order_id';
    Response resp = await Dio().get(url);

    if (resp.statusCode == 200) {
      for (var json in jsonDecode(resp.data)) {
        listEditOrderModel.add(EditOrderModel.fromJson(json));
      }
      oldListEditOrderModel = listEditOrderModel;
      masterDate =
          listEditOrderModel.where((element) => element.amount != null).first;
    }

    setState(() {});
  }

  add(index) {
    int amount = int.tryParse(listEditOrderModel[index].amount ?? '') ?? 0;
    listEditOrderModel[index].amount = (amount + 1).toString();
    setState(() {});
  }

  delete(index) {
    int amount = int.tryParse(listEditOrderModel[index].amount ?? '') ?? 0;
    if (amount == 0) return;
    listEditOrderModel[index].amount = (amount - 1).toString();
    setState(() {});
  }

  delete_order_table(id) => Dio().delete(
      '${MyConstant().domain}/WaterShop/deleteOrderTableByOrdernumber.php',
      data: {'id': id});

  delete_order_detail(id, water_id) => Dio().delete(
      '${MyConstant().domain}/WaterShop/deleteOrderDetail.php?order_id=$id&water_id=$water_id',
      data: {'order_id': id, 'water_id': water_id});

  add_order_detail(EditOrderModel item) async {
    int amount = int.tryParse(item.amount ?? '') ?? 0;
    int price = int.tryParse(item.price ?? '') ?? 0;
    int sum = amount * price;

    var formData = FormData.fromMap({
      "order_id": order_id,
      'water_id': item.id,
      'amount': item.amount,
      'sum': sum,
      'create_by': masterDate?.createBy,
    });

    Response resp = await Dio().post(
        '${MyConstant().domain}/WaterShop/addOrderDetail.php',
        data: formData);
    return resp.data;
  }

  // add_order_table(EditOrderModel item, order_detail_id) {
  //   var data = {
  //     "create_by": masterDate?.createBy,
  //     "emp_id": "none",
  //     "payment_status": masterDate?.paymentStatus,
  //     "status": item.status,
  //   };

  //   Dio()
  //       .post('${MyConstant().domain}/WaterShop/addOrderWater.php', data: data);
  // }

  ok() async {
    // delete old data
    for (EditOrderModel item in oldListEditOrderModel) {
      // delete_order_table(item.orderDetailId);
      delete_order_detail(order_id, item.id);
    }

    // add new data
    for (EditOrderModel item in listEditOrderModel) {
      int amount = int.tryParse(item.amount ?? '') ?? 0;
      print(amount);
      if (amount != 0) {
        await add_order_detail(item);
        //   add_order_table(item, order_detail_id);
      }
    }
    Navigator.pop(context);
    Toast.show("แก้ไขคำสั่งซื้อสำเร็จ",
        duration: Toast.lengthLong, gravity: Toast.bottom);
  }

  @override
  Widget build(BuildContext context) {
    // print(dropdownItemspay);
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('EditOrder'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => ok(),
          )
        ],
      ),
      body: Column(
        children: [
          // TextButton(
          //   onPressed: () => ok(),
          //   child: Text(
          //     'ok',
          //     style: TextStyle(fontSize: 48),
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: listEditOrderModel.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    showImageManu(context, index),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.width * 0.4,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyStyle().mySixedBox(),
                            Text(
                              'ยี่ห้อ ${listEditOrderModel[index].brandName ?? ''}',
                              style: MyStyle().mainSize,
                            ),
                            MyStyle().mySixedBox005(),
                            Text(
                              'ขนาด ${listEditOrderModel[index].size ?? ''} ml',
                              style: MyStyle().mainH3Title,
                            ),
                            MyStyle().mySixedBox005(),
                            Text(
                              'ราคา ${listEditOrderModel[index].price ?? ''} บาท',
                              style: MyStyle().mainH3Title,
                            ),
                            MyStyle().mySixedBox05(),
                            Text(
                              'สั่งซื้อ ${listEditOrderModel[index].amount ?? '0'}',
                              style: MyStyle().mainhPTitle,
                            ),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // TextButton(
                                //     onPressed: () => delete(index),
                                //     child: Text('delete')),
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => delete(index),
                                ),

                                IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => add(index),
                                ),

                                // TextButton(
                                //     onPressed: () => add(index),
                                //     child: Text('add')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Text(listEditOrderModel[index].brandName ?? ''),
                    // Text(listEditOrderModel[index].size ?? ''),
                    // Text(listEditOrderModel[index].price ?? ''),
                    // Text(listEditOrderModel[index].amount ?? '0'),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     TextButton(
                    //         onPressed: () => delete(index),
                    //         child: Text('delete')),
                    //     TextButton(
                    //         onPressed: () => add(index), child: Text('add')),
                    //   ],
                    // ),
                    const SizedBox(height: 60),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Image showImageManu(int index) => Image.network(
  //       '${MyConstant().domain}${listEditOrderModel[index].pathImage}',
  //     );

  Container showImageManu(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(right: 8.0, left: 8.0, top: 15.0),
      width: MediaQuery.of(context).size.width * 0.5 - 16,
      height: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
              '${MyConstant().domain}${listEditOrderModel[index].pathImage}',
            ),
            fit: BoxFit.cover),
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
        title: MyStyle().showTitleH2(
            'คุณต้องการเปลี่ยนแปลงรายการ\nสั่งซื้อที่ ${orderModel.orderNumber} ใช่ไหม ?'),
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
