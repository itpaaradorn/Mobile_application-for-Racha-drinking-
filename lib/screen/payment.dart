import 'package:application_drinking_water_shop/screen/promtpay.dart';
import 'package:flutter/material.dart';

import 'bankpay.dart';
import 'confirm_payment.dart';


class Bank extends StatefulWidget {
  final String order_id;

  const Bank({super.key, required this.order_id});

  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<Bank> {
  List<Widget> widgets = [
    Bankpayment(),
    Prompay(),
  ];

  List<IconData> icons = [
    Icons.money,
    Icons.book,
  ];

  List<String> titles = ['Bank', 'Promptpay'];

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
          body: widgets[indexPostion],
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
        shoppingCartbutton(context),
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
                    builder: (context) => ConfirmPayment(order_id: widget.order_id),
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
