import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/singout_process.dart';
import 'package:application_drinking_water_shop/widget/information.dart';
import 'package:application_drinking_water_shop/widget/list_water_shop.dart';
import 'package:application_drinking_water_shop/widget/order_list_shop.dart';
import 'package:application_drinking_water_shop/widget/show_account.dart';
import 'package:application_drinking_water_shop/widget/show_accountcs.dart';
import 'package:flutter/material.dart';

class MainShop extends StatefulWidget {
  @override
  State<MainShop> createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
// field

  Widget currentWidget = OrderListShop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Shop'),
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
            showHead(),
            homeMenu(),
            waterMenu(),
            information(),
            personEmpMenu(),
            personCsMenu(),
            MyStyle().mySixedBoxs(),
            signOutMenu(),
          ],
        ),
      );

  ListTile homeMenu() => ListTile(
        leading: Icon(Icons.list),
        title: Text('รายการน้ำดื่ม ที่ลูกค้าสั่ง'),
        subtitle: Text('รายการน้ำดื่มที่ยังไม่ส่ง'),
        onTap: () {
          setState(() {
            currentWidget = OrderListShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile waterMenu() => ListTile(
        leading: Icon(Icons.shop),
        title: Text('ข้อมูลสินค้า'),
        onTap: () {
          setState(() {
            currentWidget = ListWaterMenuShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile information() => ListTile(
        leading: Icon(Icons.info),
        title: Text('รายละเอียดของร้าน'),
        subtitle: Text('--'),
        onTap: () {
          setState(() {
            currentWidget = Information();
          });
          Navigator.pop(context);
        },
      );

  ListTile personEmpMenu() => ListTile(
        leading: Icon(Icons.person_add),
        title: Text('จัดการข้อมูลพนักงาน'),
        onTap: () {
          setState(() {
            currentWidget = ShowAccount();
          });
          Navigator.pop(context);
        },
      );

  ListTile personCsMenu() => ListTile(
        leading: Icon(Icons.person_search_rounded),
        title: Text('จัดการข้อมูลลูกค้า'),
        onTap: () {
          setState(() {
            currentWidget = ShowAccountCs();
          });
          Navigator.pop(context);
        },
      );

  ListTile signOutMenu() => ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Sign Out'),
        subtitle: Text('Sign Out และกลับไปหาหน้าแรก'),
        onTap: () => signOutProcess(context),
      );

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('shop.png'),
        currentAccountPicture: MyStyle().showLogo(),
        accountName: Text(
          'Admin',
          style: TextStyle(color: MyStyle().darkColor),
        ),
        accountEmail: Text(
          'Login',
          style: TextStyle(color: MyStyle().darkColor),
        ));
  }
}
