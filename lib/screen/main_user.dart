import 'dart:convert';

import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/singout_process.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  @override
  State<MainUser> createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  UserModel? userModel;
  String? nameUser;
  List<Widget>? shopCards = [];

  @override
  void initState() {
    super.initState();
    findUser();
    readShop();
  }

  Future<Null> readShop() async {
    String? url =
        '${MyConstant().domain}/WaterShop/getUserWhereChooseTpy.php?isAdd=true&ChooseType=Admin';

    await Dio().get(url).then(
      (value) {
        // print('value = $value');
        var result = json.decode(value.data);
        // print('result = $result');
        for (var map in result) {
          setState(() {
            userModel = UserModel.fromJson(map);
            print('nameShop = ${userModel!.nameShop}');
            shopCards!.add(crestCard(userModel!));
          });
        }
      },
    );
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main User' : '$nameUser login'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => signOutProcess(context),
          )
        ],
      ),
      drawer: showDrawer(),
      body: shopCards!.length == 0 ? MyStyle().showProgress(): GridView.extent(
        maxCrossAxisExtent: 150.0,children: shopCards!,
      ),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
          ],
        ),
      );

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration('user.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text(
        'Name Login',
        style: TextStyle(color: MyStyle().darkColor),
      ),
      accountEmail: Text(
        'Login',
        style: TextStyle(color: MyStyle().darkColor),
      ),
    );
  }

  Widget crestCard(UserModel userModel) {
    return Card(
      child: Column(
        children: [
          Container(
            width: 80.0,
            height: 80.0,
            child: Image.network('${MyConstant().domain}${userModel.urlpicture}'),
          ),
          Text('${userModel.nameShop}')
        ],
      ),
    );
  }
}
