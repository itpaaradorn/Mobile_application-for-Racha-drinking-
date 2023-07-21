import 'package:application_drinking_water_shop/screen/add_account_user.dart';
import 'package:flutter/material.dart';

import '../utility/my_style.dart';

class ShowAccountCs extends StatefulWidget {
  const ShowAccountCs({super.key});

  @override
  State<ShowAccountCs> createState() => _ShowAccountCsState();
}

class _ShowAccountCsState extends State<ShowAccountCs> {
  void routeToAddAccount() {
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => AddAccountUser(),
    );

    Navigator.push(context, materialPageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [addAndEditButton(),
        MyStyle().titleCenter('ยังไม่มีข้อมูลลูกค้า กรุณาเพิ่มด้วยครับ !!'),
        
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
                  print('you click floating');
                  routeToAddAccount();
                } ,
              ),
            ),
          ],
        ),
      ],
    );
  }
}




