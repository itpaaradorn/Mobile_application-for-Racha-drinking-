import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:flutter/material.dart';

class AddMenuWater extends StatefulWidget {
  const AddMenuWater({super.key});

  @override
  State<AddMenuWater> createState() => _AddMenuWaterState();
}

class _AddMenuWaterState extends State<AddMenuWater> {
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
          onPressed: () {}, icon: Icon(Icons.save_alt), label: Text('บันทึก')),
    );
  }

  Widget nameForm() => Container(
        width: 250.0,
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.water_drop_outlined),
            labelText: 'ชื่อน้ำดื่ม',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget pricForm() => Container(
        width: 250.0,
        child: TextField(
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
          onPressed: null,
        ),
        Container(
          width: 250.0,
          height: 250.0,
          child: Image.asset('images/WaterMenu.png'),
        ),
        IconButton(
          icon: Icon(Icons.add_photo_alternate),
          onPressed: null,
        ),
      ],
    );
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
