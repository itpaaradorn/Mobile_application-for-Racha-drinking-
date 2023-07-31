import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/singout_process.dart';
import 'package:application_drinking_water_shop/widget/information.dart';
import 'package:application_drinking_water_shop/widget/list_water_shop.dart';
import 'package:application_drinking_water_shop/widget/order_list_shop.dart';
import 'package:application_drinking_water_shop/widget/show_account.dart';
import 'package:application_drinking_water_shop/widget/show_accountcs.dart';
import 'package:flutter/material.dart';

import '../widget/list_brand_water.dart';

class MainShop extends StatefulWidget {
  @override
  State<MainShop> createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {

// field
  UserModel? userModel;
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
        child: Stack(children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              showHead(),
              homeMenu(),
              waterMenu(),
              brandMenu(),
              information(),
              personEmpMenu(),
              personCsMenu(),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              signOutMenu(),
            ],
          )
        ]),
      );

  ListTile homeMenu() => ListTile(
        leading: Icon(Icons.list,),
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
        leading: Icon(Icons.shop,),
        title: Text('ข้อมูลน้ำดื่ม'),
        subtitle: Text('น้ำดื่มที่มีของทางร้าน'),
        onTap: () {
          setState(() {
            currentWidget = ListWaterMenuShop();
          });
          Navigator.pop(context);
        },
      );
  ListTile brandMenu() => ListTile(
        leading: Icon(Icons.bar_chart_rounded,),
        title: Text('ประเภทน้ำดื่ม'),
        subtitle: Text('ยี่ห้อน้ำดื่ม'),
        onTap: () {
          setState(() {
            currentWidget = ListBrandWater();
          });
          Navigator.pop(context);
        },
      );

  ListTile information() => ListTile(
        leading: Icon(Icons.info),
        title: Text('รายละเอียดของร้าน'),
        subtitle: Text('รายละเอียดต่างๆ ของร้าน'),
        onTap: () {
          setState(() {
            currentWidget = Information();
          });
          Navigator.pop(context);
        },
      );

  ListTile personEmpMenu() => ListTile(
        leading: Icon(Icons.person_add,),
        title: Text('ข้อมูลพนักงาน'),
        subtitle: Text('จัดการข้อมูลพนักงาน'),
        onTap: () {
          setState(() {
            currentWidget = ShowAccount();
          });
          Navigator.pop(context);
        },
      );

  ListTile personCsMenu() => ListTile(
        leading: Icon(Icons.person_search_rounded,),
        title: Text('ข้อมูลลูกค้า'),
        subtitle: Text('จัดการข้อมูลลูกค้า'),
        onTap: () {
          setState(() {
            currentWidget = ShowAccountCs();
          });
          Navigator.pop(context);
        },
      );

  ListTile signOutMenu() => ListTile(
        leading: Icon(
          Icons.exit_to_app,
          color: Color.fromARGB(255, 255, 92, 4),
        ),
        title: Text('Sign Out'),
        subtitle: Text('ออกจากระบบและ กลับไปหาหน้าแรก'),
        onTap: () => signOutProcess(context),
      );

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
        arrowColor: Colors.blueAccent,
        currentAccountPicture: MyStyle().showLogo(),
        accountName: Text('Admin Login'),
        accountEmail: Text('bankch@gamil.com'));
  }
}
