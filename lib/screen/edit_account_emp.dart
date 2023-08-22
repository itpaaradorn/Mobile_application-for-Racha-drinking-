
import 'dart:io';

import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../utility/my_style.dart';

class EditAccountEmp extends StatefulWidget {
  final UserModel userModel;
  EditAccountEmp({Key? key, required this.userModel}) : super(key: key);

  @override
  State<EditAccountEmp> createState() => _EditAccountEmpState();
}

class _EditAccountEmpState extends State<EditAccountEmp> {
  UserModel? userModel;
  String? urlpicture, name, user, password, customer, address, phone, id, urlPicture;
  double? lat, lng;
  File? file;
  bool passwordVisible = true;
  bool confirmPassVissible = true;
  @override
  void initState() {
    userModel = widget.userModel;
    id = userModel!.id;
    urlpicture = userModel!.urlPicture;
    name = userModel!.name;
    phone = userModel!.phone;
    address = userModel!.address;
    user = userModel!.user;
    password = userModel!.password;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null ? MyStyle().showProgress() : showContet(),
      appBar: AppBar(
        title: Text('แก้ไข ข้อมูลพนักงาน'),
      ),
    );
  }

  Widget showContet() => SingleChildScrollView(
        child: Column(
          children: [
            nameForm(),
            MyStyle().mySixedBox(),
            userForm(),
            MyStyle().mySixedBox(),
            passwordForm(),
            MyStyle().mySixedBox(),
            phoneForm(),
            MyStyle().mySixedBox(),
            addressForm(),
            MyStyle().mySixedBox(),
            editButton(),
          ],
        ),
      );

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: TextField(
              onChanged: (value) => name = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.face,
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'Name :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
            width: 250.0,
          ),
        ],
      );

  Widget userForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: TextField(
              onChanged: (value) => user = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_box,
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'Username :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
            width: 250.0,
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: TextField(
              onChanged: (value) => phone = value.trim(),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.phone,
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'Phone :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
            width: 250.0,
          ),
        ],
      );

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: TextField(
              onChanged: (value) => password = value.trim(),
              obscureText: passwordVisible,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'Password :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
                suffixIcon: IconButton(
                  icon: Icon(
                      passwordVisible ? Icons.visibility_off : Icons.visibility,
                      color: Colors.blue.shade900),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
              ),
            ),
            width: 250.0,
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: TextField(
              onChanged: (value) => address = value.trim(),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.home,
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'Address :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
            width: 250.0,
          ),
        ],
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // editThread();
                },
                child: Text(
                  'ตกลง',
                  style:TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  //  Future<Null> editThread() async {
  //   Random random = Random();
  //   int i = random.nextInt(100000);
  //   String nameFile = 'ediShop$i.jpg';

  //   Map<String, dynamic> map = Map();
  //   map['file'] = await MultipartFile.fromFile(file!.path, filename: nameFile);
  //   FormData formData = FormData.fromMap(map);

  //   String urlUpload = '${MyConstant().domain}/WaterShop/saveShop.php';
  //   await Dio().post(urlUpload, data: formData).then(
  //     (value) async {
  //       urlPicture = '/WaterShop/shop/$nameFile';

  //       String? id = userModel?.id;
  //       print('id = $id');

  //       String? url =
  //           '${MyConstant().domain}/WaterShop/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlPicture&Lat=$lat&Lng=$lng';

  //       Response response = await Dio().get(url);
  //       if (response.toString() == 'true') {
  //         Navigator.pop(context);
  //       } else {
  //         normalDialog(context, 'ยังอัพเดทไม่ได้ กรุณาลองใหม่');
  //       }
  //     },
  //   );
  // }

}
