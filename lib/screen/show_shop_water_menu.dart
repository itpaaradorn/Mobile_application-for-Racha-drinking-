import 'package:application_drinking_water_shop/model/brand_model.dart';
import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/widget/about_shop.dart';
import 'package:application_drinking_water_shop/widget/show_menu_water.dart';
import 'package:flutter/material.dart';

class ShowShopWaterMunu extends StatefulWidget {
  final BrandWaterModel brandWaterModel;
  final UserModel userModel;
  const ShowShopWaterMunu({
    Key? key,
    required this.brandWaterModel,
    required this.userModel,
  }) : super(key: key);

  @override
  State<ShowShopWaterMunu> createState() => _ShowShopWaterMunuState();
}

class _ShowShopWaterMunuState extends State<ShowShopWaterMunu> {
  BrandWaterModel? brandModel;
  UserModel? userModel;
  List<Widget> listWidgets = [];

  int indexPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    brandModel = widget.brandWaterModel;
    listWidgets.add(ShowMenuWater(
      brandWaterModel: widget.brandWaterModel,
    ));
    listWidgets.add(AboutShop(
      userModel: widget.userModel,
    ));
  }

  BottomNavigationBarItem aboutShopNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.article_sharp),
      label: 'รายละเอียดร้าน',
    );
  }

  BottomNavigationBarItem showMenuWater() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.add_shopping_cart),
      label: 'รายการน้ำดื่ม',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สั่งซื้อน้ำดื่ม ${brandModel!.brandName}'),
      ),
      body: listWidgets[indexPage],
      bottomNavigationBar: showBottonNavigationBar(),
    );
  }

  BottomNavigationBar showBottonNavigationBar() => BottomNavigationBar(
        iconSize: 25,
        currentIndex: indexPage,
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
        items: <BottomNavigationBarItem>[
          showMenuWater(),
          aboutShopNav(),
        ],
      );
}
