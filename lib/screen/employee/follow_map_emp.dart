import 'dart:async';
import 'dart:convert';

import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../model/order_model.dart';
import '../../model/user_model.dart';
import '../../utility/my_constant.dart';

class FollowMapCustomer extends StatefulWidget {
  final OrderModel orderModel;
  const FollowMapCustomer({Key? key, required this.orderModel})
      : super(key: key);

  @override
  State<FollowMapCustomer> createState() => _FollowMapCustomerState();
}

class _FollowMapCustomerState extends State<FollowMapCustomer> {
  late OrderModel orderModel;
  UserModel? userModel;
  String? id, username;

  double? lat1, lng1, lat2, lng2;
  CameraPosition? position;
  List<LatLng> polylineCoordinates = [];
  // ignore: unused_field
  GoogleMapController? _controller;
  List<UserModel> userModels = [];

  @override
  void initState() {
    orderModel = widget.orderModel;
    id = orderModel.riderId;
    FindUserWhererider();
    findlatlng();
    super.initState();
  }

  StreamSubscription<Position>? positionStream;

  Future<Null> findlatlng() async {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      print(position);
      if (position != null) {
        lat1 = position.latitude;
        lng1 = position.longitude;

        setState(() {});
      }
      // print(position == null
      //     ? 'Unknown'
      //     : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });

    // Position positon = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);

    // print(userModel.toJson());
    // setState(() {
    //   lat1 = positon.latitude;
    //   lng1 = positon.longitude;
    //   lat2 = double.parse(userModel.lat!);
    //   lng2 = double.parse(userModel.lng!);
    // });
  }

  Future<Null> FindUserWhererider() async {
    if (userModels.isNotEmpty) {
      userModels.clear();
    }
    String url =
        '${MyConstant().domain}/WaterShop/getUserWhereId.php?isAdd=true&id=$id';

    print(url);

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);

      for (var item in result) {
        userModel = UserModel.fromJson(item);

        lat2 = double.parse(userModel?.lat ?? '0');
        lng2 = double.parse(userModel?.lng ?? '0');

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "รายการสั่งซื้อที่ ${orderModel.orderNumber}",
        ),
      ),
      body:
          lat1 == null || lng2 == null ? MyStyle().showProgress() : showList(),
    );
  }

  Widget showList() => Column(
        children: [
          buildMap(),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('ติดต่อ : ${userModel?.phone}'),
          ),
          ListTile(
            leading: Icon(Icons.account_circle_rounded),
            title: Text('ชื่อลูกค้า คุณ : ${userModel?.name}'),
          ),
        ],
      );

  Container buildMap() {
    return Container(
      height: 500,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat2!, lng2!),
          zoom: 16,
        ),
        polylines: {
          Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Color.fromARGB(255, 15, 50, 80),
            width: 10,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: mySet(),
      ),
    );
  }

  Marker riderMarker() {
    return Marker(
      markerId: MarkerId('userOrderMarker'),
      position: LatLng(lat2!, lng2!),
      icon: BitmapDescriptor.defaultMarkerWithHue(150.0),
      infoWindow: InfoWindow(
          title: 'ลูกค้าอยู่ที่นี่ ', snippet: 'รหัสลูกค้า${userModel?.id}'),
    );
  }

  Marker userMarker() {
    return Marker(
      markerId: MarkerId('userMarker'),
      position: LatLng(lat1!, lng1!),
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(
        title: 'คุณอยู่ที่นี่',
      ),
    );
  }

  Set<Marker> mySet() {
    return <Marker>[userMarker(), riderMarker()].toSet();
  }

  @override
  void dispose() {
    super.dispose();

    positionStream?.cancel();
  }
}
