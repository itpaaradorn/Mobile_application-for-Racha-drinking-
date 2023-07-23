import 'package:application_drinking_water_shop/model/water_model.dart';
import 'package:flutter/material.dart';
class ShowShopWaterMunu extends StatefulWidget {
  final WaterModel waterModel;
  const ShowShopWaterMunu({super.key, required this.waterModel});

  @override
  State<ShowShopWaterMunu> createState() => _ShowShopWaterMunuState();
}

class _ShowShopWaterMunuState extends State<ShowShopWaterMunu> {
  WaterModel? waterModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waterModel = widget.waterModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: Text('าาา'),),
    ) ;
  }
}