import 'dart:convert';

import 'package:application_drinking_water_shop/model/customer_model.dart';
import 'package:application_drinking_water_shop/screen/add_order.dart';
import 'package:application_drinking_water_shop/services/get_customer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SelectCustomerPage extends StatefulWidget {
  const SelectCustomerPage({super.key});

  @override
  State<SelectCustomerPage> createState() => _SelectCustomerPageState();
}

class _SelectCustomerPageState extends State<SelectCustomerPage> {
  List<CustomerModel> customerModel = [];
  List<CustomerModel> searchCustomerModel = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    Response resp = await getCustomer();

    if (resp.statusCode == 200) {
      for (var item in jsonDecode(resp.data)) {
        customerModel.add(CustomerModel.fromJson(item));
      }

      setState(() {
        searchCustomerModel = customerModel;
      });
    }
  }

  void search() {
    String text = searchController.text;

    if (text.isEmpty) {
      searchCustomerModel = customerModel;
    } else {
      searchCustomerModel =
          customerModel.where((e) => (e.name ?? '').contains(text)).toList();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextFormField(
            controller: searchController,
          ),
          TextButton(onPressed: search, child: Text('search')),
          const SizedBox(height: 20),
          if (searchCustomerModel.isEmpty) ...[
            Text('Empty'),
          ],
          Expanded(
            child: ListView.builder(
              itemCount: searchCustomerModel.length,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => addOrderShop(
                        customerModel: searchCustomerModel[index],
                        isAdmin: true,
                      ),
                    );
                    Navigator.push(context, route);
                  },
                  child: Text(searchCustomerModel[index].name ?? ''),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}
