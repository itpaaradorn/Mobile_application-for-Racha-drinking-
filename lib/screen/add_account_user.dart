import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


import '../utility/my_constant.dart';
import '../utility/dialog.dart';

class AddAccountUser extends StatefulWidget {
  const AddAccountUser({super.key});

  @override
  State<AddAccountUser> createState() => _AddAccountUser();
}

class _AddAccountUser extends State<AddAccountUser> {
  String? chooseType, name, user, password, customer, address, phone;
  bool passwordVisible = true;

// Position? userlocation;
//   var _nameController = TextEditingController();
//   var _emailController = TextEditingController();
//   var _passwordController = TextEditingController();
//   var _phoneController = TextEditingController();
//   var _addressController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   double? lat,lng;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     checkPermission();
//     findlatlng();
//   }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลลุกค้า'),
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


//  Future<Null> checkPermission() async {
//     bool locationService;
//     LocationPermission locationPermission;

//     locationService = await Geolocator.isLocationServiceEnabled();
//     if (locationService) {
//       print('Sevice Location Open');
//       locationPermission = await Geolocator.checkPermission();
//       if (locationPermission == LocationPermission.denied) {
//         locationPermission == await Geolocator.requestPermission();
//         if (locationPermission == LocationPermission.deniedForever) {
//           normalDialog(context, 'ไม่อนุญาติแชร์ Location โปรดแชร์ Location');
//         } else {}
//       } else {
//         if (locationPermission == LocationPermission.deniedForever) {
//           normalDialog(context, 'ไม่อนุญาติแชร์ Location โปรดแชร์ Location');
//         } else {}
//       }
//     } else {
//       print('Service Location Close');
//       normalDialog(context,
//           'Location service ปิดอยู่ ? กรุณาเปิดตำแหน่งของท่านก่อนใช้บริการค่ะ');
//     }
//   }

//   Future<Null> findlatlng() async {
//     Position positon = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       lat = positon.latitude;
//       lng = positon.longitude;
//       print(' lat == $lat , lng == $lng');
//     });
//   }


//   //Future function upload data
//   Future<Null> uploadAndInsertData() async {
//     var name = _nameController.text;
//     var address = _addressController.text;
//     var phone = _phoneController.text;
//     var user = _emailController.text;
//     var password = _passwordController.text;
//     // print(" name == ${name} ${address}");
//     // String apipath = '${API().BASE_URL}/rattaphumwater/register.php?isAdd=true&Name=$name&User=$user&Password=$password&ChooseType=Employee&Avatar=null&Phone=$phone&Address=$address&Lat=$lat&Lng=$lng';

//     // await Dio().get(apipath).then((value) {
//     //   if(value.toString() == 'true') {
//     //     Navigator.pop(context);
//     //   } else {
//     //     normalDialog(context,"ไม่สำเร็จ");
//     //   }
//     // });
  // }





}
