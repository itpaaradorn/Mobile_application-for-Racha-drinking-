import 'dart:convert';

import 'package:application_drinking_water_shop/model/brand_model.dart';
import 'package:application_drinking_water_shop/screen/admin/add_brand_water.dart';
import 'package:application_drinking_water_shop/screen/admin/edit_brand_water.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ListBrandWater extends StatefulWidget {
  const ListBrandWater({super.key});

  @override
  State<ListBrandWater> createState() => _ListBrandWaterState();
}

class _ListBrandWaterState extends State<ListBrandWater> {
  bool? loadStatus = true;
  bool? status = true;

  List<BrandWaterModel> brandWaterModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readBrandWater();
  }

  Future<Null> readBrandWater() async {
    if (brandWaterModels.length != 0) {
      brandWaterModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? idShop = preferences.getString('id');
    // print('idShop =>>> $idShop');

    String url =
        '${MyConstant().domain}/WaterShop/getWaterbrand.php';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        // print('value =>> $value');
        var result = json.decode(value.data);
        // print('result ==>> $result');

        for (var map in result) {
          BrandWaterModel brandWaterMode = BrandWaterModel.fromJson(map);
          setState(() {
            brandWaterModels.add(brandWaterMode);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'ยี่ห้อน้ำดื่ม',
          style: TextStyle(color: Colors.indigo),
        ),
      ),
      body: Stack(children: [
        loadStatus! ? MyStyle().showProgress() : showContent(),
        addBrandWater(),
      ]),
    );
  }

  Widget showContent() {
    {
      return status!
          ? showListBrand()
          : Center(
              child: Text('ยังไม่มีประเภทน้ำดื่ม'),
            );
    }
  }

  Widget showListBrand() => ListView.builder(
        itemCount: brandWaterModels.length,
        itemBuilder: (context, index) => Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              child: Image.network(
                '${MyConstant().domain}${brandWaterModels[index].brandImage}',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ID: ${brandWaterModels[index].brandId!} ',
                    style: MyStyle().mainOrangTitle,
                  ),
                  MyStyle().mySixedBox05(),
                  Text(
                    '${brandWaterModels[index].brandName!} ',
                    style: MyStyle().mainhPTitle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          MaterialPageRoute route = MaterialPageRoute(
                            builder: (context) => EditBrandWater(
                                brandWaterModel: brandWaterModels[index]),
                          );
                          Navigator.push(context, route)
                              .then((value) => readBrandWater());
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            deleateBreandWater(brandWaterModels[index]),
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Future<Null> deleateBreandWater(BrandWaterModel brandWaterModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle()
            .showTitleH2('คุณต้องการลบรายการ ${brandWaterModel.brandName}'),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  String? url =
                      '${MyConstant().domain}/WaterShop/deleteBrandWaterId.php?isAdd=true&brand_id=${brandWaterModel.brandId}';
                  await Dio().get(url).then(
                        (value) => readBrandWater(),
                      );
                  Toast.show("ลบข้อมูลสำเร็จ",
                      duration: Toast.lengthLong, gravity: Toast.bottom);
                },
                child: Text('ยืนยัน',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    )),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget addBrandWater() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 9.0, right: 10.0),
                child: FloatingActionButton(
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => AddbrandWater(),
                    );
                    Navigator.push(context, route)
                        .then((value) => readBrandWater());
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );
}
