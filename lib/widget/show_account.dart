import 'dart:convert';

import 'package:application_drinking_water_shop/screen/add_account_emp.dart';
import 'package:application_drinking_water_shop/screen/edit_account_emp.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';

import '../utility/my_constant.dart';

class ShowAccount extends StatefulWidget {
  @override
  State<ShowAccount> createState() => _ShowAccountState();
}

class _ShowAccountState extends State<ShowAccount> {
  bool loadStatus = true; // Process load JSON
  bool status = true; // Have Data
  List<UserModel> usermodels = [];

  @override
  void initState() {
    readAccount();
    super.initState();
  }

  void routeToAddAccount() {
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => AddAccountEMP(),
    );

    Navigator.push(context, materialPageRoute).then((value) => readAccount());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('จัดการข้อมูลพนักงาน'),
      ),
      body: Stack(
        children: <Widget>[
          loadStatus ? MyStyle().showProgress() : showContent(),
          addAndEditButton(),
        ],
      ),
    );
  }

  Widget showContent() {
    return status
        ? showListAccount()
        : Center(
            child: Text('ยังไม่มีข้อมูลลูกค้า'),
          );
  }

  Widget showListAccount() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: usermodels.length,
        itemBuilder: (context, index) => Row(
          children: [
            Container(
              padding: EdgeInsets.all(14.0),
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.4,
              child: buildNoneAvatarImage(),
            ),
            Container(
              padding: EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.4,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MyStyle().mySixedBox(),
                    Text(
                      'ID : ${usermodels[index].id} ',
                      style: MyStyle().mainhPTitle,
                    ),
                    Text(
                      'สมาชิก : ${usermodels[index].chooseType} ',
                      style: MyStyle().mainh2Title,
                    ),
                    Text(
                      'ชื่อ : ${usermodels[index].name} ',
                      style: MyStyle().mainh2Title,
                    ),
                    Text(
                      'ติดต่อ : ${usermodels[index].phone} ',
                      style: MyStyle().mainh2Title,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => EditAccountEmp(
                                userModel: usermodels[index],
                              ),
                            );
                            Navigator.push(context, route).then(
                              (value) => readAccount(),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => deleteAccount(usermodels[index]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildNoneAvatarImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('images/account1.png'),
        ),
      ],
    );
  }

  Future<Null> readAccount() async {
    if (usermodels.length != 0) {
      usermodels.clear();
    }

    String url =
        '${MyConstant().domain}/WaterShop/readUserModelWhereChooseTpy.php?isAdd=true&ChooseType=Employee';

    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      var result = json.decode(value.data);

      for (var item in result) {
        UserModel model = UserModel.fromJson(item);

        setState(() {
          usermodels.add(model);
        });
      }
    });
  }

  Future<Null> deleteAccount(UserModel userModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle().showTitleH2('คุณต้องการลบรายการ ${userModel.id}'),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  String? url =
                      '${MyConstant().domain}/WaterShop/deleteUserId.php?isAdd=true&id=${userModel.id}';
                  await Dio().get(url).then(
                        (value) => readAccount(),
                      );
                },
                child: Text('ยืนยัน',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    )),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Row addAndEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  print('you click floating');
                  routeToAddAccount();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
