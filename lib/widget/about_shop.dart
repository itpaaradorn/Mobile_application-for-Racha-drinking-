import 'dart:math';

import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

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

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    findLat1Lng1();
  }

  Future<Null> findLat1Lng1() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat1 = locationData.latitude;
      lng1 = locationData.longitude;
      lat2 = double.parse('${userModel!.lat}');
      lng2 = double.parse('${userModel!.lng}');
      print('lat1 =>> $lat1, lng1 =>> $lng1, lat2 =>> $lat2, lng2 =>> $lng2');
      distance = calculateDistance(lat1!, lng1!, lat2!, lng2!);

      var myFormat = NumberFormat('##.0#', 'en_us');
      distanceString = myFormat.format(distance);


      print('distance =>> $distance');
    });
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(16.0),
              width: 150.0,
              height: 150.0,
              child: Image.network(
                '${MyConstant().domain}${userModel!.urlpicture}',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('${userModel!.address}'),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('${userModel!.phone}'),
        ),
        ListTile(
          leading: Icon(Icons.social_distance),
          title: Text(distance == null ? '' : '$distanceString กิโลเมตร' ),
        ),
        ListTile(
          leading: Icon(Icons.monetization_on),
          title: Text('123 บาท'),
        ),
      ],
    );
  }
}
