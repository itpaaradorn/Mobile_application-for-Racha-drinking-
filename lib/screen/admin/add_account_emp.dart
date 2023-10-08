import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../../configs/api.dart';
import '../../utility/my_constant.dart';
import '../../utility/dialog.dart';

class AddAccountEMP extends StatefulWidget {
  const AddAccountEMP({super.key});

  @override
  State<AddAccountEMP> createState() => _AddAccountEMP();
}

class _AddAccountEMP extends State<AddAccountEMP> {
  String? name, user, password, customer, address, phone;
  String? chooseType;
  String? avatar;
  double? lat, lng;
  File? file;

  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool passwordVisible = true;
  bool confirmPassVissible = true;
  bool isHidden = false;

  @override
  void initState() {
    checkPermission();
    findLatLng();
    passwordVisible = true;
    confirmPassVissible = true;
    super.initState();
  }

  // Future<Null> findLatLng() async {
  //   Position? positon = await MyAPI().getLocation();
  //   setState(() {
  //     lat = positon?.latitude;
  //     lng = positon?.longitude;
  //     print(' lat == $lat , lng == $lng');
  //   });
  // }

  StreamSubscription<Position>? positionStream;

  Future<Null> findLatLng() async {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      print(position);
      if (position != null) {
        lat = position.latitude;
        lng = position.longitude;

        setState(() {});
      }
    });
  }

  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Sevice Location Open');
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission == await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          normalDialog(context, 'ไม่อนุญาติแชร์ Location โปรดแชร์ Location');
        } else {}
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          normalDialog(context, 'ไม่อนุญาติแชร์ Location โปรดแชร์ Location');
        } else {}
      }
    } else {
      print('Service Location Close');
      normalDialog(context,
          'Location service ปิดอยู่ ? กรุณาเปิดตำแหน่งของท่านก่อนใช้บริการค่ะ');
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลพนักงาน'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                MyStyle().showTitleH2('รูปภาพ'),
                MyStyle().mySixedBox(),
                buildAvatar(),
                MyStyle().mySixedBox05(),
                nameForm(),
                MyStyle().mySixedBox05(),
                userForm(),
                MyStyle().mySixedBox05(),
                passwordForm(),
                MyStyle().mySixedBox05(),
                passwordForm2(),
                MyStyle().mySixedBox05(),
                phoneForm(),
                MyStyle().mySixedBox05(),
                addressForm(),
                MyStyle().mySixedBox05(),
                MyStyle().mySixedBox05(),
                buildMap(),
                MyStyle().mySixedBox(),
                registerButton(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registerButton() => Container(
      width: 250.0,
      child: ElevatedButton(
        onPressed: () {
          print(
              'name = $name, user = $user, password = $password, chooseType = $customer phone = $phone address =$address');
          if (formKey.currentState!.validate()) {
            uploadPictureAndInsertData();
          }
        },
        child: Text('เพิ่มข้อมูลพนักงาน'),
      ));

  Future<Null> uploadPictureAndInsertData() async {
    String name = nameController.text;
    String address = addressController.text;
    String phone = phoneController.text;
    String user = userController.text;
    String password = passwordController.text;

    String path =
        '${MyConstant().domain}/WaterShop/getUserWhereUser.php?isAdd=true&User=$user';
    await Dio().get(path).then((value) async {
      print('## value ==>> $value');
      if (value.toString() == 'null') {
        print('## user OK');
        if (file == null) {
          // No Avatar
          processInsertMySQL(
            name: name,
            address: address,
            phone: phone,
            user: user,
            password: password,
          );
        } else {
          // Have Avatar
          print('### process Upload Avatar');
          String apiSaveAvatar =
              '${MyConstant().domain}/WaterShop/saveAvatar.php';
          int i = Random().nextInt(100000);
          String nameAvatar = 'avatar$i.jpg';
          Map<String, dynamic> map = Map();
          map['file'] =
              await MultipartFile.fromFile(file!.path, filename: nameAvatar);
          FormData data = FormData.fromMap(map);
          await Dio().post(apiSaveAvatar, data: data).then((value) {
            avatar = '/WaterShop/avatar/$nameAvatar';
            processInsertMySQL(
              name: name,
              address: address,
              phone: phone,
              user: user,
              password: password,
            );
          });
        }
      } else {
        normalDialog(context, 'User False Please Change User?');
      }
    });
  }

  // Future<Null> processInsertMySQL(
  //     {String? name,
  //     String? address,
  //     String? phone,
  //     String? user,
  //     String? password}) async {
  //   print('### processInsertMySQL Work and avatar ==>> $avatar');
  //   String apiInsertUser =
  //       '${MyConstant().domain}/WaterShop/addUser.php?isAdd=true&Name=$name&User=$user&Password=$password&ChooseType=Employee&Address=$address&Phone=$phone&Urlpicture=$avatar&Lat=$lat&Lng=$lng';
  //   await Dio().get(apiInsertUser).then((value) {
  //     if (value.toString() == 'true') {
  //       Navigator.pop(context);
  //       Toast.show("เพิ่มข้อมูลพนักงานสำเร็จ",
  //           duration: Toast.lengthLong, gravity: Toast.bottom);
  //     } else {
  //       normalDialog(context, 'Create New User False !!!');
  //     }
  //   });
  // }

  Future<Null> processInsertMySQL(
      {String? name,
      String? address,
      String? phone,
      String? user,
      String? password}) async {
    print('### processInsertMySQL Work and avatar ==>> $avatar');
    String apiInsertUser =
        '${MyConstant().domain}/WaterShop/addUser.php?isAdd=true&Name=$name&User=$user&Password=$password&ChooseType=Employee&Address=$address&Phone=$phone&UrlPicture=$avatar&Lat=$lat&Lng=$lng';
    await Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
        Toast.show("เพิ่มข้อมูลพนักงานสำเร็จ",
            duration: Toast.lengthLong, gravity: Toast.bottom);
      } else {
        normalDialog(context, 'Create New User False !!!');
      }
    });
  }

  Row buildAvatar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 22,
          ),
        ),
        Container(
          width: 180,
          height: 180,
          child:
              file == null ? Image.asset(MyConstant.avatar) : Image.file(file!),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 22,
          ),
        ),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker()
          .pickImage(source: source, maxWidth: 800, maxHeight: 800);
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Widget buildMap() => Container(
        color: Colors.grey,
        width: double.infinity,
        height: 250,
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

  Widget nameForm() => Container(
        margin: EdgeInsets.only(top: 10),
        width: 270.0,
        child: TextFormField(
          controller: nameController,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value.toString().isEmpty) {
              return 'กรุณากรอก name ด้วย ค่ะ';
            }
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: Colors.blueAccent,
            ),
            labelStyle: TextStyle(
              color: Colors.blue,
            ),
            labelText: 'Name :',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      );

  Widget userForm() => Container(
        margin: EdgeInsets.only(top: 10),
        width: 270.0,
        child: TextFormField(
          controller: userController,
          keyboardType: TextInputType.emailAddress,
          // ignore: body_might_complete_normally_nullable
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอก email ด้วย ค่ะ';
            } else if (!EmailValidator.validate(value ?? '')) {
              AwesomeDialog(
                context: context,
                animType: AnimType.bottomSlide,
                dialogType: DialogType.info,
                body: Center(
                  child: Text(
                    'กรุณากรอก email ให้ถูกต้อง @xxxx.com ค่ะ',
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                ),
                title: 'This is Ignored',
                desc: 'This is also Ignored',
                btnOkOnPress: () {},
              ).show();
              return 'email ไม่ถูกต้อง';
            } else {}
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: Colors.blueAccent,
            ),
            labelStyle: TextStyle(
              color: Colors.blue,
            ),
            labelText: 'Email :',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      );

  Widget passwordForm() => Container(
        margin: EdgeInsets.only(top: 10),
        width: 270.0,
        child: TextFormField(
          obscureText: isHidden,
          controller: passwordController,
          validator: (value) {
            if (value.toString().isEmpty) {
              return 'กรุณากรอก password ด้วย ค่ะ';
            } else {}
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.blueAccent,
            ),
            labelStyle: TextStyle(
              color: Colors.blue,
            ),
            suffixIcon: IconButton(
                icon: isHidden
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                onPressed: togglePasswordVisibility),
            labelText: 'Password :',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      );

  Widget passwordForm2() => Container(
        margin: EdgeInsets.only(top: 10),
        width: 270.0,
        child: TextFormField(
          obscureText: isHidden,
          controller: confirmPasswordController,
          validator: (value) {
            if (value.toString().isEmpty) {
              return 'กรุณากรอก password ด้วย ค่ะ';
            } else if (passwordController.text !=
                confirmPasswordController.text) {
              AwesomeDialog(
                context: context,
                animType: AnimType.scale,
                dialogType: DialogType.info,
                body: Center(
                  child: Text(
                    'กรุณากรอก password ให้ตรงกันด้วย ค่ะ',
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                ),
                title: 'This is Ignored',
                desc: 'This is also Ignored',
                btnOkOnPress: () {},
              )..show();

              return "password ไม่ตรงกัน";
            }
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.blueAccent,
            ),
            labelStyle: TextStyle(
              color: Colors.blue,
            ),
            suffixIcon: IconButton(
                icon: isHidden
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                onPressed: togglePasswordVisibility),
            labelText: 'Confirm Password :',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      );

  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);

  Widget phoneForm() => Container(
        margin: EdgeInsets.only(top: 10),
        width: 270.0,
        child: TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value.toString().isEmpty) {
              return 'กรุณากรอก เบอร์โทร ด้วย ค่ะ';
            } else {}
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.blueAccent,
            ),
            labelStyle: TextStyle(
              color: Colors.blue,
            ),
            labelText: 'Phone :',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 250.0,
            child: TextFormField(
              controller: addressController,
              validator: (value) {
                if (value.toString().isEmpty) {
                  return 'กรุณากรอก ที่อยู่ ด้วย ค่ะ';
                } else {}
              },
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Address :',
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: Icon(
                    Icons.home,
                    color: Colors.blue,
                  ),
                ),
                labelStyle: TextStyle(
                  color: Colors.blueAccent,
                ),
                labelText: 'Address :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent)),
              ),
            ),
          ),
        ],
      );

  Row showAppname() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'สมัครสมาชิก',
          style: TextStyle(color: Colors.blue.shade800, fontSize: 35.0),
        )
      ],
    );
  }

  Widget myLogo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MyStyle().showLogo(),
        ],
      );

  @override
  void dispose() {
    super.dispose();

    positionStream?.cancel();
  }
}
