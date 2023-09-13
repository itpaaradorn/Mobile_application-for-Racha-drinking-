import 'dart:convert';

import 'package:application_drinking_water_shop/model/user_model.dart';
import 'package:application_drinking_water_shop/screen/employee/main_emp.dart';
import 'package:application_drinking_water_shop/screen/admin/main_shop.dart';
import 'package:application_drinking_water_shop/screen/main_user.dart';
import 'package:application_drinking_water_shop/screen/signUp.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Field

  String? user, password;
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
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

                // RaisedBu tton(onPressed: (){}, child: Text('data'))
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
          AwesomeDialog(
                context: context,
                animType: AnimType.bottomSlide,
                dialogType: DialogType.error,
                body: Center(
                  child: Text(
                  'Password ผิด กรุณาลองใหม่',
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                ),
                title: 'This is Ignored',
                desc: 'This is also Ignored',
                btnOkOnPress: () {},
              )..show();
          
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
              color: Colors.blueAccent,
            ),
            labelStyle: TextStyle(color: Colors.blue),
            labelText: 'User :',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color:  Colors.blueAccent)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
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
              color: Colors.blueAccent,
            ),
            labelStyle: TextStyle(color: Colors.blue),
            labelText: 'Password :',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color:Colors.blue)),
            suffixIcon: IconButton(
              icon: Icon(
                  passwordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.blue),
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