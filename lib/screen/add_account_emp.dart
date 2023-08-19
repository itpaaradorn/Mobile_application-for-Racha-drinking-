import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utility/my_constant.dart';
import '../utility/dialog.dart';

class AddAccountEMP extends StatefulWidget {
  const AddAccountEMP({super.key});

  @override
  State<AddAccountEMP> createState() => _AddAccountEMPState();
}

class _AddAccountEMPState extends State<AddAccountEMP> {
  String? chooseType, name, user, password, employee, address, phone;
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลพนักงาน'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
           MyStyle().mySixedBox(),
            MyStyle().mySixedBox(),
            MyStyle().mySixedBox(),
            myLogo(),
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
              'name = $name, user = $user, password = $password, chooseType = $employee phone = $phone address =$address');
          if (name == null ||
              name!.isEmpty ||
              user == null ||
              user!.isEmpty ||
              password == null ||
              password!.isEmpty ||
              phone == null ||
              phone!.isEmpty ||
              address == null ||
              address!.isEmpty) {
            print('Have Space');
            normalDialog(context, 'มีช่องว่าง กรุณากรอกให้ครบครับ');
          } else {
            checkUser();
          }
        },
        child: Text('เพิ่มข้อมูลพนักงาน'),
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
        '${MyConstant().domain}/WaterShop/addUser.php?isAdd=true&Name=$name&User=$user&Password=$password&ChooseType=Employee&Avatar=null&Address=$address&Phone=$phone';

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
                prefixIcon: Icon(
                  Icons.face,
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'Name :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
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
            child: TextField(
              onChanged: (value) => user = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_box,
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'Username :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
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
            child: TextField(
              onChanged: (value) => phone = value.trim(),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.phone,
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'Phone :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
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
            child: TextField(
              onChanged: (value) => password = value.trim(),
              obscureText: passwordVisible,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'Password :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
                suffixIcon: IconButton(
                  icon: Icon(
                      passwordVisible ? Icons.visibility_off : Icons.visibility,
                      color: Colors.blue.shade900),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
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
            child: TextField(
              onChanged: (value) => address = value.trim(),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.home,
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'Address :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
            width: 250.0,
          ),
        ],
      );


  Widget myLogo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MyStyle().showLogo(),
        ],
      );
}
