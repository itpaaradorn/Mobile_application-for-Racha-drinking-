import 'package:flutter/material.dart';

import '../utility/my_style.dart';

class listManuAddOrderWater extends StatefulWidget {
  @override
  State<listManuAddOrderWater> createState() => _listManuAddOrderWaterState();
}

class _listManuAddOrderWaterState extends State<listManuAddOrderWater> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyStyle().mySixedBox(),
          buildTitle(),
          // MyStyle().mySixedBoxxxxxxx(),
          // buildKtb(),
          // MyStyle().mySixedBoxxxxxxx(),
          // buildKbank(),
        ],
      ),
    );
  }

  Widget buildKtb() {
    return Container(
      height: 90,
      child: Center(
        child: ListTile(
          leading: Container(
            width: 100,
            height: 100,
            child: Image.asset('images/ktb.jpg'),
          ),
          title: MyStyle().showTitleH2('ธนาคารกรุงไทย'),
          subtitle: MyStyle().showTitleH3(
              'ชื่อบัญชี นายภราดร ชูเก็น                                                                      เลขที่บัญชี 926-0-35642-3'),
        ),
      ),
    );
  }

  Widget buildKbank() {
    return Container(
      height: 90,
      child: Center(
        child: ListTile(
          leading: Container(
            width: 100,
            height: 100,
            child: Image.asset('images/kbank.jpg'),
          ),
          title: MyStyle().showTitleH2(
            'ธนาคารกสิกรไทย',
          ),
          subtitle: MyStyle().showTitleH3(
              'ชื่อบัญชี นายภราดร ชูเก็น                                                              เลขที่บัญชี 140-3-34073-8'),
        ),
      ),
    );
  }

  Widget as() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      height: 160,
      child: Center(
        child: Card(
          color: Color.fromARGB(255, 196, 248, 197),
          child: ListTile(
            leading: Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 53, 133, 56),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(''),
              ),
            ),
            title: MyStyle().showTitleKbank('ธนาคารกสิกรไทย '),
            subtitle: MyStyle().showTitleH3(''),
          ),
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MyStyle().showTitleB('ListManuWater'),
    );
  }
}
