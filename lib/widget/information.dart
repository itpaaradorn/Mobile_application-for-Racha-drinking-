import 'dart:convert';

import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/screen/add_info_Shop.dart';
import 'package:application_drinking_water_shop/screen/edit_info_shop.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_constant.dart';

class Information extends StatefulWidget {

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  UserModel? userModel;
  String? address;

  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  Future<Null> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');

    String url =
        '${MyConstant().domain}/WaterShop/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(url).then(
      (value) {
        // print('value = $value');
        var result = json.decode(value.data);
        // print('result = $result');
        for (var map in result) {
          setState(() {
            userModel = UserModel.fromJson(map);
            print('nameShop = ${userModel!.nameShop}');
          });
        }
      },
    );
  }

  void routeToAddInfo() {
     Widget widget = userModel!.nameShop!.isEmpty ? AddInfoShop() : EditInfoShop();
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.push(context, materialPageRoute).then((value) => readDataUser());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        userModel == null
            ? MyStyle().showProgress()
            : userModel!.nameShop!.isEmpty
                ? showNodata(context)
                : showListinfoShop(),
        addAndEditButton(),
      ],
    );
  }

  Widget showListinfoShop() => Column(
        children: <Widget>[
          MyStyle().showTitleH2('รายละเอียดของร้าน ${userModel?.nameShop}'),
          showImage(),
          Row(
            children: [
              MyStyle().showTitleH2('ที่อยู่ของร้าน'),
            ],
          ),
          Row(
            children: [
              Text('${userModel?.address}'),
            ],
          ),MyStyle().mySixedBox(),
          showMap()
        ],
      );

  Container showImage() {
    return Container(width: 200.0,height: 200.0,
          child: Image.network('${MyConstant().domain}${userModel?.urlpicture}'),
        );
  }

  Set<Marker> shopMarker() {
    return <Marker>{
      Marker(
          markerId: MarkerId('shopID'),
          position: LatLng(
            double.parse('${userModel?.lat}'),
            double.parse('${userModel?.lng}'),
          ),
          infoWindow: InfoWindow(
            title: 'ร้านราชาน้ำดื่ม อยู่ที่นี่',
            snippet:
                'ละติจูด = ${userModel?.lat} , ลองติจูด = ${userModel?.lng}',
          ))
    };
  }

  Widget showMap() {
    double lat = double.parse('${userModel?.lat}');
    double lng = double.parse('${userModel?.lng}');

    LatLng latLng = LatLng(lat, lng);
    CameraPosition Position = CameraPosition(target: latLng, zoom: 16.0);

    return Expanded(
      // padding: EdgeInsets.all(10.0),
      // height: 290.0,
      child: GoogleMap(
        initialCameraPosition: Position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: shopMarker(),
      ),
    );
  }

  Widget showNodata(BuildContext context) =>
      MyStyle().titleCenter('ยังไม่มีข้อมูลกรุณาเพิ่มด้วยครับ !!');

  Row addAndEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 18.0, bottom: 18.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  print('you click floating');
                  routeToAddInfo();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}