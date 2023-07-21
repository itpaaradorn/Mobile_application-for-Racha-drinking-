import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Colors.blue.shade900;
  Color primaryColor = Colors.green;
  SizedBox mySixedBox() => SizedBox(
        width: 8.0,
        height: 12.0,
      );

  Widget showProgress(){
    return Center(child: CircularProgressIndicator(),);
  }

  TextStyle mainTitle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color:  Color.fromARGB(255, 29, 77, 180),
  );

  TextStyle mainH2Title = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 63, 119, 224),
  );

  TextStyle mainH3Title = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 224, 94, 8),
  );



  SizedBox mySixedBoxs() => SizedBox(
        width: 100.0,
        height: 280.0,
      );

  Text showTitle(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 23.0,
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

  Text showTitleH2(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blue.shade900,
          fontWeight: FontWeight.bold,
        ),
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

  MyStyle();
}
