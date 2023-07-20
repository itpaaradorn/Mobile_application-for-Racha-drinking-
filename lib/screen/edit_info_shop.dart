import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfoShop extends StatefulWidget {
  const EditInfoShop({super.key});

  @override
  State<EditInfoShop> createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  UserModel? userModel;
  String? nameShop, address, phone, urlPicture;
  Location? location = Location();
  double? lat, lng;
  File? file;

  @override
  void initState() {
    super.initState();
    readCurrentInfo();

    location?.onLocationChanged.listen(
      (event) {
        setState(() {
          lat = event.latitude;
          lng = event.longitude;
          // print('lat = $lat, lng = $lng');
        });
      },
    );
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idShop = preferences.getString('id');
    print('idShop ==> $idShop');

    String? url =
        '${MyConstant().domain}/WaterShop/getUserWhereUserId.php?isAdd=true&id=$idShop';

    Response response = await Dio().get(url);
    print('response ==>> $response');

    var result = json.decode(response.data);
    print('result ==>> $result');

    for (var map in result) {
      print('map ==>> $map');
      setState(
        () {
          userModel = UserModel.fromJson(map);
          nameShop = '${userModel?.nameShop}';
          address = '${userModel?.address}';
          phone = '${userModel?.phone}';
          urlPicture = '${userModel?.urlpicture}';
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null ? MyStyle().showProgress() : showContet(),
      appBar: AppBar(
        title: Text('แก้ไข รายละเอียดร้าน'),
      ),
    );
  }

  Widget showContet() => SingleChildScrollView(
        child: Column(
          children: [
            nameShopFrom(),
            showImage(),
            addressFrom(),
            phoneFrom(),
            lat == null ? MyStyle().showProgress() : showMap(),
            editButton()
          ],
        ),
      );

  Widget editButton() => Container(
        width: 300.0,
        margin: EdgeInsetsDirectional.only(top: 2.0),
        child: ElevatedButton.icon(
          onPressed: () {
            confirmDialog();
          },
          icon: Icon(Icons.edit),
          label: Text(
            'ปรับปรุง รายละเอียด',
          ),
        ),
      );

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'คุณแน่ใจว่าจะ ปรับปรุงรายละเอียดร้าน ?',
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  editThread();
                },
                child: Text('ตกลง'),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ยกเลิก',
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<Null> editThread() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String nameFile = 'ediShop$i.jpg';

    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file!.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);

    String urlUpload = '${MyConstant().domain}/WaterShop/saveShop.php';
    await Dio().post(urlUpload, data: formData).then(
      (value) async {
        urlPicture = '/WaterShop/shop/$nameFile';

        String? id = userModel?.id;
        // print('id = $id');

        String? url =
            '${MyConstant().domain}/WaterShop/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlPicture&Lat=$lat&Lng=$lng';

        Response response = await Dio().get(url);
        if (response.toString() == 'true') {
          Navigator.pop(context);
        } else {
          normalDialog(context, 'ยังอัพเดทไม่ได้ กรุณาลองใหม่');
        }
      },
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker()
          .pickImage(source: source, maxWidth: 800.0, maxHeight: 800.0);

      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }

  Set<Marker> currenMarker() {
    return <Marker>{
      Marker(
        markerId: MarkerId('myMarker'),
        position: LatLng(lat!, lng!),
        infoWindow: InfoWindow(
            title: 'ตำแหน่งร้าน', snippet: 'Lat = $lat,  Lng = $lng'),
      )
    };
  }

  Container showMap() {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat!, lng!),
      zoom: 16.0,
    );

    return Container(
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: currenMarker(),
      ),
      margin: EdgeInsets.only(top: 16.0),
      height: 250.0,
    );
  }

  Widget showImage() => Container(
        margin: EdgeInsetsDirectional.only(top: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () => chooseImage(ImageSource.camera),
            ),
            Container(
              child: Image.network(
                  width: 250.0,
                  height: 200.0,
                  '${MyConstant().domain}${userModel?.urlpicture}'),
            ),
            IconButton(
              icon: Icon(Icons.add_photo_alternate),
              onPressed: () => chooseImage(ImageSource.gallery),
            ),
          ],
        ),
      );

  Widget nameShopFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 18.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => nameShop = value,
              initialValue: nameShop,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ชื่อของร้าน'),
            ),
          ),
        ],
      );

  Widget addressFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 18.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => address = value,
              initialValue: address,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ที่อยู่'),
            ),
          ),
        ],
      );

  Widget phoneFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 18.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => phone = value,
              initialValue: phone,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'เบอร์ติดต่อ'),
            ),
          ),
        ],
      );
}
