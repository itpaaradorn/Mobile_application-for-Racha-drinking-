import 'package:application_drinking_water_shop/screen/add_water_manu.dart';
import 'package:flutter/material.dart';

class ListWaterMenuShop extends StatefulWidget {
  @override
  State<ListWaterMenuShop> createState() => _ListWaterMenuShopState();
}

class _ListWaterMenuShopState extends State<ListWaterMenuShop> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text('รายการน้ำดื่ม'),
        addMenuButton(),
      ],
    );
  }

  Widget addMenuButton() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => AddMenuWater(),
                    );
                    Navigator.push(context, route);
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );
}
