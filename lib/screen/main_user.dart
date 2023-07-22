import 'dart:convert';

import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/model/water_model.dart';
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
  
  
  String? nameUser;
  List<WaterModel> waterModels = [];
  List<Widget> brandimageCards = [];

  List<Widget> shopCards = [];

  @override
  void initState() {
    super.initState();
    findUser();
    readBrand();
  }

  // Future<Null> readShop() async {
  //   String? url =
  //       '${MyConstant().domain}/WaterShop/getWaterbrand.php';
  //   await Dio().get(url).then((value) {
  //     // print('value = $value');
  //     var result = json.decode(value.data);
  //     for (var map in result) {
  //       WaterModel model = WaterModel.fromJson(map);
  //       print('NameShop ==>> ${model.nameWater}');
  //       setState(() {
  //         WaterModel.add(model);
  //         shopCards.add(createCard(model));
  //       });
  //     }
  //   });
  // }

  Future<Null> readBrand() async {
    String url =  'http://192.168.1.99:8012/WaterShop/getWaterbrand.php?isAdd=true&wtbrand';
    await Dio().get(url).then((value) {
      // print('value ==> $value');
      var result = json.decode(value.data);
      int index = 0;
      // print('result ==> $result');

      for (var map in result) {
        // print('item ==> $item');
        WaterModel model = WaterModel.fromJson(map);
        // print('brand gas ==>> ${model.brandGas}');

        String PathImage = '${model.pathImage}';
        if (PathImage.isNotEmpty) {
          setState(() {
            waterModels.add(model);
            brandimageCards.add(createCard(model, index));
            index++;
          });
        }
      }
    });
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
      body: brandimageCards.length == 0
          ? MyStyle().showProgress()
          : GridView.extent(
              maxCrossAxisExtent: 250,
              children: brandimageCards,
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

  Widget createCard(WaterModel waterModel, int index, ) {
    return Card(
      child: Column(
        children: [
          Container(
            width: 80.0,
            height: 80.0,
            child:
                Image.network('${MyConstant().domain}${waterModel.pathImage}'),
          ),
          Text('${waterModel.wtbrand}')
        ],
      ),
    );
  }
}
