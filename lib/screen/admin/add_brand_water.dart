import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../utility/my_constant.dart';
import '../../utility/my_style.dart';
import '../../utility/dialog.dart';

class AddbrandWater extends StatefulWidget {
  const AddbrandWater({super.key});

  @override
  State<AddbrandWater> createState() => _AddbrandWaterState();
}

class _AddbrandWaterState extends State<AddbrandWater> {
  File? file;
  String? brand_id, brand_name, brand_image;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มประเภทน้ำดื่ม'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            showTitleWater('รูปยี่ห้อ'),
            groupImage(),
            showTitleWater('รายละเอียดน้ำดื่ม'),
            brandForm(),
            MyStyle().mySixedBox(),
            saveButton()
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 2.0),
      width: 300.0,
      child: ElevatedButton.icon(
        onPressed: () {
          if (file == null) {
            AwesomeDialog(
            context: context,
            animType: AnimType.bottomSlide,
            dialogType: DialogType.warning,
            body: Center(
              child: Text(
                "ยังไม่ได้เลือกรูปภาพ Camera หรือ Gallery!",
                style: TextStyle(fontStyle: FontStyle.normal ,),
              ),
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: () {
              // Navigator.pop(context);
            },
          ).show();
          } else if (brand_name == null || brand_name!.isEmpty ) {
            // normalDialog(context, 'กรุณากรอกข้อมูลทุกช่อง !');
            AwesomeDialog(
            context: context,
            animType: AnimType.bottomSlide,
            dialogType: DialogType.warning,
            body: Center(
              child: Text(
                "กรุณากรอกข้อมูลทุกช่อง!",
                style: TextStyle(fontStyle: FontStyle.normal , fontWeight: FontWeight.bold),
              ),
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: () {
              // Navigator.pop(context);
            },
          ).show();
          } else {
            uploadWaterAndInsertData();
          }
        },
        icon: Icon(Icons.save_alt),
        label: Text('บันทึก'),
      ),
    );
  }

  Future<Null> uploadWaterAndInsertData() async {
    String? urlUpload = '${MyConstant().domain}/WaterShop/Savebrand.php';

    Random random = Random();
    int i = random.nextInt(1000000);
    String? nameFile = 'brand$i.jpg';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);

      await Dio().post(urlUpload, data: formData).then(
        (value) async {
          String? brand_image = '/WaterShop/brand/$nameFile';

          print('urlPathImage = ${MyConstant().domain}$brand_image');

          SharedPreferences preferences = await SharedPreferences.getInstance();
          String? idShop = preferences.getString('id');

          String? urlInsertData =
              '${MyConstant().domain}/WaterShop/addBrandWater.php?isAdd=true&brand_id=$brand_id&brand_name=$brand_name&brand_image=$brand_image';
          await Dio()
              .get(urlInsertData)
              .then((value) => Navigator.pop(context));
              Toast.show("เพิ่มข้อมูลสำเร็จ",
                      duration: Toast.lengthLong, gravity: Toast.bottom);
        },
      );
    } catch (e) {}
  }

  Widget brandForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => brand_name = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.water_drop_outlined),
            labelText: 'ยี่ห้อน้ำดื่ม',
            border: OutlineInputBorder(),
          ),
        ),
      );

  
  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () => chooseImage(ImageSource.camera),
        ),
        Container(
          width: 200.0,
          height: 200.0,
          child: file == null
              ? Image.asset('images/WaterMenu.png')
              : Image.file(file!),
        ),
        IconButton(
          icon: Icon(Icons.add_photo_alternate),
          onPressed: () => chooseImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker().pickImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }

  Widget showTitleWater(String string) {
    return Container(
      margin: EdgeInsets.all(13.0),
      child: Row(
        children: [
          MyStyle().showTitleH2(string),
        ],
      ),
    );
  }
}
