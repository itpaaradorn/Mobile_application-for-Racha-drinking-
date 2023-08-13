import 'package:flutter/material.dart';

import '../screen/show_shop_cart.dart';

class MyStyle {
  Color darkColor = Colors.blue.shade900;
  Color primaryColor = Colors.green;
  Color myColor = Color.fromARGB(255, 211, 103, 35);

  Widget iconShowCart(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add_shopping_cart),
      onPressed: () {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowCart(),
        );
        Navigator.push(context, route);
      },
    );
  }

  SizedBox mySixedBox() => SizedBox(
        width: 8.0,
        height: 12.0,
      );
  SizedBox mySixedBoxxxxxxx() => SizedBox(
        width: 15.0,
        height: .0,
      );
  SizedBox mySixedBox05() => SizedBox(
        width: 8.0,
        height: 8.0,
      );

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  TextStyle mainTitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 29, 77, 180),
  );

  TextStyle mainSize = TextStyle(
    fontSize: 19.0,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 29, 77, 180),
  );

  TextStyle mainH2Title = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 63, 119, 224),
  );
  TextStyle mainTitleBig = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 63, 119, 224),
  );

  TextStyle mainH3Title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 224, 94, 8),
  );
  TextStyle mainDackTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 54, 54, 53),
  );
  TextStyle mainOrangTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 224, 94, 8),
  );

  TextStyle mainhPTitle = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.bold,
    color: Color(0xff2972ff),
  );

  TextStyle mainhATitle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 182, 24, 12),
  );

  TextStyle mainh3Title = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  TextStyle mainh1Title = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  TextStyle mainh4Title = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  SizedBox mySixedBoxs() => SizedBox(
        width: 100.0,
        height: 280.0,
      );
  SizedBox mySixedBoxEnd() => SizedBox(
        child: Container(
          margin: EdgeInsets.all(160),
        ),
      );

  Text showTitle(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 21.0,
          color: Colors.blue.shade900,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget titleCenter(String string) {
    return Center(
      child: Text(
        string,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  TextStyle mainh2Title = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  Text showTitleH2(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blue.shade900,
          fontWeight: FontWeight.bold,
        ),
      );
  Text showTitleH3(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.red.shade900,
          fontWeight: FontWeight.bold,
        ),
      );
  Text showTitleHDack(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blue.shade800,
          fontWeight: FontWeight.w600,
        ),
      );

  Text showTitleHC(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 23.0,
            color: Color.fromARGB(255, 7, 0, 210),
            fontWeight: FontWeight.bold),
      );

  Text showTitleH44(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 16.0,
            color: Colors.blue.shade800,
            fontWeight: FontWeight.w500),
      );
  Text showTitleH44color(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 16.0,
            color: Colors.deepPurple,
            fontWeight: FontWeight.w500),
      );
  Text showTitleB(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 24.0, color: Colors.black, fontWeight: FontWeight.bold),
      );

  Text showTitleKbank(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 18.0,
            color: Color.fromARGB(255, 51, 101, 53),
            fontWeight: FontWeight.bold),
      );
  TextStyle mainConfirmTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Color.fromARGB(255, 9, 82, 142),
  );

  TextStyle mainh23Title = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  BoxDecoration myBoxDecoration(String namePic) {
    return BoxDecoration(
      image: DecorationImage(
          image: AssetImage('images/$namePic'), fit: BoxFit.cover),
    );
  }

  Container showLogo() {
    return Container(
      width: 150.0,
      child: Image.asset('images/logowater.png'),
    );
  }

  BoxDecoration myBoxDecoretion(String namePic) {
    return BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/images/$namePic'), fit: BoxFit.cover),
    );
  }

  MyStyle();
}
