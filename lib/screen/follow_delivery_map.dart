import 'package:application_drinking_water_shop/model/order_model.dart';
import 'package:flutter/material.dart';

class FollowTrackingDelivery extends StatefulWidget {
  final OrderModel orderModel;
  const FollowTrackingDelivery({super.key,required this.orderModel});

  @override
  State<FollowTrackingDelivery> createState() => _FollowTrackingDeliveryState();
}

class _FollowTrackingDeliveryState extends State<FollowTrackingDelivery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),);
  }
}