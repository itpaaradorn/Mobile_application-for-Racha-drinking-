import 'dart:convert';

import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../utility/account_widget.dart';
import '../utility/app_icon.dart';
import '../utility/big_text.dart';
import '../utility/my_constant.dart';
import 'edit_profile_location.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  UserModel? userModel;
  String? id, avatar_image, address, phone, name, password;
  bool loadstatus = true;

  @override
  void initState() {
    // TODO: implement initState
    getImageformUser();
    super.initState();
  }

  Future<Null> getImageformUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getString('id');
    String url =
        '${MyConstant().domain}/WaterShop/getuserwhereidAvatar.php?isAdd=true&id=$id';

    await Dio().get(url).then((value) {
      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        for (var map in result) {
          setState(() {
            userModel = UserModel.fromJson(map);
            address = userModel?.address;
            phone = userModel?.phone;
            name = userModel?.name;
            loadstatus = false;
          });
          // print('nameShop = ${userModel.urlpicture}');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel != null
          ? Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(top: 25),
              child: Column(
                // profile Icons
                children: [
                  Text(
                    "Profile & Location",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                  ),
                  MyStyle().mySixedBox(),
                  AppIcon(
                    icon: Icons.person,
                    backgroundColor: Colors.blueAccent,
                    iconColor: Colors.white,
                    iconSize: 80,
                    size: 150,
                  ),  
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //name
                          AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.person,
                              backgroundColor: Colors.blueAccent,
                              iconColor: Colors.white,
                              iconSize: 25,
                              size: 50,
                            ),
                            bigText: BigText(
                              text: name!,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //phone
                          AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.phone,
                              backgroundColor: Colors.amber,
                              iconColor: Colors.white,
                              iconSize: 25,
                              size: 50,
                            ),
                            bigText: BigText(
                              text: phone!,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          //email

                          //address
                          AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.location_on,
                              backgroundColor: Colors.amber,
                              iconColor: Colors.white,
                              iconSize: 25,
                              size: 50,
                            ),
                            bigText: BigText(
                              text: address!.length >= 100 ? "...." : address!,
                            ),
                          ),

                          SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              MaterialPageRoute route = MaterialPageRoute(
                                  builder: (context) => EditProfileLocation(
                                      userModel: userModel!));
                              Navigator.push(context, route).then(
                                (value) => getImageformUser(),
                              );
                            },
                            child: AccountWidget(
                              appIcon: AppIcon(
                                icon: Icons.settings,
                                backgroundColor: Colors.redAccent,
                                iconColor: Colors.white,
                                iconSize: 25,
                                size: 50,
                              ),
                              bigText: BigText(
                                text: "Setting",
                              ),
                            ),
                          ),
                          //message

                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : MyStyle().showProgress(),
    );
  }

  Widget buildAvatarImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        CircleAvatar(
          backgroundImage:
              NetworkImage('${MyConstant().domain}${userModel?.urlpicture}'),
        ),
      ],
    );
  }
}
