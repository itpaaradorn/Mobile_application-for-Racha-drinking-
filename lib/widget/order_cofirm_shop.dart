import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../configs/api.dart';
import '../model/order_model.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';

class ListOrder {
  String orderName;
  List<OrderModel> items;

  ListOrder({required this.orderName, required this.items});
}

class OrderConfirmShop extends StatefulWidget {
  const OrderConfirmShop({super.key});

  @override
  State<OrderConfirmShop> createState() => _OrderConfirmShopState();
}

class _OrderConfirmShopState extends State<OrderConfirmShop> {
  bool loadStatus = true; // Process load JSON
  bool status = true;

  List<OrderModel> ordermodels = [];
  List<ListOrder> listOrder = [];
  List<List<String>> listnameWater = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listPrices = [];
  List<List<String>> listSums = [];
  List<int> totals = [];
  List<List<String>> listusers = [];

  @override
  void initState() {
    super.initState();
    initialFont();
    findOrderShop();
  }

  late Uint8List dataInt;

  Future<void> initialFont() async {
    ByteData fontByte = await rootBundle.load('fonts/Samba/SambaBold.ttf');
    dataInt = fontByte.buffer
        .asUint8List(fontByte.offsetInBytes, fontByte.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'รายการน้ำดื่มที่จัดส่งเสร็จสิ้น',
          // style: TextStyle(color: Colors.indigo),
          // style: GoogleFonts.notoSans(color: Colors.indigo),
          style: GoogleFonts.kanit(color: Colors.indigo),
        ),
      ),
      body: Stack(
        children: <Widget>[
          listOrder.isNotEmpty ? showListOrderWater() : buildNoneOrder(),
        ],
      ),
    );
  }

  // Widget showContent() {
  //   return status ? showListOrderWater() : buildNoneOrder();
  // }

  Center buildNoneOrder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyStyle().mySixedBox(),
          Text(
            'ยังไม่มีข้อมูลการสั่งน้ำดื่ม',
            style: TextStyle(fontSize: 20),
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
        '${MyConstant().domain}/WaterShop/getOrderWhereIdShop.php?status=Finish';
    await Dio().get(path).then((value) {
      // print('value ==> $value');
      var result = jsonDecode(value.data);
      // print('result ==> $result');

      if (result != null) {
        result?.forEach((elem) => ordermodels.add(OrderModel.fromJson(elem)));

        /*
         listOrder = [
          {
            "orderName": "12345678",
            "items": [model1, model2],
         }
         ];
        */

        Map<String, List<OrderModel>> items = {};

        ordermodels.forEach((elem) {
          if (items[elem.orderTableId] == null) {
            items[elem.orderTableId as String] = [];
          }

          items[elem.orderTableId as String]?.add(elem);
        });

        items.forEach((key, value) =>
            listOrder.add(ListOrder(orderName: key, items: value)));

        // print('\nlistOrder: $listOrder\n\n');
        print(' ->>>>>> $value');

        setState(() {});
      } else {
        setState(() {
          status = true;
        });
      }
    });
  }

  Future<void> _createPDF(int index) async {
    PdfDocument document = PdfDocument();

    var page = document.pages.add();

    drawGrid(index, page, listOrder);
    Imagebill(page, index, ordermodels);
    Detailbill(page, index, ordermodels);

    List<int> bytes = await document.save();

    saveAndLanchFile(bytes, 'Order_${ordermodels[index].orderTableId}.pdf');
    document.dispose();
  }

  static void Imagebill(PdfPage page, int index, List<OrderModel> ordermodels) {
    page.graphics.drawString(
      'Racha Drinking WaterShop ',
      PdfStandardFont(PdfFontFamily.helvetica, 30, style: PdfFontStyle.bold),
      bounds: const Rect.fromLTWH(75, 0, 0, 0),
    );
  }

  void Detailbill(PdfPage page, int index, List<OrderModel> ordermodels) {
    page.graphics.drawString(
      'Name: ${ordermodels[index].name}',
      // 'Name: สมัครสมาชิก',
      // 'こんにちは世界',
      // 'hello',
      PdfTrueTypeFont(dataInt, 21),
      // PdfCjkStandardFont(PdfCjkFontFamily.heiseiMinchoW3, 20),
      // PdfStandardFont(PdfFontFamily.helvetica, 21),
      bounds: const Rect.fromLTWH(0, 45, 0, 0),
    );
    page.graphics.drawString(
      'Order ID: ${ordermodels[index].orderTableId}',
      PdfStandardFont(PdfFontFamily.helvetica, 21),
      bounds: const Rect.fromLTWH(0, 75, 0, 0),
    );

    page.graphics.drawString(
      'Order Time: ${ordermodels[index].createAt}',
      PdfStandardFont(PdfFontFamily.helvetica, 21),
      bounds: const Rect.fromLTWH(0, 105, 0, 0),
    );

    page.graphics.drawString(
      'Delivery Distance: ${ordermodels[index].distance} Km.',
      PdfStandardFont(PdfFontFamily.helvetica, 21),
      bounds: const Rect.fromLTWH(0, 135, 0, 0),
    );
    page.graphics.drawString(
      'Shipping cost: ${ordermodels[index].transport} THB.',
      PdfStandardFont(PdfFontFamily.helvetica, 21),
      bounds: const Rect.fromLTWH(0, 165, 0, 0),
    );
  }

  static void drawGrid(int index, PdfPage page, List listOrder) {
    final grid = PdfGrid();
    grid.columns.add(count: 4);

    final headerRow = grid.headers.add(3)[0];
    headerRow.cells[0].value = ' Amount';
    headerRow.cells[1].value = ' Description';
    headerRow.cells[2].value = ' Price';
    headerRow.cells[3].value = ' Total';

    PdfGridCellStyle headerStyle = PdfGridCellStyle();
    headerStyle.borders.all = PdfPen(PdfColor(126, 151, 173));
    headerStyle.backgroundBrush = PdfSolidBrush(PdfColor(126, 151, 173));
    headerStyle.textBrush = PdfBrushes.white;
    headerStyle.font = PdfStandardFont(PdfFontFamily.helvetica, 21,
        style: PdfFontStyle.regular);

    for (int i = 0; i < headerRow.cells.count; i++) {
      if (i == 0 || i == 1) {
        headerRow.cells[i].stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle);
      } else {
        headerRow.cells[i].stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.right,
            lineAlignment: PdfVerticalAlignment.middle);
      }
      headerRow.cells[i].style = headerStyle;
    }

    // PdfGridRow row = grid.rows.add();
    // row.style.font = PdfStandardFont(PdfFontFamily.helvetica, 21,
    //     style: PdfFontStyle.regular);
    // row.cells[0].value = 'CA-1098';
    // row.cells[1].value = 'AWC Logo Cap';
    // row.cells[2].value = '\$8.99';
    // row.cells[3].value = '2';

    // row = grid.rows.add();
    // row.style.font = PdfStandardFont(PdfFontFamily.helvetica, 21,
    //     style: PdfFontStyle.regular);
    // row.cells[0].value = 'LJ-0192';
    // row.cells[1].value = 'Long-Sleeve Logo Jersey,M';
    // row.cells[2].value = '\$49.99';
    // row.cells[3].value = '3';

    // row = grid.rows.add();
    // row.style.font = PdfStandardFont(PdfFontFamily.helvetica, 21,
    //     style: PdfFontStyle.regular);
    // row.cells[0].value = 'So-B909-M';
    // row.cells[1].value = 'Mountain Bike Socks,M';
    // row.cells[2].value = '\$9.5';
    // row.cells[3].value = '2';

    // row = grid.rows.add();
    // row.style.font = PdfStandardFont(PdfFontFamily.helvetica, 21,
    //     style: PdfFontStyle.regular);
    // row.cells[0].value = 'LJ-0192';
    // row.cells[1].value = 'Long-Sleeve Logo Jersey,M';
    // row.cells[2].value = '\$49.99';
    // row.cells[3].value = '4';

    List<OrderModel> items = listOrder[index].items;
    PdfGridRow row;

    for (int i = 0; i < items.length; i++) {
      // print(i);
      // print(' =>>>> ${items[i].brandName}');

      row = grid.rows.add();

      row.style.font = PdfStandardFont(PdfFontFamily.helvetica, 50,
          style: PdfFontStyle.regular);

      // row.cells[0].value = '  ${listOrder[i].items[0].amount}x';
      row.cells[0].value = '  ${items[i].amount ?? ''}';
      // row.cells[1].value = '   ${listOrder[i].items[0].brandName}';
      row.cells[1].value = '   ${items[i].brandName ?? ''}';
      // row.cells[2].value = '   ${listOrder[i].items[0].price}';
      row.cells[2].value = '   ${items[i].price ?? ''}';
      row.cells[3].value = '   ${items[i].sum ?? ''}';

      PdfGridCellStyle cells = PdfGridCellStyle();
      cells.borders.all = PdfPens.white;
      cells.borders.bottom = PdfPen(PdfColor(217, 217, 217), width: 0.70);
      cells.font = PdfStandardFont(PdfFontFamily.helvetica, 19);
      cells.textBrush = PdfSolidBrush(PdfColor(0, 0, 0));
//Adds cell customizations
      for (int i = 0; i < grid.rows.count; i++) {
        PdfGridRow row = grid.rows[i];
        for (int j = 0; j < row.cells.count; j++) {
          row.cells[j].style = cells;
          if (j == 0 || j == 1) {
            row.cells[j].stringFormat = PdfStringFormat(
                alignment: PdfTextAlignment.left,
                lineAlignment: PdfVerticalAlignment.middle);
          } else {
            row.cells[j].stringFormat = PdfStringFormat(
                alignment: PdfTextAlignment.right,
                lineAlignment: PdfVerticalAlignment.middle);
          }
        }
      }
    }

    int total = items.fold(
        0, (previous, current) => previous + int.parse(current.sum ?? '0'));
    total = total + int.parse(items[0].transport ?? '0');

    int totalPric = items.fold(
        0, (previous, current) => previous + int.parse(current.sum ?? '0'));

    for (var i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }

    PdfLayoutResult? lo =
        grid.draw(page: page, bounds: Rect.fromLTWH(0, 205, 0, 0));

    page.graphics.drawString(
      'Total Price: $totalPric THB.',
      PdfStandardFont(PdfFontFamily.helvetica, 18),
      bounds: Rect.fromLTWH(10, (lo?.bounds.bottom ?? 0) + 40, 0, 0),
    );
    page.graphics.drawString(
      'Total Price (with trasport): $total THB.',
      PdfStandardFont(PdfFontFamily.helvetica, 18),
      bounds: Rect.fromLTWH(220, (lo?.bounds.bottom ?? 0) + 40, 0, 0),
    );
  }

  Future<void> saveAndLanchFile(List<int> bytes, String filename) async {
    final path = (await getExternalStorageDirectory())!.path;
    final file = File('$path/$filename');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$filename');
  }

  Widget showListOrderWater() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listOrder.length,
      itemBuilder: (context, i) {
        return Card(
          color: i % 2 == 0 ? Colors.grey.shade100 : Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyStyle().showTitleH2('คุณ ${listOrder[i].items[0].name}'),
                    IconButton(
                      onPressed: () async {
                        _createPDF(i);
                      },
                      icon: Icon(
                        Icons.print,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                MyStyle().showTitleH33(
                    'คำสั่งซื้อ : ${listOrder[i].items[0].orderTableId}'),
                MyStyle().showTitleH33(
                    'สถานะการชำระเงิน : ${listOrder[i].items[0].paymentStatus}'),
                MyStyle().showTitleH33('สถานะการจัดส่ง : สำเร็จ ✔'),
                MyStyle().mySixedBox(),
                buildTitle(),
                ListView.builder(
                    itemCount: listOrder[i].items.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, j) {
                      List<OrderModel> items = listOrder[i].items;

                      return Container(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${items[j].amount}x',
                                style: MyStyle().mainh3Title,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                items[j].brandName ?? '',
                                style: MyStyle().mainh3Title,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                items[j].price ?? '',
                                style: MyStyle().mainh3Title,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                items[j].sum ?? '',
                                style: MyStyle().mainh3Title,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
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
                              'รวมทั้งสิ้น :',
                              style: MyStyle().mainh1Title,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${listOrder[i].items.fold(0, (previous, current) => previous + int.parse(current.sum ?? '0'))} บาท',
                              style: MyStyle().mainhATitle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container buildTitle() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(color: Color.fromARGB(255, 76, 164, 206)),
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
