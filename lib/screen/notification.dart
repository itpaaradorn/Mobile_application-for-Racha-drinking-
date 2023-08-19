import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              child: Image.asset('images/chat.png'),
            ),
            Text(
              'ยังไม่มีข้อความ',
              style: TextStyle(fontSize: 30),
            ),
            TextButton(
              onPressed: () {},
              child: Text('ติดต่อร้าน'),
            ),
          ],
        ),
      ),
    );
  }
}
