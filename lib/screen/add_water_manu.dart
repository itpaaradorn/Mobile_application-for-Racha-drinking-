import 'dart:io';
import 'dart:math';

import 'package:application_drinking_water_shop/model/water_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMenuWater extends StatefulWidget {
  final WaterModel waterModel;

  const AddMenuWater({super.key, required this.waterModel});
  @override
  State<AddMenuWater> createState() => _AddMenuWaterState();
}

class _AddMenuWaterState extends State<AddMenuWater> {
  WaterModel? waterModel;
  File? file;
  String? id, nameWhat, price, size, idbrand;
  String? selectedValue;

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
            groupImage(), MyStyle().mySixedBox(),
            showTitleWater('รายละเอียดน้ำดื่ม'),
            // nameForm(),
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
            ),
            MyStyle().mySixedBox(),
            sizeWater(),
            priceWater(),
            // qtyWater(),
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
          } else if (
              // idbrand == null ||
              //   idbrand!.isEmpty ||
              price == null ||
                  price!.isEmpty ||
                  size == null ||
                  size!.isEmpty) {
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

  Future<Null> uploadWaterAndInsertData() async {
    String? urlUpload = '${MyConstant().domain}/WaterShop/savewater.php';

    Random random = Random();
    int i = random.nextInt(1000000);
    String? nameFile = 'what$i.jpg';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);

      await Dio().post(urlUpload, data: formData).then(
        (value) async {
          String? urlPathImage = '/WaterShop/water/$nameFile';

          print('urlPathImage = ${MyConstant().domain}$urlPathImage');

          SharedPreferences preferences = await SharedPreferences.getInstance();
          String? idShop = preferences.getString('id');

          String? urlInsertData =
              '${MyConstant().domain}/WaterShop/addWater.php?isAdd=true&idShop=$idShop&NameWater=$nameWhat&PathImage=$urlPathImage&Price=$price&Size=$size&idbrand=$idbrand';
          // print('urlInsertData ======== $urlInsertData');
          await Dio()
              .get(urlInsertData)
              .then((value) => Navigator.pop(context));
        },
      );
    } catch (e) {}
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Namthip"), value: "2"),
      DropdownMenuItem(child: Text("Crystal"), value: "1"),
      DropdownMenuItem(child: Text("Sing"), value: "4"),
      DropdownMenuItem(child: Text("Nestle"), value: "3"),
    ];
    return menuItems;
  }

  // Widget nameForm() => Container(
  //       width: 250.0,
  //       child: TextField(
  //         onChanged: (value) => nameWhat = value.trim(),
  //         decoration: InputDecoration(
  //           prefixIcon: Icon(Icons.water_drop_outlined),
  //           labelText: 'ชื่อน้ำดื่ม',
  //           border: OutlineInputBorder(),
  //         ),
  //       ),
  //     );

  // DropdownButtonFormField<String> Dropdownbrandgas() {
  //   return DropdownButtonFormField(
  //       hint: Container(width: 250.0, child: Text('เลือกยี่ห้อน้ำดื่ม')),
  //       items: [
  //         DropdownMenuItem<String>(
  //           value: '1',
  //           child: Center(
  //             child: Text("Crytsal"),
  //           ),
  //         ),
  //         DropdownMenuItem<String>(
  //           value: '2',
  //           child: Center(
  //             child: Text("Namthip"),
  //           ),
  //         ),
  //         DropdownMenuItem<String>(
  //           value: '3',
  //           child: Center(
  //             child: Text("Nestle"),
  //           ),
  //         ),
  //         DropdownMenuItem<String>(
  //           value: '4',
  //           child: Center(
  //             child: Text("Sing"),
  //           ),
  //         ),
  //       ],
  //       onChanged: (value) {
  //         print(' value ==== $value');
  //         setState(() {
  //           idbrand = value!;
  //           nameWhat = value;
  //         });
  //       });
  // }

  Widget priceWater() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              onChanged: (value) => price = value.trim(),
              initialValue: price,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.attach_money_rounded),
                labelText: 'ราคา',
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
            width: 300.0,
            child: TextFormField(
              onChanged: (value) => size = value.trim(),
              initialValue: size,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.merge_type),
                labelText: 'ขนาด',
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
            width: 300.0,
            child: TextFormField(
              onChanged: (value) {},
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.production_quantity_limits),
                labelText: 'จำนวน',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  // Widget siezForm() => Container(
  //       width: 400.0,
  //       child: TextFormField(
  //         keyboardType: TextInputType.number,
  //         onChanged: (value) => size = value.trim(),
  //         decoration: InputDecoration(
  //           prefixIcon: Icon(Icons.view_list_rounded),
  //           labelText: 'ขนาด ml',
  //           border: OutlineInputBorder(),
  //         ),
  //       ),
  //     );

  // Widget pricForm() => Container(
  //       width: 400.0,
  //       child: TextFormField(
  //         keyboardType: TextInputType.number,
  //         onChanged: (value) => price = value.trim(),
  //         decoration: InputDecoration(
  //           prefixIcon: Icon(Icons.monetization_on_outlined),
  //           labelText: 'ราคา',
  //           border: OutlineInputBorder(),
  //         ),
  //       ),
  //     );

  // Widget detaiForm() => Container(
  //       width: 250.0,
  //       child: TextField(
  //         onChanged: (value) => detail = value.trim(),
  //         keyboardType: TextInputType.multiline,
  //         maxLines: 3,
  //         decoration: InputDecoration(
  //           prefixIcon: Icon(Icons.description_outlined),
  //           labelText: 'รายละเอียดน้ำดื่มขนาด',
  //           border: OutlineInputBorder(),
  //         ),
  //       ),
  //     );

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
