import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_assignment_demo/src/models/product.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends ControllerMVC {
  List<Product> product = <Product>[];
  late SharedPreferences sharedPreferences;
  bool isEmpty = true;
  String layout = 'grid';

  HomeController() {
    getSavedProduct();
  }

  Future<void> getSavedProduct() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      if (sharedPreferences.getString('product') != null) {
        var productJson = sharedPreferences.getString('product');
        List data = await json.decode(productJson!);
        product.clear();
        data.asMap().forEach((index, jsonData) {
          Product levelModel = Product(jsonData['name'], jsonData['launchedAt'], jsonData['launchSite'], jsonData['popularity']);
          setState(() {
            product.add(levelModel);
          });
        });
        if (product.isEmpty) {
          setState(() {
            isEmpty = true;
          });
        } else {
          setState(() {
            isEmpty = false;
          });
        }
      }
    } catch (exception) {
      debugPrint(exception.toString());
    }
  }

  void showAlertDialog(BuildContext context, int isIndex) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget deleteButton = TextButton(
      child: const Text("Delete"),
      onPressed: () async {
        List<dynamic> insertList = [];
        sharedPreferences = await SharedPreferences.getInstance();
        if (sharedPreferences.getString('product') != null) {
          var productJson = sharedPreferences.getString('product');
          await json.decode(productJson!).asMap().forEach((index, jsondata) {
            if (isIndex == index) {
              Product levelModel =
              Product(jsondata['name'], jsondata['launchedAt'], jsondata['launchSite'], jsondata['popularity']);
              insertList.remove(levelModel);
            } else {
              Product levelModel =
              Product(jsondata['name'], jsondata['launchedAt'], jsondata['launchSite'], jsondata['popularity']);
              insertList.add(json.encode(levelModel.toMap()));
            }
          });
        }
        sharedPreferences.setString('product', insertList.toString()).then((value) {
          getSavedProduct();
          Navigator.pop(context);
        });
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Delete"),
      content: const Text("Are you sure want to delete.?"),
      actions: [cancelButton, deleteButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  double screenWidth({required BuildContext context}) {
    return MediaQuery.of(context).size.width;
  }

  double screenHeight({required BuildContext context}) {
    return MediaQuery.of(context).size.height;
  }
}