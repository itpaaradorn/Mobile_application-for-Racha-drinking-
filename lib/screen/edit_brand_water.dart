import 'dart:io';

import 'package:application_drinking_water_shop/model/brand_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utility/my_constant.dart';
import '../utility/dialog.dart';

class EditBrandWater extends StatefulWidget {
  final BrandWaterModel brandWaterModel;
  const EditBrandWater({super.key, required this.brandWaterModel});

  @override
  State<EditBrandWater> createState() => _EditBrandWaterState();
}

class _EditBrandWaterState extends State<EditBrandWater> {
  BrandWaterModel? brandModel;
  File? file;
  String? brand_id, brand_name, brand_image, idShop;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    brandModel = widget.brandWaterModel;
    brand_id = brandModel?.brandId;
    brand_name = brandModel?.brandName;
    brand_image = brandModel?.brandImage;
    idShop = brandModel?.idShop;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: uploadButton(),
        appBar: AppBar(
          title: Text(
            'แก้ไข ยี่ห้อน้ำดื่ม ${brandModel!.brandName}',
          ),
        ),
        body: Column(
          children: [
            nameBrandWater(),
            groupImage(),
          ],
        ));
  }

  FloatingActionButton uploadButton() {
    return FloatingActionButton(
      onPressed: () {
        if (brand_name!.isEmpty) {
          normalDialog(context, 'กรุณากรอกให้ครบทุกช่อง');
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
        title: Text('คุณต้องการจะเปลี่ยนแปลง ?'),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  editvalueOnMySQL();
                },
                icon: Icon(
                  Icons.check,
                  color: Color.fromARGB(255, 0, 184, 31),
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
          ),
        ],
      ),
    );
  }

  Future<Null> editvalueOnMySQL() async {
    // ignore: unused_local_variable
    String? id = brandModel!.brandId;
    String? url =
        '${MyConstant().domain}/WaterShop/editBrand.php?isAdd=true&brand_id=$brand_id&brand_name=$brand_name&brand_image=$brand_image&idShop=$idShop';
    await Dio().get(url).then((value) => {
          if (value.toString() == 'true')
            {Navigator.pop(context)}
          else
            {normalDialog(context, 'กรุณาลองใหม่ มีข้อผิดพลาด')}
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
                    '${MyConstant().domain}${brandModel?.brandImage}',
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

  Widget nameBrandWater() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => brand_name = value.trim(),
              initialValue: brand_name,
              decoration: InputDecoration(
                labelText: 'ชื่อ ยี่ห้อ น้ำดื่ม',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
