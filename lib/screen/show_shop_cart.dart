import 'package:application_drinking_water_shop/model/cart_model.dart';
import 'package:application_drinking_water_shop/utility/my_constant.dart';
import 'package:application_drinking_water_shop/utility/my_style.dart';
import 'package:application_drinking_water_shop/utility/normal_dialog.dart';
import 'package:application_drinking_water_shop/utility/sqlite_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ShowCart extends StatefulWidget {
  const ShowCart({super.key});

  @override
  State<ShowCart> createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<CartModel> cartModels = [];
  int total = 0;
  bool ststus = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    var object = await SQLiteHelper().readAllDataFormSQLite();
    print('object length == ${object.length}');

    if (object.length != 0) {
      for (var model in object) {
        String sumString = model.sum!;
        int sumInt = int.parse(sumString);
        setState(() {
          ststus = false;
          cartModels = object;
          total = total + sumInt;
        });
      }
    } else {
      setState(() {
        ststus = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการในตะกร้า'),
      ),
      body: ststus
          ? Center(
              child: Text('ตะกร้าว่างเปล่า'),
            )
          : buildContent(),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildNameShop(),
            buildHeadTitle(),
            buildListWater(),
            Divider(),
            buildTotal(),
            Divider(),
            // buildClaerCartButton(),
            // buildOrderButton(), 
            buildPaymentButton(),
            buildAddOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget buildClaerCartButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            confirmDeleteData();
          },
          icon: Icon(Icons.clear_all),
          label: Text('ลบรายการทั้งหมด'),
        ),
      ],
    );
  }

  Widget buildOrderButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 110,
          child: ElevatedButton.icon(
            onPressed: () {
              orderThread();
            },
            icon: Icon(Icons.add_shopping_cart_sharp),
            label: Text('สั่งซื้อ'),
          ),
        ),
      ],
    );
  }
  Widget buildPaymentButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10, right: 10),
          width: 160,
          child: ElevatedButton.icon(
           
            onPressed: () {
              // MaterialPageRoute route = MaterialPageRoute(
              //   builder: (context) => null,
              // );
              // Navigator.pushNamed(context, AppRoute.confirmpayment).then((value) => readSQLite());
            },
            label: Text(
              'ชำระเงินล่วงหน้า',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.add_shopping_cart_sharp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAddOrderButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10, right: 10),
          width: 160,
          child: ElevatedButton.icon(
            onPressed: () {
              orderThread();
            },
            label: Text(
              'สั่งซื้อปลายทาง',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.add_shopping_cart_sharp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTotal() => Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyStyle().showTitleH2('ยอดรวมทั้งสิ้น =  '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3(total.toString()),
          ),
        ],
      );

  Widget buildNameShop() {
    return Container(
      margin: EdgeInsets.only(top: 1, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              MyStyle().showTitleHC('รายการในตะกร้า'),
            ],
          ),
          Row(
            children: [
              MyStyle()
                  .showTitleH44('ระยะทาง : ${cartModels[0].distance} กิโลเมตร'),
            ],
          ),
          Row(
            children: [
              MyStyle()
                  .showTitleH44('ค่าจัดส่ง : ${cartModels[0].transport} บาท'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeadTitle() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: MyStyle().showTitleH2('รายการน้ำดื่ม'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH2('ขนาด'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH2('ราคา'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH2('จำนวน'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH2(' รวม'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().mySixedBox(),
          )
        ],
      ),
    );
  }

  Widget buildListWater() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: cartModels.length,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.all(2),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(cartModels[index].brandName!),
              ),
              Expanded(
                flex: 1,
                child: Text(cartModels[index].size!),
              ),
              Expanded(
                flex: 1,
                child: Text(cartModels[index].price!),
              ),
              Expanded(
                flex: 1,
                child: Text(cartModels[index].amount!),
              ),
              Expanded(
                flex: 1,
                child: Text(cartModels[index].sum!),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () async {
                      int id = cartModels[index].id!;
                      print('You Click Delete id == $id');
                      await SQLiteHelper().deleteDataWhereId(id).then((value) {
                        print('Success Delete id == $id');
                        readSQLite();
                      });
                    },
                    icon: Icon(Icons.delete_forever)),
              ),
            ],
          ),
        ),
      );

  Future<Null> confirmDeleteData() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'คุณต้องการจะลบรายการน้ำดื่มทั้งหมดใช่ไหม ?',
          style: MyStyle().mainh2Title,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 90,
                child: ElevatedButton(
                    child: Text('ตกลง'),
                    onPressed: () async {
                      Navigator.pop(context);
                      await SQLiteHelper().deleteAllData().then((value) {
                        readSQLite();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade500,
                    )),
              ),
              Container(
                width: 90,
                child: ElevatedButton(
                    child: Text('ยกเลิก'),
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade500,
                    )),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<Null> orderThread() async {
    DateTime dateTime = DateTime.now();
    // print(dateTime.toString());

    String orderDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    String distance = cartModels[0].distance!;
    String transport = cartModels[0].transport!;

    List<String> water_ids = [];
    List<String> water_brand_ids = [];
    List<String> sizes = [];
    List<String> water_brand_names = [];
    List<String> prices = [];
    List<String> amounts = [];
    List<String> sums = [];

    for (var model in cartModels) {
      water_ids.add(model.waterId!);
      water_brand_ids.add(model.brandId!);
      sizes.add(model.size!);
      water_brand_names.add(model.brandName!);
      prices.add(model.price!);
      amounts.add(model.amount!);
      sums.add(model.sum!);
    }
    String water_id = water_ids.toString();
    String water_brand_id = water_brand_ids.toString();
    String size = sizes.toString();
    String water_brand_name = water_brand_names.toString();
    String price = prices.toString();
    String amount = amounts.toString();
    String sum = sums.toString();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user_id = preferences.getString('id');
    String? user_name = preferences.getString('Name');

    print(
        'orderDateTime == $orderDateTime, distance == $distance, transport == $transport');
    print(
        'water_id == $water_id, water_brand_id == $water_brand_id, size == $size, water_brand_name == $water_brand_name, price == $price, amount == $amount, sum == $sum ');

    String? url =
        '${MyConstant().domain}/WaterShop/addOrder.php?isAdd=true&orderDateTime=$orderDateTime&user_id=$user_id&user_name=$user_name&water_id=$water_id&water_brand_id=$water_brand_id&size=$size&distance=$distance&transport=$transport&water_brand_name=$water_brand_name&price=$price&amount=$amount&sum=$sum&riderId=none&status=userOrder';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        claerAllSQLite();
      } else {
        normalDialog(context, 'ไม่สามารถ สั่งซื้อได้ กรุณาลองใหม่');
      }
    });
  }

  Future<Null> claerAllSQLite() async {
    Toast.show("ทำรายการสั่งซื้อ เสร็จสิ้น",
        duration: Toast.lengthLong, gravity: Toast.bottom);

    await SQLiteHelper().deleteAllData().then((value) {
      readSQLite();
    });
  }
}
