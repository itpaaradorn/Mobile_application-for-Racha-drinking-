import 'package:application_drinking_water_shop/screen/signIn.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/dialog.dart';
import '../utility/my_constant.dart';
import 'employee/main_emp.dart';
import 'admin/main_shop.dart';
import 'main_user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getToken();

//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.of(context).pop();
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (context) => LoginPage(),
//       //   ),
//       // );
// //        }
// //      });
//     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(25),
              child: SizedBox(),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: Image.asset(
                'images/logowater.png',
                width: 350,
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FittedBox(
                child: Text(
                  '2023 \u00a9  My Water. All Rights Reserved',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

    if (idLogin == null || idLogin == "") {
      //  Login
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      });
    } else {
      // homne
      Future.delayed(const Duration(seconds: 3), () => checkPreferance());
    }

    if (idLogin != null && idLogin.isNotEmpty) {
      String url =
          '${MyConstant().domain}/WaterShop/editTokenWhereId.php?isAdd=true&id=$idLogin&Token=$token';
      await Dio().get(url).then(
            (value) => '',
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
}
