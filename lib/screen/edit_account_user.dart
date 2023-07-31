import 'package:flutter/material.dart';

import '../model/user_model.dart';

class EditAccountUser extends StatefulWidget {
  final UserModel userModel;
  EditAccountUser({Key? key, required this.userModel}) : super(key: key);

  @override
  State<EditAccountUser> createState() => _EditAccountUserState();
}

class _EditAccountUserState extends State<EditAccountUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('EditAccountUser'),),);
  }
}