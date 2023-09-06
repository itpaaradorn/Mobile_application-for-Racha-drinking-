import 'dart:io';

import 'package:application_drinking_water_shop/screen/profilepage.dart';
import 'package:application_drinking_water_shop/screen/show_shop_cart.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/singout_process.dart';
import 'package:application_drinking_water_shop/widget/historypage.dart';

import 'package:application_drinking_water_shop/widget/show_list_shop.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/dialog.dart';
import '../widget/tab_bar_material.dart';

class MainUser extends StatefulWidget {
  @override
  State<MainUser> createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String? nameUser;
  Widget? currentWidget;
  Widget? tabbarWidget;
  int index = 0;
  final pages = <Widget>[
    ShowListShop(),
    History(),
    ShowCart(),
    AccountPage(),
  ];

  @override
  void initState() {
    super.initState();
    aboutNotification();
    findUser();
    currentWidget = ShowListShop();
  }

  Future<Null> aboutNotification() async {
    if (Platform.isAndroid) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        // ignore: unused_local_variable
        RemoteNotification? notification = message.notification;
        print('A new onMessageApp App ${message.toString()}');
        // String title = message[''][''];
        String? titlenotiMessage = message.notification?.title;
        String? bodynotiMessage = message.notification?.body;
        normalDialog2(context, titlenotiMessage!, bodynotiMessage!);
      });

      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        String? titlenotiMessage1 = message.notification?.title;
        String? bodynotiMessage1 = await message.notification?.body;
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

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              nameUser == null ? 'Main User' : 'สวัสดี $nameUser',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onPressed: () => signOutProcess(context),
              )
            ],
          ),

          // drawer: showDrawer(),
          body: pages[index],
          backgroundColor: Color(0xfff1f1f5),
          bottomNavigationBar: TabbarMaterialWidget(
            index: index,
            onChangedTab: onChangedTab,
          ),
        ),
      ],
    );
  }

  void onChangedTab(int index) {
    setState(() {
      this.index = index;
    });
  }

  Widget shoppingCartbutton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 20.0, bottom: 58.0),
              child: FloatingActionButton(
                child: Icon(
                  Icons.shopping_cart,
                  size: 28.0,
                ),
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => ShowCart(),
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

  Drawer showDrawer() => Drawer(
        child: Stack(children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              showHeadDrawer(),
              menuListShop(),
              menuStatusWaterOrder(),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              menuSignOut(),
            ],
          )
        ]),
      );

  ListTile menuListShop() {
    return ListTile(
      onTap: () {
        setState(() {
          Navigator.pop(context);
          currentWidget = ShowListShop();
        });
      },
      leading: Icon(Icons.home),
      title: Text('รายการน้ำดื่ม'),
    );
  }

  ListTile menuStatusWaterOrder() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = History();
        });
      },
      leading: Icon(Icons.list_alt),
      title: Text('รายการน้ำดื่ม ที่สั่ง'),
    );
  }

  ListTile menuSignOut() {
    return ListTile(
      onTap: () => signOutProcess(context),
      leading: Icon(Icons.exit_to_app),
      title: Text('Sign Out'),
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration('user.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text(
        nameUser == null ? 'Name Login' : nameUser!,
        style: TextStyle(color: MyStyle().darkColor, fontSize: 18),
      ),
      accountEmail: Text(
        'Login',
        style: TextStyle(color: MyStyle().darkColor),
      ),
    );
  }
}
