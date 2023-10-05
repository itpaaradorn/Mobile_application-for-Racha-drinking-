import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:toast/toast.dart';

import '../utility/my_constant.dart';
import '../utility/my_style.dart';
import '../utility/dialog.dart';

class Prompay extends StatefulWidget {
  const Prompay({Key? key}) : super(key: key);

  @override
  State<Prompay> createState() => _PrompayState();
}

class _PrompayState extends State<Prompay> {
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildTitle(),
          buildPromptPay(),
          buildshowQRcode(),
          buildDowloadQR(),
        ],
      ),
    );
  }

  ElevatedButton buildDowloadQR() {
    return ElevatedButton(
      onPressed: () async {
        String path = 'Download';
        try {
          await FileUtils.mkdir([path]);
          await Dio()
              .download(MyConstant.urlPromptpay, '$path/promptpay.png')
              .then((value) => Toast.show("Download สำเร็จ",
                  duration: Toast.lengthLong, gravity: Toast.bottom));
        } catch (e) {
          Toast.show("Download สำเร็จ",
              duration: Toast.lengthLong, gravity: Toast.bottom);
          print('error ==> ##${e.toString()}');

          // normalDialog(context, 'Error! กรุณาเปิด Permision Storageใน Setting');
        }
      },
      child: Text('Dowload QRcode'),
    );
  }

  Container buildshowQRcode() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: CachedNetworkImage(
        imageUrl: MyConstant.urlPromptpay,
        placeholder: (context, url) => MyStyle().showProgress(),
      ),
    );
  }

  Widget buildPromptPay() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Card(
        color: Color.fromARGB(255, 213, 232, 247),
        child: ListTile(
            title: MyStyle().showTitleB('0840856164'),
            subtitle: MyStyle().showTitleH2('บัญชี Promptpay'),
            trailing: IconButton(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: '0840856164'),
                );
                Toast.show("Copy สำเร็จ ",
                    duration: Toast.lengthLong, gravity: Toast.bottom);
              },
              icon: Icon(Icons.copy),
            )),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MyStyle().showTitleB('ชำระเงินพร้อมเพย์'),
    );
  }
}
