import 'package:application_drinking_water_shop/screen/add_account_emp.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:flutter/material.dart';

class ShowAccount extends StatefulWidget {
  @override
  State<ShowAccount> createState() => _ShowAccountState();
}

class _ShowAccountState extends State<ShowAccount> {

 void routeToAddAccount() {
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => AddAccountEMP(),
    );

    Navigator.push(context, materialPageRoute);
  }


  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyStyle().titleCenter('ยังไม่มีข้อมูลพนักงาน กรุณาเพิ่มด้วยครับ !!'),
        addAndEditButton()
      ],
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
