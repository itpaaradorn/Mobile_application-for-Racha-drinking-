import 'dart:io';

import 'package:application_drinking_water_shop/model/water_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditWaterMenu extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final waterModel;
  EditWaterMenu({Key? key, this.waterModel}) : super(key: key);

  @override
  State<EditWaterMenu> createState() => _EditWaterMenuState();
}

class _EditWaterMenuState extends State<EditWaterMenu> {
  WaterModel? waterModel;
  File? file;
  String? name, price, size, pathImage, idbrand, quantity;
  String? selectedValue ="1";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waterModel = widget.waterModel;
    name = waterModel?.idbrand;
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
        title: Text('แก้ไข ${waterModel?.nameWater}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            nameWater(),
            groupImage(),
            sizeWater(),
            priceWater(),
            Container(
              width: 300,
              child: DropdownButtonFormField(
                value: selectedValue,
                items: dropdownItems,
                onChanged: (String? value) {
                  setState(() {
                    idbrand = value;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  FloatingActionButton uploadButton() {
    return FloatingActionButton(
      onPressed: () {
        if (name!.isEmpty || size!.isEmpty || price!.isEmpty) {
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
    String? id = waterModel!.id;
    String? url =
        '${MyConstant().domain}/WaterShop/editWater.php?isAdd=true&id=$id&NameWater=$name&PathImage=$pathImage&Price=$price&Size=$size&idbrand=$idbrand&quantity=$quantity';
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
              onChanged: (value) => name = value.trim(),
              initialValue: name,
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

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Namthip"), value: "2"),
      DropdownMenuItem(child: Text("Crystal"), value: "1"),
      DropdownMenuItem(child: Text("Sing"), value: "4"),
      DropdownMenuItem(child: Text("Nestle"), value: "3"),
      DropdownMenuItem(child: Text("เลือกยี่ห้อน้ำดื่ม"), value: "5"),
    ];
    return menuItems;
  }


}
