import 'dart:io';

import 'package:application_drinking_water_shop/model/water_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditWaterMenu extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final WaterModel? waterModel;
  EditWaterMenu({Key? key, this.waterModel}) : super(key: key);

  @override
  State<EditWaterMenu> createState() => _EditWaterMenuState();
}

class _EditWaterMenuState extends State<EditWaterMenu> {
  WaterModel? waterModel;
  File? file;
  String? brandname, price, size, pathImage, idbrand, quantity;
  String? selectedValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waterModel = widget.waterModel;
    brandname = waterModel?.brandname;
    price = waterModel?.price;
    size = waterModel?.size;
    pathImage = waterModel?.pathImage;
    quantity = waterModel?.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: uploadButton(),
      appBar: AppBar(
        title: Text('แก้ไข รายการน้ำดื่ม ID: ${waterModel!.id}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // nameWater(),
            Container(
              margin: EdgeInsets.only(top: 20),
            ),
            nameWater(),
            groupImage(),
            sizeWater(),
            priceWater(),
            qtyWater(),
          ],
        ),
      ),
    );
  }

  FloatingActionButton uploadButton() {
    return FloatingActionButton(
      onPressed: () {
        if (brandname!.isEmpty || size!.isEmpty || price!.isEmpty) {
          normalDialog(context, 'กรุณากรอกให้ครบทุกช่อง!');
        } else {
          confirmEdit();
        }
      },
      child: Icon(Icons.cloud_upload_rounded),
    );
  }

  Future<Null> confirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการเปลี่ยนแปลงรายการน้ำดื่มใช่ไหม ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  editValueOnMySQL();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                label: Text('ตกลง'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Text('ยกเลิก'),
              )
            ],
          )
        ],
      ),
    );
  }

  // Future<Null> editvalueOnMySQL() async {
  //   String? id = waterModel!.id;
  //   String? url =
  //       '${MyConstant().domain}/WaterShop/editWater.php?isAdd=true&id=$id&NameWater=$name&PathImage=$pathImage&Price=$price&Size=$size&idbrand=$idbrand&quantity=$quantity';
  //   await Dio().get(url).then((value) => {
  //         if (value.toString() == 'true')
  //           {Navigator.pop(context)}
  //         else
  //           {normalDialog(context, 'กรุณาลองใหม่ มีข้อผิดพลาด')}
  //       });
  // }

  Future<Null> editValueOnMySQL() async {
    String? id = waterModel!.id;
    String url =
        '${MyConstant().domain}/WaterShop/editWater.php?isAdd=true&id=$id&brandname=$brandname&PathImage=$pathImage&Price=$price&Size=$size&idbrand=$idbrand&quantity=$quantity';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'กรุณาลองใหม่มีอะไร ผิดพลาด!');
      }
    });
  }

  Widget groupImage() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseImage(ImageSource.camera),
          ),
          Container(
            padding: EdgeInsets.all(4.0),
            margin: EdgeInsets.only(top: 13.0),
            width: 250.0,
            height: 250.0,
            child: file == null
                ? Image.network(
                    '${MyConstant().domain}${waterModel?.pathImage}',
                    fit: BoxFit.cover,
                  )
                : Image.file(file!),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseImage(ImageSource.gallery),
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

  Widget nameWater() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 30.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => brandname = value.trim(),
              initialValue: brandname,
              decoration: InputDecoration(
                labelText: 'ชื่อน้ำดื่ม',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget sizeWater() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => price = value.trim(),
              keyboardType: TextInputType.number,
              initialValue: size,
              decoration: InputDecoration(
                labelText: 'ขนาด ml',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget priceWater() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => price = value.trim(),
              keyboardType: TextInputType.number,
              initialValue: price,
              decoration: InputDecoration(
                labelText: 'ราคา',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget qtyWater() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => quantity = value.trim(),
              initialValue: quantity,
              decoration: InputDecoration(
                labelText: 'จำนวน',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
