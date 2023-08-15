import 'dart:io';

import 'package:application_drinking_water_shop/screen/employee/main_emp.dart';
import 'package:application_drinking_water_shop/screen/main_shop.dart';
import 'package:application_drinking_water_shop/screen/main_user.dart';
import 'package:application_drinking_water_shop/screen/profilepage.dart';
import 'package:application_drinking_water_shop/screen/signIn.dart';
import 'package:application_drinking_water_shop/screen/signUp.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/show_status_water_order.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
int index = 0;
  Widget? currentWidget;

  String? currentPage;
  Widget? tabbarWidget;
  bool exitPage = false;
  final pages = <Widget>[
    
    ShowStatusWaterOrder(),
    AccountPage(),
  ];



  @override
  void initState() {
    super.initState();
    checkPreferance();
    getToken();
    // aboutNotification();
  }

  Future<void> getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idLogin = preferences.getString(MyConstant().keyId);
// use the returned token to send messages to users from your custom server
    String? token = await messaging.getToken(
      vapidKey: "BGpdLRs......",
    );
    print('token ==> $token');
    print('idLogin ==> $idLogin');
    if (idLogin != null && idLogin.isNotEmpty) {
      String url =
          '${MyConstant().domain}/WaterShop/editTokenWhereId.php?isAdd=true&id=$idLogin&Token=$token';
      await Dio().get(url).then(
            (value) => print('##### token update success #####'),
          );
    }
  }

  Future<Null> checkPreferance() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? chooseType = preferences.getString(MyConstant().keyType);

      if (chooseType != null && chooseType.isNotEmpty) {
        if (chooseType == 'Customer') {
          routeToService(MainUser());
        } else if (chooseType == 'Admin') {
          routeToService(MainShop());
        } else if (chooseType == 'Employee') {
          routeToService(MainEmp());
        } else {
          normalDialog(context, 'Error user Type!');
        }
      }
    } catch (e) {}
  }

  void routeToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome guest user !'),
      ),
      drawer: showDrawer(),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
            SigninMunu(),
            SignUpMunu(),
          ],
        ),
      );

  ListTile SigninMunu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text("Sign In"),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => Signin());
        Navigator.push(context, route);
      },
    );
  }

  ListTile SignUpMunu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text("Sign Up"),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignUp());

        Navigator.push(context, route);
      },
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('guest.png'),
        currentAccountPicture: MyStyle().showLogo(),
        accountName: Text('Guest'),
        accountEmail: Text('Please Login'));
  }

  Future<Null> aboutNotification() async {
    if (Platform.isAndroid) {
      print('aboutNoti Work Android');

      // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      // await firebaseMessaging.con
    } else if (Platform.isIOS) {
      print('aboutNoti Work IOS');
    }
  }
}
