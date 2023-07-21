import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? chooseType, name, user, password, customer, address, phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SignUp'),
        ),
        body: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            myLogo(),
            MyStyle().mySixedBox(),
            showAppname(),
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

            // MyStyle().showTitleH2('ชนิดของสมาชิก :'),
            // MyStyle().mySixedBox(),
            // userRadio(),
            // employeeRadio(),
            registerButton()
          ],
        ));
  }

  Widget registerButton() => Container(
      width: 250.0,
      child: ElevatedButton(
        onPressed: () {
          print(
              'name = $name, user = $user, password = $password, chooseType = $customer phone = $phone address =$address');
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
        child: Text('สมัครสมาชิก'),
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

  // Widget userRadio() => Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           width: 250.0,
  //           child: Row(
  //             children: <Widget>[
  //               Radio(
  //                 value: 'Customer',
  //                 groupValue: chooseType,
  //                 onChanged: (value) {
  //                   setState(() {
  //                     chooseType = value;
  //                   });
  //                 },
  //               ),
  //               Text(
  //                 'ลูกค้า',
  //                 style: TextStyle(color: MyStyle().darkColor),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     );

  // Widget employeeRadio() => Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           width: 250.0,
  //           child: Row(
  //             children: <Widget>[
  //               Radio(
  //                 value: 'Employee',
  //                 groupValue: chooseType,
  //                 onChanged: (value) {
  //                   setState(() {
  //                     chooseType = value;
  //                   });
  //                 },
  //               ),
  //               Text(
  //                 'พนักงานขนส่ง',
  //                 style: TextStyle(color: MyStyle().darkColor),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     );

  // Widget shopkeeperRadio() => Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           width: 250.0,
  //           child: Row(
  //             children: <Widget>[
  //               Radio(
  //                 value: 'Shopkeeper',
  //                 groupValue: chooseType,
  //                 onChanged: (value) {
  //                   setState(() {
  //                     chooseType = value;
  //                   });
  //                 },
  //               ),
  //               Text(
  //                 'เจ้าของร้าน',
  //                 style: TextStyle(color: MyStyle().darkColor),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     );

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
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
          ),
        ],
      );

  Widget userForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => user = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_box,
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'User :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
          ),
        ],
      );

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => password = value.trim(),
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
              ),
            ),
          ),
        ],
      );
  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => phone = value.trim(),
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
          ),
        ],
      );
  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              onChanged: (value) => address = value.trim(),
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
