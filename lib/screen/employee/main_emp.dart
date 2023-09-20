import 'dart:convert';
import 'dart:io';

import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/singout_process.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/api.dart';
import '../../model/user_model.dart';
import '../../utility/my_constant.dart';
import '../../utility/dialog.dart';
import '../../widget/order_emp_process.dart';
import '../../widget/order_emp_shop.dart';

class MainEmp extends StatefulWidget {
  @override
  State<MainEmp> createState() => _MainEmpState();
}

class _MainEmpState extends State<MainEmp> {
  UserModel? userModel;
  Widget currentWidget = OrderConfirmEmp();
  double? lat, lng;
  String? address, phone, name, avatar, emp_id, nameUser;
  bool loadstatus = true;
  bool status = true;

  void initState() {
    super.initState();
    findLatLng();
    findUser();
    aboutNotification();
    getImageformUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
    });
  }

  Future<Null> findLatLng() async {
    Position? userlocation = await MyAPI().getLocation();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    emp_id = preferences.getString(MyConstant().keyId);
    await Future.delayed(Duration(seconds: 10));
    Stream.fromFuture(findLatLng());
    if (emp_id != 'null') {
      lat = userlocation?.latitude;
      lng = userlocation?.longitude;
      updateLocationEmp();
    } else {
      normalDialog(context, 'rider logout');
    }
  }

  Future<Null> updateLocationEmp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? emp_id = preferences.getString(MyConstant().keyId);
    String? typeId = preferences.getString(MyConstant().keyType);
    String la1 = lat.toString();
    String la2 = lng.toString();

    if (typeId == 'Employee') {
      if (lat != null) {
        String url =
            '${MyConstant().domain}/WaterShop/updatelatlngemp.php?isAdd=true&id=$emp_id&Lat=$la1&Lng=$la2';
        await Dio().get(url).then(
              (value) => {},
            );
      }
    }
  }

  Future<Null> aboutNotification() async {
    if (Platform.isAndroid) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        // ignore: unused_local_variable
        RemoteNotification? notification = message.notification;
        // ignore: unused_local_variable
        AndroidNotification? android = message.notification?.android;
        print('A new onMessageApp App ${message.toString()}');
        // String title = message[''][''];
        String? titlenotiMessage = message.notification?.title;
        String? bodynotiMessage = message.notification?.body;
        normalDialog2(context, titlenotiMessage!, bodynotiMessage!);
      });
      // FirebaseMessaging.onMessage.listen((event) async {
      //   String title = event.notification.title;
      //   String body = event.notification.body;
      //   normalDialog2(context, title, body);
      // });
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        String? titlenotiMessage1 = message.notification?.title;
        String? bodynotiMessage1 = message.notification?.body;
        normalDialog2(context, titlenotiMessage1!, bodynotiMessage1!);
        // normalDialog2(context, title, notiMessage);
        print(
            'A new onMessageOpenedApp event was published! Home ${message.toString()}');
        Navigator.pushNamed(
          context,
          '/message',
          arguments: message,
        );
      });
    } else if (Platform.isIOS) {
      print('aboutNoti work IOS');
    }
  }

  Future<Null> getImageformUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');
    String url =
        '${MyConstant().domain}/WaterShop/getuserwhereidAvatar.php?isAdd=true&id=$id';
    // print('url ==>>>>>>>>> $url');

    await Dio().get(url).then((value) {
      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        for (var map in result) {
          setState(() {
            userModel = UserModel.fromJson(map);
            avatar = userModel?.urlPicture;
            name = userModel?.name;
            loadstatus = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee ${nameUser} '),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => signOutProcess(context),
          )
        ],
      ),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
            homeMenu(),
            ProcessOrderMenu(),
            // MyStyle().mySixedBoxEnd(),
            signOutMenu(),
          ],
        ),
      );

  ListTile homeMenu() => ListTile(
        leading: Icon(
          Icons.home,
          color: Colors.blueAccent,
        ),
        title: Text('รายการน้ำดื่มที่ลูกค้าสั่ง'),
        subtitle: Text('รายการน้ำดื่มที่ยังไม่ได้ส่งลูกค้า'),
        onTap: () {
          setState(() {
            currentWidget = OrderConfirmEmp();
          });
          Navigator.pop(context);
        },
      );

  ListTile ProcessOrderMenu() => ListTile(
        leading: Icon(
          Icons.delivery_dining,
          color: Colors.orange,
        ),
        title: Text('กำลังจัดส่ง'),
        subtitle: Text('รายการน้ำดื่มที่กำลังจัดส่ง'),
        onTap: () {
          setState(() {
            currentWidget = OrderProcessEmp();
          });
          Navigator.pop(context);
        },
      );

  ListTile signOutMenu() => ListTile(
        leading: Icon(
          Icons.logout,
          color: Colors.red,
        ),
        title: Text('Sign Out'), onTap: () => signOutProcess(context),
        // subtitle: Text(''),
      );


      

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
      // decoration: MyStyle().myBoxDecoration('rider.jpg'),

       currentAccountPicture: Container(
          width: 100.0,
          height: 100.0,
          child: MyStyle().showLogoEmp(),
        ),

      accountName: Text(
        '${nameUser} Login',
       
      ),
      accountEmail: Text(
        'Login !',
        
      ),
    );
  }
}
