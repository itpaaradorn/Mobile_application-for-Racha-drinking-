import 'dart:convert';

import 'package:application_drinking_water_shop/configs/api.dart';
import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutShop extends StatefulWidget {
  final UserModel? userModel;
  AboutShop({Key? key, this.userModel}) : super(key: key);

  @override
  State<AboutShop> createState() => _AboutShopState();
}

class _AboutShopState extends State<AboutShop> {
  UserModel? userModel;
  double? lat1, lng1, lat2, lng2, distance;
  String? distanceString;
  int? transport;
  CameraPosition? position;

  @override
  void initState() {
    super.initState();
    readDataShop();
    // findLocation();
  }

  Future<Null> findLocation() async {
    // var currentLocation = await Location.instance.getLocation();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user_id = preferences.getString('id');

    String url =
        "http://192.168.1.99/WaterShop/getUserWhereId.php?isAdd=true&id=$user_id";
    Response resp = await Dio().get(url);

    if (resp.statusCode == 200) {
      lat1 = double.parse(jsonDecode(resp.data)[0]['Lat']);
      lng1 = double.parse(jsonDecode(resp.data)[0]['Lng']);
      findLatLng();
    }

    print(lat1);
    print(lng1);

    // lat1 = currentLocation.latitude;
    // lng1 = currentLocation.longitude;
    // print('lat1 ==> $lat1 , lng1 ==> $lng1');
  }

  Future<Null> findLatLng() async {
    // LocationData locationData = await findLocationData();
    setState(() {
      // lat1 = locationData.latitude;
      // lng1 = locationData.longitude;
      lat2 = double.parse('${userModel!.lat}');
      lng2 = double.parse('${userModel!.lng}');
      print('lat1 =>> $lat1, lng1 =>> $lng1, lat2 =>> $lat2, lng2 =>> $lng2');
      distance = MyAPI().calculateDistance(lat1!, lng1!, lat2!, lng2!);

      var myFormat = NumberFormat('##.0#', 'en_us');
      distanceString = myFormat.format(distance);

      transport = MyAPI().calculateTransport(distance!);

      // print('distance =>> $distance');
      // print('transport =>> $transport');
    });
  }

  Future<Null> readDataShop() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String? id = preferences.getString('id');
    String url =
        '${MyConstant().domain}/WaterShop/readUserModelWhereChooseTpy.php?isAdd=true&ChooseType=Admin';
    await Dio().get(url).then((value) {
      print('value = $value');
      var result = json.decode(value.data);
      print('result = $result');
      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
          findLocation();
        });
        // print('nameShop = ${detailShopModel.nameShop}');
      }
    });
  }

  Future<LocationData> findLocationData() async {
    Location? location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      // ignore: null_check_always_fails
      return null!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          userModel == null ? MyStyle().showProgress() : showList()
        ],
      ),
    );
  }

  Widget showNoData(BuildContext context) =>
      MyStyle().titleCenter(context, 'ยังไม่มีข้อมูล');

  Widget showList() {
    return Column(
      children: [
        showMap(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text(
            'ร้านราชาน้ำดื่ม',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text(
            '${userModel!.address}',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text(
            '${userModel!.phone}',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        ListTile(
          leading: Icon(Icons.social_distance),
          title: Text(
            distance == null
                ? 'กำลังคำนวณระยะทาง...'
                : '$distanceString กิโลเมตร',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        ListTile(
          leading: Icon(Icons.monetization_on),
          title: Text(
            transport == null ? 'กำลังคำนวณราคา..' : '$transport บาท',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        // showMap(),
      ],
    );
  }

  Container showMap() {
    if (lat1 != null) {
      LatLng latLng1 = LatLng(lat1!, lng1!);
      position = CameraPosition(
        target: latLng1,
        zoom: 16.0,
      );
    }

    Marker userMaker() {
      return Marker(
          markerId: MarkerId('userMaker'),
          position: LatLng(lat1!, lng1!),
          icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
          infoWindow: InfoWindow(
            title: 'คุณอยู่ที่นี้',
          ));
    }

    Marker shopMaker() {
      return Marker(
          markerId: MarkerId('shopMaker'),
          position: LatLng(lat2!, lng2!),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: 'ร้านราชาน้ำดื่ม',
          ));
    }

    Set<Marker> mySet() {
      return <Marker>[
        userMaker(),
        shopMaker(),
      ].toSet();
    }

    return Container(
      margin: EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 10),
      // color: Colors.grey,
      height: 400.0,
      child: lat1 == null
          ? MyStyle().showProgress()
          : GoogleMap(
              initialCameraPosition: position!,
              mapType: MapType.normal,
              onMapCreated: (controller) {},
              markers: mySet(),
            ),
    );
  }
}
