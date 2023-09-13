import 'dart:async';
import 'dart:convert';

import 'package:application_drinking_water_shop/model/hsitory_model.dart';
import 'package:application_drinking_water_shop/model/order_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/user_model.dart';

class FollowTrackingDelivery extends StatefulWidget {
  final HistoryModel orderModel;
  const FollowTrackingDelivery({super.key, required this.orderModel});

  @override
  State<FollowTrackingDelivery> createState() => _FollowTrackingDeliveryState();
}

class _FollowTrackingDeliveryState extends State<FollowTrackingDelivery> {
  HistoryModel? orderModel;
  UserModel? userModel;
  String? order_id, date_time, rider_id;
  double? lat1, lng1, lat2, lng2;
  String? distanceString;
  int? transport;
  Position? userlocation;
  CameraPosition? position;
  List<LatLng> polylineCoordinates = [];
  GoogleMapController? _controller;
  List<UserModel> userModels = [];

  @override
  void initState() {
    super.initState();
    orderModel = widget.orderModel;
    rider_id = orderModel!.riderId;
    order_id = orderModel!.orderNumber;
    date_time = orderModel!.createAt;
    FindUserWhererider();

    getPolyPoints();
  }

  StreamSubscription<Position>? positionStream;

  Future<Null> findLatLng() async {
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
  }

  Future<Null> FindUserWhererider() async {
    if (userModels.length != 0) {
      userModels.clear();
    }
    String url =
        '${MyConstant().domain}/WaterShop/getUserriderWhereId.php?isAdd=true&id=$rider_id';

    print(url);

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      for (var item in result) {
        userModel = UserModel.fromJson(item);

        lat2 = double.parse(userModel?.lat ?? '0');
        lng2 = double.parse(userModel?.lng ?? '0');
        setState(() {});
      }
      findLatLng();
    });
  }

  Widget showNoData(BuildContext context) => const Center(
        child: Text("ยังไม่มีข้อมูล"),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ติดตามการจัดส่ง'),
      ),
      body: lat1 == null ? MyStyle().showProgress() : showList(),
    );
  }

  // Future refresh() async {
  //   await Future.delayed(
  //     Duration(seconds: 3),
  //   );
  //   findLatLng();
  // }

  Widget showList() => Column(
        children: [
          buildMap(),
          ListTile(
            leading: userModel!.urlPicture == null
                ? MyStyle().showProgress()
                : Container(
                    width: 50,
                    height: 50,
                    child: CachedNetworkImage(
                        imageUrl:
                            '${MyConstant().domain}${userModel!.urlPicture}')),
            title: Text('ผู้จัดส่ง : ${userModel!.name}'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('ติดต่อ : ${userModel!.phone}'),
          ),
        ],
      );

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      MyConstant().google_api_key,
      PointLatLng(lat1!, lng1!),
      PointLatLng(lat2!, lng2!),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  Container buildMap() {
    return Container(
      height: 500,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat1!, lng1!),
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
      markerId: MarkerId('riderMarker'),
      position: LatLng(lat2!, lng2!),
      icon: BitmapDescriptor.defaultMarkerWithHue(150.0),
      infoWindow: InfoWindow(
          title: 'พนักงานอยู่ที่นี่ ',
          snippet: 'ชื่อพนักงาน${userModel!.name}'),
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
