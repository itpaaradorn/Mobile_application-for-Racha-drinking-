import 'dart:io';
import 'dart:math';

import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../configs/api.dart';
import '../model/user_model.dart';
import '../utility/my_constant.dart';
import '../utility/dialog.dart';

class EditProfileLocation extends StatefulWidget {
  final UserModel userModel;
  const EditProfileLocation({Key? key, required this.userModel})
      : super(key: key);

  @override
  State<EditProfileLocation> createState() => _EditProfileLocationState();
}

class _EditProfileLocationState extends State<EditProfileLocation> {
  UserModel? userModel;

  String? urlpicture, name, address, phone, user, password, user_id;
  double? lat, lng;
  File? file;
  bool passwordVisible = true;
  bool confirmPassVissible = true;
  // bool passwordVisible = true;
  // bool confirmPassVissible = true;

  @override
  void initState() {
    findLatLng();
    userModel = widget.userModel;
    user_id = userModel!.id;
    urlpicture = userModel!.urlPicture;
    name = userModel!.name!;
    phone = userModel!.phone!;
    address = userModel!.address;
    user = userModel!.user;
    password = userModel!.password;
    super.initState();
  }

  Future<Null> findLatLng() async {
    Position? positon = await MyAPI().getLocation();
    setState(() {
      lat = positon?.latitude;
      lng = positon?.longitude;
      print(' lat == $lat , lng == $lng');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แก้ไขข้อมูลสมาชิก"),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                if (name == null ||
                    name!.isEmpty ||
                    phone == null ||
                    phone!.isEmpty ||
                    address == null ||
                    address!.isEmpty ||
                    user == null ||
                    user!.isEmpty ||
                    password == null ||
                    password!.isEmpty) {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.bottomSlide,
                    dialogType: DialogType.info,
                    body: Center(
                      child: Text(
                        'กรุณากรอกข้อมูลให้ครบด้วยค่ะ ',
                        style: TextStyle(fontStyle: FontStyle.normal),
                      ),
                    ),
                    title: 'This is Ignored',
                    desc: 'This is also Ignored',
                    btnOkOnPress: () {},
                  ).show();
                } else {
                  updateProfileandLocation().then(
                    (value) => Navigator.pop(context),
                  );
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15.0,
            ),

            // AppTextFieldString(text: user!.trim(), hintText: "user", icon: Icons.person),
            // AppTextFieldString(text: password!.trim(), hintText: "password", icon: Icons.person),
            // AppTextFieldString(text: name!.trim(), hintText: "name", icon: Icons.person),
            // AppTextFieldString(text: phone!.trim(), hintText: "phone", icon: Icons.person),
            // AppTextFieldString(text: address!.trim(), hintText: "address", icon: Icons.person),
            groupImage(),
            nameUser(),
            userForm(),
            passwordForm(),
            phonesUser(),
            addressUser(),
            MyStyle().mySixedBox(),
            buildMap(),
            MyStyle().mySixedBox(),
          ],
        ),
      ),
    );
  }

  Widget nameUser() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              onChanged: (value) => name = value.trim(),
              initialValue: name,
              decoration: InputDecoration(
                labelText: 'name-surname',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget userForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              onChanged: (value) => user = value.trim(),
              initialValue: user,
              decoration: InputDecoration(
                labelText: 'user',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              onChanged: (value) => password = value.trim(),
              obscureText: passwordVisible,
              initialValue: password,
              decoration: InputDecoration(
                labelText: 'password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      );

  Widget phonesUser() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              onChanged: (value) => phone = value.trim(),
              initialValue: phone,
              decoration: InputDecoration(
                labelText: 'phone',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget addressUser() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              onChanged: (value) => address = value.trim(),
              initialValue: address,
              decoration: InputDecoration(
                labelText: 'address',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Future<Null> updateProfileandLocation() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String nameFile = 'editavatar$i.jpg';
    Map<String, dynamic> map = Map();

    if (file != null) {
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameFile);

      FormData formData = FormData.fromMap(map);
      String urlUpload = '${MyConstant().domain}/WaterShop/saveAvatar.php';

      await Dio().post(urlUpload, data: formData);
      urlpicture = '/WaterShop/avatar/$nameFile';
    }

    String url =
        '${MyConstant().domain}/WaterShop/editProfilelocation.php?isAdd=true&id=$user_id&UrlPicture=$urlpicture&Name=$name&User=$user&Password=$password&Phone=$phone&Address=$address&Lat=$lat&Lng=$lng';
    await Dio().get(url).then((value) => AwesomeDialog(
          context: context,
          animType: AnimType.bottomSlide,
          dialogType: DialogType.success,
          body: Center(
            child: Text(
              "แก้ไขข้อมูลสมาชิกสำเร็จ",
              style: TextStyle(fontStyle: FontStyle.normal),
            ),
          ),
          title: 'This is Ignored',
          desc: 'This is also Ignored',
          btnOkOnPress: () {},
        ).show());
  }

  Widget buildMap() => Container(
        color: Colors.grey,
        width: double.infinity,
        height: 300,
        child: lat == null
            ? MyStyle().showProgress()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat!, lng!),
                  zoom: 16,
                ),
                onMapCreated: (context) {},
                markers: setMarker(),
              ),
      );

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(
              title: 'คุณอยู่ที่นี่ ', snippet: 'lat = $lat, lng = $lng'),
        ),
      ].toSet();

  Row groupImage() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseImage(
              ImageSource.camera,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            width: 250.0,
            height: 250.0,
            child: file == null
                ? Image.network(
                    '${MyConstant().domain}${urlpicture}',
                    fit: BoxFit.cover,
                  )
                : Image.file(file!),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseImage(
              ImageSource.gallery,
            ),
          )
        ],
      );

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }
}
