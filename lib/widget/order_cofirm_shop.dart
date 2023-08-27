import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../configs/api.dart';
import '../model/order_model.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';

class OrderConfirmShop extends StatefulWidget {
  const OrderConfirmShop({super.key});

  @override
  State<OrderConfirmShop> createState() => _OrderConfirmShopState();
}

class _OrderConfirmShopState extends State<OrderConfirmShop> {
  bool loadStatus = true; // Process load JSON
  bool status = true;

  List<OrderModel> ordermodels = [];
  List<List<String>> listnameWater = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listPrices = [];
  List<List<String>> listSums = [];
  List<int> totals = [];
  List<List<String>> listusers = [];

  @override
  void initState() {
    super.initState();
    findOrderShop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'รายการน้ำดื่มที่จัดส่งแล้ว',
          style: TextStyle(color: Colors.indigo),
        ),
      ),
      body: Stack(
        children: <Widget>[
          loadStatus ? buildNoneOrder() : showContent(),
        ],
      ),
    );
  }

  Widget showContent() {
    return status ? showListOrderWater() : buildNoneOrder();
  }

  Center buildNoneOrder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            child: Image.asset('images/nowater.png'),
          ),
          MyStyle().mySixedBox(),
          Text(
            'ยังไม่มีข้อมูลการสั่งน้ำดื่ม',
            style: TextStyle(fontSize: 28),
          ),
        ],
      ),
    );
  }

  Future<Null> findOrderShop() async {
    if (ordermodels.length != 0) {
      ordermodels.clear();
    }

    String path =
        '${MyConstant().domain}/WaterShop/getOrderwherestatus_Finish.php?isAdd=true';
    await Dio().get(path).then((value) {
      // print('value ==> $value');
      var result = jsonDecode(value.data);
      // print('result ==> $result');
      if (result != null) {
        for (var item in result) {
          OrderModel model = OrderModel.fromJson(item);
          // print('OrderdateTime ==> ${model.orderDateTime}');

          List<String> nameWater =
              MyAPI().createStringArray(model.waterBrandName!);
          List<String> amountgas = MyAPI().createStringArray(model.amount!);
          List<String> pricewater = MyAPI().createStringArray(model.price!);
          List<String> pricesums = MyAPI().createStringArray(model.sum!);
          List<String> userid = MyAPI().createStringArray(model.userId!);

          int total = 0;
          for (var item in pricesums) {
            total = total + int.parse(item);
          }

          setState(() {
            loadStatus = false;
            ordermodels.add(model);
            listnameWater.add(nameWater);
            listAmounts.add(amountgas);
            listPrices.add(pricewater);
            listSums.add(pricesums);
            totals.add(total);
            listusers.add(userid);
          });
        }
      }
    });
  }

  Future<void> _createPDF(
    int index,
  ) async {
    PdfDocument document = PdfDocument();
    var page = document.pages.add();

    drawGrid(
        index, page, listAmounts, listnameWater, listPrices, listSums, totals);
    Imagebill(page, index, ordermodels);
    Detailbill(page, index, ordermodels);

    List<int> bytes = await document.save();

    saveAndLanchFile(bytes, 'Order_${ordermodels[index].orderId}.pdf');
    document.dispose();
  }

  static void Imagebill(PdfPage page, int index, List<OrderModel> ordermodels) {
    page.graphics.drawString(
      'Racha Drinking WaterShop ',
      PdfStandardFont(PdfFontFamily.helvetica, 30, style: PdfFontStyle.bold),
      bounds: const Rect.fromLTWH(75, 0, 0, 0),
    );
  }

  static void Detailbill(
      PdfPage page, int index, List<OrderModel> ordermodels) {
    page.graphics.drawString(
      'Name: ${ordermodels[index].userName}',
      PdfStandardFont(PdfFontFamily.helvetica, 23),
      bounds: const Rect.fromLTWH(0, 45, 0, 0),
    );
    page.graphics.drawString(
      'Order ID: ${ordermodels[index].orderId}',
      PdfStandardFont(PdfFontFamily.helvetica, 23),
      bounds: const Rect.fromLTWH(0, 75, 0, 0),
    );

    page.graphics.drawString(
      'Order Time: ${ordermodels[index].orderDateTime}',
      PdfStandardFont(PdfFontFamily.helvetica, 23),
      bounds: const Rect.fromLTWH(0, 105, 0, 0),
    );

    page.graphics.drawString(
      'Delivery Distance: ${ordermodels[index].distance} Km.',
      PdfStandardFont(PdfFontFamily.helvetica, 23),
      bounds: const Rect.fromLTWH(0, 135, 0, 0),
    );
    page.graphics.drawString(
      'Shipping cost: ${ordermodels[index].transport} THB.',
      PdfStandardFont(PdfFontFamily.helvetica, 23),
      bounds: const Rect.fromLTWH(0, 165, 0, 0),
    );
  }

  static void drawGrid(int index, PdfPage page, List listAmounts, listnameWater,
      listPrices, listSums, totals) {
    final grid = PdfGrid();
    grid.columns.add(count: 4);

    final headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(0, 0, 122));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Amount';
    headerRow.cells[1].value = 'Brand';
    headerRow.cells[2].value = 'Price';
    headerRow.cells[3].value = 'Total';
    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);

    final row = grid.rows.add();
    row.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
    if (listAmounts != null) {
      row.cells[0].value = '${listAmounts[index]}';
      row.cells[1].value = '${listnameWater[index]}';
      row.cells[2].value = '${listPrices[index]}';
      row.cells[3].value = '${totals[index]}';
    }

    for (var i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }

    grid.draw(page: page, bounds: Rect.fromLTWH(0, 205, 0, 0));
  }

  Future<void> saveAndLanchFile(List<int> bytes, String filename) async {
    final path = (await getExternalStorageDirectory())!.path;
    final file = File('$path/$filename');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$filename');
  }

  Widget showListOrderWater() {
    return ListView.builder(
      itemCount: ordermodels.length,
      itemBuilder: (context, index) => Card(
        color: index % 2 == 0 ? Colors.grey.shade100 : Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyStyle().showTitleH2('${ordermodels[index].userName}'),
                  IconButton(
                    onPressed: () async {
                      _createPDF(index);
                    },
                    icon: Icon(
                      Icons.print,
                      size: 30,
                    ),
                  ),
                ],
              ),
              MyStyle().showTitleH33('${ordermodels[index].orderDateTime}'),
              MyStyle().showTitleH33('สถานะการจัดส่ง : สำเร็จ'),
              MyStyle().showTitleH33(
                  'สถานะการชำระเงิน : ${ordermodels[index].pamentStatus}'),
              MyStyle().mySixedBox05(),
              buildTitle(),
              ListView.builder(
                itemCount: listnameWater[index].length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index2) => Container(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${listAmounts[index][index2]}x',
                          style: MyStyle().mainh3Title,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          listnameWater[index][index2],
                          style: MyStyle().mainh3Title,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          listPrices[index][index2],
                          style: MyStyle().mainh3Title,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          listSums[index][index2],
                          style: MyStyle().mainh3Title,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'รวมทั้งหมด :  ',
                            style: MyStyle().mainh1Title,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${totals[index].toString()} THB',
                        style: MyStyle().mainhATitle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildTitle() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(color: Color.fromARGB(255, 11, 91, 128)),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(
                'จำนวน',
                style: MyStyle().mainh4Title,
              )),
          Expanded(
            flex: 1,
            child: Text(
              'ยี่ห้อ',
              style: MyStyle().mainh4Title,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'ราคา',
              style: MyStyle().mainh4Title,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'รวม',
              style: MyStyle().mainh4Title,
            ),
          ),
        ],
      ),
    );
  }
}
