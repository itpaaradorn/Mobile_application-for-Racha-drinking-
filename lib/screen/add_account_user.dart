import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utility/my_constant.dart';
import '../utility/normal_dialog.dart';

class AddAccountUser extends StatefulWidget {
  const AddAccountUser({super.key});

  @override
  State<AddAccountUser> createState() => _AddAccountUser();
}

class _AddAccountUser extends State<AddAccountUser> {
  String? chooseType, name, user, password, customer, address, phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลลุกค้า'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            myLogo(),
            MyStyle().mySixedBox(),
            showAppname(),
            MyStyle().mySixedBox(),
            MyStyle().mySixedBox(),
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
            registerButton()
          ],
        ),
      ),
    );
  }

  Widget registerButton() => Container(
      width: 250.0,
      child: ElevatedButton(
        onPressed: () {
          print(
              'name = $name, user = $user, password = $password, chooseType = $customer phone = $phone address =$address');
          if (
            name == null ||
              name!.isEmpty ||
              user == null ||
              user!.isEmpty ||
              password == null ||
              password!.isEmpty ||
              phone == null ||
              phone!.isEmpty ||
              address == null ||
              address!.isEmpty
              ) {
            print('Have Space');
            normalDialog(context, 'มีช่องว่าง กรุณากรอกให้ครบครับ');
          } else {
            checkUser();
          }
        },
        child: Text('เพิ่มข้อมูลลุกค้า'),
      ));

  Future<Null> checkUser() async {
    String url =
        '${MyConstant().domain}/WaterShop/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        registerThread();
      } else {
        normalDialog(
            context, 'User นี้ $user มีคนใช้แล้วกรุณาเปลี่ยน User ใหม่');
      }
    } catch (e) {}
  }

  Future<Null> registerThread() async {
    String url =
        '${MyConstant().domain}/WaterShop/addUser.php?isAdd=true&Name=$name&User=$user&Password=$password&ChooseType=Customer&Avatar=null&Address=$address&Phone=$phone';

    try {
      Response response = await Dio().get(url);
      print('res = $response');

      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ไม่สามารถสมัครได้ กรุณาลองใหม่ ครับ');
      }
    } catch (e) {
      // print('error $e');
    }
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: TextField(
              onChanged: (value) => name = value.trim(),
              decoration: InputDecoration(
                labelText: 'Name :',
                prefixIcon: Icon(Icons.face),
                border: OutlineInputBorder(),
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
            child: TextField(onChanged: (value) => user = value.trim(),
              decoration: InputDecoration(
                labelText: 'Username :',
                prefixIcon: Icon(Icons.account_box),
                border: OutlineInputBorder(),
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
            child: TextField(onChanged: (value) => phone = value.trim(),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone :',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
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
            child: TextField(onChanged: (value) => password = value.trim(),
              decoration: InputDecoration(
                labelText: 'Password :',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
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
            child: TextField(onChanged: (value) => address = value.trim(),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Address :',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
            ),
            width: 250.0,
          ),
        ],
      );


  Row showAppname() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyStyle().showTitle('Racha Drinking Water Shop'),
      ],
    );
  }

  Widget myLogo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MyStyle().showLogo(),
        ],
      );
}
