import 'package:application_drinking_water_shop/model/customer_model.dart';
import 'package:application_drinking_water_shop/screen/promtpay.dart';
import 'package:application_drinking_water_shop/screen/show_cartShop.dart';
import 'package:application_drinking_water_shop/screen/show_listManu_watershop.dart';
import 'package:flutter/material.dart';

import 'bankpay.dart';
import 'confirm_payment.dart';

class addOrderShop extends StatefulWidget {
  final CustomerModel? customerModel;
  final bool isAdmin;

  const addOrderShop({super.key, this.customerModel, this.isAdmin = false});

  @override
  _addOrderShopState createState() => _addOrderShopState();
}

class _addOrderShopState extends State<addOrderShop> {
  // List<Widget> widgets = [listManuAddOrderWater(), ShowCartShop()];

  List<IconData> icons = [
    Icons.add_box_sharp,
    Icons.card_travel,
  ];

  List<String> titles = ['รายการน้ำดื่มที่ต้องการเพิ่ม', 'รายการในตะกร้า'];

  int indexPostion = 0;
  List<BottomNavigationBarItem> bottomNavigationBarItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    int i = 0;
    for (var item in titles) {
      bottomNavigationBarItems
          .add(createBottomNavigationBarItem(icons[i], item));
      i++;
    }
  }

  BottomNavigationBarItem createBottomNavigationBarItem(
          IconData iconData, String string) =>
      BottomNavigationBarItem(icon: Icon(iconData), label: string);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('${titles[indexPostion]}'),
          ),
          body: [
            listManuAddOrderWater(
              isAdmin: widget.isAdmin,
              customerModel: widget.customerModel,
            ),
            ShowCartShop(customerModel: widget.customerModel as CustomerModel)
          ][indexPostion],
          bottomNavigationBar: BottomNavigationBar(
            selectedIconTheme: IconThemeData(color: Colors.blue),
            unselectedIconTheme: IconThemeData(color: Colors.grey),
            selectedItemColor: Colors.blue.shade900,
            unselectedItemColor: Colors.grey,
            items: bottomNavigationBarItems,
            currentIndex: indexPostion,
            onTap: (value) {
              setState(() {
                indexPostion = value;
              });
            },
          ),
        ),
        // shoppingCartbutton(context),
      ],
    );
  }

  Widget shoppingCartbutton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 30.0, bottom: 70.0),
              child: FloatingActionButton(
                child: Icon(Icons.receipt),
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                    // builder: (context) => ConfirmPayment(),
                    builder: (context) => Container(),
                  );
                  Navigator.push(context, route);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
