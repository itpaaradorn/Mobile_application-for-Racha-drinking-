import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../screen/main_user.dart';
import 'my_constant.dart';
import 'my_style.dart';

Future<void> normalDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(message),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.red),
                )),
          ],
        )
      ],
    ),
  );
}

Future<void> normalDialogNoti(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(message),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => MainUser(),
                  );
                  Navigator.push(context, route);
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.blue),
                )),
          ],
        )
      ],
    ),
  );
}

Future<void> normalDialog3(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: ListTile(
        leading: Image.asset('images/notification.png'),
        title: MyStyle().showTitleH3(title),
        subtitle: MyStyle().showTitleH3(message),
      ),
      children: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
      ],
    ),
  );
}

Future<void> normalDialog2(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Container(
        width: 150,
        child: ListTile(
          leading: Image.asset('images/notification.png'),
          title: Text(
            title,
            style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
          ),
          subtitle: Text(message),
        ),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.blue)
                )),
          ],
        )
      ],
    ),
  );
}
Future<void> normalDialogChack(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Container(
        width: 150,
        child: ListTile(
          leading: Image.asset('images/order_ss.png'),
          title: Text(
            title,
            style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
          ),
          subtitle: Text(message),
        ),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.blue),
                )),
          ],
        )
      ],
    ),
  );
}

class MyDialog {
  Future<Null> alertLocationService(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: Image.asset(MyConstant.logowaterapp),
          title: Text(title),
          subtitle: Text(message),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Navigator.pop(context);
              await Geolocator.openLocationSettings();
              exit(0);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
