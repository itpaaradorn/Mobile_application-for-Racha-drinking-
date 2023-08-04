import 'package:application_drinking_water_shop/screen/main_emp.dart';
import 'package:application_drinking_water_shop/screen/main_shop.dart';
import 'package:application_drinking_water_shop/screen/main_user.dart';
import 'package:application_drinking_water_shop/screen/signIn.dart';
import 'package:application_drinking_water_shop/screen/signUp.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/normal_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    checkPreferance();
    // getToken();
  }

  // Future<void> getToken() async {
  //   FirebaseMessaging firebaseMessaging = FirebaseMessaging Future<void> getToken() async {
  //   String token = await FirebaseMessaging.instance.getToken();
  //   print(token);
  // }

    // String? token = await FirebaseMessaging.instance.getToken();
    // print(token);
  
//  }




  Future<Null> checkPreferance() async {
    try {

      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String token = await FirebaseMessaging.instance.getToken();
      print('token ====>>> $token');

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? chooseType = preferences.getString('chooseType');
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
      appBar: AppBar(),
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
}
