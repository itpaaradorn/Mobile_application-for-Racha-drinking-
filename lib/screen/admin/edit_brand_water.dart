import 'dart:io';
import 'dart:math';

import 'package:application_drinking_water_shop/model/brand_model.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../../utility/my_constant.dart';
import '../../utility/dialog.dart';

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
    ToastContext().init(context);
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
           AwesomeDialog(
            context: context,
            animType: AnimType.bottomSlide,
            dialogType: DialogType.warning,
            body: Center(
              child: Text(
                "กรุณากรอกข้อมูลให้ครบ!",
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
        title: MyStyle().showTitleH2('คุณต้องการจะเปลี่ยนแปลง ?'),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  editvalueOnMySQL();
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
          ),
        ],
      ),
    );
  }

  Future<Null> editvalueOnMySQL() async {
    // ignore: unused_local_variable
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

        String? id = brandModel!.brandId;

        String? url =
            '${MyConstant().domain}/WaterShop/editBrand.php?isAdd=true&brand_id=$brand_id&brand_name=$brand_name&brand_image=$brand_image';
        await Dio().get(url).then((value){
              if (value.toString() == 'true'){
                Navigator.pop(context);
                Toast.show("แก้ไขสำเร็จ",
                      duration: Toast.lengthLong, gravity: Toast.bottom);
              }else{
                normalDialog(context, 'กรุณาลองใหม่ มีข้อผิดพลาด');
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
