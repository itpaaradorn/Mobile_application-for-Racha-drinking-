import 'dart:io';
import 'dart:math';

import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMenuWater extends StatefulWidget {
  const AddMenuWater({super.key});

  @override
  State<AddMenuWater> createState() => _AddMenuWaterState();
}

class _AddMenuWaterState extends State<AddMenuWater> {
  File? file;
  String? nameWhat, price, detail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรายการน้ำดื่ม'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            showTitleWater('รูปน้ำดื่ม'),
            groupImage(),
            showTitleWater('รายละเอียดน้ำดื่ม'),
            nameForm(),
            MyStyle().mySixedBox(),
            pricForm(),
            MyStyle().mySixedBox(),
            detaiForm(),
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
            normalDialog(context, 'กรุณาเลือกรูปภาพ !');
          } else if (nameWhat == null ||
              nameWhat!.isEmpty ||
              price == null ||
              price!.isEmpty ||
              detail == null ||
              detail!.isEmpty) {
            normalDialog(context, 'กรุณากรอกข้อมูลทุกช่อง !');
          } else {
            uploadWaterAndInsertData();
          }
        },
        icon: Icon(Icons.save_alt),
        label: Text('บันทึก'),
      ),
    );
  }

  Future<Null> uploadWaterAndInsertData ()async{

    String? urlUpload = '${MyConstant().domain}/WaterShop/savewater.php';

    Random  random = Random();
    int i = random.nextInt(1000000);
    String? nameFile = 'what$i.jpg';

    try {
      
       Map<String, dynamic> map = Map();
       map['file'] = await MultipartFile.fromFile(file!.path, filename: nameFile);
       FormData formData = FormData.fromMap(map);

       await Dio().post(urlUpload,data: formData).then((value) async {
        String? urlPathImage = '/WaterShop/water/$nameFile';

        print('urlPathImage = ${MyConstant().domain}$urlPathImage');

        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? idShop = preferences.getString('id');


        String? urlInsertData = '${MyConstant().domain}/WaterShop/addWater.php?isAdd=true&idShop=$idShop&NameWater=$nameWhat&PathImage=$urlPathImage&Price=$price&Detail=$detail';
        await Dio().get(urlInsertData).then((value) => Navigator.pop(context));

       },);

    } catch (e) {
      
    }

  }


  Widget nameForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => nameWhat = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.water_drop_outlined),
            labelText: 'ชื่อน้ำดื่ม',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget pricForm() => Container(
        width: 250.0,
        child: TextField(keyboardType: TextInputType.number,
          onChanged: (value) => price = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.monetization_on_outlined),
            labelText: 'ราคาน้ำดื่ม',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget detaiForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => detail = value.trim(),
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.description_outlined),
            labelText: 'รายละเอียดน้ำดื่ม',
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
          width: 230.0,
          height: 230.0,
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
