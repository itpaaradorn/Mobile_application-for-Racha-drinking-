import 'dart:convert';

import 'package:application_drinking_water_shop/model/water_model.dart';
import 'package:application_drinking_water_shop/screen/add_water_manu.dart';
import 'package:application_drinking_water_shop/screen/edit_water.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListWaterMenuShop extends StatefulWidget {
  @override
  State<ListWaterMenuShop> createState() => _ListWaterMenuShopState();
}

class _ListWaterMenuShopState extends State<ListWaterMenuShop> {
  bool? loadStatus = true; //กำลังโหลด
  bool? status = true; //มีข้อมูล
  List<WaterModel>? waterModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readWaterMenu();
  }

  Future<Null> readWaterMenu() async {
    if (waterModels!.length != 0) {
      waterModels!.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idShop = preferences.getString('id');
    print('idShop = $idShop');

    String? url =
        '${MyConstant().domain}/WaterShop/getWaterWheredShop.php?isAdd=true&idShop=$idShop';
    await Dio().get(url).then(
      (value) {
        setState(
          () {
            loadStatus = false;
          },
        );

        if (value.toString() != 'null') {
          // print('value =>> $value');

          var result = json.decode(value.data);
          // print('result ==>> $result');

          for (var map in result) {
            WaterModel waterModel = WaterModel.fromJson(map);
            setState(() {
              waterModels!.add(waterModel);
            });
          }
        } else {
          setState(
            () {
              status = false;
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.white,
        title: Text('ข้อมูลน้ำดื่ม',
          style: TextStyle(color: Colors.indigo),),
      ),
      body: Stack(
        children: <Widget>[
          loadStatus! ? MyStyle().showProgress() : showContent(),
          addMenuButton(),
        ],
      ),
    );
  }

  Widget showContent() {
    return status!
        ? showListWater()
        : Center(
            child: Text('ยังไม่มีรายการน้ำดื่ม'),
          );
  }

  Widget showListWater() => ListView.builder(
        itemCount: waterModels!.length,
        itemBuilder: (context, index) => Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(6.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              child: Image.network(
                '${MyConstant().domain}${waterModels![index].pathImage!}',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ยี่ห้อ: ${waterModels![index].brandname!} ',
                      style: MyStyle().mainTitle,
                    ),
                    Text(
                      'ขนาด: ${waterModels![index].size!} ml',
                      style: MyStyle().mainH2Title,
                    ),
                    Text(
                      'ราคา: ${waterModels![index].price!} บาท',
                      style: MyStyle().mainH3Title,
                    ),
                    Text(
                      'จำนวน ${waterModels![index].quantity!} ขวด/แพ็ค',
                      style: MyStyle().mainDackTitle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue.shade900,
                          ),
                          onPressed: () {
                            MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => EditWaterMenu(
                                waterModel: waterModels![index],
                              ),
                            );
                            Navigator.push(context, route).then(
                              (value) => readWaterMenu(),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => deleateWater(waterModels![index]),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Future<Null> deleateWater(WaterModel waterModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title:
            MyStyle().showTitleH2('คุณต้องการลบรายการ ${waterModel.brandname}'),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  String? url =
                      '${MyConstant().domain}/WaterShop/deleteWhereId.php?isAdd=true&id=${waterModel.id}';
                  await Dio().get(url).then(
                        (value) => readWaterMenu(),
                      );
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

  Widget addMenuButton() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) =>
                          AddMenuWater(waterModel: WaterModel()),
                    );
                    Navigator.push(context, route)
                        .then((value) => readWaterMenu());
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );
}
