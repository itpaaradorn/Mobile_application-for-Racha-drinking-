import 'dart:convert';
import 'package:application_drinking_water_shop/model/brand_model.dart';
import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../screen/show_shop_water_menu.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';

class ShowListShop extends StatefulWidget {
  const ShowListShop({super.key});

  @override
  State<ShowListShop> createState() => _ShowListShopState();
}

class _ShowListShopState extends State<ShowListShop> {
  BrandWaterModel? brandWaterModels;
  UserModel? userModels;
  List<Widget>? shopCards = [];

  @override
  void initState() {
    super.initState();
    readBrand();
    readShop();
  }

  Future<Null> readBrand() async {
    
    String? url =
        '${MyConstant().domain}/WaterShop/getWaterbrand.php';
        // print('url === $url');

    await Dio().get(url).then(
      (value) {
        // print('value = $value');
        var result = json.decode(value.data);
        int index = 0;
        // print('result = $result');
        for (var map in result) {

          BrandWaterModel model = BrandWaterModel.fromJson(map);


          String? brand_image = model.brandImage;
          if (brand_image!.isNotEmpty) {
            setState(() {
            brandWaterModels = BrandWaterModel.fromJson(map);
            // print('nameShop = ${brandWaterModels!.brandName}');
            shopCards!.add(crestCard(brandWaterModels!, index));
            index++;
          });
          }
          
        }
      },
    );
  }

  Future<Null> readShop() async {
    String? url =
        '${MyConstant().domain}/WaterShop/getWaterbrand.php';
        // print('url === $url');

    await Dio().get(url).then(
      (value) {
        // print('value = $value');
        var result = json.decode(value.data);
        print('result = $result');
        for (var map in result) {
          setState(() {
            userModels = UserModel.fromJson(map);
          });
        }
      },
    );
  }




  Widget crestCard(BrandWaterModel brandWaterModel, int index) {
    return GestureDetector(
      onTap: () {
        print('You Click index $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) =>
              ShowShopWaterMunu(brandWaterModel: brandWaterModel,userModel: userModels!),
        );
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 150.0,
                height: 150.0,
                child: Image.network(
                    '${MyConstant().domain}${brandWaterModel.brandImage}')),
            MyStyle().mySixedBox(),
            // Text('${brandWaterModel.brandName}')
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return shopCards!.length == 0
        ? MyStyle().showProgress()
        : GridView.extent(
            maxCrossAxisExtent: 250.0,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            children: shopCards!,
          );
  }
}
