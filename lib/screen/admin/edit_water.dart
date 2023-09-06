import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:application_drinking_water_shop/model/water_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';

import 'package:application_drinking_water_shop/utility/dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../../model/brand_model.dart';
import '../../utility/my_style.dart';

class EditWaterMenu extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final WaterModel? waterModel;
  EditWaterMenu({Key? key, this.waterModel}) : super(key: key);

  @override
  State<EditWaterMenu> createState() => _EditWaterMenuState();
}

class _EditWaterMenuState extends State<EditWaterMenu> {
  WaterModel? waterModel;
  BrandWaterModel? selectedModel;
  File? file;
  String? brandname, price, size, pathImage, idbrand, quantity;
  String? selectvalue;
  List<BrandWaterModel> brandModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readBrandWaterShop();
    waterModel = widget.waterModel;
    brandname = waterModel?.brandName;
    price = waterModel?.price;
    size = waterModel?.size;
    pathImage = waterModel?.pathImage;
    quantity = waterModel?.quantity;
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      floatingActionButton: uploadButton(),
      appBar: AppBar(
        title: Text('แก้ไขน้ำดื่ม ${waterModel!.brandName} '),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // nameWater(),
            Container(
              margin: EdgeInsets.only(top: 20),
            ),
            // nameWater(),
            Dropdownbrandwater(),
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
        title:
            MyStyle().showTitleH2('คุณต้องการเปลี่ยนแปลงรายการน้ำดื่มใช่ไหม ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  editValueOnMySQL();
                },
                child: Text(
                  ' ตกลง ',
                  style: MyStyle().mainDackTitle,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  ' ยกเลิก ',
                  style: MyStyle().mainDackTitle,
                ),
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
    String? urlUpload = '${MyConstant().domain}/WaterShop/Savebrand.php';

    Random random = Random();
    int i = random.nextInt(1000000);
    String? nameFile = 'brand$i.jpg';

    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file!.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);

    await Dio().post(urlUpload, data: formData).then(
      (value) async {
        String? brand_image = '/WaterShop/brand/$nameFile';

        String? id = waterModel!.id;
        String url =
            '${MyConstant().domain}/WaterShop/editWater.php?isAdd=true&id=$id&brandname=$brandname&PathImage=$pathImage&Price=$price&Size=$size&idbrand=$idbrand&quantity=$quantity';
        await Dio().get(url).then((value) {
          if (value.toString() == 'true') {
            Navigator.pop(context);
            Toast.show("แก้ไขข้อมูลสำเร็จ",
                duration: Toast.lengthLong, gravity: Toast.bottom);
          } else {
            normalDialog(context, 'กรุณาลองใหม่มีอะไร ผิดพลาด!');
          }
        });
      },
    );
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

  Future<Null> readBrandWaterShop() async {
    if (brandModels.length != 0) {
      brandModels.clear();
    }

    String url =
        '${MyConstant().domain}/WaterShop/getWaterbrand.php?isAdd=true&idShop=46';

    await Dio().get(url).then((value) {
      // print('value ==> $value');
      var result = json.decode(value.data);
      // print('result ==> $result');

      for (var item in result) {
        // print('item ==> $item');
        BrandWaterModel model = BrandWaterModel.fromJson(item);
        // print('brand ==>> ${model.brandId}');

        setState(() {
          brandModels.add(model);
        });
      }
    });
  }

  Widget Dropdownbrandwater() {
    return Container(
      width: 300,
      child: DropdownButtonFormField(
          hint: selectedModel?.brandName != null
              ? Text('${selectedModel?.brandName}')
              : Text('กรุณาเลือกยี่ห้อ'),
          value: selectedModel
              ?.brandName, // Use the selected model's brandName as the value
          items: brandModels.map((BrandWaterModel model) {
            return DropdownMenuItem(
              value: model.brandName, // Set the value to the model's brandName
              child: Text(model.brandName!),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              // Find the corresponding model based on the selected brandName
              selectedModel =
                  brandModels.firstWhere((model) => model.brandName == value);

              // You can access the selected model's properties here
              idbrand = selectedModel?.brandId ?? '';
              brandname = selectedModel?.brandName ?? '';

              print(
                  'selectedModel ==== ${selectedModel!.brandId}  ${selectedModel!.brandName}');
            });
          }),
    );
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
