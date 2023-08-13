import 'dart:convert';

import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/screen/main_emp.dart';
import 'package:application_drinking_water_shop/screen/main_shop.dart';
import 'package:application_drinking_water_shop/screen/main_user.dart';
import 'package:application_drinking_water_shop/screen/signUp.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  // Field

  String? user, password;
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MyStyle().showLogo(),
                MyStyle().showTitle('Racha Drinking Water Shop'),
                MyStyle().mySixedBox(),
                MyStyle().mySixedBox(),
                userForm(),
                MyStyle().mySixedBox(),
                passwordForm(),
                MyStyle().mySixedBox(),
                loginButton(),
                showTextDonAccount(), showTextSigUp(),

                // RaisedButton(onPressed: (){}, child: Text('data'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column showTextDonAccount() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('Don\'t have an account?')),
      ],
    );
  }

  Widget showTextSigUp() => Container(
        width: 250.0,
        child: TextButton(
          onPressed: () {
            MaterialPageRoute route =
                MaterialPageRoute(builder: (context) => SignUp());
            Navigator.push(context, route);
          },
          child: Text(
            'Create Account',
            style: TextStyle(color: Color.fromARGB(255, 0, 62, 170)),
          ),
        ),
      );

  Widget loginButton() => Container(
      width: 250.0,
      child: ElevatedButton(
        onPressed: () {
          if (user == null ||
              user!.isEmpty ||
              password == null ||
              password!.isEmpty) {
            normalDialog(context, 'มีช่องว่างกรุณากรอกให้ครบ ครับ');
          } else {
            checkAuthen();
          }
        },
        child: Text('Login'),
      ));

  Future<Null> checkAuthen() async {
    String url =
        '${MyConstant().domain}WaterShop/getUserWhereUser.php?isAdd=true&User=$user';
    print('url == $url');
    try {
      Response response = await Dio().get(url);
      print(response.data);

      var result = json.decode(response.data);
      print('result = $result');
      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password) {
          String? chooseType = userModel.chooseType;
          if (chooseType == 'Customer') {
            routeTuService(MainUser(), userModel);
          } else if (chooseType == 'Admin') {
            routeTuService(MainShop(), userModel);
          } else if (chooseType == 'Employee') {
            routeTuService(MainEmp(), userModel);
          } else {
            normalDialog(context, 'Error!');
          }
        } else {
          normalDialog(context, 'Password ผิด กรุณาลองใหม่');
        }
      }
    } catch (e) {
      print('e === $e');
    }
  }

  Future<Null> routeTuService(Widget myWidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(MyConstant().keyId, userModel.id!);
    preferences.setString(MyConstant().keyType, userModel.chooseType!);
    preferences.setString(MyConstant().keyName, userModel.name!);

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget userForm() => Container(
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
      );

  Widget passwordForm() => Container(
        width: 250.0,
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
      );
}
